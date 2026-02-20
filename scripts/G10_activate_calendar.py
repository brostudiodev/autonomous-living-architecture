import os
from google.oauth2 import service_account
from googleapiclient.discovery import build

# Configuration
CREDENTIALS_FILE = "/home/{{USER}}/Documents/autonomous-living/scripts/google_credentials.json"
PRIMARY_CALENDAR_ID = "{{EMAIL}}"
SCOPES = ['https://www.googleapis.com/auth/calendar'] # Need non-readonly to 'insert' to list

def activate():
    creds = service_account.Credentials.from_service_account_file(
        CREDENTIALS_FILE, scopes=SCOPES)
    service = build('calendar', 'v3', credentials=creds)
    
    print(f"Attempting to add {PRIMARY_CALENDAR_ID} to service account's calendar list...")
    calendar_list_entry = {
        'id': PRIMARY_CALENDAR_ID
    }
    
    try:
        created_entry = service.calendarList().insert(body=calendar_list_entry).execute()
        print(f"✅ Success! {PRIMARY_CALENDAR_ID} is now active for the service account.")
        print(f"Summary: {created_entry.get('summary')}")
    except Exception as e:
        print(f"❌ Error activating calendar: {e}")

if __name__ == "__main__":
    activate()
