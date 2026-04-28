---
title: "Implementation Plan: Infrastructure Consolidation (G11-SSH/PSO)"
type: "implementation"
status: "active"
owner: "Michal"
updated: "2026-04-24"
---

# Strategic Implementation: Infrastructure Consolidation

This plan tracks the technical merge of services from multiple compose files into a single project-root `docker-compose.yml`.

## 1. Environment & Network (Task G11-INF-01)
- [x] Create `autonomous-net` (bridge) as the global network.
- [x] Centralize `.env` variables for all services.
- [x] Define `PUID` and `PGID` as 1000.

## 2. Core Service Migration (Task G11-INF-02)
- [x] **Postgres:** Transition to using existing external volumes for data safety.
- [x] **n8n:** Standardized on `n8n` service name, integrated `n8n-import`.
- [x] **Digital-Twin-API:** 
    - [x] Merged the two definitions.
    - [x] Removed `network_mode: host` in favor of bridge mapping.
    - [x] Added internal DNS resolution for `postgres`.
    - [x] Refactor volumes to relative paths.

## 3. Monitoring & Exporters Migration (Task G11-INF-03)
- [x] **Prometheus:** Consolidated into one container.
- [x] **Exporters:** Moved `goals-exporter`, `g01-exporter`, and `node-exporter` into the main compose.
- [x] **Grafana:** Integrated and connected to the unified Prometheus.

## 4. AI & Interface Layer (Task G11-INF-04)
- [x] **Ollama/Qdrant:** Maintained with CPU/GPU profiles.
- [x] **Obsidian:** Standardized volume paths to relative `../Obsidian Vault`.

## 5. Path Refactoring Log
| Service | Old Absolute Path | New Relative Path | Status |
|---------|-------------------|-------------------|--------|
| Goals Exporter | `{{ROOT_LOCATION}}/autonomous-living/docs` | `./docs` | ✅ |
| G01 Exporter | `/home/{{USER}}/.../Training/data` | `./docs/10_Goals/G01_Target-Body-Fat/Training/data` | ✅ |
| Digital Twin | `{{ROOT_LOCATION}}/autonomous-living/scripts` | `./scripts` | ✅ |
| Obsidian | `{{ROOT_LOCATION}}/Obsidian Vault` | `../Obsidian Vault` | ✅ |

## 6. Hardening Audit (G11-SSH)
- [/] `digital-twin-api`: Applied `security_opt: [no-new-privileges:true]`.
- [x] `postgres`: Standardized on `pgvector:pg16` with healthchecks.
- [/] Audit all Dockerfiles: Temporarily running `root` for Prometheus/Grafana to resolve volume ownership issues with external legacy volumes.

## 7. Final Verification & Cutover
- [x] Stopped legacy stacks (`autonomous-living/docker-compose.yml`, `infrastructure/docker-compose.yml`).
- [x] Resolved naming conflicts for `goals-exporter`.
- [x] **Resolved n8n Key Mismatch:** Decoupled `N8N_ENCRYPTION_KEY` in compose to allow config-file priority.
- [x] **Resolved Exporter Dependencies:** Updated `Dockerfile.g01-exporter` with `psycopg2-binary` and `libpq-dev`.
- [x] **Resolved Metric Logic Errors:** Fixed indentation and variable definitions in `goals-exporter.py` and `g01-exporter.py`.
- [x] **Successfully Cutover:** Unified stack launched via `docker compose -f docker-compose.unified.yml --profile cpu up -d`.
- [x] Verified all 17 containers healthy and reachable.

## 8. Identity & SSO (G11-SSO)
- [x] **Authentik Startup:** Resolved missing `authentik` database issue in Postgres.
- [x] **Grafana SSO:** Enabled native OIDC integration via Authentik.
- [x] **n8n & Portainer Security:** Implemented Authentik Proxy to add mandatory MFA/SSO layer to Community Edition tools.
- [x] **Outpost Manual Hardening:** Transitioned from automated Docker management to a manual `authentik-proxy` service for 100% reliability.
- [x] **Domain Resolution:** SQL-injected `localhost` as the primary tenant domain to fix browser redirection loops.

