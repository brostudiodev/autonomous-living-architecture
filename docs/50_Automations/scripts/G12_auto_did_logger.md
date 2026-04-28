---
title: "G12: Auto Did Logger"
type: "automation"
status: "active"
owner: "Michał"
updated: "2026-04-28"
goal_id: "goal-g12"
---

# G12: Auto Did Logger

## Purpose
The `G12_auto_did_logger.py` is a "Zero-Touch Documentation" tool that automatically captures daily accomplishments from various system sources and injects them into the Obsidian Daily Note. This eliminates the need for manual tracking of technical progress.

## Scope
- **In Scope:**
    - Scanning Git commits for goal-related changes.
    - Scanning PostgreSQL `system_activity_log` for script successes.
    - Scanning Google Tasks for completed items.
    - Updating the "Did" section of each goal in the current Daily Note.
- **Out Scope:**
    - Editing goal roadmaps directly (handled by `G09_sync_daily_goals.py`).
    - Logging manual (non-digital) activities.

## Inputs/Outputs
- **Inputs:**
    - Git Repository (`{{ROOT_LOCATION}}/autonomous-living`)
    - PostgreSQL Database (`digital_twin_michal.system_activity_log`)
    - Google Tasks API (Completed tasks in last 24h)
    - Current Daily Note (`Obsidian Vault/01_Daily_Notes/YYYY-MM-DD.md`)
- **Outputs:**
    - Updated Daily Note with "Did" logs for each touched goal.

## Dependencies
- **Systems:** [S03 Data Layer](../../20_Systems/S03_Data-Layer/README.md), [S04 Digital Twin](../../20_Systems/S04_Digital-Twin/README.md)
- **Services:** Google Tasks API
- **Scripts:** [G11_log_system.py](./G11_log_system.md), [G10_google_tasks_sync.py](./G10_google_tasks_sync.md)

## Procedure
This script is executed automatically by the `autonomous_daily_manager.py` (during morning sync) and `autonomous_evening_manager.py` (before shutdown), and can be triggered manually:
```bash
{{ROOT_LOCATION}}/autonomous-living/.venv/bin/python3 scripts/G12_auto_did_logger.py
```

## Failure Modes
| Scenario | Detection | Response |
|---|---|---|
| Database Connection Fail | Error log: "❌ DB Error" | Check PostgreSQL container status and `.env` credentials. |
| Google Tasks Auth Expired | Error log: "❌ Tasks Error" | Run `G10_google_tasks_sync.py --reauth` to refresh token. |
| Daily Note Missing | Error log: "❌ Daily note not found" | Ensure `fill-daily.sh` has run for the current day. |
| Regex Match Failure | No update in note | Check if Daily Note structure matches the expected `**GXX**` pattern. |

## Security Notes
- Uses `google_tasks_token.pickle` for API access.
- Accesses PostgreSQL via `.env` credentials.
- No sensitive data is logged to the Daily Note; only task titles and commit messages.

## Owner + Review Cadence
- **Owner:** Michał
- **Review Cadence:** Monthly audit of logging accuracy.
