---
title: "G04: Digital Twin API Failure"
type: "runbook"
status: "active"
owner: "Michał"
updated: "2026-03-31"
---

# Runbook: Digital Twin API Failure

## Symptoms
- Telegram commands return "Internal Server Error"
- Dashboard widgets in Obsidian show "Connection Refused"
- Logs show `Address already in use` (Errno 98)
- Logs show `AttributeError: 'DigitalTwinEngine' object has no attribute 'get_health_status'`
- n8n shows "timeout of 10000ms exceeded" (ECONNABORTED)

## Scenario 1: Port Conflict (Address already in use)
This typically happens when a ghost process (often root-owned) or a Docker container is already binding to the port (5677/5678).

### Detection
```bash
docker ps | grep digital-twin-api
ss -tunlp | grep 5677
```

### Response
1. **If in Docker:**
   ```bash
   docker restart digital-twin-api
   ```
2. **If running as a script (Manual):**
   ```bash
   sudo fuser -k 5677/tcp
   {{ROOT_LOCATION}}/autonomous-living/.venv/bin/python3 scripts/G04_digital_twin_api.py &
   ```

## Scenario 2: Internal Server Error (500)
Usually caused by an unhandled exception in the `DigitalTwinEngine` or a database connection failure.

### Detection
Check the container logs:
```bash
docker logs --tail 50 digital-twin-api
```

### Common Fixes
- **AttributeError:** Ensure `G04_digital_twin_engine.py` has all required methods (e.g., `get_health_status`). This often happens after a refactor where methods are renamed but not updated in `initialize_state()`.
- **Database Connection:** Ensure PostgreSQL is running and the `.env` file has the correct `DB_PASSWORD`.
  ```bash
  docker ps | grep postgres
  ```

## Scenario 3: Request Timeout (ECONNABORTED)
Happens when a command (like `/approve`) triggers slow external integrations (Google Sheets, Tasks) that exceed n8n's 10-second timeout.

### Fix implemented
The API now uses `BackgroundTasks` for `/approve`, `/query`, and `/sync`. The API responds immediately with "Queued for execution," and the heavy lifting happens in the background.

### Response
If timeouts persist, check if the Digital Twin container has sufficient resources (CPU/RAM) or if the external APIs (Google) are experiencing latency.

## Scenario 4: Permission Denied
Happens if the API tries to write logs or state files to a root-owned directory.

### Response
```bash
sudo chown -R michal:michal {{ROOT_LOCATION}}/autonomous-living/
```

## Security Notes
- Do not restart the API with `sudo` unless absolutely necessary, as it will create root-owned log files that cause subsequent permission errors for the `michal` user.
