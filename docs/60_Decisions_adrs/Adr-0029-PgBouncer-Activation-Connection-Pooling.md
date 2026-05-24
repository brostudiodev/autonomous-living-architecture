---
title: "Adr-0029: PgBouncer Activation & Connection Pooling Standard"
type: "adr"
status: "accepted"
date: "2026-05-09"
owner: "Michał"
---

# Adr-0029: PgBouncer Activation & Connection Pooling Standard

## Context
The autonomous ecosystem involves hundreds of scripts and n8n workflows that connect to PostgreSQL. These high-frequency, short-lived connections previously created significant overhead on the Postgres backend, leading to performance bottlenecks during automation bursts. While a PgBouncer container was defined in the architecture, it was dormant and not utilized by the system.

## Decision
We will enforce centralized connection pooling across the entire ecosystem.

1.  **Mobilization:** The PgBouncer sidecar is activated on port `6432`.
2.  **Global Default:** The primary database port in `.env` is switched to `6432`.
3.  **Smart Routing:** `db_config.py` is updated to prefer `6432` for all local and Docker-based connections unless explicitly overridden.
4.  **Pool Mode:** PgBouncer is configured in `session` mode initially for maximum compatibility, with a transition plan to `transaction` mode for high-scale n8n workflows.

## Consequences
- **Performance:** Drastic reduction in Postgres backend process forks.
- **Stability:** Prevents "Too many connections" errors during parallel script execution.
- **Transparency:** The shift is transparent to existing scripts thanks to the centralized `db_config.py`.
- **Latency:** Minor overhead (<1ms) for connection routing, offset by faster connection acquisition.

## Implementation (May 09, 2026)
- **Container:** `pgbouncer` service started and verified healthy.
- **Configuration:** Updated `.env` with `DB_PORT=6432`.
- **Infrastructure:** Updated `db_config.py` with PgBouncer-aware port detection.
- **Bug Fix:** Fixed legacy hardcoded connection string in `G11_pre_flight_check.py` to follow this new standard.
