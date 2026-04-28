---
title: "G03_appliance_monitor: Maintenance Prediction Engine"
type: "automation_spec"
status: "active"
automation_id: "G03_appliance_monitor"
goal_id: "goal-g03"
systems: ["S03", "S04", "S07"]
owner: "Michał"
updated: "2026-04-28"
---

# G03_appliance_monitor: Maintenance Prediction Engine

## Purpose
Monitors the usage cycles of household appliances (Dishwasher, Washing Machine) and generates proactive maintenance requests (salt, filters, cleaning) via the Decision Engine.

## Triggers
- **Daily Briefing:** Part of the `autonomous_daily_manager.py` execution.
- **Global Sync:** Included in `G11_global_sync.py`.

## Inputs
- **Home Assistant API:** Power sensor data (if used for real-time detection).
- **Database:** `digital_twin_michal.appliance_status` (Stores current counts and thresholds).

## Processing Logic
1. **Cycle Tracking:**
   - Increments `cycles_since_maintenance` for active appliances detected via HA power state changes.
2. **Threshold Auditing:**
   - Compares current cycle count against `maintenance_threshold`.
   - Generates a `PENDING` decision request in the Decision Engine when a threshold is breached.
3. **Automated Reset:**
   - Once human approval is received (via `G11_decision_handler.py`), the cycle count is reset to 0 and the maintenance event is recorded in strategic memory.

## Outputs
- **Markdown Summary:** Status table in Daily Note under `%%APPLIANCE_START%%`.
- **Decision Request:** Entry in `decision_requests` table (domain: `household`).
- **Activity Log:** Performance tracking in `system_activity_log`.

## Dependencies
### Systems
- [S03 Data Layer](../../20_Systems/S03_Data-Layer/README.md)
- [S04 Digital Twin](../../20_Systems/S04_Digital-Twin/README.md)
- [S07 Smart Home System](../../20_Systems/S07_Smart-Home/README.md) (Home Assistant)

### Credentials
- Database and HA credentials via `.env`

## Error Handling
| Failure Scenario | Detection | Response | Alert |
|---|---|---|---|
| DB Connection Fail | psycopg2 Exception | Exit with error | Logged to `system_activity_log` |
| HA API Timeout | Requests timeout | Skip real-time tracking | Log warning |

## Monitoring
- Success metric: Number of maintenance cycles accurately recorded.
- Dashboard: Digital Twin API `/status`.

## Related Documentation
- [G03_pantry_one_click](./G03_pantry_one_click.md)
- [G11_decision_proposer](./G11_decision_proposer.md)
- [G11_decision_handler](./G11_decision_handler.md)
