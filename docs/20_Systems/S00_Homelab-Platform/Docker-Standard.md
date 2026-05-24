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

### 4. Resource Constraints & Stability (NEW)
**The "How and Why" of Current Settings:**
- **Goal:** Transform a "best effort" homelab into a mission-critical "Autonomous OS" by eliminating random failures and OOM events.
- **Why Memory Limits?** In a 19+ container stack, a single memory leak in a non-critical service (like an exporter) shouldn't be allowed to steal RAM from the Database or n8n. Strict limits force "fail-fast" behavior in leaking containers while protecting the core.
- **Tiered Allocation Strategy:**
    - **Tier 1: Core Hubs (2GB):** `postgres`, `n8n`. These handle high-concurrency SQL and LLM logic.
    - **Tier 2: Middleware (512MB-1GB):** `authentik`, `rabbitmq`, `qdrant`. These are stable but need overhead for event spikes.
    - **Tier 3: Leaf Services (64MB-256MB):** `exporters`, `apis`. Minimal footprint to maximize host efficiency.

### 5. Service-Specific Tuning
- **n8n Versioning:** Standardized on `docker.n8n.io/n8nio/n8n:latest` (Alpine).
    - **Why:** The Debian image is significantly outdated (v0.x vs v2.x). To maintain security and features, we accept the lack of Python 3 in the standard Alpine image and delegate Python tasks to the host/dedicated containers.
- **Postgres Optimization:** `shared_buffers` is set to 25% of the container limit (512MB of 2GB). This ensures Postgres has its own dedicated cache without relying on the host OS, improving consistency.
- **RabbitMQ Safety:** `RABBITMQ_VM_MEMORY_HIGH_WATERMARK_RELATIVE=0.4` ensures RabbitMQ starts rejecting new messages before it hits the 512MB Docker limit. Without this, RabbitMQ would be OOM-killed during a message spike.

## Implementation Checklist
- [x] Create root `.dockerignore`
- [x] Synchronize `.env.example` with active `.env`
- [x] Implement memory limits for all core services (2026-05-05)
- [x] Tune RabbitMQ and Postgres for containerized environments (2026-05-05)
- [x] Finalize n8n v1+ storage migration and environment cleanup (2026-05-05)
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
