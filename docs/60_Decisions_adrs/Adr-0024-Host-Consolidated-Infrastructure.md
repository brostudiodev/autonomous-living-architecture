---
title: "ADR 0024: Host-Consolidated Infrastructure (Phase 5 Hardening)"
type: "adr"
status: "accepted"
owner: "Michał"
updated: "2026-05-05"
---

# ADR 0024: Host-Consolidated Infrastructure (Phase 5 Hardening)

## Status
Accepted

## Context
As part of the **North Star 2026** vision and the **Phase 5 Hardening** of the `autonomous-living` system, there was a critical need to move away from Docker-managed "named volumes" and legacy external volumes. 

Issues identified:
1. **Data Opacity:** Named volumes are stored in hidden system paths (e.g., `/var/lib/docker/volumes`), making manual backups, inspection, and migration difficult.
2. **Path Confusion:** Migration to the `autonomous-living` repository structure caused project-prefixed volumes (e.g., `autonomous-living_*`) to clash with legacy prefixes (e.g., `local-ai-packaged_*`), leading to accidental data loss scenarios.
3. **Portability Barriers:** Moving the system to a new host required complex volume export/import procedures.

## Decision
We will transition all core persistent data storage from **Named Volumes** to **Direct Local Bind Mounts** within the project's root directory.

Key implementation details:
- **Consolidated Root:** All data resides in `./infrastructure/<service>_data`.
- **Direct Mapping:** Use relative host paths in `docker-compose.yml` for maximum transparency.
- **Service Standard:**
    - Postgres: `./infrastructure/database/postgres_data`
    - n8n: `./infrastructure/n8n/n8n_data`
    - Qdrant: `./infrastructure/qdrant/qdrant_data`
    - Ollama: `./infrastructure/ollama/ollama_data`
    - Prometheus: `./infrastructure/prometheus/prometheus_data`
    - Grafana: `./infrastructure/grafana/grafana_data`

## Consequences
- **Positive:** Everything is "in one place." Backing up the repo folder now backs up the entire state of the brain.
- **Positive:** Improved visibility for AI agents and human operators into the physical storage state.
- **Negative:** Host-side permissions must be managed (solved via Docker container mapping).
- **Negative:** Initial migration requires a manual one-time copy of data from named volumes to host paths.

## Validation
- Verified n8n workflow retention (114 draft workflows restored).
- Verified Postgres connectivity and vector storage health (Qdrant).
- Verified Prometheus TSDB integrity after fresh start.
