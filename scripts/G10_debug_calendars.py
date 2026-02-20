import os
import datetime
from google.oauth2 import service_account
from googleapiclient.discovery import build

# Configuration
CREDENTIALS_FILE = "/home/{{USER}}/Documents/autonomous-living/scripts/google_credentials.json"
SCOPES = ['https://www.googleapis.com/auth/calendar.readonly']

def get_calendar_service():
    creds = service_account.Credentials.from_service_account_file(
        CREDENTIALS_FILE, scopes=SCOPES)
    return build('calendar', 'v3', credentials=creds)

def list_calendars():
    service = get_calendar_service()
    print("Listing accessible calendars:")
    calendar_list = service.calendarList().list().execute()
    calendars = calendar_list.get('items', [])
    
    if not calendars:
        print("No calendars found. This usually means the service account hasn't had any calendars shared with it yet.")
    for calendar in calendars:
        print(f"- {calendar['summary']} (ID: {calendar['id']})")

if __name__ == "__main__":
    try:
        list_calendars()
    except Exception as e:
        print(f"Error: {e}")
