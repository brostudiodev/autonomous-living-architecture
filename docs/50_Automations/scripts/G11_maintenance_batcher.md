---
title: "Automation Spec: G11_maintenance_batcher.py"
type: "automation_spec"
status: "active"
automation_id: "G11_maintenance_batcher"
goal_id: "goal-g11"
systems: ["S11", "S08", "S07"]
owner: "Michal"
updated: "2026-04-18"
---

# 🤖 Automation Spec: G11_maintenance_batcher.py

## Purpose
Reduces daily cognitive load and "alert fatigue" by batching non-critical hardware and logistics maintenance tasks into a single weekly "Sunday Admin" task. It acts as a triage layer between raw sensor data/deadlines and the user's active task list.

## Triggers
- **Daily Sync:** Executed as part of `G11_global_sync.py`.
- **Manual:** `python3 G11_maintenance_batcher.py` to check current maintenance state.

## Inputs
- **Home Assistant API:** Fetches battery levels for all connected sensors via `G08_home_monitor.py`.
- **Database:** `autonomous_life_logistics` (Fetches items due within 7 days).
- **Environment:** `.env` for Home Assistant URL and Token.

## Processing Logic
1.  **Data Collection:**
    -   Scans HA states for all entities containing `battery` in their ID.
    -   Queries the logistics database for any item with a `due_date` within the next 7 days that is not marked as `DONE` or `Completed`.
2.  **Triage & Batching:**
    -   **Sunday Logic:** If the current day is Sunday, it aggregates all identified items into a single consolidated Google Task: `🛠️ Sunday Admin: Maintenance & Hardware`.
    -   **Weekday Logic:** If it's not Sunday, the script remains silent unless a critical threshold is met.
3.  **Critical Overrides:**
    -   **Battery Critical:** If any battery level is `< 5%`, an immediate Telegram alert is sent regardless of the day.
    -   **Logistics Overdue:** If any logistics item is past its `due_date`, an immediate Telegram alert is sent.
4.  **Logging:** Records the number of items batched or alerted in the `system_activity_log`.

## Outputs
- **Google Tasks:** A single consolidated task in the "Today's Autonomous Focus" list (on Sundays).
- **Telegram Notification:** Critical alerts for immediate action (any day).
- **Activity Log:** Success/Failure status recorded in `system_activity_log`.

## Dependencies
### Systems
- [S07 Smart Home](../../20_Systems/S07_Smart-Home/README.md)
- [S08 Automation Orchestrator](../../20_Systems/S08_Automation-Orchestrator/README.md)
- [S11 Meta-System](../../20_Systems/S11_Meta-System-Integration/README.md)

### External Services
- Home Assistant (REST API)
- Google Tasks API
- Telegram Bot API

## Error Handling
| Failure Scenario | Detection | Response | Alert |
|---|---|---|---|
| HA API Offline | Connection timeout/error | Log error, skip battery check | System Activity Log |
| DB Query Failure | `psycopg2` exception | Log error, skip logistics check | System Activity Log |
| Google Tasks Error | API exception | Log error, fallback to Telegram | System Activity Log |

## Manual Fallback
If the Sunday task is not created:
1.  Run the script manually: `python3 G11_maintenance_batcher.py`.
2.  Check `G11_log_system` for errors related to HA or Google Tasks.
3.  Manually review the "Battery" section in the Grafana dashboard or the `autonomous_life_logistics` table.
