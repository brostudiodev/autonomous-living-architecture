---
title: "SOP: Event-Driven Dispatcher (Reactive System)"
type: "sop"
status: "active"
owner: "Michał"
updated: "2026-05-02"
tags:
  - EDA
  - RabbitMQ
  - Reactive
  - Autonomy
---

# SOP: Event-Driven Dispatcher (Reactive System)

## 🎯 Purpose
To transition the autonomous ecosystem from a polling-based model (cron/scheduled) to a **Reactive Event-Driven Architecture (EDA)**. This ensures that the system reacts instantly to biological, financial, or technical changes without waiting for the next execution cycle.

## 🛠️ Components
- **Message Broker:** RabbitMQ (`life.events` topic exchange)
- **Producer:** `G11_event_emitter.py` (Common library for all scripts)
- **Bridge:** `G11_db_event_bridge.py` (PostgreSQL NOTIFY to RabbitMQ)
- **Dispatcher:** `G11_event_listener.py` (The local "eda-orchestrator")
- **Intelligence Layer:** n8n (`EVENT_Universal-Autonomy-Orchestrator`)

## 🔄 Reactive Chains (Current)

| Trigger Event | Domain | Action | Reactive Consumer |
| :--- | :--- | :--- | :--- |
| `health.biometrics_updated` | Health | Fresh biometrics arrived | `G10_schedule_optimizer.py` (Local Re-calculate) |
| `health.low_readiness` | Health | Readiness < 60 | **n8n Orchestrator** (LLM Analysis + Notif) |
| `finance.bank_ingest_complete` | Finance | New transactions added | `G05_llm_categorizer.py` (Calls n8n SVC) |
| `finance.budget_breach` | Finance | Overspend detected | **n8n Orchestrator** (Critical Alert) |
| `pantry.sync_complete` | Pantry | Inventory updated | `G03_pantry_suggestor.py` (Local Audit) |
| `meta.activity_logged` (FAILURE) | Meta | Script failure detected | `G11_self_healing_supervisor.py` (Local Repair) |
| `db_event.transactions` | Finance | Direct SQL Insert | `G05_llm_categorizer.py` (Immediate AI) |
| `db_event.pantry_inventory` | Pantry | Stock update | `G03_cart_aggregator.py` (Auto-Procure) |
| `training.workout.completed` | Training | Exercise log sync | `G01_strength_gains_reporter.py` (Analytics) |
| `learning.study.session_complete`| Learning | Study log sync | `G06_study_velocity.py` (Milestone Track) |
| `content.idea.created` | Content | New idea in Vault | `G02_linkedin_drafter.py` (Auto-Draft) |

## 🛠️ Infrastructure: Universal DB Triggers
The system utilizes a "Notify-and-Forward" pattern. Every core table in the ecosystem is equipped with a `trg_{table}_notify` trigger that fires `pg_notify('roi_events', payload)`.

- **Deployment Script:** `scripts/deploy_universal_triggers.py`
- **Monitored Databases:** `finance`, `health`, `pantry`, `training`, `twin`, `learning`, `logistics`, `career`.
- **Partition Support:** Dynamic trigger application to all yearly transaction partitions (2012-2027).

## 📝 Operating Procedures

### 1. Adding a New Event Emission
To make a script "Signal" its completion or a specific state change:
```python
from G11_event_emitter import emit_event
emit_event("domain", "action_name", {"key": "value"}, severity="INFO")
```

### 2. Adding a New Reactive Response
To make the system react to an event, update `G11_event_listener.py`:
1. Locate the `process_event` function.
2. Add an `elif` block for the specific `domain` and `action`.
3. Use `subprocess.Popen` with `start_new_session=True` to trigger the reactive script.

### 3. Monitoring
- **RabbitMQ Management UI:** `http://localhost:15672`
- **Listener Logs:** `docker logs eda-orchestrator -f`
- **DB Bridge Logs:** `docker logs db-event-bridge -f`

## 🛡️ Guardrails
- **The Voice of the System (Python):** The local `G11_event_listener.py` is the **sole RabbitMQ consumer** for system-driven events. It is responsible for all **Outbound** Telegram notifications (the "Voice"), ensuring the system manages its own lifecycle.
- **The Strategic Brain (n8n):** n8n is utilized as a **Service Provider (SVC)**. The Python Dispatcher calls n8n webhooks for strategic reasoning (LLM analysis) and uses the result to notify the user.
- **The Interactive Router (n8n):** n8n remains the **Inbound** entry point. When a user sends a message/command via Telegram, n8n routes the intent back to the system.
- **Execution vs. Intelligence:**
    - **Execution (Local Python):** Event Consumption → Deterministic Action → Outbound Notification.
    - **Intelligence (n8n Webhooks):** Contextual Analysis → Strategic Proposal Generation.
- **Recursion Prevention:** Ensure reactive scripts do not emit events that trigger themselves (loops).
- **Idempotency:** All reactive scripts must be safe to run multiple times (check `was_successful_today`).
