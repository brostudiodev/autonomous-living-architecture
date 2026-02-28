---
title: "WF014: SVC_GitHub-Todo-List-Extractor"
type: "automation_spec"
status: "active"
automation_id: "WF014__svc-github-todo-list-extractor"
goal_id: "goal-g12"
systems: ["S10"]
owner: "Micha\u0142"
updated: "2026-02-13"
---

# WF014: SVC_GitHub-Todo-List-Extractor

## Purpose
Extracts open TODO items from all Goal Roadmap files (`Roadmap.md`) in the GitHub repository.

## Triggers
- **Workflow Call**: Triggered by another workflow (e.g., `WF002: SVC_Command-Handler`).
- **Webhook**: An HTTP POST request to the `todo-webhook` endpoint.
- **Telegram**: The `/todo` command.

## Inputs
- The command `/todo` or `/todo GXX` via Telegram, webhook, or a sub-workflow call.

## Processing Logic
1.  **Parse Command**: Determines the source of the request (Telegram, webhook, or sub-workflow) and extracts the command.
2.  **Prepare Goals**: Prepares a list of goals to fetch. It can fetch all goals or filter by a specific goal ID provided in the command.
3.  **Get Files from GitHub**: Fetches the `Roadmap.md` file for each selected goal from the GitHub repository.
4.  **Extract Content**: Decodes the base64 content of the files.
5.  **Parse TODOs**: Parses the content of each `Roadmap.md` file, extracting unchecked todo items (`- [ ]`) and grouping them by quarter (Q1, Q2, Q3, Q4).
6.  **Format Response**: Formats the extracted TODOs into a user-friendly, Telegram-ready markdown response.
7.  **Route Output**: Sends the response to the appropriate channel (Telegram, webhook, or parent workflow).

## Outputs
- A formatted string containing the list of open TODO items, grouped by goal and quarter.

## Dependencies
### Systems
- [S10 Daily-Goals-Automation](../../20_Systems/S10_Daily-Goals-Automation/README.md)

### External Services
- GitHub API
- Telegram API

### Credentials
- The workflow uses GitHub and Telegram API credentials stored in n8n.

## Error Handling
| Failure Scenario | Detection | Response | Alert |
|---|---|---|---|
| Invalid Command | The "Is Valid Command?" node fails. | An error response is sent to the webhook. | No alert. |
| GitHub File Not Found | The "GitHub Get File" node fails to retrieve a file. | The error is handled in the "Extract and Merge Content" node, which marks the goal as having an error. | No alert. |

## Monitoring
- **Success Metric**: A successful execution returns a list of TODO items.
- **Alerts**: No automated alerts are configured.

## Manual Fallback
If the automation fails, the `Roadmap.md` files in the GitHub repository can be checked manually.

## Related Documentation
- [WF002: SVC_Command-Handler](../WF002__svc-command-handler.md)
