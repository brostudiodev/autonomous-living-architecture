---
title: "G05: Financial Anomaly Optimizer"
type: "automation_spec"
status: "active"
automation_id: "G05_finance_optimizer.py"
goal_id: "goal-g05"
systems: ["S03", "S05"]
owner: "Michał"
updated: "2026-03-11"
---

# G05: Financial Anomaly Optimizer

## Purpose
Transitions financial management from passive tracking to active defense. This script autonomously identifies unusual spending patterns (anomalies) using statistical standard deviations, flagging potential fraud, double-billing, or budget creep.

## Triggers
- **Automated:** Executed as part of the `G11_global_sync.py` registry.
- **Manual:** `python3 scripts/G05_finance_optimizer.py`
- **Dashboard:** Injected into the "Director's Insights" section of the Daily Note.

## Inputs
- PostgreSQL Database: `autonomous_finance`
- View: `v_spending_anomalies` (Logic: identifies transactions > 1.5x - 3x category average over 90 days).

## Processing Logic
1.  **Anomaly Detection:** Queries the database view for transactions from the last 7 days with an anomaly severity of 'CRITICAL' or 'HIGH'.
2.  **Severity Mapping:** 
    *   🔴 **CRITICAL:** > 3x standard deviation.
    *   🟠 **HIGH:** > 2x standard deviation.
3.  **Synthesis:** Formats anomalies into a readable Markdown alert including the category, amount, and multiplier.

## Outputs
- **Markdown Alert:** Injected into Obsidian daily notes.
- **Centralized Logging:** Reports `WARNING` if anomalies are found, or `SUCCESS` if normal.

## Dependencies
### Systems
- [S03 Data Layer](../../20_Systems/S03_Data-Layer/README.md)
- [S05 Finance System](../../10_Goals/G05_Autonomous-Financial-Command-Center/README.md)

## Error Handling
| Failure Scenario | Detection | Response | Alert |
|---|---|---|---|
| View Missing | SQL Error | Log failure | System Activity Log |
| No Data | Empty dataframe | Report "Normal" status | None |

## Manual Fallback
If anomalies are flagged:
1.  Review the transaction in the bank app or Google Sheet.
2.  If it's a valid but unusual purchase, no action is needed.
3.  If it's an error, correct the entry in Google Sheets and re-sync.
