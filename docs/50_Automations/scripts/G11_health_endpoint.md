---
title: "G11_health_endpoint.py: G11 Health API"
type: "automation_spec"
status: "active"
automation_id: "G11_health_endpoint"
goal_id: "goal-g11"
systems: ["S11", "S04"]
owner: "Michał"
updated: "2026-04-18"
---

# G11: Health and Readiness Endpoint

## Purpose
Provides a FastAPI-based interface for health and readiness probes of the G11 Meta-System services. It allows external monitoring tools (like n8n or uptime checkers) to verify the status of critical infrastructure.

## Endpoints
- **GET `/health/ready`**: Standardized readiness probe. Returns a 200 OK with a JSON payload indicating the health of individual components (Database, n8n).
- **GET `/health/live`**: Liveness probe. Simple ping to verify the API service is running.

## Infrastructure Checks
- **Database**: Verifies connectivity to the `digital_twin_michal` database.
- **n8n**: Verifies that the n8n health endpoint is responsive.

## Implementation Details
- **Framework**: FastAPI / Uvicorn.
- **Port**: 5679.
- **Standardized Timeouts**: Uses `connect_timeout=3` for Postgres and `timeout=10` for HTTP requests.

---
*Related Documentation:*
- [G04_digital_twin_api.md](G04_digital_twin_api.md)
- [G11_system_vital_sentinel.md](G11_system_vital_sentinel.md)
