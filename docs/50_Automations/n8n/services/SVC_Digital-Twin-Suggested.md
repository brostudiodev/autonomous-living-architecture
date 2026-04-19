---
title: "SVC: Digital Twin Suggested"
type: "automation_spec"
status: "active"
automation_id: "SVC_Digital-Twin-Suggested"
goal_id: "goal-g04"
systems: ["S04", "S08"]
owner: "Michal"
updated: "2026-04-10"
---

# SVC: Digital-Twin-Suggested

## Purpose
Retrieves AI-generated suggestions/recommendations from the Digital Twin API's `/suggested` endpoint and delivers them to the user via Telegram. Provides intelligent recommendations for tasks, priorities, or actions.

## Triggers
- **Workflow Trigger:** Executed by another workflow (e.g., `ROUTER_Intelligent_Hub`).
- **Command:** Triggered via `/suggested` in Telegram or CLI.

## Inputs
- **Workflow Input:** JSON object containing `chat_id`, `source_type`, and `username` (usually passed from the router).
- **API Call:** GET request to `http://{{INTERNAL_IP}}:5677/suggested` (placeholder IP in JSON - line 32).

## Processing Logic
1. **Normalize Router Input** (Code node, lines 19-29): Extracts `chat_id`, `source_type`, and `username` from input JSON. Logs warning if chat_id is missing.
2. **Fetch Suggested Report** (HTTP Request node, line 32): GET request to Digital Twin API's `/suggested` endpoint. Note: Uses placeholder `{{INTERNAL_IP}}` - should be updated to actual IP.
3. **Format for Dispatcher** (Code node, lines 46-56): Extracts `report` field from API response, formats JSON for dispatcher.

## Outputs
- **JSON Object:** Contains `response_text` (AI suggestion) and delivery `metadata`.
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
| API Offline | HTTP node failure | Returns "Error: Could not retrieve suggested report." | n8n Execution log |
| Missing chat_id | Code node warning | Logs warning to console; continues if possible | Console |

## Security Notes
- **ISSUE:** Uses placeholder `{{INTERNAL_IP}}` instead of actual IP address - should be updated to `{{INTERNAL_IP}}`.

## Manual Fallback
```bash
curl -s http://localhost:5677/suggested
```