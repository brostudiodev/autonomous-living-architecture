---
title: "SVC: Digital Twin Todos"
type: "automation_spec"
status: "active"
automation_id: "SVC_Digital-Twin-Todos"
goal_id: "goal-g04"
systems: ["S04", "S08"]
owner: "Michal"
updated: "2026-02-25"
---

# SVC: Digital-Twin-Todos

## Purpose
Aggregates all tasks from Google Tasks, System Alerts (Pantry, Finance, Home), and active Q2 Roadmap missions into a single, time-categorized agenda (Today, Tomorrow, 7 Days). This provides full transparency into upcoming personal and project-based goals.

## Triggers
- **Workflow Trigger:** Executed by another workflow (e.g., `ROUTER_Intelligent_Hub`).
- **Command:** Triggered via `/todos` in Telegram or CLI.

## Inputs
- **Workflow Input:** JSON object containing `chat_id`, `source_type`, and `username` (usually passed from the router).
- **API Call:** Requests data from `http://{{INTERNAL_IP}}:5677/todos?format=text`.

## Processing Logic
1. **Normalize Router Input:** Extracts context (`chat_id`, `source_type`) and handles default language/username.
2. **Fetch Twin Todos:** Performs an HTTP GET request to the Digital Twin API's `/todos` endpoint.
3. **Format for Dispatcher:** Normalizes the plain text response and bundles it with the necessary metadata for Telegram delivery.

## Outputs
- **JSON Object:** Contains `response_text` (Markdown formatted agenda) and delivery `metadata`.
- **Telegram Dispatch:** Routed back to the user via the central dispatcher.

## Dependencies
### Systems
- [S04 Digital Twin](../../../20_Systems/S04_Digital-Twin/README.md) - Source API.
- [S08 Automation Orchestrator](../../../20_Systems/S08_Automation-Orchestrator/README.md) - n8n Execution engine.

### External Services
- Digital Twin API (running on port 5677).

## Error Handling
| Failure Scenario | Detection | Response | Alert |
|---|---|---|---|
| API Offline | HTTP node failure | Returns "Agenda: No data available." | n8n Execution log |
| Missing chat_id | Code node warning | Logs warning to console; continues if possible | Console |

## Manual Fallback
```bash
curl -s http://localhost:5677/todos?format=text
```
