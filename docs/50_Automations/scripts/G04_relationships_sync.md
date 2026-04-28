---
title: "G04: Relationships Sync"
type: "automation_spec"
status: "active"
automation_id: "G04_relationships_sync"
goal_id: "goal-g04"
systems: ["S04", "S10"]
owner: "Michał"
updated: "2026-03-19"
---

# G04: G04_relationships_sync.py

## Purpose
Synchronizes relationship data from the `Life_Logistics` Google Sheet to the `autonomous_life_logistics` database and automatically generates Google Tasks for periodic contact reminders.

## Triggers
- **Scheduled:** Part of the global sync cycle via `G11_global_sync.py`.
- **Manual:** `python3 scripts/G04_relationships_sync.py`

## Inputs
- **Google Sheet:** `Life_Logistics` (Worksheet: `Relationships`)
- **Headers:** `Name`, `Relationship_Type`, `Desired_Frequency_Days`, `Last_Contact_Date`, `Comment`
- **Database:** `autonomous_life_logistics` (Table: `relationships`)

## Processing Logic
1.  Connects to Google Sheets and fetches all records from the `Relationships` worksheet.
2.  Truncates the `relationships` table in the database to ensure a clean sync.
3.  Parses dates and frequencies, then inserts data into the local database.
4.  **Automation Logic:** For each person, calculates `Next_Contact = Last_Contact_Date + Desired_Frequency_Days`.
5.  If `Next_Contact <= Today`, creates a task in the "Relationships" Google Tasks list.
6.  Prevents duplicate tasks by checking for existing active tasks with the same title.

## Outputs
- **Database Table:** `autonomous_life_logistics.public.relationships`
- **Google Tasks:** "Relationships" list updated with contact reminders.

## Dependencies
### Systems
- [S04 Digital Twin Subsystem](../../20_Systems/S04_Digital-Twin/README.md)
- [S10 Daily Goals Automation](../../20_Systems/S10_Daily-Goals-Automation/README.md)

### External Services
- Google Sheets API
- Google Tasks API

### Credentials
- `google_credentials_digital-twin-michal.json` (Service Account)
- `token.json` (User OAuth for Google Tasks)

## Error Handling
| Failure Scenario | Detection | Response | Alert |
|---|---|---|---|
| Sheet Missing | `WorksheetNotFound` Exception | Log error, skip sync | Console |
| DB Connection Fail | `psycopg2.OperationalError` | Log error, exit | System Sync Status: ❌ |
| API Rate Limit | `gspread.exceptions.APIError` | Retry with exponential backoff | Console |

## Monitoring
- **Success Metric:** Total entries synced > 0.
- **Log:** `system_activity_log` (G11) records success/failure.

## Manual Fallback
Check the `Life_Logistics` Google Sheet directly and manually add tasks to Google Tasks.
