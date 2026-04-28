---
title: "Infrastructure: Docker & Environment Standard"
type: "standard"
status: "active"
owner: "Michał"
updated: "2026-04-21"
goal_id: "goal-g11"
---

# Docker & Environment Standard

## Purpose
Ensure system-wide security, portability, and consistency by standardizing how Docker containers and environment variables are managed.

## Scope
- **In Scope:** `.env.example` synchronization, `.dockerignore` protocol, and `docker-compose.yml` networking standards.
- **Out Scope:** Physical server hardware maintenance.

## Standards

### 1. Environment Variable Management
- **The .env.example Rule:** Every variable required for the system MUST be documented in `.env.example` with a `changeme` or placeholder value.
- **Deduplication:** Database credentials should be synchronized across `POSTGRES_USER` (Docker) and `DB_USER` (Python Scripts).
- **Google Sheets Integration:** Hardcoded Sheet IDs are prohibited in scripts. All IDs MUST be stored in `.env` (e.g., `GOOGLE_SHEET_ID_FINANCE`) to prevent document exposure in public repositories.

### 2. Docker Security
- **.dockerignore Protocol:** Every deployment MUST include a `.dockerignore` file to exclude:
    - `.env` (Prevent credential leakage into images)
    - `*.json` / `*.pickle` (Prevent token leakage)
    - `docs/` (Reduce image size; documentation is for humans, not runtimes)
    - `__pycache__` and local virtual environments.

### 3. Networking
- **Autonomous Network:** All project-specific containers MUST share the `autonomous_network` to enable zero-configuration inter-service communication via container names (e.g., `DB_HOST=postgres`).

## Implementation Checklist
- [x] Create root `.dockerignore`
- [x] Synchronize `.env.example` with active `.env`
- [ ] Refactor `docker-compose.yml` to use relative volume paths (Roadmap Task)

## Failure Modes

| Scenario | Detection | Response |
|----------|-----------|----------|
| Credential Leak | Secret found in image | Rebuild image after adding to .dockerignore; rotate keys |
| Network Isolation | Container cannot ping `postgres` | Verify `networks` section in `docker-compose.yml` |

## Security Notes
- Documentation must NEVER contain raw secrets or internal IPs (except standardized placeholders).

## Owner + Review Cadence
- **Owner:** Michał
- **Review Cadence:** Quarterly.
