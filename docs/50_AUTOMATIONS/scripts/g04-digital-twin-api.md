---
title: "service: G04_digital_twin_api.py"
type: "automation_spec"
status: "active"
automation_id: "g04-digital-twin-api"
goal_id: "goal-g04"
systems: ["S04", "S05"]
owner: "{{OWNER_NAME}}"
updated: "2026-02-19"
---

# service: G04_digital_twin_api.py

## Purpose
Provides a FastAPI-based REST interface for the Digital Twin Ecosystem. It exposes real-time health and finance data to external systems (like n8n Intelligent-Hub) and persists state snapshots to PostgreSQL.

## Triggers
- **Continuous:** Runs as a background service on port **5677**.
- **On-Demand:** Responds to HTTP GET requests from authorized internal services.

## Endpoints
| Endpoint | Description |
|---|---|
| `GET /status` | Returns a human-readable summary and the full JSON state. |
| `GET /health` | Returns raw health metrics (workouts, body composition). |
| `GET /finance` | Returns raw finance metrics (MTD net, budget alerts). |
| `GET /history` | Returns historical state snapshots from the database. |

## Inputs
- **Internal Logic:** Calls `G04_digital_twin_engine.py` to aggregate data.
- **Database:** Reads from `autonomous_finance` and `autonomous_training`.

## Outputs
- **JSON Responses:** Structured data for programmatic consumption.
- **Persistence:** Automatically saves state to `digital_twin_updates` table on `/status` calls.

## Dependencies
### Systems
- [S04 Digital Twin](../../20_SYSTEMS/S04_Digital-Twin/README.md)
- [S05 Telegram Integration](../../20_SYSTEMS/S05_Telegram-Integration/README.md)

### External Services
- **FastAPI / Uvicorn:** Python web framework.
- **Docker PostgreSQL:** Backend storage.

## Error Handling
| Failure Scenario | Detection | Response | Alert |
|---|---|---|---|
| Port Conflict | Uvicorn startup error | Service fails to start | Log: "address already in use" |
| DB Timeout | psycopg2 timeout | Returns 500 Internal Server Error | JSON error body |
| Missing Engine | ImportError | Service fails to start | Console output |

## Manual Fallback
Use the CLI version of the engine if the API is down:
```bash
/home/{{USER}}/Documents/autonomous-living/.venv/bin/python /home/{{USER}}/Documents/autonomous-living/scripts/G04_digital_twin_engine.py
```

## Infrastructure
- **Docker**: The API runs in a Python container (`digital-twin-api`) defined in `infrastructure/docker-compose.yml`.
- **Restart Policy**: `always` (Ensures high availability when VM/Docker starts).
- **Network**: `host` mode (Direct access to local PostgreSQL and port 5677).
- **Context**: Root of the project (`scripts` folder used for builds).

## Related Documentation
- [Automation: G04 Digital Twin Engine](./g04-digital-twin-engine.md)
- [Goal: G04 Digital Twin Ecosystem](../../10_GOALS/G04_Digital-Twin-Ecosystem/README.md)
