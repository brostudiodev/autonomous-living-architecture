---
title: "Runbook: Docker Network & DNS Recovery"
type: "runbook"
status: "active"
automation_id: "RB-NET-001"
owner: "Michał"
updated: "2026-05-01"
---

# Runbook: Docker Network & DNS Recovery

## 🔍 Incident Profile
**Symptom:** Scripts fail with `getaddrinfo ENOTFOUND`, `Database connection timed out`, or `API Unreachable`. Telegram Router (n8n) rejects incoming tasks with "Offer expired".
**Root Cause:** Cascasding DNS failure or connection hang within the `autonomous-net` bridge network, causing services to lose "name-to-IP" resolution.

## 🛠️ Resolution Procedure

### 1. Identify Affected Containers
Check logs for DNS errors:
```bash
docker logs n8n --tail 50 | grep "ENOTFOUND"
```

### 2. Verify Database Health
Ensure the Postgres container is healthy and accepting connections:
```bash
docker inspect -f '{{.State.Health.Status}}' postgres
```

### 3. Clear DNS Cache (Nuclear Option)
If name resolution is broken, restart the core automation stack to force a fresh network join:
```bash
docker restart n8n rabbitmq eda-orchestrator db-event-bridge
```

### 4. Verify API Responsiveness
Test the Digital Twin API from the host:
```bash
curl -m 5 http://localhost:5677/health
```

## 🛡️ Preventive Hardening
- **Service Dependencies:** All dependent containers now have `condition: service_healthy` checks in `docker-compose.yml`.
- **IP Standardization:** Services are locked to the `[INTERNAL_SUBNET]/16` subnet to prevent route bleeding.
- **Smart Host Detection:** Python scripts now use `socket.gethostbyname` to fallback from `rabbitmq` to `localhost` if running outside the container.
