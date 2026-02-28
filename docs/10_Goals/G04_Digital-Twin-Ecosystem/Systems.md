---
title: "G04: Systems & Traceability"
type: "technical_spec"
status: "active"
goal_id: "goal-g04"
owner: "Michal"
updated: "2026-02-24"
---

# G04 Digital Twin - Systems Architecture

## Core Components

### 1. Digital Twin Engine (`G04_digital_twin_engine.py`)
The "brain" of the ecosystem. Stateless Python class responsible for:
- **Data Aggregation**: Queries PostgreSQL databases (`autonomous_finance`, `autonomous_training`, `autonomous_pantry`).
- **State Calculation**: Converts raw DB rows into structured JSON state objects.
- **Summary Generation**: Creates human-readable status strings.

### 2. Digital Twin API (`G04_digital_twin_api.py`)
Central interface for n8n, Obsidian, and Telegram.
- **Port**: 5677 (FastAPI)
- **Primary Endpoints**:
  - `GET /status`: Full system briefing.
  - `GET /report`: Strategic monthly summary (Markdown).
  - `GET /tasks`: Aggregated cross-system task inventory.
  - `GET /training`: Dynamic HIT session recommendations.
  - `GET /sync`: Orchestrates all background sync scripts.
  - `GET /vision`: 2026 North Star and Power Goal intent.

### 3. Notification Hub (`G04_digital_twin_notifier.py`)
Centralized Telegram delivery system for all autonomous alerts and briefings.

## Traceability (Outcome → System → Automation → SOP)

| Outcome | System | Automation | SOP/Runbook |
|---|---|---|---|
| Real-time Event Response | S04 Digital Twin | [G04_digital_twin_listener.py](../../50_Automations/scripts/G04-digital-twin-listener.md) | - |
| Unified State View | S04 Digital Twin | [G04_digital_twin_api.py](../../50_Automations/scripts/g04-digital-twin-api.md) | - |
| Proactive Daily Briefing | S04 Digital Twin | [morning-briefing-sender.md](../../50_Automations/scripts/morning-briefing-sender.md) | - |
| Strategic Progress Reporting | S04 Digital Twin | [SVC_Digital-Twin-Report.md](../../50_Automations/n8n/services/SVC_Digital-Twin-Report.md) | - |
| System-wide Sync | S11 Meta-System | [SVC_Digital-Twin-Sync.md](../../50_Automations/n8n/services/SVC_Digital-Twin-Sync.md) | - |

## Infrastructure
- **Docker**: API runs in `digital-twin-api` container.
- **Volumes**: Local `scripts/` mounted to `/app` for live updates.
- **Environment**: `.env` file for Telegram and Database credentials.
