---
title: "Automation Spec: G11_decision_handler.py"
type: "automation_spec"
status: "active"
automation_id: "G11_decision_handler"
goal_id: "goal-g11"
systems: ["S11", "S04"]
owner: "Michal"
updated: "2026-03-20"
---

# 🤖 Automation Spec: G11_decision_handler.py

## Purpose
The execution engine for human-approved decisions. It scans the Obsidian Daily Note for `#approve_NN` markers or processes specific IDs from the Telegram Bot to execute authorized system actions across all domains.

## Triggers
- **Daily Note Scan:** Part of the `autonomous_daily_manager.py` cycle.
- **Telegram Callback:** Triggered via the Digital Twin API when a user clicks "Approve" on a mobile notification.
- **Manual:** `python3 G11_decision_handler.py [ID]` to force-execute a specific request.

## Inputs
- **Obsidian Daily Note:** `YYYY-MM-DD.md` (Checked for `- [x] #approve_NN`).
- **Database:** `digital_twin_michal.decision_requests` (Fetches payload and policy).
- **Environment:** `.env` for database and API credentials.

## Processing Logic
1.  **Identification:** Extracts IDs from checked tasks in the Daily Note or receives them from the API.
2.  **Action Routing:** Matches the `domain.policy_key` to specific execution functions:
    -   `financial.auto_categorize`: Updates transaction category in PostgreSQL and Google Sheets.
    -   `financial.auto_budget_rebalance`: Increases/decreases budget amounts in PostgreSQL and Google Sheets.
    -   `health.auto_workout_adjustment`: Injects a "Recovery" task into Google Tasks.
    -   `household.auto_procurement`: 
        -   Adds a shopping task to the "Shopping (Autonomous)" list in Google Tasks.
        -   Triggers `G03_cart_aggregator.py` to refresh the Obsidian shopping manifest.
    -   `productivity.focus_block_adjustment`: 
        -   Force-updates the Obsidian Daily Note with a "Recovery" schedule via `G10_schedule_optimizer.py`.
        -   Adds a recovery task to Google Tasks for visibility.
3.  **Status Update:** Marks the request as `RESOLVED` (Success) or `FAILED` (Error) in the database with a timestamp.
4.  **Cascading Resolution:** Automatically identifies and marks all older pending requests for the same category/transaction as `SUPERSEDED` to prevent duplicate actions.

## Outputs
- **Cross-System Actions:** Updates to Google Sheets, Google Tasks, and PostgreSQL databases.
- **Activity Log:** Records the execution result in the `system_activity_log`.

## Dependencies
### Systems
- [S03 Data Layer](../../../20_Systems/S03_Data-Layer/README.md)
- [S11 Meta-System](../../../20_Systems/S11_Meta-System-Integration/README.md)

### External Services
- Google Sheets API
- Google Tasks API

## Error Handling
| Failure Scenario | Detection | Response | Alert |
|---|---|---|---|
| Sheet Row Not Found | `worksheet.find()` fails | Log error, mark request as `FAILED` | System Activity Log |
| API Rate Limit | `gspread` exception | Wait/Retry or fail with error | Log warning |

## Manual Fallback
If an approval fails to execute:
1.  Check the `system_activity_log` for the specific error (e.g., "Transaction ID not found").
2.  Manually execute the action (e.g., categorize in Google Sheets).
3.  Mark the request as `RESOLVED` in the database manually.
