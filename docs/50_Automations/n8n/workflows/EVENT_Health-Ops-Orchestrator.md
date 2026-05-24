---
title: "EVENT: Health & Ops Orchestrator"
type: "n8n_workflow"
status: "active"
owner: "Michał"
goal_id: "goal-g04"
updated: "2026-05-01"
---

# EVENT: Health & Ops Orchestrator

## Purpose
Reactive orchestration of health recovery and operational maintenance based on real-time events from the RabbitMQ `life.events` bus.

## Scope
### In Scope
- Listening to `health.warning.#` (e.g., Low Readiness).
- Listening to `household.warning.#` (e.g., Appliance Maintenance).
- Listening to `meta.warning.#` (e.g., Script Failures).
- Autonomous schedule pivoting via `G10_morning_rescheduler.py`.
- Telegram notifications for critical state changes.

### Out of Scope
- Direct biometrics ingestion (handled by `G07_zepp_sync.py`).
- Decision resolution (handled by `EVENT_Digital-Twin-Decision-Resolver`).

## Architecture
- **Trigger**: RabbitMQ Trigger (Queue: `eda-orchestrator`).
- **Logic**: Switch-based routing by routing key.
- **Integration**: Digital Twin API for context, SSH for script execution.

## Dependencies
- RabbitMQ Exchange: `life.events`.
- Digital Twin API: `/health/readiness`.
- Scripts: `G10_morning_rescheduler.py`.

## Failure Modes
| Scenario | Detection | Response |
|----------|-----------|----------|
| RabbitMQ Disconnect | n8n node error | Auto-reconnect (n8n native) |
| SSH Failure | Node error | Telegram alert via error branch |
| API Timeout | 15s timeout | Retry once, then notify |

## Related Documentation
- [S04: Digital Twin API Specification](../../../20_Systems/S04_Digital-Twin/API-Specification.md)
- [Script: Morning Rescheduler](../../scripts/G10_morning_rescheduler.md)
