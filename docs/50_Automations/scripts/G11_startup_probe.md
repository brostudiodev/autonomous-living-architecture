---
title: "G11_startup_probe.py: Critical Infrastructure Audit"
type: "automation_spec"
status: "active"
automation_id: "G11_startup_probe"
goal_id: "goal-g11"
systems: ["S11", "S04"]
owner: "Michal"
updated: "2026-04-18"
---

# G11: Startup Health Probe

## Purpose
Ensures that all critical infrastructure services (n8n, Digital Twin API, Postgres) are online and healthy before the system begins its daily operational cycle. It prevents script failures caused by underlying service unavailability.

## Processing Logic
1. **Service Verification**:
    - **Docker Services**: Utilizes `docker inspect -f '{{.State.Running}}'` to verify the operational state of the `n8n` and `postgres` containers. This provides a more robust check than simple port polling by verifying the actual container state.
    - **API Services**: Uses `requests.get` with a strict 10-second timeout to verify the responsiveness of the Digital Twin API via its `/health/ready` endpoint.
2. **Retry Mechanism**: If services are offline, it retries up to 5 times with a 10-second delay between attempts.
3. **Reporting**: Logs the outcome (SUCCESS/FAILURE) to the `system_activity_log`.
4. **Fast-Fail**: Exits with a non-zero status code if critical services remain offline after all retries.

## Monitored Services
- **n8n**: Verified via `docker inspect` (Container name: `n8n`).
- **Postgres**: Verified via `docker inspect` (Container name: `postgres`).
- **API**: Verified via HTTP GET to `http://localhost:5677/health/ready`.

---
*Related Documentation:*
- [G11_global_sync.md](G11_global_sync.md)
- [G11_system_vital_sentinel.md](G11_system_vital_sentinel.md)
