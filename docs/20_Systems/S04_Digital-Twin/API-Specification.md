---
title: "S04: Digital Twin API Specification"
type: "system_spec"
status: "active"
system_id: "S04"
goal_id: "goal-g04"
owner: "Michal"
updated: "2026-02-26"
---

# S04: Digital Twin API

## Purpose
The Digital Twin API is the central intelligence hub for the autonomous ecosystem. It aggregates data from health, finance, and logistics to provide a unified "State of the Self."

## ⚠️ Mandatory Response Standard
All endpoints intended for n8n consumption **MUST** return a JSON object containing these three keys to ensure backward compatibility with existing sub-workflows:
- `report`: The primary formatted content.
- `response_text`: Duplicate of report (for Telegram dispatchers).
- `content`: Duplicate of report (for legacy extractors).

## Endpoints

### Intelligence & Planning
- `GET /all`: **The Uber-Context Endpoint.** Aggregates high-density summaries from all domains (Health, Finance, Pantry, Smart Home, Roadmaps) into a single JSON object. Designed specifically for LLM situational awareness.
- `GET /suggested`: The core autonomous report (Connectivity, Insights, Schedule, Missions).
- `GET /tomorrow` | `/briefing`: Tomorrow's mission briefing and calendar events.
- `GET /today`: Live "Mobile Dashboard" parsed from the current Obsidian Daily Note.
- `GET /os`: Meta-optimization advice and system warnings from the Rules Engine.
- `GET /vision`: North Star vision and 2026 Power Goals dashboard.
- `GET /todos`: Formatted and cleaned version of `Daily Autonomous Tasks.md`.

### System & Health
- `GET /status`: Detailed summary of system health, including **Sync Supervisor** results (Pantry, Finance, Health freshness).
- `GET /workout`: Returns the last 5 workout sessions (Date, Type, Duration, Recovery) and recent strength progression highlights (Weight, Time Under Tension, Progress Status).
- `GET /home_status`: Smart home environmental metrics (temp, battery) and device health alerts.
- `GET /home_security`: Home security hub (Alarm state, active motion, camera status, entry points).
- `GET /home_lights`: Active lighting report (List of all lights currently ON).
- `GET /audit`: Results of the G12 Documentation Audit.
- `GET /map`: G11 Meta-System connectivity matrix.
- `GET /health`: Raw biometric and recovery telemetry.
- `GET /finance`: Raw budget and transaction alerts.
- `GET /workout`: Detailed workout history (last 5 sessions) and strength progression highlights from the training database. Supports `?format=text` for human-readable summaries.

### Operations
- `GET /sync`: Triggers `G11_global_sync.py` with **Self-Healing logic**. Proactively attempts to resync any core domain (Pantry, Health, Finance) that is identified as stale (> 24h). Always returns results in the Standardized Response format.
    - **Parameters:**
        - `format` (optional): `text` or `json`.
        - `skip_manager` (optional): Set to `true` to skip updating the Obsidian Daily Note and suppress briefings. Mandatory for background/automated triggers to avoid loops.
- `GET /health_sync`: Triggers `G07_zepp_sync.py` to perform a manual extraction of Amazfit/Zepp biometric data into the `autonomous_health` database.

## Implementation Details
- **Port:** 5677 (Fixed)
- **Engine:** FastAPI / Uvicorn
- **Deployment:** Docker container `digital-twin-api`
- **Source:** `scripts/G04_digital_twin_api.py`
