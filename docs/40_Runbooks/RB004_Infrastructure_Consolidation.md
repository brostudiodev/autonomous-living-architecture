---
title: "RP004: Infrastructure Consolidation Procedure"
type: "runbook"
status: "draft"
owner: "Michal"
updated: "2026-04-24"
---

# RP004: Infrastructure Consolidation Procedure (G11-SSH/PSO)

## 1. Objective
Consolidate fragmented Docker services into a single, hardened, and portable `docker-compose.yml`. Standardize networking, remove absolute path dependencies, and ensure non-root execution across all containers.

## 2. Current Fragmentation Audit
- **Main Compose:** `autonomous-living/docker-compose.yml` (n8n, postgres, digital-twin-api, ollama, monitoring)
- **Infra Compose:** `autonomous-living/infrastructure/docker-compose.yml` (redundant prometheus, exporters, activitywatch)
- **Zrok Compose:** `zrok/docker-compose.yml` (tunneling)

## 3. Consolidation Strategy

### Phase 1: Preparation & Unified Environment
1.  **Backup Data:** Ensure all external volumes and bind mounts are backed up.
2.  **Environment Sync:** Merge all required variables into the root `.env` file.
3.  **Define Unified Network:** Use a single bridge network `autonomous-net`.

### Phase 2: Unified `docker-compose.yml` Drafting
Create a new master compose file at the project root.
1.  **Standardize Volumes:** Convert absolute host paths to relative paths (e.g., `./docs` instead of `/home/{{USER}}/...`).
2.  **Deduplicate Services:**
    - Merge `digital-twin-api` (prefer bridge network over `host` mode for security).
    - Merge monitoring (Prometheus/Grafana) into a single stack.
    - Integrate exporters from `infrastructure/`.
3.  **Profile Integration:** Maintain `bootstrap`, `cpu`, and `gpu-nvidia` profiles for modular startup.

### Phase 3: Hardening (G11-SSH)
1.  **Non-Root Execution:** Audit all Dockerfiles to ensure `USER 1000:1000`.
2.  **Privilege Escalation:** Add `security_opt: [no-new-privileges:true]` where possible.
3.  **Read-Only Mounts:** Mount `/docs` and config files as `:ro` where write access is not required.

### Phase 4: Execution & Cutover
1.  Stop all existing stacks: `docker compose down`.
2.  Cleanup orphaned volumes/networks.
3.  Launch unified stack: `docker compose up -d`.
4.  Verify cross-service communication (n8n -> Postgres, Grafana -> Prometheus).

## 4. Operational Commands
### Start Unified Stack
```bash
cd ~/Documents/autonomous-living
docker compose -f docker-compose.unified.yml --profile cpu up -d
```

### Check Logs
```bash
docker compose -f docker-compose.unified.yml logs -f [service_name]
```

## 5. Verification Checklist
- [x] All containers running (17 total).
- [x] No absolute paths in `docker-compose.unified.yml`.
- [x] `digital-twin-api` reachable by `n8n` via internal network name `digital-twin-api:5677`.
- [x] Prometheus scraping all exporters via internal DNS.
- [x] Obsidian reachable on `localhost:3010`.

## 6. Lessons Learned & Fixes
- **Permissions:** Monitoring stack (Prometheus/Grafana) requires `user: root` to interact with legacy external volumes created by Portainer/other stacks.
- **n8n Encryption:** If `n8n` restarts in a loop, comment out `N8N_ENCRYPTION_KEY` in the compose file to allow the container to use its internal configuration file.
- **Exporters:** Python exporters require `psycopg2-binary` and proper `DATA_DIR` definitions to run inside the unified stack.
- **Naming Conflicts:** Force-remove old containers before launching the unified stack to prevent "Container name already in use" errors.

## 7. Rollback Plan
In case of catastrophic failure:
1.  `docker compose -f docker-compose.unified.yml down`
2.  Revert to legacy compose files:
    - `docker compose -f docker-compose.yml up -d`
    - `docker compose -f infrastructure/docker-compose.yml up -d`
