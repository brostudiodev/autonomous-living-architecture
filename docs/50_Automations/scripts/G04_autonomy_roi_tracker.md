---
title: "G04: Autonomy ROI Tracker"
type: "automation_spec"
status: "active"
automation_id: "G04_autonomy_roi_tracker"
goal_id: "goal-g04"
systems: ["S03", "S04", "S11"]
owner: "Michał"
updated: "2026-03-08"
---

# G04: Autonomy ROI Tracker

## Purpose
Quantifies the time saved by autonomous systems by logging "time-saving events" to a central database. This provides empirical data for the "Autonomy ROI" KPI.

## Triggers
- **Internal Call:** Triggered by other scripts via `DigitalTwinEngine.log_roi()`.
- **G03_cart_aggregator.py:** Logged after successful shopping list generation.
- **G05_llm_categorizer.py:** Logged after successful transaction categorization.
- **G10_tomorrow_planner.py:** Logged after successful mission briefing generation.

## Inputs
- **Source:** The script name triggering the log.
- **Category:** Human-readable category (e.g., "Logistics & Procurement").
- **Minutes:** Integer value of estimated time saved.
- **Details:** Contextual string describing the specific action taken.

## Processing Logic
1. Receive event data via `log_roi` method in `G04_digital_twin_engine.py`.
2. Connect to `digital_twin_michal` PostgreSQL database.
3. Insert record into `autonomy_roi` table with timestamp.
4. Provide summary data via `get_roi_summary()` for dashboards and reports.

## Outputs
- **Database Record:** Entry in `digital_twin_michal.autonomy_roi`.
- **ROI Summary:** JSON/Text output for `/roi` API endpoint and Daily Note updates.

## Dependencies
### Systems
- [S03 Data Layer](../../20_Systems/S03_Data-Layer/README.md)
- [S04 Digital Twin](../../20_Systems/S04_Digital-Twin/README.md)

### External Services
- None (Local PostgreSQL)

### Credentials
- DB_PASSWORD (loaded from `.env`)

## Error Handling
| Failure Scenario | Detection | Response | Alert |
|---|---|---|---|
| DB Connection Fail | Try/Except block in `log_roi` | Log error to console, continue execution | No alert (non-critical) |
| Table Missing | `initialize_roi_table` check | Automatically create table if missing | Log info |

## Monitoring
- **Success metric:** Total minutes logged today > 0.
- **Alert on:** 3 consecutive days of 0 ROI logged (indicates system stagnation).
- **Dashboard:** Digital Twin Dashboard (`/roi` endpoint).

## Manual Fallback
If automation fails, manual ROI can be entered in the Obsidian Daily Note frontmatter:
```yaml
time_saved_minutes: 45
```
The system will aggregate both database and manual entries.

## Related Documentation
- [G04: Digital Twin README](../../10_Goals/G04_Digital-Twin-Ecosystem/README.md)
- [G11: Meta-System README](../../10_Goals/G11_Meta-System-Integration-Optimization/README.md)
