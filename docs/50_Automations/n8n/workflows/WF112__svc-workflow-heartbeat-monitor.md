---
title: "WF112: SVC_Workflow-Heartbeat-Monitor"
type: "automation_spec"
status: "active"
automation_id: "WF112__svc-workflow-heartbeat-monitor"
goal_id: "goal-g11"
systems: ["S08", "S01"]
owner: "{{OWNER_NAME}}"
updated: "2026-02-18"
---

# WF112: SVC_Workflow-Heartbeat-Monitor

## Purpose
This workflow acts as a central monitoring service, regularly checking the execution status of other critical n8n workflows. It identifies workflows that have not run within their expected intervals (missed heartbeats) or are inactive, and sends alerts to ensure the continuous operation of the autonomous living ecosystem.

## Triggers
-   **When:** Scheduled to run every 60 minutes (hourly).

## Inputs
-   **Internal n8n API:** Queries your n8n instance for a list of all workflows and their recent execution history.
-   **Configuration (`Config` node):**
    *   `n8n_baseURL`: Base URL of your n8n instance.
    *   `Telegram_ChatID`: Telegram chat ID for alerts.
    *   `Alert_Email`: Email address for alerts.
    *   `check_window_hours`: The time window (in hours) to check for recent executions.
    *   `send_healthy_summary`: Boolean to control whether a "healthy" summary is sent when no alerts.
-   **Workflows To Monitor (`Workflows To Monitor` node):** A JavaScript array defining specific workflows to monitor, including their ID, name, and `expected_interval_hours`.

## Processing Logic
1.  **Schedule Trigger:** Initiates the workflow hourly.
2.  **Config:** Sets up global variables for n8n base URL, Telegram chat ID, alert email, check window, and healthy summary preference.
3.  **Workflows To Monitor:** Defines a list of n8n workflows (by ID and name) and their expected maximum execution interval.
4.  **Get All Workflows:** Fetches a list of all workflows from the n8n API.
5.  **Get All Recent Executions:** Fetches recent execution data from the n8n API.
6.  **Analyze & Build Report:**
    *   Matches the configured workflows-to-monitor list against actual n8n workflows.
    *   Indexes executions by workflow ID.
    *   Analyzes each monitored workflow for its status:
        *   `not_found`: Workflow defined in monitor list not found in n8n.
        *   `inactive`: Workflow exists but is deactivated.
        *   `no_runs`: Workflow active but no executions found.
        *   `missed_heartbeat`: Last successful run was longer ago than `expected_interval_hours`.
        *   `healthy`: Running as expected.
    *   Compiles a report indicating which workflows have issues.
7.  **Has Alerts?:** An If node checks if the report contains any alerts.
    *   **If Alerts:** Proceeds to send notifications.
    *   **If No Alerts:** Proceeds to check `send_healthy_summary` flag.
8.  **Send Telegram Alert:** Sends a detailed alert message to the configured Telegram chat.
9.  **Send Gmail Alert:** Sends a detailed alert email to the configured email address.
10. **Webhook Alert (Optional):** A disabled node for sending alerts to a generic webhook endpoint.
11. **Send Healthy Summary?:** If no alerts, checks if a healthy summary should be sent.
12. **Send Healthy Summary TG:** (Currently disabled) Sends a healthy summary to Telegram.
13. **Silent - All Healthy:** If no alerts and no healthy summary is configured, the workflow ends silently.

## Outputs
-   **Telegram Notification:** Alerts (and optional healthy summaries) sent to the configured Telegram chat.
-   **Email Notification:** Alerts sent to the configured email address.
-   **n8n Execution Log:** Detailed logs of workflow execution and monitoring results.

## Dependencies
### Systems
-   [S08 Automation Orchestrator](../../20_Systems/S08-Automation-Orchestrator/README.md) (n8n instance - this workflow relies on n8n's internal API)
-   [S01 Observability & Monitoring](../../20_Systems/S01_Observability-Monitoring/README.md) (as this provides core monitoring functionality)

### External Services
-   n8n Internal API
-   Telegram API
-   Gmail API

### Credentials
-   `n8n account` (n8n credential, with API access to query workflows and executions).
-   `Telegram (AndrzejAIBot)` (n8n credential for sending Telegram messages).
-   `Gmail account` (n8n credential for sending email alerts).

## Error Handling
-   **API Call Failures:** HTTP Request nodes have `continueOnFail: true` for robustness.
-   **Report Generation:** JavaScript code includes logic to handle missing data and gracefully build the report.
-   **External Alerts:** Notifies via Telegram and Email if monitored workflows have issues.

## Monitoring
-   **Frequency:** Every 60 minutes.
-   **Alert on:** Workflows not found, inactive, no runs, or missed heartbeats (last run too long ago).
-   **Notification:** Alerts sent via Telegram and Email.

## Manual Fallback
If the Heartbeat Monitor itself fails:
1.  Manually check the n8n UI for workflow statuses and recent executions.
2.  Review n8n server logs.
3.  Restart n8n if necessary.
4.  Verify API credentials for internal n8n API calls.
