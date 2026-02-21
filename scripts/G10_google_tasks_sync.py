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
SCOPES = ['https://www.googleapis.com/auth/tasks']

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

def add_task(tasklist_name, title, notes=None, due=None):
    """Create a task in a specific tasklist, creating the list if it doesn't exist."""
    service = get_tasks_service()
    if not service:
        return None

    try:
        # 1. Find or create tasklist
        tasklists_results = service.tasklists().list().execute()
        tasklists = tasklists_results.get('items', [])
        
        target_list_id = None
        for tl in tasklists:
            if tl['title'].lower() == tasklist_name.lower():
                target_list_id = tl['id']
                break
        
        if not target_list_id:
            print(f"Creating tasklist: {tasklist_name}")
            new_tl = service.tasklists().insert(body={'title': tasklist_name}).execute()
            target_list_id = new_tl['id']

        # 2. Check if task already exists (to avoid duplicates)
        existing_tasks = service.tasks().list(tasklist=target_list_id, showCompleted=False).execute()
        for task in existing_tasks.get('items', []):
            if task['title'] == title:
                # Already exists and not completed
                return task['id']

        # 3. Create task
        task_body = {
            'title': title,
            'notes': notes,
        }
        if due:
            # Format must be RFC 3339 (e.g. 2026-02-21T00:00:00Z)
            if 'T' not in due:
                due = f"{due}T09:00:00Z"
            task_body['due'] = due

        result = service.tasks().insert(tasklist=target_list_id, body=task_body).execute()
        return result['id']
    except Exception as e:
        print(f"Error adding task: {e}")
        return None

if __name__ == "__main__":
    print("Fetching Google Tasks...")
    tasks = get_upcoming_tasks()
    if not tasks:
        print("No tasks found or permission error.")
    for t in tasks:
        due_str = f" [Due: {t['due']}]" if t['due'] else ""
        print(f"- {t['title']}{due_str} (List: {t['list']})")
