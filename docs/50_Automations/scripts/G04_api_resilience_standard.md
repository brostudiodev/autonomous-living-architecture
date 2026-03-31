---
title: "G04: API Resilience & n8n Compatibility Standard"
type: "infrastructure_spec"
status: "active"
automation_id: "G04_api_resilience"
goal_id: "goal-g04"
systems: ["S04"]
owner: "Michal"
updated: "2026-03-12"
---

# G04: API Resilience Standard

## Purpose
Ensures 100% availability and compatibility of the Digital Twin API with n8n Agentic workflows and multi-modal interfaces.

## Standards Implemented
1. **Multi-Method Support:** All endpoints (except root UI) MUST support both `GET` and `POST` methods to accommodate n8n's `toolHttpRequest` default behavior.
2. **Payload Standardization:** Every response MUST include the "n8n Uber-Keys":
   - `report`: Human-readable summary for the Agent.
   - `response_text`: Human-readable summary (alias).
   - `content`: Full data or text for downstream processing.
3. **High-Resilience Error Handling:** All endpoint logic must be wrapped in `try/except` blocks. If internal logic fails (e.g., DB timeout), the API must still return a `200 OK` with a descriptive error in the `report` field to prevent n8n workflow crashes.
4. **Endpoint Uniqueness:** No duplicate route definitions are allowed. Redundant routes (e.g., duplicate `/health` or `/os`) must be consolidated.

## Implementation Details
- **Decorator:** `@app.api_route("/path", methods=["GET", "POST"])`
- **Request Parameter:** `async def function(request: Request = None):` to handle optional JSON bodies.
- **Formatter:** `format_api_response(content: str)` utility function used system-wide.
