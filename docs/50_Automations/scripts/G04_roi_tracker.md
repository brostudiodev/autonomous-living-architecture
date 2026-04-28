---
title: "Automation Spec: G04 ROI Tracker"
type: "automation_spec"
status: "active"
automation_id: "G04_roi_tracker"
goal_id: "goal-g04"
systems: ["S04", "S11"]
owner: "Michał"
updated: "2026-03-25"
---

# G04: ROI Tracker

## Purpose
Automates the calculation of time saved (ROI) by counting successful automation runs and applying estimated time-saved values per script.

## Triggers
- **Daily Manager:** Part of the `autonomous_daily_manager.py` cycle.
- **Manual:** `python3 G04_roi_tracker.py`

## Inputs
- **Activity Log:** `system_activity_log` table in `digital_twin_michal`.
- **ROI Weights:** Internal dictionary mapping script names to minutes saved.

## Processing Logic
1.  **Activity Fetch:** Retrieves all successful script runs from the current day.
2.  **Weighted Calculation:** 
    - Applies a base weight per script run (e.g., 5 mins for finance sync).
    - Applies scalable weights for scripts processing items (e.g., 2 mins per categorized transaction).
3.  **Deduplication:** Clears any existing automated ROI entries for today to prevent double-counting.
4.  **Persistence:** Logs the total daily ROI to the `autonomy_roi` table.

## Outputs
- **Database Entry:** A new row in `autonomy_roi` under the source `G04_roi_tracker`.
- **System Activity Log:** Records the calculation result.

## Dependencies
### Systems
- [S04 Digital Twin Ecosystem](../../20_Systems/S04_Digital-Twin/README.md)
- [S11 Meta-System](../../20_Systems/S11_Meta-System-Integration/README.md)

## Error Handling
| Failure Scenario | Detection | Response | Alert |
|---|---|---|---|
| DB Connection Fail | Exception | Logs error, returns 0 | Console |

## Monitoring
- **Dashboard:** Viewed via `G10_today_status.py` and the Daily Note.
