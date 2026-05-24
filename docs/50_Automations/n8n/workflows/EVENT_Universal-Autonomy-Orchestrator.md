---
title: "n8n Workflow: EVENT_Universal-Autonomy-Orchestrator"
type: "automation_spec"
status: "active"
automation_id: "WF116"
goal_id: "goal-g11"
systems: ["S11", "S08", "S04"]
owner: "Michał"
updated: "2026-05-01"
---

# ⚡ EVENT_Universal-Autonomy-Orchestrator (WF116)

## Purpose
The **Universal Autonomy Orchestrator** is the centralized "Autonomic Nervous System" of the ecosystem. It consumes all real-time events from RabbitMQ and dispatches reactive actions across Health, Finance, Training, and Meta-System domains.

## Triggers
- **Type:** RabbitMQ Trigger
- **Queue:** `eda-orchestrator`
- **Exchange:** `life.events` (Topic)
- **Routing Keys:** 
    - `health.#` (Biometrics, Readiness warnings)
    - `*.warning.#` (System/Domain alerts)
    - `*.critical.#` (Infrastructure failures)
    - `*.db_event.#` (Universal database triggers)

## Inputs
- **Payload:** JSON event containing `routing_key`, `payload` (data), and `timestamp`.

## Processing Logic
1. **⚙️ Config:** Sets global variables (API Base URL, Telegram Chat ID).
2. **Parse EDA Message:** Extracts the domain and action from the routing key.
3. **Route by Domain:**
    - **Health:**
        - `biometric_inserted`: Triggers `daily_note_refresh` tool.
        - `warning`: Fetches readiness and pivots schedule to Recovery Mode if needed.
    - **Finance:** Sends real-time Telegram alerts for new transactions (`transactions_insert`).
    - **Training:** Notifies upon workout logging (`workouts_insert`).
    - **Meta:** Fetches pending decisions and sends interactive Telegram buttons.

## Outputs
- **API Calls:** Digital Twin API (`/execute_tool`, `/decisions/pending`).
- **Telegram Notifications:** Real-time HTML/Markdown alerts via `AndrzejSmartBot`.
- **System Actions:** Schedule pivoting, Dashboard refreshing.

## Dependencies
### Systems
- [S08 Automation Orchestrator](../../../20_Systems/README.md)
- [S04 Digital Twin](../../../20_Systems/README.md)

### Infrastructure
- **RabbitMQ:** Broker for event distribution.
- **Digital Twin API:** For tool execution and decision retrieval.

## Failure Modes
| Scenario | Detection | Response |
|---|---|---|
| RabbitMQ Offline | Node Error | n8n retry logic (exponential backoff) |
| API Unreachable | HTTP 5xx / Timeout | Log error, send critical alert via fallback |
| Parse Error | JS Exception | Error Trigger node notifies maintainer |

---
*Location:* `{{ROOT_LOCATION}}/autonomous-living/infrastructure/n8n/workflows/EVENT_Universal-Autonomy-Orchestrator.json`
