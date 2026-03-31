---
title: "G05: Budget Rebalancer"
type: "automation_spec"
status: "active"
automation_id: "G05_budget_rebalancer"
goal_id: "goal-g05"
systems: ["S05", "S11"]
owner: "Michal"
updated: "2026-03-20"
---

# G05: Budget Rebalancer

## Purpose
Identifies budget breaches and surpluses across financial categories, providing automated reallocation suggestions or executing rebalances for amounts up to **2000 PLN** based on autonomy policies and current savings rate.

## Triggers
- **Daily Manager:** Part of the `autonomous_daily_manager.py` cycle.
- **Manual Execute:** `python3 G05_budget_rebalancer.py --execute` for forced database and sheet update.

## Inputs
- **Transactions Data**: Aggregated by category for the current month from `autonomous_finance` database.
- **Budget Definitions**: Monthly targets and priority levels from the database.
- **Rules Engine:** Evaluates if a specific rebalance can be auto-executed.

## Processing Logic
1.  **Breach Detection**: Identifies categories where actual spending exceeds the monthly budget.
2.  **Surplus Identification**: Finds categories with remaining funds, leaving a 20% safety buffer.
3.  **Policy Evaluation:** For each potential transfer, it calls `G11_rules_engine` with `amount`, `priority`, and `savings_rate`.
4.  **Autonomy Levels (NEW Mar 28):**
    -   **Full Autonomy (Low-Stakes):** Transfers < 100 PLN from `surplus_priority_below: 4` are auto-executed.
    -   **Sleep-Driven Safety:** If Sleep Score < 70, all rebalancing thresholds are **halved** automatically.
    -   **Limited Autonomy:** Transfers up to 2000 PLN require 1-click Telegram approval.
5.  **Agentic Execution:**
    -   If the engine returns `AUTO_ACT`, the script updates the `budgets` table immediately.
    -   If the engine returns `ASK_HUMAN`, it creates a `PENDING` request for proactive Telegram approval.
    -   Approved requests are executed via `G11_decision_handler.py`.
6.  **Synchronization:** Automatically calls `G05_finance_sync.py --to-sheets` to push changes to Google Sheets.
7.  **Reporting:** Injects suggestions into the `%%REBALANCE%%` marker in the Daily Note for manual visibility.

## Changelog
| Date | Change |
|------|--------|
| 2026-03-20 | Initial budget rebalancing logic |
| 2026-03-28 | Implemented Low-Stakes Full Autonomy and Sleep-Driven Safety thresholds |

## Outputs
- **Markdown Suggestions**: Detailed reallocation plan injected into the Daily Note.
- **Database Updates**: Direct adjustments to the `budgets` table.
- **Google Sheets Sync**: Updates the "Budget" tab in the Finance spreadsheet.
- **Telegram Notification**: Confirms autonomous execution and amount.

## Dependencies
### Systems
- [S05 Data Layer - Finance](../../10_Goals/G05_Autonomous-Financial-Command-Center/README.md)
- [S03 Data Layer](../../20_Systems/S03_Data-Layer/README.md)
- [S11 Meta-System](../../20_Systems/S11_Meta-System-Integration/README.md)

## Error Handling
| Failure Scenario | Detection | Response | Alert |
|---|---|---|---|
| Sheet Sync Fail | Exception in gspread | DB updated, but notify user of sync lag | Telegram |
| Insufficient Surplus | Algorithm check | Reports shortfall and recommends manual review | Daily Note |

## Monitoring
- **Success metric**: Percentage of budget breaches covered autonomously.
- **Audit**: Review "AI changes" column in Google Sheets.
