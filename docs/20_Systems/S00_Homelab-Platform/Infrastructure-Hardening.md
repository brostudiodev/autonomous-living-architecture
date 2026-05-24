# System Infrastructure: High-Density Hardening (Adr-0027 Compliance)

## Purpose
This document details the enterprise-grade infrastructure hardening performed to ensure system stability, resource efficiency, and data integrity across the Autonomous Living ecosystem.

## Key Capabilities
- **Automated Health Monitoring:** Real-time visibility into the operational status of all 24 system containers.
- **Resource Rationalization:** Tiered CPU allocation to prevent resource contention and OOM cascades.
- **Unified Data Pipeline:** Single-source-of-truth CDC (Change Data Capture) via PostgreSQL `LISTEN/NOTIFY` triggers.
- **High-Performance Persistence:** Pooled database connections to handle high-frequency autonomous updates.

## Technical Specifications

### 1. Healthcheck Matrix
| Service Tier | Diagnostic Tool | Frequency | Purpose |
|--------------|-----------------|-----------|---------|
| **Core DB** | `pg_isready` | 5s | Verifies SQL availability & connectivity. |
| **Messaging** | `rabbitmq-diagnostics` | 10s | Ensures exchange/queue availability. |
| **Caching** | `redis-cli ping` | 5s | Checks low-latency session store. |
| **Logic/APIs**| `curl` / `requests` | 30s | Validates endpoint responsiveness. |
| **AI Inference**| `ollama list` | 30s | Confirms local model serving health. |

### 2. Tiered CPU Limits (Adr-0027)
Following the Resource Rationalization ADR, CPU limits are applied based on service priority:

| Tier | Services | Limit (CPUs) |
|------|----------|--------------|
| **High** | `postgres`, `n8n`, `ollama` | 2.0 |
| **Medium** | `qdrant`, `prometheus`, `grafana`, `obsidian`, `authentik`, `digital-twin-api` | 0.5 - 1.0 |
| **Low** | `redis`, `rabbitmq`, `exporters`, `db-event-bridge` | 0.25 |

### 3. CDC Consolidation (LISTEN/NOTIFY)
To eliminate architectural complexity and remove external plugin dependencies (like `wal2json`), the system uses a robust **trigger-based CDC model**:

- **Unified Triggers:** `AFTER INSERT OR UPDATE` triggers on core domain tables.
- **Bridge Engine:** `G11_db_event_bridge.py` acts as a multi-threaded listener across all 8 domain databases.
- **Resilience:** PostgreSQL's native `NOTIFY` ensures sub-second reactivity without the need for complex replication slot management.

### 4. PgBouncer Sidecar
A connection pooling layer is implemented to optimize database resource usage for all standard application traffic.
- **Primary Entry Port:** `6432` (PgBouncer)
- **Direct Backend Port:** `5432` (Postgres Container)
- **Policy:** All n8n workflows and API services must connect via port `6432`. Only the `db-event-bridge` uses dedicated direct connections to maintain listener stability.

### 5. Script Lifecycle Management (Inventory)
To prevent self-healing loops for abandoned scripts, a centralized inventory system was established.
- **Inventory File:** `scripts/_meta/script_inventory.json`
- **Manager:** `G11_script_inventory_manager.py` (scans disk and logs).
- **Auto-Retirement:** Scripts inactive for > 30 days are automatically marked as **RETIRED**.
- **Supervisor Policy:** The `G11_self_healing_supervisor.py` only audits and attempts repairs for scripts with **PRODUCTION** status.

## Maintenance & Recovery
- **User Sync:** If `.env` credentials change, update the `infrastructure/database/pgbouncer/userlist.txt` file and restart the `pgbouncer` container.
- **Manual Override:** Services can be reverted to port `5432` by modifying the `DB_PORT` environment variable in `docker-compose.yml`.

---
*Updated: 2026-05-09 | Architectural Pivot: WAL decommissioned.*

## References
- [Adr-0027: Container Resource Rationalization](../../60_Decisions_adrs/Adr-0027-Container-Resource-Rationalization.md)
- [Service Registry](../Service-Registry.md)
