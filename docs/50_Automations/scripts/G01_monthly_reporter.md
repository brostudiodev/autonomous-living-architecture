---
title: "G01: Monthly Health Reporter"
type: "automation_spec"
status: "active"
automation_id: "G01_monthly_reporter"
goal_id: "goal-g01"
systems: ["S01", "S03"]
owner: "Michal"
updated: "2026-03-20"
---

# G01: Monthly Health Reporter

## Purpose
Generates a monthly executive summary of body composition (weight, body fat) and HIT training performance (sessions, TUT).

## Triggers
- Scheduled: Part of the `G11_global_sync.py` registry (Runs only on the 1st of each month).
- Manual: `python3 G01_monthly_reporter.py`

## Inputs
- `autonomous_training` database (Workouts/Sets tables)
- `autonomous_health` database (Biometrics table)

## Processing Logic
1.  **Training Stats:** Aggregate total workout count and average Time Under Tension (TUT) for the current/previous month.
2.  **Health Stats:** Calculate weight and body fat delta (start vs. end of month).
3.  **Insight Generation:** Determine if weight is trending down and if performance is progressing (TUT > 60s).
4.  **Markdown Export:** Write to `docs/10_Goals/G01_Target-Body-Fat/artifacts/reports/YYYY-MM_Monthly_Health_Report.md`.

## Outputs
- Markdown report file in goal artifacts.
- Console status log.

## Dependencies
### Systems
- [S03 Data Layer](../../20_Systems/S03_Data-Layer/README.md)
- [S01 Observability](../../20_Systems/S01_Observability-Monitoring/README.md)

## Error Handling
| Failure Scenario | Detection | Response | Alert |
|---|---|---|---|
| DB Connection Fail | Exception caught | Log error to console | G11 Sync Log |
| Missing Data | Empty query result | Return "N/A" for metrics | Report still generated |

## Monitoring
- Success metric: Monthly report file exists on the 1st of the month.
- Audit: Check `docs/10_Goals/G01_Target-Body-Fat/artifacts/reports/`.
