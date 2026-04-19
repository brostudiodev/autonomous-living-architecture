---
title: "Automation Spec: G10 Productivity ROI Reporter"
type: "automation_spec"
status: "active"
automation_id: "G10_productivity_roi_reporter"
goal_id: "goal-g10"
systems: ["S04", "S10"]
owner: "Michal"
updated: "2026-04-18"
---

# G10: Productivity ROI Reporter

## Purpose
Generates daily and weekly productivity ROI analysis by quantifying reclaimed time from autonomous actions and measuring overall system reliability. It provides a data-driven "Efficiency Index" to track how effectively the system is managing your focus.

## Triggers
- **Daily Manager:** Part of the `autonomous_daily_manager.py` cycle.
- **Manual:** `python3 G10_productivity_roi_reporter.py`

## Inputs
- **Autonomy ROI:** `autonomy_roi` table in `digital_twin_michal`.
- **System Activity:** `system_activity_log` for reliability stats.

## Processing Logic
1.  **Reclaimed Time Aggregation:** Sums minutes saved for today and the last 7 days.
2.  **Reliability Calculation:** Calculates success rate of all scripts in the last 24 hours.
3.  **Efficiency Indexing:** Computes `(Hours Reclaimed Today) * (System Success Rate)`.
4.  **Trend Analysis:** Generates a 7-day velocity chart with impact labeling (High/Normal/Low).

## Outputs
- **Markdown Report:** Detailed efficiency summary injected into the Daily Note under `%%VELOCITY%%`.
- **System Activity Log:** Success/Failure of report generation.

## Dependencies
### Systems
- [S04 Digital Twin Ecosystem](../../20_Systems/S04_Digital-Twin/README.md)
- [S10 Productivity Platform](../../20_Systems/S09_Productivity-Time/README.md)

## Error Handling
| Failure Scenario | Detection | Response | Alert |
|---|---|---|---|
| DB Connection Fail | Exception | Logs error, returns partial report | Console |

## Monitoring
- **Daily Note:** "Productivity & Autonomy ROI" section.
