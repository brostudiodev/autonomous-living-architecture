---
title: "G04: Systems & Technical Spec"
type: "technical_spec"
status: "current"
owner: "{{OWNER_NAME}}"
updated: "2026-02-20"
---

# G04 Digital Twin - Systems Architecture

## Core Components

### 1. Digital Twin Engine (`G04_digital_twin_engine.py`)
The "brain" of the ecosystem. It is a stateless Python class responsible for:
- **Data Aggregation**: Querying multiple PostgreSQL databases (`autonomous_finance`, `autonomous_training`, `autonomous_pantry`).
- **State Calculation**: Converting raw DB rows into structured JSON state objects.
- **Summary Generation**: Creating human-readable status strings for Telegram/Daily Notes.
- **Persistence**: Writing state snapshots to `digital_twin_updates` (PostgreSQL).

### 2. Digital Twin API (`G04_digital_twin_api.py`)
The interface for external systems (n8n, Obsidian).
- **Port**: 5677
- **Tech Stack**: FastAPI, Uvicorn, Psycopg2
- **Endpoints**:
  - `GET /status`: Combined briefing + raw state.
  - `GET /health`: Current body composition and last workout.
  - `GET /finance`: MTD Net and active budget alerts.
  - `GET /history?limit=x`: Historical state transitions.

## Data Model (JSONB)

The system persists state in a unified format:
```json
{
  "entity_type": "health | finance | pantry",
  "entity_id": "PERSON_UUID",
  "update_data": { ... },
  "source_system": "g04_engine",
  "update_type": "status_sync"
}
```

## Integration Matrix

| Source System | Method | Frequency |
| --- | --- | --- |
| Finance (G05) | SQL Query (Transactions/Alerts) | Every Request / Sync |
| Training (G01) | SQL Query (Workouts/v_body_comp) | Every Request / Sync |
| Pantry (G03) | SQL Query (Inventory) | Every Request / Sync |
| n8n Router | REST API (`/status`) | On-Demand (User / Cron) |
| Daily Note | Python Import (`DigitalTwinEngine`) | Daily (6:00 AM) |

## Infrastructure
- **Docker**: The API runs in a Python container within the `autonomous-living` bridge network.
- **Database**: PostgreSQL (Host: localhost/docker-alias, Port: 5432).
- **Observability**: Prometheus metrics (planned for Q2).
