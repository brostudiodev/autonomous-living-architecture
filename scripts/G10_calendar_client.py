import os
import datetime
from google.oauth2 import service_account
from googleapiclient.discovery import build

# Configuration
CREDENTIALS_FILE = "/home/{{USER}}/Documents/autonomous-living/scripts/google_credentials.json"
PRIMARY_CALENDAR_ID = "{{EMAIL}}"
SCOPES = ['https://www.googleapis.com/auth/calendar.readonly']

def get_calendar_service():
    if not os.path.exists(CREDENTIALS_FILE):
        print(f"Error: {CREDENTIALS_FILE} not found")
        return None
    
    creds = service_account.Credentials.from_service_account_file(
        CREDENTIALS_FILE, scopes=SCOPES)
    # The service account needs to be shared with the calendar or have domain-wide delegation.
    # In this case, we assume the calendar '{{EMAIL}}' is shared with 
    # the service account email: {{EMAIL}}
    return build('calendar', 'v3', credentials=creds)

def get_today_events():
    service = get_calendar_service()
    if not service:
        return []

    now = datetime.datetime.utcnow().isoformat() + 'Z'  # 'Z' indicates UTC time
    # Start of day
    start_of_day = datetime.datetime.combine(datetime.date.today(), datetime.time.min).isoformat() + 'Z'
    # End of day
    end_of_day = datetime.datetime.combine(datetime.date.today(), datetime.time.max).isoformat() + 'Z'

    try:
        events_result = service.events().list(
            calendarId=PRIMARY_CALENDAR_ID, 
            timeMin=start_of_day,
            timeMax=end_of_day,
            singleEvents=True,
            orderBy='startTime'
        ).execute()
        events = events_result.get('items', [])
        
        parsed_events = []
        for event in events:
            start = event['start'].get('dateTime', event['start'].get('date'))
            end = event['end'].get('dateTime', event['end'].get('date'))
            
            # Format time if it's a dateTime (not all-day)
            if 'T' in start:
                start_time = datetime.datetime.fromisoformat(start.replace('Z', '+00:00')).strftime('%H:%M')
                end_time = datetime.datetime.fromisoformat(end.replace('Z', '+00:00')).strftime('%H:%M')
                time_range = f"{start_time}–{end_time}"
            else:
                time_range = "All Day"
                
            parsed_events.append({
                "time": time_range,
                "summary": event.get('summary', 'No Title'),
                "start_raw": start
            })
        return parsed_events
    except Exception as e:
        print(f"Calendar API Error: {e}")
        return []

if __name__ == "__main__":
    print(f"Fetching events for {PRIMARY_CALENDAR_ID}...")
    events = get_today_events()
    if not events:
        print("No events found or permission error (Service Account needs access to this calendar).")
    for e in events:
        print(f"[{e['time']}] {e['summary']}")
