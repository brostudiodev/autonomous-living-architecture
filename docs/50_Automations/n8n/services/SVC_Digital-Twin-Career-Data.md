---
title: "SVC: Digital Twin Career Data"
type: "automation_spec"
status: "active"
automation_id: "SVC_Digital-Twin-Career-Data"
goal_id: "goal-g09"
systems: ["S04", "S08"]
owner: "Michal"
updated: "2026-04-10"
---

# SVC_Digital-Twin-Career-Data

## Purpose
Retrieves career-related data and analysis from the Digital Twin API's `/career_data` endpoint. Provides career insights, job applications tracking, and professional development data.

## Triggers
- **Workflow Trigger:** Executed by another workflow (e.g., `ROUTER_Intelligent_Hub`).
- **Command:** Triggered via `/career` in Telegram or CLI.

## Inputs
- **Workflow Input:** JSON object containing `chat_id`, `source_type`, and `username` (usually passed from the router).
- **API Call:** GET request to `http://{{INTERNAL_IP}}:5677/career_data`.

## Processing Logic
1. **Normalize Router Input** (Code node, lines 21-31): Extracts `chat_id`, `source_type`, and `username` from input JSON. Logs warning if chat_id is missing.
2. **Trigger Career Analysis Endpoint** (HTTP Request node, line 34): GET request to `http://{{INTERNAL_IP}}:5677/career_data` - fetches career data from Digital Twin API.
3. **Format for Dispatcher** (Code node, lines 54-64): Processes raw response - extracts text from various response fields.

## Outputs
- **JSON Object:** Contains `response_text` (career data) and delivery `metadata`.
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
| API Offline | HTTP node failure | Returns career data error message | n8n Execution log |
| Missing chat_id | Code node warning | Logs warning to console; continues if possible | Console |

## Manual Fallback
```bash
curl -s http://localhost:5677/career_data
```