---
title: "Script: autonomous-daily-manager.py"
type: "automation_spec"
status: "active"
automation_id: "autonomous-daily-manager.py"
goal_id: "goal-g10"
systems: ["S10", "S04", "S09"]
owner: "{{OWNER_NAME}}"
updated: "2026-02-20"
---

# Script: autonomous-daily-manager.py

## Purpose
The core execution engine for daily operations. It automates the creation and enrichment of Obsidian Daily Notes with real-time data from the Digital Twin and goal roadmaps.

## Triggers
- **When**: Scheduled daily at 06:00 AM (via Cron/Systemd)
- **Manual**: Executed via CLI for immediate note refresh

## Inputs
- **Obsidian Template**: `99_System/Templates/Daily/Daily Note Template.md`
- **Databases**: 
  - `autonomous_finance`: Budget alerts and MTD net
  - `autonomous_training`: Workout history and recovery scores
  - `autonomous_pantry`: Inventory stock levels
- **Roadmaps**: All `Roadmap.md` files in `docs/10_GOALS/`

## Processing Logic
1.  **Sync Foundation**: Triggers `pantry_sync.py` to update DB from manual CSVs.
2.  **Note Preparation**: Creates today's `.md` file if missing using the standard template.
3.  **Dynamic Task Injection**:
    - **Status Alerts**: Injects workout due alerts, budget threshold breaches, and low-stock pantry items.
    - **MINS Engine**: Parses roadmaps to find the next incomplete Q1 task for each goal (limit 5).
4.  **Briefing Integration**: Fetches a summary from the `DigitalTwinEngine` (G04).
5.  **Adaptive Scheduling**:
    - Overwrites the `Suggested Schedule` block.
    - Swaps "Workout" for "Mandatory Recovery" if recovery score < 3.
    - Swaps "Admin" for "URGENT Admin" if budget alerts > 0.

## Outputs
- **Enriched Daily Note**: Updated `01_Daily_Notes/YYYY-MM-DD.md` with injected sections.
- **Console Logs**: Success/Error status of database syncs.

## Dependencies
### Systems
- [S04 Digital Twin](../../20_SYSTEMS/S04_Digital-Twin/README.md)
- [S10 Daily Goals Automation](../../20_SYSTEMS/S10_Daily-Goals-Automation/README.md)
- [S09 Productivity & Time](../../20_SYSTEMS/S09_Productivity-Time/README.md)

### External Services
- Obsidian (File system)
- PostgreSQL (Local Docker)

## Error Handling
| Failure Scenario | Detection | Response | Alert |
|---|---|---|---|
| DB Connection Fail | `psycopg2.OperationalError` | Injects "Offline" status to note | Visible in Daily Note |
| Template Missing | `os.path.exists` check | Skips creation, logs error | CLI Output |
| Parsing Error | Exception catch in loop | Skips specific goal, continues | CLI Output |

## Manual Fallback
```bash
cd autonomous-living/scripts
python3 autonomous_daily_manager.py
```
