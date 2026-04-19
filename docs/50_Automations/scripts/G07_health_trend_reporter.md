---
title: "G07_health_trend_reporter.py: Biological Velocity Engine"
type: "automation_spec"
status: "active"
automation_id: "g07-health-trend-reporter"
goal_id: "goal-g07"
systems: ["S03", "S10"]
owner: "Michal"
updated: "2026-03-10"
review_cadence: "Monthly"
---

# G07_health_trend_reporter.py

## Purpose
Automates the longitudinal analysis of biological data by comparing the current 7-day averages against the previous 7-day baseline. It aims to detect subtle shifts in health performance (Sleep, HRV, Steps, Weight) that are invisible in daily snapshots, providing the user with "Biological Velocity" insights.

## Scope
### In Scope
- Calculating 7-day rolling averages for Sleep Score, HRV, Readiness, Steps, and Weight.
- Comparing current period vs. previous period to determine percentage variance.
- **Advanced Telemetry:** Extracting Sleep Architecture (Deep/REM) and System Stress averages.
- **Heuristic Correlation:** Identifying patterns like "High activity vs. Low recovery".
- **Obsidian Integration:** Injecting a Markdown trend table directly into Weekly Review notes.

### Out of Scope
- Medical diagnosis (strictly performance-oriented).
- Modifying raw biometric data.

## Triggers
- **Scheduled:** Triggered by `autonomous_weekly_manager.py` (Every Sunday).
- **API Call:** Via `/health/weekly_report` endpoint.
- **Manual:** `python3 scripts/G07_health_trend_reporter.py [--print]`

## Inputs
- **PostgreSQL (`autonomous_health`):** `biometrics` and `body_metrics` tables.
- **Obsidian Vault:** Weekly Review notes in `03_Areas/A - Systems/Reviews`.

## Processing Logic
1.  **Data Fetch:** Retrieves the last 14 days of biometric metrics from the database.
2.  **Aggregation:** Splits data into "Current Week" (0-7d) and "Previous Week" (7-14d) buckets.
3.  **Trend Calculation:** 
    - `variance = ((curr - prev) / prev) * 100`
    - Assigns indicators: 🔺 (Increase), 🔻 (Decrease), 🟢 (Positive Direction), 🔴 (Negative Direction).
4.  **Insight Synthesis:**
    - Detects HRV improvements.
    - Flags recovery gaps (e.g., Sleep < 80 with Steps > 10k).
5.  **Injection:** Finds the `### 💪 Health` header in the latest `YYYY-WXX.md` and replaces/inserts the trend report.

## Outputs
- **Markdown Table:** Integrated into Obsidian Weekly Reviews.
- **API Response:** JSON/Text summary for Digital Twin consumption.

## Dependencies
### Systems
- [S03 Data Layer](../../20_Systems/S03_Data-Layer/README.md) - Database backend.
- [S10 Productivity](../../10_Goals/G{{LONG_IDENTIFIER}}/README.md) - Consumes metrics for review.

## Error Handling
| Failure Scenario | Detection | Response | Alert |
|---|---|---|---|
| DB Offline | `psycopg2` Error | Report "Data Source Offline" | API 500 |
| Weekly Note Missing | `os.path.exists` | Log warning, skip injection | Console |
| Insufficient Data | Count < 3 days | Report "⚠️ Insufficient baseline" | Note UI |

## Related Documentation
- [Goal: G07 Predictive Health Management](../../10_Goals/G07_Predictive-Health-Management/README.md)
- [Script: autonomous_weekly_manager.py](./autonomous_weekly_manager.md)

---
*Created: 2026-03-10 by Digital Twin Assistant*
