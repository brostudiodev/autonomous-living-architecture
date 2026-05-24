---
title: "Adr-0016: Event-Driven Architecture"
type: "decision"
status: "accepted"
date: "2026-02-25"
deciders: ["Michał"]
---

# Adr-0016: Event-Driven Architecture (EDA)

## Status
Accepted (v2.0 - Hybrid RabbitMQ Migration)

## Context
The system initially relied on polling (scripts running on crontab) to detect changes, creating high latency. While v1.0 used pure PostgreSQL `LISTEN/NOTIFY`, it lacked a centralized message broker for cross-service synchronization and complex routing (e.g., Python to n8n).

## Decision
We transitioned to a **Hybrid RabbitMQ-based EDA**:
1.  **Broker:** RabbitMQ (`life.events` Topic Exchange) serves as the central communication backbone.
2.  **Universal Bridge:** `G11_db_event_bridge.py` captures PostgreSQL `NOTIFY` events from 8+ databases and forwards them as AMQP messages.
3.  **Producers:** All core Python scripts utilize `G11_event_emitter.py` to broadcast state changes (e.g., `finance.bank_ingest_complete`).
4.  **Consumers:**
    *   **Execution (Local):** `G11_event_listener.py` handles deterministic system tasks (script restarts, DB syncs).
    *   **Intelligence (n8n):** `EVENT_Universal-Autonomy-Orchestrator` handles strategic analysis and user interaction.

## Consequences
- **Positive:** Sub-second latency for budget alerts and schedule pivots. Decoupled "Intelligence" (n8n) from "Execution" (Python).
- **Negative:** Increased infrastructure complexity (RabbitMQ + Bridge container).

## Implementation
- **Infrastructure:** `rabbitmq:3-management` in `docker-compose.yml`.
- **Logic:** `G11_event_listener.py`, `G11_db_event_bridge.py`.
- **Coverage:** Deployed universal triggers to 20+ tables across all 12 goals.
