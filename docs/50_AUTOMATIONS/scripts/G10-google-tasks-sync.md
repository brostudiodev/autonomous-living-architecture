---
title: "G10: Google Tasks Sync"
type: "automation_spec"
status: "active"
automation_id: "script:G10_google_tasks_sync.py"
goal_id: "goal-g10"
systems: ["S03", "S10"]
owner: "{{OWNER_NAME}}"
updated: "2026-02-20"
---

# script: G10_google_tasks_sync.py

## Purpose
Autonomously fetch pending tasks from Google Tasks API and provide them as a data source for the Daily Note generation process, eliminating manual to-do list migration.

## Triggers
- **Scheduled:** Triggered by `autonomous_daily_manager.py` (Daily at 05:00 AM)
- **Manual:** `python3 G10_google_tasks_sync.py` from terminal

## Inputs
- **API:** Google Tasks API (v1)
- **Credentials:** `client_secret.json` (OAuth Desktop App)
- **Token:** `google_tasks_token.pickle` (Persistent User Session)

## Processing Logic
1. Authenticate using OAuth2 User Flow (refreshes token: "{{GENERIC_API_SECRET}}" expired).
2. Fetch all Task Lists for the authenticated user.
3. Iterate through active lists and fetch non-completed tasks.
4. Normalize task data (Title, Due Date, List Name).
5. Return a list of task objects for system consumption.

## Outputs
- **Console:** List of fetched tasks (when run standalone).
- **Internal:** Python list/generator for `autonomous_daily_manager.py`.

## Dependencies
### Systems
- **S03 Data Layer:** Provides context for task prioritization.
- **S10 Daily Goals Automation:** Consumes task data for Obsidian notes.

### External Services
- **Google Tasks API:** Source of truth for personal tasks.

### Credentials
- `client_secret.json`: OAuth client ID and secret.
- `google_tasks_token.pickle`: Stored user authorization.

## Error Handling
| Failure Scenario | Detection | Response | Alert |
|---|---|---|---|
| Token: "{{GENERIC_API_SECRET}}" | API returns 401 | Script attempts auto-refresh | Log warning |
| Refresh Token: "{{GENERIC_API_SECRET}}" | Refresh fails | Require manual re-auth (browser) | Obsidian Warning |
| API Quota Reached | API returns 429 | Back-off and retry | Log Error |
| Network Offline | Connection Error | Skip sync, use last known state | Log warning |

## Monitoring
- **Success metric:** Task block correctly appears in Obsidian Daily Note.
- **Alert on:** 2 consecutive days with "Google Tasks Error" in Daily Note.

## Manual Fallback
If automation fails:
1. Open Google Tasks on mobile/web.
2. Manually type critical tasks into Obsidian "Tasks (manual planning)" section.
3. Check `client_secret.json` validity in Google Cloud Console.
