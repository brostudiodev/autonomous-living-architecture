---
title: "G04: Digital Twin Central API"
type: "automation_spec"
status: "active"
automation_id: "G04_digital_twin_api"
goal_id: "goal-g04"
systems: ["S04"]
owner: "Michal"
updated: "2026-03-31"
---

# G04: Digital Twin Central API

## Purpose
The primary communication interface for the Autonomous Living ecosystem. It acts as the high-performance bridge between the Python execution layer and the n8n/Obsidian interfaces. Version 5.6 (Total Recall Milestone).

## Triggers
- **Persistent Service**: Runs via Uvicorn/FastAPI on port 5677.
- **n8n Orchestrator**: Primary consumer for Agent Zero queries.
- **Obsidian Dashboard**: Secondary consumer for real-time telemetry.
- **Telegram Bot**: Interface for mobile commands.

## Inputs
- **Queries**: Natural language via `/ask` or `/chat`.
- **Structured JSON**: Specific models for `/reflect`, `/log_event`, and `/memory/operation`.
- **System States**: Aggregated data from all PostgreSQL databases (Finance, Health, Training, etc.).

## Complete Endpoint Directory

### 🧠 Intelligence & Planning
Endpoints for high-level synthesis and scheduling.

| Endpoint | Method | Description |
|----------|--------|-------------|
| `/ask` | POST | Unified natural language entry point. Directs to AgentZero reasoning engine. |
| `/chat` | POST | Alias for `/ask` with standard request model. |
| `/all` | GET/POST | **Uber-Context:** Returns the entire current system state (Health + Finance + Focus + Logistics). |
| `/status` | GET/POST | Returns a high-level summary of all domains + operational readiness. |
| `/suggested`| GET/POST | Returns AI-generated daily priorities and the "Primary Directive". |
| `/today` | GET/POST | Full dashboard for today: schedule, tasks, focus blocks, and health metrics. |
| `/tomorrow` | GET/POST | Briefing for tomorrow: prep tasks, upcoming events, and goal alignment. |
| `/vision` | GET/POST | Returns progress tracking for the 12 Power Goals of 2026. |
| `/todos` | GET/POST | Fetches top 10 upcoming tasks from the unified Google Tasks agenda. |
| `/tasks` | GET/POST | Returns data-driven task recommendations based on current system bottlenecks. |
| `/search` | GET/POST | Parameters: `q` (string). Performs a semantic search across the entire Obsidian Vault. |
| `/os` | GET/POST | Returns API version (5.4) and operational freshness scores for all subsystems. |
| `/roi` | GET/POST | Returns the calculated "Autonomy ROI" (Total time saved today/month). |

### 🧬 Domain Telemetry (Deep Data)
Endpoints for domain-specific metrics and granular database queries.

| Endpoint | Method | Description |
|----------|--------|-------------|
| `/health` | GET/POST | Biological status: readiness, sleep score, HRV, and step trends. |
| `/health/history` | POST | Returns raw health metrics for a specific `target_date` (YYYY-MM-DD). |
| `/query` | POST | **Total Recall:** Direct read-only SQL querying across all databases (`twin`, `health`, `finance`, `training`). |
| `/readiness`| GET | Returns the multi-component readiness score (Biological + Operational + Financial). |
| `/hydration`| GET/POST | **REFINED:** Returns Water vs. Coffee breakdown, total hydration (ml), and balance status. |
| `/finance` | GET/POST | High-level financial status and active budget alerts. |
| `/finance/details`| GET/POST | Params: `month` (int), `year` (int). Returns top 5 expenses and detailed budget breaches. |
| `/finance/forecast`| GET | Returns daily burn rate, estimated liquidity runway, and predicted depletion date. |
| `/pantry` | GET/POST | Summary of inventory status (low stock count, expiring count). |
| `/pantry/inventory`| GET/POST | **FULL DUMP:** Returns current quantity, units, and thresholds for every tracked item. |
| `/pantry/suggestions`| GET/POST | Returns AI-predicted shopping needs based on burn rate and meal plans. |
| `/workout` | GET/POST | Summary of recent training history and HIT method progression. |
| `/workout/stats`| GET/POST | Params: `days` (int). Returns aggregate training metrics (total mins, sessions, avg duration). |
| `/career` | GET/POST | Returns skill gaps, certification progress, and market demand alignment. |
| `/memory` | GET/POST | Returns the last 10 strategic memories and operational lessons learned. |

### 🏠 Smart Home (Read-Only)
Direct integration with Home Assistant status sensors.

| Endpoint | Method | Description |
|----------|--------|-------------|
| `/home` | GET/POST | General environment overview (temperature, occupancy, power usage). |
| `/home_security`| GET/POST | Security perimeter status: door sensors, motion, and lock states. |
| `/home_lights`| GET/POST | Lighting telemetry and circadian lighting alignment check. |

### ⚙️ Operations & Sync
Commands to force data refreshes or trigger system maintenance.

| Endpoint | Method | Description |
|----------|--------|-------------|
| `/sync` | GET/POST | Triggers **Global System Sync** as a background task. Sends Telegram notification on completion. |
| `/health_sync`| GET/POST | Forces immediate synchronization with Zepp/Amazfit cloud. |
| `/scale_sync` | GET/POST | Triggers ingestion of Withings smart scale data into MariaDB/PostgreSQL. |
| `/logistics_sync`| GET/POST | Syncs document expiries, car insurance, and administrative deadlines. |
| `/substack_sync`| GET/POST | Syncs views and subscriber growth for the Automationbro brand. |
| `/system_health`| GET/POST | Alias for subsystems freshness check. |
| `/system/gaps`| GET | Scans for script failures, stale data, and missing documentation. |
| `/audit` | GET/POST | Runs a full G12 standard documentation audit and coherence check. |
| `/map` | GET/POST | Returns the technical architecture and connectivity map of the ecosystem. |

### 📝 Recording & Mutation
Endpoints that write data to the Digital Twin or Obsidian.

| Endpoint | Method | Description |
|----------|--------|-------------|
| `/log_coffee`| GET/POST | Quick-log one espresso (100mg caffeine). Defaults to standard cup sizes. |
| `/log_water` | GET/POST | Quick-log one glass (250ml water). |
| `/log_reflection`| GET/POST | Triggers the evening reflection logic to generate daily summary suggestions. |
| `/log_event` | POST | Body: `{content: str, type: str}`. Records a custom timestamped event to memory. |
| /reflect | POST | Body: `{mood: str, energy: str, highlight: str, frustration: str}`. Updates Daily Note. |
| `/memory/operation`| POST | Body: `{content: str, goal_id: str}`. Saves a goal-specific technical lesson. |
| `/decisions/pending`| GET | Returns a list of all current `PENDING` decision requests from the Rules Engine. |
| `/decisions/resolve`| POST | Body: `{request_id: int, choice: str}`. Standard endpoint to Approve/Deny a decision. |
| `/approve/{id}` | GET/POST | **Background Execution:** Direct approval endpoint for Telegram buttons. |
| `/deny/{id}` | GET/POST | Direct denial endpoint for Telegram buttons. |
| `/harvest` | GET/POST | Triggers content harvester to pull ideas into the brand pipeline. |

## Processing Logic
1.  **Request Handling**: Uses FastAPI to route requests. Long-running tasks (`/approve`, `/query`, `/sync`) utilize `BackgroundTasks` to prevent caller timeouts.
2.  **Total Recall (SQL Interface)**: The `/query` endpoint provides a universal analytical bridge to all PostgreSQL databases for external agents.
3.  **Engine Interaction**: Calls `DigitalTwinEngine` to fetch cached states or compute real-time metrics.
4.  **Decoupled Intelligence**: Natural language intent and date math are handled at the orchestrator level (n8n), while the API remains a deterministic data provider.

## Monitoring
- **Health Check**: `GET /status` returns simple connectivity status.
- **Logs**: API events are recorded in `api_5678.log` and `api_restart.log`.

---
*Updated: 2026-03-31 | Total Recall Architecture Documented.*
