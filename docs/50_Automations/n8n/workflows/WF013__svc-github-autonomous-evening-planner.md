---
title: "WF013: SVC_Github-Autonomous_Evening_Planner"
type: "automation_spec"
status: "active"
automation_id: "WF013__svc-github-autonomous-evening-planner"
goal_id: "goal-g11"
systems: ["S09", "S10"]
owner: "Micha\u0142"
updated: "2026-02-13"
---

# WF013: SVC_Github-Autonomous_Evening_Planner

## Purpose
Acts as a strategic advisor for evening deep-work sessions. It can analyze the current state of all goals from `Execution.md` files in the GitHub repository, recommend a high-priority task for the evening, and handle task completion logging.

## Triggers
- **Workflow Call**: Triggered by `WF002: SVC_Command-Handler` when commands like `/status`, `/plan`, or `/done` are used.

## Inputs
- A JSON object from the router containing the command and its arguments (e.g., `/plan G04 90m`).

## Processing Logic
The workflow has three main paths based on the command:

### /status
1.  **Get Repository Tree**: Fetches the entire file tree from the GitHub repository.
2.  **Filter EXECUTION Files**: Identifies all `Execution.md` files within the `docs/10_Goals/` directory.
3.  **Read Files**: Reads the content of all found `Execution.md` files.
4.  **Combine Data**: Merges the content of all execution files into a single context.
5.  **AI Analysis**: A Gemini LLM generates a strategic evening work recommendation based on the combined execution state.
6.  **Send Report**: The recommendation is sent as a Telegram message.

### /plan
1.  **Parse Command**: Extracts the goal ID and available time from the command.
2.  **Find Goal**: Locates the specified goal's directory in the repository.
3.  **Read `Execution.md`**: Reads the execution file for the specified goal.
4.  **AI Planning**: An Anthropic LLM is used for planning analysis.

### /done
1.  **Parse Command**: Extracts the task ID, goal ID, and actual time spent from the command.
2.  **Update `Execution.md`**: Uses an Anthropic LLM to update the `Execution.md` file, marking the task as complete.
3.  **Commit `Execution.md`**: Commits the updated file to the GitHub repository.
4.  **Update `Activity-log.md`**: Appends a new entry to the goal's `Activity-log.md` file.
5.  **Commit `Activity-log.md`**: Commits the updated activity log.
6.  **Send Confirmation**: Sends a confirmation message to Telegram.

## Outputs
- Telegram messages containing status reports, evening plans, or task completion confirmations.

## Dependencies
### Systems
- [S09 Productivity-Time](../../20_Systems/S09_Productivity-Time/README.md)
- [S10 Daily-Goals-Automation](../../20_Systems/S10_Daily-Goals-Automation/README.md)

### External Services
- GitHub API
- Google Gemini API
- Anthropic API
- Telegram API

### Credentials
- GitHub account (ID: `SWpOnkLoKO1C9hQn`)
- Google Gemini(PaLM) Api account 2 (ID: `x9Jp7ab2PivcIEj9`)
- Telegram (AndrzejAIBot) (ID: `iUTfhBhZ5vUwjE9F`)
- Telegram (OliwiaAIBot) (ID: `DCOwEgVhcQsb8aXC`)

## Error Handling
| Failure Scenario | Detection | Response | Alert |
|---|---|---|---|
| Invalid GitHub Response | The "Filter EXECUTION Files" node receives no tree data. | The workflow execution fails with an error. | Failures are logged in n8n's execution history. |
| No EXECUTION files found | The "Filter EXECUTION Files" node finds no files. | The workflow execution fails with an error. | Failures are logged in n8n's execution history. |
| Invalid Goal ID | The "Parse Plan Command" node detects an invalid goal ID format. | The workflow execution fails with an error. | Failures are logged in n8n's execution history. |

## Monitoring
- **Success Metric**: A successful execution results in a Telegram message or a commit to the GitHub repository.
- **Alerts**: No automated alerts are configured.

## Manual Fallback
If the automation fails, the `Execution.md` and `Activity-log.md` files can be updated manually in the GitHub repository.

## Related Documentation
- [WF002: SVC_Command-Handler](../WF002__svc-command-handler.md)
