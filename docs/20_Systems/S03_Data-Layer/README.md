---
title: "S03: Data Layer (The Source of Truth)"
type: "system"
status: "active"
system_id: "system-s03"
owner: "Michał"
updated: "2026-05-09"
---

# S03: Data & Messaging Layer

## Purpose
The Data & Messaging Layer provides the persistent "Source of Truth" for all life domains and the real-time "Nervous System" for autonomous communication. It ensures that every biometric update, financial transaction, and logistics deadline is captured, stored, and disseminated to the intelligence agents.

## Scope
- **In Scope:** Persistent storage (PostgreSQL), Connection Pooling (PgBouncer), Message Broker (RabbitMQ), Real-Time Event Bus (EDA), Change Data Capture (CDC).
- **Out Of Scope:** Business logic (n8n/Scripts), Vector storage (Qdrant - see S04), Long-term file storage.

## Inputs/Outputs
- **Inputs:** Raw telemetry (biometrics, calendar, finance), User triage commands, Service logs.
- **Outputs:** Real-time event notifications (RabbitMQ), Queryable structured data (Postgres), Situational awareness context.

## Dependencies
- **Systems:** S00 Homelab Platform (Host).
- **Services:** PostgreSQL 16 (pgvector), RabbitMQ 3.12, PgBouncer 1.25.
- **Credentials:** Root `.env` (DB_USER, RABBITMQ_PASS), `/app/config/auth/` (centralized keys).

## Implementation Detail

### 1. Unified Domain Storage (Postgres)
The system uses a single Postgres instance with multiple specialized databases to maintain domain isolation while allowing cross-db queries:
- `autonomous_finance` (G05)
- `autonomous_health` (G01, G07)
- `autonomous_pantry` (G03)
- `autonomous_training` (G01)
- `autonomous_learning` (G06)
- `autonomous_life_logistics` (G03)
- `autonomous_career` (G02, G09)
- `digital_twin_michal` (G04, G10, G11, G12)

### 2. CDC Pipeline (Unified)
- **Primary Engine:** PostgreSQL `LISTEN/NOTIFY` Triggers.
- **Implementation:** `G11_db_event_bridge.py` connects to all domain databases and listens on the `roi_events` channel.
- **Consolidation:** WAL Streaming (Logical Replication) was decommissioned in favor of `LISTEN/NOTIFY` to reduce architectural complexity and remove dependency on the `wal2json` plugin.
- **Reactivity:** Sub-second situational awareness across all 8 domain databases.

### 3. Message Bus (Real-Time)
- **Exchange:** `life.events` (Topic)
- **Routing:** `[domain].[severity].[action]`
- **Spec:** [RabbitMQ Messaging Specification](RabbitMQ-Specification.md)

## Procedure: CDC Maintenance
1. **Adding a Table:**
   - Update `DEPLOYMENT_PLAN` in `scripts/deploy_universal_triggers.py`.
   - Run `python3 scripts/deploy_universal_triggers.py`.
   - Restart `db-event-bridge` container.
2. **Monitoring Logs:**
   - `docker logs -f db-event-bridge` to verify notification capture.
   - `rabbitmqadmin list queues` to check `life.events` throughput.

## Failure Modes
| Scenario | Detection | Response |
|----------|-----------|----------|
| **Trigger Drop** | Metadata Audit (G11) | Re-run `deploy_universal_triggers.py` |
| **Bridge Disconnect** | `db-event-bridge` logs / Healthcheck | Container auto-restarts via Docker |
| **Notification Loss** | Daily Sync Delta (G12) | System self-corrects during next full sync |
| **RabbitMQ Down** | `G11_event_emitter` errors | Check `rabbitmq` container health / disk space |

## Architectural Performance (Adr-0027 Compliance)
To support 100+ concurrent autonomous workflows and prevent system instability, the following optimizations have been applied:
- **Resource Limiting:** Postgres container is limited to 2GB RAM and 2.0 CPUs (Adr-0027) to prevent host starvation.
- **Connection Pooling:** Added PgBouncer to manage the massive influx of short-lived connections from n8n and API requests.
- **Shared Buffers:** Increased to `512MB` for better caching of frequently used training and health metrics.
- **Connection Management:** `max_connections` set to 300 to prevent n8n worker starvation during massive parallel event triggers.
- **Memory Efficiency:** `effective_cache_size` set to 2GB to inform the query planner of available OS cache.

## Security Notes
- All credentials stored in `.env` and `/app/config/auth`.
- Database accessible only via local network/Docker bridge.
- Regular AES256 encrypted backups via `G11_db_recovery_shield.py`.
- **PgBouncer:** Only authorized users in `userlist.txt` can connect via port 6432.

---
*Updated: 2026-05-09 | Part of G11 Meta-System Integration*
