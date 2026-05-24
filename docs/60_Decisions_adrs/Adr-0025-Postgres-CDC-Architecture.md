---
title: "Adr-0025: Postgres CDC Architecture"
type: "adr"
status: "accepted"
date: "2026-05-06"
---

# Adr-0025: Postgres CDC Architecture

## Context
The system previously relied on REST polling (15-60 min latency) to detect changes in domain databases (Health, Finance, Pantry). This caused "stale context" in n8n agents and delayed reactivity for critical events like budget breaches or low stock.

## Decision
Implement **Change Data Capture (CDC)** using native PostgreSQL `LISTEN/NOTIFY` triggers.

1.  **Triggers:** `AFTER INSERT OR UPDATE` triggers on key tables (`biometrics`, `transactions`, `pantry_inventory`).
2.  **Notification:** A shared PL/pgSQL function `notify_db_event()` that packs the `TG_TABLE_NAME`, `TG_OP`, and `row_to_json(NEW)` into a JSONB payload sent over the `roi_events` channel.
3.  **Bridge:** `G11_db_event_bridge.py` acts as the long-running consumer, listening across all 8 domain databases.
4.  **Bus:** Events are forwarded to the RabbitMQ `meta.db_event.<table_name>_<action>` exchange.

## CONSEQUENCES
- **Positive:** Sub-second reactivity for all domain changes. Reduced database CPU load (no more polling).
- **Negative:** Requires long-running listener threads per database. Higher complexity in the event bridge.

---

## 2026-05-09 UPDATE: PIVOT TO LISTEN/NOTIFY
While WAL Streaming (Logical Replication) was initially prototyped, it has been decommissioned in favor of a robust `LISTEN/NOTIFY` architecture for the following reasons:
1. **Zero Plugin Dependency:** Removed the need for `wal2json`, ensuring compatibility with standard PostgreSQL images.
2. **Simplified Infrastructure:** The `db-event-bridge` now uses standard `psycopg2` connections without complex replication slot management.
3. **Trigger Reliability:** The `deploy_universal_triggers.py` script provides a single source of truth for all 8 databases.
4. **Resilience:** PostgreSQL's native `NOTIFY` is sufficient for the "eventual consistency" requirements of the n8n intelligence layer. Any missed notifications are naturally recovered during the next write operation or daily sync.

