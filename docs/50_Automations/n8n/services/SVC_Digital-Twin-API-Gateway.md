---
title: "n8n Service: SVC_Digital-Twin-API-Gateway"
type: "automation_spec"
status: "active"
automation_id: "SVC_Digital-Twin-API-Gateway"
goal_id: "goal-g04"
systems: ["S04"]
owner: "Michał"
updated: "2026-04-17"
---

# n8n Service: Digital Twin API Gateway

## Purpose
Acts as the centralized communication hub between the n8n orchestration layer and the Digital Twin FastAPI backend. It normalizes request formats, handles HTTP method switching (GET vs POST), and standardizes error responses for downstream dispatchers.

## Logic Flow
1. **Input Normalization:** Extracts `api_config` (endpoint, emoji, fallback) and request context (chat_id, source).
2. **Method Detection:** Automatically determines if an endpoint requires `POST` (with body) or `GET` based on a predefined list.
3. **API Execution:** Calls the Digital Twin API at `http://{{INTERNAL_IP}}:5677`.
4. **Response Formatting:** Parses raw JSON/Text from the API and maps it to the standard `response_text` field used by the `SVC_Response-Dispatcher`.

## Supported POST Endpoints
The gateway automatically switches to `POST` for the following routes:
- `/ask`, `/chat`, `/reflect`, `/log_event`
- `/memory/operation`, `/reflection/submit`
- `/decisions/resolve`, `/shopping/populate_cart`

## Inputs
| Key | Type | Description |
|---|---|---|
| `api_config.endpoint` | String | The FastAPI route (e.g., `/health/ready`). |
| `api_config.emoji` | String | Optional. Icon for the response. |
| `_command.args` | String | Arguments passed to POST bodies as the `query` field. |

## Outputs
| Key | Type | Description |
|---|---|---|
| `response_text` | String | Standardized output for the user. |
| `success` | Boolean | Whether the API call succeeded. |
| `metadata.api_endpoint`| String | The endpoint that was called. |

## Dependencies
- **Backend:** [G04: Digital Twin Central API](../../scripts/G04_digital_twin_api.md)
- **Infrastructure:** Digital Twin FastAPI service running on port 5677.

## Failure Modes
| Scenario | Detection | Response |
|---|---|---|
| Connection Refused | Node Error (Catch) | Returns "Please check if the Digital Twin service is running." |
| Missing Endpoint | Validation Node | Throws ⛔ Error to calling workflow. |
| Timeout | HTTP Node (10s) | Returns connection failed error. |

---
*Created by Digital Twin AI Assistant - April 2026*
