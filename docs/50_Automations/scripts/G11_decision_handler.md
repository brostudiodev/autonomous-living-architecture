---
title: "Automation Spec: G11_decision_handler.py"
type: "automation_spec"
status: "active"
automation_id: "G11_decision_handler"
goal_id: "goal-g11"
systems: ["S11", "S04"]
owner: "Michał"
updated: "2026-04-28"
---

# 🤖 Automation Spec: G11_decision_handler.py

## Purpose
The execution engine for human-approved decisions and **Implicit Autonomy** actions. It scans the Obsidian Daily Note for `#approve_NN` markers, processes specific IDs from the Telegram Bot, or executes high-trust actions automatically to authorized system actions across all domains.

## Triggers
- **Implicit Approval:** Automatically triggered by `G11_decision_proposer.py` for high-trust policies.
- **Daily Note Scan:** Part of the `autonomous_daily_manager.py` cycle.
- **Telegram Callback:** Triggered via the Digital Twin API when a user clicks "Approve" on a mobile notification.
- **Manual:** `python3 G11_decision_handler.py [ID]` to force-execute a specific request.

## Inputs
- **Obsidian Daily Note:** `YYYY-MM-DD.md` (Checked for `- [x] #approve_NN`).
- **Database:** `digital_twin_michal.decision_requests` (Fetches payload and policy).
- **Environment:** `.env` for database and API credentials.

## Processing Logic
1.  **Resilience (Circuit Breaker):** Integrates with `G04_domain_isolator`. If the `decision_handler` domain is flagged as unstable, the script fast-fails to prevent cascading system hangs.
2.  **Identification:** Extracts IDs from checked tasks in the Daily Note or receives them from the API.
3.  **State Verification (Hardening):** Strictly verifies that a decision request is in `PENDING` status before execution (unless explicitly overridden by a specific ID from a trusted source), preventing duplicate actions or race conditions.
4.  **Action Routing:** Matches the `domain.policy_key` to specific execution functions:
    -   `meta.roadmap_task_enforcement`: Injects high-priority tasks into Google Tasks.
    -   `career.content_scheduling`: Finalizes and schedules Substack drafts.
    -   `financial.auto_categorize` / `auto_budget_rebalance`: Updates PostgreSQL and Google Sheets.
    -   `household.auto_procurement`: Adds shopping tasks and refreshes manifest.
    -   `productivity.focus_block_adjustment`: Re-optimizes schedule and updates Daily Note.
5.  **Cascading Resolution (NEW):** Automatically identifies and marks all older `PENDING` requests for the same item (e.g., same transaction or same pantry restock) as `SUPERSEDED`. This eliminates "approval storms" and prevents redundant execution of historical requests.
6.  **Status Update:** Marks the request as `RESOLVED` (Success) or `FAILED` (Error) in the database with a timestamp and detailed resolution result.

## Outputs
- **Cross-System Actions:** Updates to Google Sheets, Google Tasks, and PostgreSQL databases.
- **Activity Log:** Records the execution result in the `system_activity_log`.

## Dependencies
### Systems
- [S03 Data Layer](../../20_Systems/S03_Data-Layer/README.md)
- [S11 Meta-System](../../20_Systems/S11_Meta-System-Integration/README.md)

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
