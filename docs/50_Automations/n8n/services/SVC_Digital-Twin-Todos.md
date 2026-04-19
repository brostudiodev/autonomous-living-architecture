---
title: "SVC: Digital Twin Todos"
type: "automation_spec"
status: "active"
automation_id: "SVC_Digital-Twin-Todos"
goal_id: "goal-g04"
systems: ["S04", "S08"]
owner: "Michal"
updated: "2026-04-10"
---

# SVC: Digital-Twin-Todos

## Purpose
Aggregates all tasks from Google Tasks, System Alerts (Pantry, Finance, Home), and active Q2 Roadmap missions into a single, time-categorized agenda (Today, Tomorrow, 7 Days). This provides full transparency into upcoming personal and project-based goals.

## Triggers
- **Workflow Trigger:** Executed by another workflow (e.g., `ROUTER_Intelligent_Hub`).
- **Command:** Triggered via `/todos` in Telegram or CLI.

## Inputs
- **Workflow Input:** JSON object containing `chat_id`, `source_type`, and `username` (usually passed from the router).
- **API Call:** GET request to `http://{{INTERNAL_IP}}:5677/todos?format=text`.

## Processing Logic
1. **Normalize Router Input** (Code node, lines 21-31): Extracts `chat_id`, `source_type`, and `username` from input JSON. Falls back to defaults if missing. Logs warning to console if chat_id is missing.
2. **Fetch Twin Todos** (HTTP Request node, line 34): GET request to `http://{{INTERNAL_IP}}:5677/todos?format=text` - fetches plain text response from Digital Twin API.
3. **Format for Dispatcher** (Code node, lines 54-63): Processes raw response - extracts text from various response fields (data, body, response_text, content). Returns fallback text "Agenda: No data available." if response empty.

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
