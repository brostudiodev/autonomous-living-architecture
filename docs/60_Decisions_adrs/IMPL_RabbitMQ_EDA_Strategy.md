---
title: "IMPL: RabbitMQ Event-Driven Architecture (EDA)"
type: "implementation_guide"
status: "draft"
owner: "Michał"
updated: "2026-05-01"
---

# IMPL: RabbitMQ Event-Driven Architecture (EDA)

## Overview
This document outlines the technical strategy for migrating the Autonomous Living ecosystem from a polling-based model to a real-time Event-Driven Architecture (EDA) using **RabbitMQ**.

## 1. Infrastructure Deployment
### Docker Configuration
RabbitMQ will be added to the unified `docker-compose.yml` with the following specifications:
- **Image:** `rabbitmq:3-management` (includes web UI)
- **Ports:**
    - `5672`: AMQP protocol (messaging)
    - `15672`: Management UI (monitoring/admin)
- **Volumes:** `rabbitmq_data:/var/lib/rabbitmq`
- **Environment:** Standard `.env` variables for `RABBITMQ_DEFAULT_USER` and `RABBITMQ_DEFAULT_PASS`.

## 2. Standardized "LifeEvent" Schema
All events emitted in the ecosystem MUST follow this JSON structure:

```json
{
  "event_id": "uuid-v4",
  "timestamp": "ISO-8601",
  "source": "digital-twin-api | n8n | scripts",
  "domain": "health | finance | productivity | household | meta",
  "severity": "DEBUG | INFO | WARNING | CRITICAL",
  "action": "state_change | threshold_breach | task_completed",
  "payload": {
    "entity_id": "optional-id",
    "old_state": {},
    "new_state": {},
    "metadata": {}
  }
}
```

## 3. Integration Phases
### Phase 1: The Producer (Digital Twin API)
- **Library:** `pika` (Python RabbitMQ client).
- **Logic:** Update `G04_digital_twin_engine.py` to emit an event whenever the `Uber-Context` (all-in-one state) is refreshed and specific deltas are detected.
- **Example:** If `readiness_score` drops from 80 to 55, emit a `WARNING:threshold_breach` event.

### Phase 2: The Consumer (n8n Orchestrator)
- **Node:** RabbitMQ Trigger node.
- **Logic:** n8n workflows will listen to specific queues (e.g., `life.events.critical`) and trigger immediate responses (Telegram alerts, Home Assistant actions) without waiting for a cron trigger.

### Phase 3: The Dashboard (Real-Time UI)
- **Bridge:** A lightweight WebSocket server (possibly integrated into FastAPI) that consumes RabbitMQ events and pushes them to the browser/Obsidian UI.

## 4. Initial Routing Key Strategy
We will use a **Topic Exchange** (`life.events`) with routing keys following the pattern:
`[domain].[severity].[action]`

Examples:
- `health.warning.threshold_breach`
- `finance.info.transaction_detected`
- `meta.critical.service_down`

---
*Blueprint established: 2026-05-01*
