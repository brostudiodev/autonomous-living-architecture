---
title: "G10: Task Sync"
type: "automation_spec"
status: "active"
automation_id: "G10_task_sync"
goal_id: "goal-g10"
systems: ["S03", "S08"]
owner: "Michał"
updated: "2026-04-27"
---

# G10: Task Sync

## Purpose
Provides bidirectional synchronization of completed tasks between the Obsidian Daily Note and Google Tasks to eliminate double-entry.

## Triggers
- **Scheduled:** Part of the `autonomous_daily_manager.py` cycle (Morning/Evening).
- **Manual:** Can be run via CLI to force synchronization.

## Inputs
- **Obsidian Daily Note:** `01_Daily_Notes/YYYY-MM-DD.md` (for task completion status `[x]`).
- **Google Tasks API:** List of tasks completed in the last 24 hours.

## Processing Logic
1. **Prefetching (MTD Optimization 2026-04-27):**
    - Fetches all pending Google Tasks in a single call to cache titles and IDs.
    - Prevents timeouts and excessive API overhead.
2. **Obsidian -> Google Tasks:**
    - Scans the today's daily note for tasks marked as completed (`- [x]`).
    - Uses cached ID-based lookup to mark tasks completed in Google Tasks, minimizing API latency.
3. **Google Tasks -> Obsidian:**
    - Fetches tasks completed on Google Tasks within the last 24 hours.
    - Searches for matching task titles in the today's daily note.
    - If a matching uncompleted task (`- [ ]`) is found, marks it as completed (`- [x]`).
4. **ROI Logging:**
    - Logs 1 minute of "Time Architecture" ROI for every task successfully synced.

## Outputs
- **Obsidian Note:** Updated completion status for tasks.
- **Google Tasks:** Updated status for tasks.
- **ROI Log:** Entry in `autonomy_roi` table in `digital_twin_michal` database.

## Dependencies
### Systems
- [S03 Data Layer](../../20_Systems/S03_Data-Layer/README.md)
- [S08 Personal Agents](../../20_Systems/S08_Automation-Orchestrator/README.md)

### External Services
- **Google Tasks API:** Requires valid OAuth token (`google_tasks_token.pickle`).
- **Obsidian Vault:** Local filesystem access.

### Credentials
- `google_tasks_token.pickle`: User OAuth credentials for Tasks API.

## Error Handling
| Failure Scenario | Detection | Response | Alert |
|---|---|---|---|
| Google API Timeout | Exception during fetch | Skip sync, retry next cycle. Optimized 2026-04-27 to reduce risk. | Log warning |
| Missing Daily Note | File not found | Exit silently (too early) | None |
| Title Mismatch | No regex match | Skip task | None |

## Monitoring
- **Success metric:** Task sync counts logged to `system_activity_log`.
- **Alert on:** 3 consecutive sync failures.
- **Dashboard:** Digital Twin Activity Log.

## Manual Fallback
If sync fails, users must manually check tasks in both systems. To force a sync:
```bash
{{ROOT_LOCATION}}/autonomous-living/.venv/bin/python3 {{ROOT_LOCATION}}/autonomous-living/scripts/G10_task_sync.py
```
