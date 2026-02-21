import os
import datetime
import json
import pickle
from google_auth_oauthlib.flow import InstalledAppFlow
from google.auth.transport.requests import Request
from googleapiclient.discovery import build

# Configuration
CLIENT_SECRET_FILE = "/home/{{USER}}/Documents/autonomous-living/scripts/client_secret.json"
TOKEN_FILE = "/home/{{USER}}/Documents/autonomous-living/scripts/google_tasks_token.pickle"
SCOPES = ['https://www.googleapis.com/auth/tasks.readonly']

def get_tasks_service():
    creds = None
    if os.path.exists(TOKEN_FILE):
        with open(TOKEN_FILE, 'rb') as token:
            creds = pickle.load(token)
    
    if not creds or not creds.valid:
        if creds and creds.expired and creds.refresh_token:
            creds.refresh(Request())
        else:
            if not os.path.exists(CLIENT_SECRET_FILE):
                print(f"Error: {CLIENT_SECRET_FILE} not found. Please provide Google OAuth client_secret.json")
                return None
            flow = InstalledAppFlow.from_client_secrets_file(CLIENT_SECRET_FILE, SCOPES)
            creds = flow.run_local_server(port=0)
        
        with open(TOKEN_FILE, 'wb') as token:
            pickle.dump(creds, token)
            
    return build('tasks', 'v1', credentials=creds)

def get_upcoming_tasks():
    service = get_tasks_service()
    if not service:
        return []

    try:
        # Get all task lists
        tasklists_results = service.tasklists().list().execute()
        tasklists = tasklists_results.get('items', [])
        
        all_tasks = []
        for tasklist in tasklists:
            tasks_results = service.tasks().list(tasklist=tasklist['id'], showCompleted=False).execute()
            tasks = tasks_results.get('items', [])
            for task in tasks:
                all_tasks.append({
                    "title": task['title'],
                    "due": task.get('due'),
                    "list": tasklist['title'],
                    "notes": task.get('notes', '')
                })
        return all_tasks
    except Exception as e:
        print(f"Google Tasks API Error: {e}")
        return []

if __name__ == "__main__":
    print("Fetching Google Tasks...")
    tasks = get_upcoming_tasks()
    if not tasks:
        print("No tasks found or permission error.")
    for t in tasks:
        due_str = f" [Due: {t['due']}]" if t['due'] else ""
        print(f"- {t['title']}{due_str} (List: {t['list']})")
