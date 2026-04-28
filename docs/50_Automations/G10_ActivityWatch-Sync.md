---
title: "Automation Spec: G10 ActivityWatch Sync"
type: "automation_spec"
status: "active"
owner: "Michał"
updated: "2026-04-16"
---

# G10: ActivityWatch Sync

## Purpose
Synchronizes passive time tracking telemetry from the ActivityWatch server into the Digital Twin PostgreSQL database. This provides the data layer for automated "Deep Work" and productivity analysis.

## Logic
1.  **Discovery:** Finds the `aw-watcher-window` bucket on the ActivityWatch server.
2.  **Incremental Sync:** Fetches only events newer than the last timestamp stored in `activity_watch_events`.
3.  **Classification:** Automatically labels events as `is_productive` based on application names and window titles (e.g., VS Code, Terminal = Productive; YouTube, Social Media = Unproductive).
4.  **Persistence:** Stores `timestamp`, `duration`, `app_name`, `window_title`, and `productivity_label` in the database.

## Inputs/Outputs
- **Inputs:** ActivityWatch REST API (`GET /api/0/buckets/.../events`).
- **Outputs:** `digital_twin_michal.public.activity_watch_events` table.

## Dependencies
- **System:** [S09 Productivity & Time Architecture](../20_Systems/S09_Productivity-Time/README.md)
- **Service:** `activitywatch` container (aw-server).
- **Database:** `DB_TWIN` (PostgreSQL).

## Procedure
The script is integrated into the `G11_global_sync.py` loop and runs every 10-15 minutes (or on demand via the API).

### Manual Execution
```bash
{{ROOT_LOCATION}}/autonomous-living/.venv/bin/python3 scripts/G10_activitywatch_sync.py
```

## Failure Modes
| Scenario | Detection | Response |
|----------|-----------|----------|
| API Connection Refused | Script logs `FAILURE` in `system_activity_log`. | Ensure ActivityWatch container is running (`docker ps`). |
| No Window Bucket | Warning in logs: "No window watcher bucket found". | Ensure `aw-watcher-window` is running on the host machine and connected to the server. |
| Duplicate Events | Database unique constraint trigger. | The script uses `ON CONFLICT DO NOTHING` to prevent duplicates. |

## Security Notes
- Data remains local.
- No sensitive keys are required for the local API.

---
*Created: 2026-04-16 | Registered as Tool: activitywatch_sync*
