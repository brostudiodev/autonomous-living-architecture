---
title: "G04: API Resilience & n8n Compatibility Standard"
type: "infrastructure_spec"
status: "active"
automation_id: "G04_api_resilience"
goal_id: "goal-g04"
systems: ["S04"]
owner: "Michal"
updated: "2026-04-17"
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
3. **High-Resilience Error Handling (Standard 200 OK):** All endpoint logic must be wrapped in `try/except` blocks. Even on critical failure (e.g., DB timeout), the API must still return a `200 OK` with a descriptive error in the `report` field to prevent n8n workflow crashes.
4. **Circuit Breaker Integration:** All engine method calls that interact with domain databases MUST be wrapped in the `@domain_circuit_breaker` decorator. This ensures that repeated failures in one domain (e.g., Health) do not block requests to other domains.
5. **Domain Isolation:** If a domain database is offline or its circuit is OPEN, the API must return a "Degraded" response for that domain instead of failing the entire request.
6. **Fast-Fail Registry:** The `DomainIsolator` registry tracks failure counts. After 3 consecutive errors, the circuit opens for 60 seconds, during which all calls fail fast without hitting the database.

## Implementation Details
- **Decorator:** `@app.api_route("/path", methods=["GET", "POST"])`
- **Resilience Decorator:** `@domain_circuit_breaker(domain_name)` in the Engine layer.
- **Request Parameter:** `async def function(request: Request = None):` to handle optional JSON bodies.
- **Formatter:** `format_api_response(content: str)` utility function used system-wide.
- **Circuit Registry:** `G04_domain_isolator.py` manages system-wide circuit states.
