---
title: "Runbook: Digital Twin UI Restoration and Modularization"
type: "runbook"
status: "active"
owner: "Michał"
updated: "2026-05-20"
goal_id: "goal-g04"
---

# RB_G04_001: Digital Twin UI Restoration and Modularization

## Purpose
This runbook describes the process for restoring the Digital Twin UI (port 5677) and its dashboards (`/map`, `/system/status`) following the migration to a modular codebase. It ensures that the UI is served from the centralized SDK static directory and that all core API components are correctly linked to the modular structure.

## Scope
- **In Scope:** Digital Twin API (`core/api.py`), Digital Twin Engine (`core/engine.py`), SDK Static Assets (`autonomous_sdk/static/`), Docker configuration.
- **Out of Scope:** Individual domain module logic (Finance, Health, etc.), except for their API registration.

## Inputs/Outputs
- **Inputs:** 
  - Legacy static files in `scripts/static/`.
  - Modularized Python components in `core/` and `modules/`.
- **Outputs:** 
  - Functional UI on port 5677.
  - Live Mermaid-based System Connectivity Map.
  - Real-time System Status Dashboard with WebSocket integration.

## Dependencies
- **Systems:** S04 Digital Twin Core, S11 Meta-System Glue.
- **Hardware:** Docker host.
- **Environment Variables:** `DIGITAL_TWIN_PORT` (default: 5677), `PYTHONPATH`.

## Procedure

### 1. Static Asset Migration
If the UI is showing "Not Found" errors for HTML files:
1. Ensure the `autonomous_sdk/static` directory exists.
2. Copy all files from `scripts/static/` to `autonomous_sdk/static/`.
3. Verify ownership is set to the application user (e.g., `michal:michal` or `appuser` in Docker).
4. Remove the legacy `scripts/static` directory to avoid path confusion.

### 2. API Path Configuration
In `core/api.py`, ensure the following paths are standardized:
1. `BASE_DIR` should resolve to the project root.
2. `STATIC_PATH` must point to `os.path.join(BASE_DIR, "autonomous_sdk", "static")`.
3. The FastAPI app must mount the static directory:
   ```python
   app.mount("/static", StaticFiles(directory=STATIC_PATH), name="static")
   ```

### 3. Modular Import Alignment
All core components must import `db_config` from the SDK:
- **Change:** `from db_config import ...` 
- **To:** `from autonomous_sdk.db_config import ...`

### 4. Docker Environment Hardening
Update `docker-compose.yml` and `Dockerfile.digital-twin`:
1. Set `PYTHONPATH=/app`.
2. Remove legacy paths like `/app/scripts` or `/app/modules/.../scripts` from `PYTHONPATH` to prevent "split-brain" imports.
3. Ensure the `CMD` starts the API from the modular path: `["python", "-u", "core/api.py"]`.

## Failure Modes

| Scenario | Detection | Response |
|----------|-----------|----------|
| UI returns 404 for index.html | `curl localhost:5677` returns 404 | Verify `STATIC_PATH` exists and contains `index.html`. |
| Map dashboard is empty | `/map/data` returns error or empty graph | Check `modules/docs/scripts/G12_connectivity_mapper.py` for path errors. |
| Vitals show "--" | UI vitals don't update | Check `/status` endpoint and ensure Redis/Postgres connectivity. |
| Static files permission denied | Docker logs show `PermissionError` | Run `chown -R 1000:1000 autonomous_sdk/static`. |

## Security Notes
- UI is protected via `X-API-KEY` header in Phase 1 (Logging) and JWT for the web interface.
- Ensure `JWT_SECRET_KEY` is loaded from environment variables and not hardcoded.

## Owner + Review Cadence
- **Owner:** Michał
- **Review Cadence:** Monthly documentation audit (G12).
