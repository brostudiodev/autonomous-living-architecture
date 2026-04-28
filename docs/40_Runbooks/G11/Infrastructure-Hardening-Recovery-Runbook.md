---
title: "Runbook: Infrastructure Hardening & Recovery"
type: "runbook"
status: "active"
owner: "Michał"
updated: "2026-04-22"
goal_id: "goal-g11"
---

# Runbook: Infrastructure Hardening & Recovery (G11-SSH)

## Purpose
This runbook provides procedures for managing container hardening (non-root migration) and recovering from common database/volume permission issues resulting from security updates.

## Scope
- **In Scope:** Volume permission management (UID/GID), cross-service database routing, and RBAC inheritance fixes.
- **Out Scope:** Application-level bug fixing, network-level firewalling.

## Inputs/Outputs
- **Inputs:** Docker volumes, Service users (`dt_n8n_orchestrator`, etc.).
- **Outputs:** Healthy service state (Up), consistent data visibility.

## Standard Procedures

### 1. Volume Permission Synchronization
When services are migrated to non-root users (UID 1000), host volumes must be updated to prevent `PermissionError`.

**Fix Procedure:**
```bash
# For most services (UID 1000)
docker run --rm -v [VOLUME_NAME]:/data busybox chown -R 1000:1000 /data

# For Postgres (UID 999)
docker run --rm -v [VOLUME_NAME]:/data busybox chown -R 999:999 /data
```

### 2. Cross-Service Database Routing
Ensure specialized services connect to their dedicated databases rather than shared project defaults.

**n8n Connection Fix:**
In `docker-compose.yml`, explicitly set the database to prevent fallback to `${POSTGRES_DB}`:
```yaml
environment:
  - DB_POSTGRESDB_DATABASE=n8n
```

### 3. Database Role Inheritance
Service users must have the `INHERIT` attribute to utilize permissions granted via roles (`role_brain`, `role_archivist`).

**Grant Procedure:**
```sql
ALTER ROLE [SERVICE_USER] INHERIT;
```

## Failure Modes
| Scenario | Detection | Response |
|----------|-----------|----------|
| n8n: 0 Workflows | Logs show "Processed 0 workflows" despite DB count > 0 | Check `DB_POSTGRESDB_DATABASE` variable and `INHERIT` status. |
| DB: Permission Denied | Logs show `could not open file "..._fsm"` | Volume ownership mismatch (Host vs Container). Run `chown` fix. |
| Grafana/Prometheus crash | Status `Restarting`, logs show `out of memory` or `permission denied` | Check volume permissions (UID 1000). |

## Owner + Review Cadence
- **Owner:** Michał
- **Review Cadence:** Quarterly.
