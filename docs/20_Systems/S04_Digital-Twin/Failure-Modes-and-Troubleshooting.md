---
title: "S04: Digital Twin Failure Modes & Troubleshooting"
type: "troubleshooting_guide"
status: "active"
system_id: "S04"
goal_id: "goal-g04"
version: "1.0"
owner: "Michal"
updated: "2026-04-17"
---

# Digital Twin Failure Modes & Troubleshooting

This document tracks identified failure modes in the Digital Twin API and Engine, their detection methods, and established responses.

## 🚨 Failure Modes Matrix

| Scenario | Detection | Response |
|----------|-----------|----------|
| **Engine Parameter Mismatch** | `TypeError` in `monitor_state.json` or `docker logs`: "get_health_status() got an unexpected keyword argument 'target_date'" | Ensure `get_full_context` sets `self.target_date` and calls sub-methods without parameters. |
| **Command Translation Error** | `sys.argv` parsing failure in `G11_decision_handler.py`. Flags like `--all` being treated as integer IDs. | Update entry point logic to check for flags (`startswith("-")`) before assigning to `target_id`. |
| **Stale Health Blockers** | UI Status is **CRITICAL** but logs are clean. Check `system_health_md` for "ImportError" or "Address in use". | Manually clear `_meta/automation_health.json` on host and container. Reset the JSON to `{"status": "Healthy", "failures": []}`. |
| **Port Conflict (Errno 98)** | `docker logs`: "error while attempting to bind on address ('0.0.0.0', 5677): address already in use" | A ghost process is holding the port. Run `docker restart digital-twin-api` or check `fuser -k 5677/tcp` on host. |
| **AttributeError in API** | `docker logs`: "'AgentZero' object has no attribute 'get_historical_health'" | Ensure `G04_digital_twin_api.py` calls methods on `engine`, not `agent`, if they are engine-only methods. |
| **Historical Data Override** | Agent returns today's data regardless of the date in the query. | Fixed by prioritizing the date string in the command over the global `target_date` parameter in `AgentZero.ask`. |
| **Stale Data (Degraded)** | `/system_health` reports "Status: DEGRADED" with "Stale" labels. | Manually trigger the specific sync script (e.g., `G05_finance_sync.py`) to refresh the database. |
| **Database Hang** | API request threads blocked, non-responsive UI. | Mandatory 5s `connect_timeout` added to `db_config.py` prevents indefinite hangs. Restart API if thread pool is exhausted. |
| **Offline Domain DB** | API fails to start or crashes on domain query. | **Startup Resilience:** Engine now uses Lazy Load. API will boot even if DBs are down. Broken domains return "Degraded" response instead of 500. |
| **Stale Lockfiles** | Daily sync or Managers fail to start with "Already running". | **Self-Healing:** `G11_self_healing_logic.py` now autonomously clears locks from both `/tmp/` and `scripts/` if >30 mins old. |
| Container Failure | API process crashes silently. | **Observability:** Docker `healthcheck` now monitors `/health/ready`. Container will auto-restart if health fails for 3 consecutive 30s checks. |
| **Intermittent Domain Instability** | API returns "Degraded" for specific sections. `docker logs`: "Circuit OPENED for 'health'". | **Circuit Breaker:** System is auto-protecting. Wait 60s for auto-reset, or probe with `python3 scripts/G04_health_probe.py [domain]`. |
| **Stale API Response on Failure** | n8n gets data but with `report: "❌ Error: ..."` and `200 OK`. | **Resilience Standard:** This is expected. The error in `report` indicates a backend failure while keeping the API pipe open. |


## 🛠️ Recovery Procedures

### 1. Resetting Automation Health JSON
If the UI shows a critical error that has already been fixed, the blocker is likely cached in the JSON registry.
```bash
# On Host
echo '{"timestamp": "'$(date -u +"%Y-%m-%dT%H:%M:%S.%NZ")'", "status": "Healthy", "failures": [], "passed": ["Digital Twin Engine", "Digital Twin API"]}' > {{ROOT_LOCATION}}/autonomous-living/_meta/automation_health.json

# Inside Container
docker exec digital-twin-api sh -c "echo '{\"timestamp\": \"'$(date -u +\"%Y-%m-%dT%H:%M:%S.%NZ\")'\", \"status\": \"Healthy\", \"failures\": [], \"passed\": [\"Digital Twin Engine\", \"Digital Twin API\"]}' > /_meta/automation_health.json"
```

### 2. Clearing Persistent "CRITICAL" state from DB
If a script failure from 12 hours ago is still flagging the system as critical:
```sql
UPDATE system_activity_log 
SET status = 'RESOLVED' 
WHERE script_name = '[FAILED_SCRIPT_NAME]' 
  AND status = 'FAILURE' 
  AND logged_at > NOW() - INTERVAL '24 hours';
```

### 3. Verification Checklist
After applying fixes:
1.  Run `python3 scripts/G04_digital_twin_monitor.py` -> Ensure no "Engine failure" alerts.
2.  `curl http://localhost:5677/health/ready` -> Ensure global readiness.
3.  `curl http://localhost:5677/health/domain/finance` -> Check specific domain circuit status.
4.  Check Digital Twin UI -> Light should be **Green**.

---
*Created by Digital Twin AI Assistant - April 2026*
