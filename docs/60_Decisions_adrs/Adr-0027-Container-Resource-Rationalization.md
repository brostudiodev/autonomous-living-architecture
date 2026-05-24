---
title: "Adr-0027: Container Resource Rationalization"
type: "adr"
status: "accepted"
date: "2026-05-06"
---

# Adr-0027: Container Resource Rationalization

## Context
As the stack grew to 19+ containers, the system experienced occasional "OOM (Out Of Memory) cascades." Some services (like Redis or exporters) were overallocated, while core services (Postgres, n8n) lacked guaranteed headroom.

## Decision
Apply tiered resource limits in `docker-compose.yml`.

1.  **Tier 1 (Core):** `postgres`, `n8n`, `digital-twin-api`. Higher memory limits (256MB-512MB) and CPU shares.
2.  **Tier 2 (Messaging/Logic):** `rabbitmq`, `eda-orchestrator`. Moderate limits (128MB-256MB).
3.  **Tier 3 (Exporters/Proxies):** `node-exporter`, `g01-exporter`, `redis`. Strict caps (64MB).
4.  **Persistence:** Use **Host Bind Mounts** instead of named volumes for 100% visibility and manual audit capability from the host terminal.

## Consequences
- **Positive:** High system stability. No more OOM kills. Simplified backups via host folder sync.
- **Negative:** Host filesystem permissions must be managed carefully for Docker access.
