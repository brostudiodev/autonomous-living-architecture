---
title: "G05: Financial Anomaly Detector"
type: "automation_spec"
status: "active"
automation_id: "G05_finance_anomaly_detector"
goal_id: "goal-g05"
systems: ["S05"]
owner: "Michal"
updated: "2026-03-12"
---

# G05: Financial Anomaly Detector

## Purpose
Monitors category-level spending to detect unusual spikes or hidden subscription costs. It distinguishes between "real" anomalies and planned expenses by cross-referencing spending with the expense calendar.

## Triggers
- **Scheduled:** Part of the `autonomous_daily_manager.py` daily sync cycle.
- **Manual:** `python3 scripts/G05_finance_anomaly_detector.py`

## Inputs
- **PostgreSQL:** `transactions`, `categories`, `expense_calendar`.
- **Logic:** Rolling 3-month average + Current Month Expected Expenses.

## Processing Logic
1.  **Query Current:** Aggregate total expense per sub-category for the current month.
2.  **Query History:** Calculate the average monthly expense per category for the previous 3 months (Lagging Indicators).
3.  **Query Expectations:** Pull planned large expenses from `expense_calendar` (Forward-Looking Context).
4.  **Smart Filtering (Contextual Analysis):**
    -   Identify categories where current spend is >100 PLN AND >20% above the historical average.
    -   **False Positive Check:** If the spike matches a planned expense in the `expense_calendar` (within 10%), it is auto-ignored.
    -   **Criticality Check:** Spikes in categories containing "Other" (uncategorized) or deviations >100% are flagged as CRITICAL.
5.  **Contextual Reporting:** For each anomaly, the script identifies the largest single transaction contributing to the spike.

## Outputs
- **Markdown Report:** Injected into the Daily Note.
- **Telegram Alert:** Proactive notification sent for CRITICAL anomalies (e.g., unrecognized spikes or budget-breaking "Other" entries).
- **Activity Log:** Reports `WARNING` for real anomalies or `SUCCESS` if patterns are normal.

## Error Handling
| Failure Scenario | Detection | Response | Alert |
|---|---|---|---|
| Insufficient Data | <3 months history | Gracefully exit with "Insufficient data" | Log Info |
| Missing Calendar | Empty `expense_calendar` | Proceed with simple average-based detection | Log Warning |
| DB Error | psycopg2 error | Exit with error | Log Failure |
