---
title: "pantry_to_tasks.py: Pantry-to-Google-Tasks Sync"
type: "automation_spec"
status: "active"
automation_id: "pantry-to-tasks"
goal_id: "goal-g03"
systems: ["S03", "S05", "S08"]
owner: "Michal"
updated: "2026-02-24"
---

# pantry_to_tasks.py: Pantry-to-Google-Tasks Sync

## Purpose
Automatically synchronizes low-stock and expiring items from the `autonomous_pantry` database to a dedicated Google Tasks list for frictionless household restocking.

## Triggers
- **Scheduled:** Daily (06:00 AM Weekdays / 09:00 AM Weekends) via `autonomous_daily_manager.py`
- **Manual:** `python3 scripts/pantry_to_tasks.py`

## Inputs
- **PostgreSQL:** `autonomous_pantry` database (tables: `pantry_inventory`)
- **Credentials:** `google_tasks_token.pickle` (Google Tasks API)

## Processing Logic
1. Query `pantry_inventory` for items where `current_quantity <= critical_threshold`.
2. Query `pantry_inventory` for items with `next_expiry` within the next 7 days.
3. For each item, check if a task with the same title already exists in the "Shopping (Autonomous)" task list.
4. If not exists, create a new task with stock details and expiry dates.

## Outputs
- **Google Tasks:** Updates/Creates tasks in "Shopping (Autonomous)" list.
- **Logs:** Console output during execution.

## Dependencies
### Systems
- [S03 Data Layer](../../20_Systems/S03_Data-Layer/README.md)
- [S08 Automation Orchestrator](../../20_Systems/S08_Automation-Orchestrator/README.md)

### External Services
- **Google Tasks API:** For task creation and management.

### Credentials
- `google_tasks_token.pickle`: OAuth2 token for Google API access.
- `client_secret.json`: Google Cloud Project credentials.

## Error Handling
| Failure Scenario | Detection | Response | Alert |
|---|---|---|---|
| Database Connection Fail | `psycopg2.OperationalError` | Script exits with error message | Cron log entry |
| Google API Auth Expired | `google.auth.exceptions.RefreshError` | Script attempts refresh; fails if token invalid | Manual re-auth required |
| Duplicate Tasks | Internal Logic | Matches on title to prevent spamming | None |

## Monitoring
- **Success Metric:** "Shopping (Autonomous)" list reflects current database state.
- **Alert on:** Failed execution in `manager.log`.

## Manual Fallback
```bash
cd {{ROOT_LOCATION}}/autonomous-living/scripts
./.venv/bin/python3 pantry_to_tasks.py
```
