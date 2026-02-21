---
title: "WF111: Autonomous Finance - Daily Budget Alerts"
type: "automation_spec"
status: "inactive"
automation_id: "WF111__autonomous-finance-daily-budget-alerts"
goal_id: "goal-g05"
systems: ["S03", "S08"]
owner: "{{OWNER_NAME}}"
updated: "2026-02-18"
---

# WF111: Autonomous Finance - Daily Budget Alerts

## Purpose
This workflow proactively monitors budget utilization and triggers alerts for categories nearing or exceeding their allocated budget, helping to maintain financial control and prevent overspending. It focuses on 'CRITICAL' and 'HIGH' severity alerts.

## Triggers
-   **When:** Scheduled to run twice daily, at 8 AM and 8 PM (cron expression `0 8,20 * * *`).

## Inputs
-   **PostgreSQL Database:** `autonomous_finance` (access to `budgets` and `transactions` tables via `get_current_budget_alerts()` function).

## Processing Logic
1.  **Schedule Trigger:** Initiates the workflow twice daily.
2.  **Query Critical Budget Alerts:** Executes the `get_current_budget_alerts()` PostgreSQL function, filtering for alerts with `alert_severity` in ('CRITICAL', 'HIGH').
3.  **Has Critical Alerts?**: An If node checks if any critical or high-severity alerts were returned from the database query.
4.  **Format Alert Message:** If alerts are present, a Code node formats a summary message, detailing critical and high-priority alerts with their recommended actions.

*(Note: As of this documentation, there is no direct node to send this formatted alert message via a notification channel. This will need to be configured separately.)*

## Outputs
-   **Formatted Alert Message:** A JSON object containing the `message` and `alert_count` (intended for a downstream notification node).
-   **n8n Execution Log:** Detailed logs of workflow execution.

## Dependencies
### Systems
-   [S03 Data Layer](../../20_Systems/S03-Data-Layer/README.md) (PostgreSQL `autonomous_finance` database with `get_current_budget_alerts()` function deployed).
-   [S08 Automation Orchestrator](../../20_Systems/S08-Automation-Orchestrator/README.md) (n8n instance).

### External Services
-   PostgreSQL database service.

### Credentials
-   `Postgres account autonomous_finance docker` (n8n credential, with access to `autonomous_finance` database).

## Error Handling
-   **Database Query:** Relies on the robustness of the `get_current_budget_alerts()` PostgreSQL function for error handling within the query itself.
-   **Workflow Continuation:** Nodes are configured to continue on failure (`continueOnFail: true`) where appropriate, allowing the workflow to attempt to process all alerts.

## Monitoring
-   **Frequency:** Twice daily.
-   **Alert on:** The presence of critical or high-severity budget alerts (currently, this would need manual inspection of n8n execution logs unless a notification node is added).
-   **Heartbeat Monitor:** This workflow should be monitored by `SVC_Workflow-Heartbeat-Monitor` (WF112) to ensure it runs on schedule.

## Manual Fallback
If automation fails (e.g., database connection issues):
1.  Review n8n execution logs for detailed error messages.
2.  Manually query the `get_current_budget_alerts()` function in PostgreSQL to identify current alerts.
3.  Manually address any budget issues or reconfigure budgets in the Google Sheet.
4.  Consult `P - Finance - Autonomous_Financial_Command_Center_Implementation_Guide.md` troubleshooting for database issues.
