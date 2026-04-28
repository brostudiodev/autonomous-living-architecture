---
title: "G01: Progress Analyzer (Body Composition)"
type: "automation_spec"
status: "active"
automation_id: "G01_progress_analyzer.py"
goal_id: "goal-g01"
systems: ["S03", "S06"]
owner: "Michał"
updated: "2026-04-28"
---

# G01: Progress Analyzer (Body Composition)

## Purpose
Calculates high-fidelity trends for Weight and Body Fat % using 7-day moving averages. This provides a more accurate picture of progress toward the 15% Body Fat target by smoothing out daily biological fluctuations.

## Triggers
- **Automated:** Executed as part of the `G11_global_sync.py` registry.
- **Manual:** `python3 scripts/G01_progress_analyzer.py`
- **Dashboard:** Injected into the "Director's Insights" section of the Daily Note.

## Inputs
- PostgreSQL Database: `autonomous_health`
- Table: `biometrics` (requires `weight_kg` and `body_fat_pct`).

## Processing Logic
1.  **Data Retrieval:** Fetches all historical weight and body fat records sorted by date.
2.  **Rolling Average:** Uses Pandas to calculate a 7-day rolling mean for both metrics.
3.  **Delta Calculation:** Compares today's 7-day average against the average from 7 days ago.
4.  **Baseline Comparison:** Compares current metrics against the Jan 2026 baseline (20.8%).
5.  **Target Analysis:** Calculates the remaining gap to the 15.0% Body Fat goal.
6.  **Projection:** Calculates estimated date to reach 15% target based on 30-day linear regression of BF% changes.
7.  **Milestone Alerts:** Generates a "Monthly Photo Log" reminder on the 1st of each month.

## Outputs
- **Markdown Report:** A trend summary including +/- changes, baseline progress, gap analysis, and projections.
- **Centralized Logging:** Reports `SUCCESS` or `FAILURE` to `system_activity_log`.

## Dependencies
### Systems
- [S03 Data Layer](../../20_Systems/S03_Data-Layer/README.md)
- [S06 Health Performance System](../../20_Systems/S06_Health-Performance/README.md)

## Error Handling
| Failure Scenario | Detection | Response | Alert |
|---|---|---|---|
| Missing Data | < 3 days of measurements | Return "Insufficient data" warning | System Activity Log |
| DB Error | `psycopg2` exception | Log failure | System Activity Log |

## Manual Fallback
If trend analysis is unavailable:
1.  Manually review weight logs in the Withings or Zepp apps.
2.  Check the `biometrics` table directly via SQL.
