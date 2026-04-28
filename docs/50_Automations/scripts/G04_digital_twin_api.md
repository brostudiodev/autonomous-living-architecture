---
title: "G04: Digital Twin Central API"
type: "automation_spec"
status: "active"
automation_id: "G04_digital_twin_api"
goal_id: "goal-g04"
systems: ["S04"]
owner: "Michał"
updated: "2026-04-25"
---

# G04: Digital Twin Central API

## Purpose
The primary communication interface for the Autonomous Living ecosystem. It acts as the high-performance bridge between the Python execution layer and the n8n/Obsidian interfaces. Version 7.3 (Environment Parity & Redis-First Milestone).

## Triggers
- **Persistent Service**: Runs via Uvicorn/FastAPI on port 5677 (or internal container port).
- **n8n Orchestrator**: Primary consumer for Agent Zero queries.
- **Obsidian Dashboard**: Secondary consumer for real-time telemetry.
- **Telegram Bot**: Interface for mobile commands.

## Inputs
- **Queries**: Natural language via `/ask` or `/chat`.
- **Structured JSON**: Specific models for `/reflect`, `/log_event`, and `/memory/operation`.
- **System States**: Aggregated data from all PostgreSQL databases (Finance, Health, Training, etc.).

## Complete Endpoint Directory (100% Reachable)

### 🧠 Intelligence & Planning
Endpoints for high-level synthesis and scheduling.

| Endpoint | Method | Description |
|----------|--------|-------------|
| `/status` | GET/POST | **Consolidated:** Returns high-level summary via `AgentZero.ask("/status")`. |
| `/suggested` | GET/POST | Alias for tactical briefing via suggestion engine. |
| `/tomorrow` | GET/POST | **RECOVERED:** Forecasted briefing for the next day. |
| `/today` | GET/POST | **Native Handler:** Standardized today's mission briefing and schedule. |
| `/os` | GET/POST | **RECOVERED:** Returns real-time system health and vital sentinel report. |
| `/vision` | GET/POST | **RECOVERED:** Returns strategic roadmap status and Q1/Q2 priority missions. |
| `/roi` | GET/POST | **RECOVERED:** Detailed Autonomy ROI (Time Reclaimed) report. |
| `/tasks` | GET/POST | **RECOVERED:** Returns priority tasks and intelligence-led recommendations. |
| `/readiness`| GET/POST | **Agent-Driven:** Detailed biological/financial readiness report. |
| `/forecast` | GET/POST | **Agent-Driven:** Unified financial burn and runway prediction. |
| `/workout` | GET/POST | **Agent-Driven:** Summary of training sessions and HIT progression. |
| `/memory` | GET/POST | **Agent-Driven:** Last 10 strategic memories and guidance history. |
| `/all` | GET/POST | **Uber-Context:** Returns token-efficient system state for AI ingestion. |
| `/system/activity`| GET/POST | Returns the last 10 entries from the System Activity Log. |
| `/system/gaps`| GET/POST | Autonomously detects missing documentation or script failures. |
| `/best_day` | GET/POST | **STANDARDIZED:** Identifies historical peak performance days (correlated metrics). |

### 🛡️ System Health & Observability
Endpoints for monitoring the integrity and readiness of the Digital Twin.

| Endpoint | Method | Description |
|----------|--------|-------------|
| `/health/live` | GET | Liveness check for Docker/Process status. |
| `/health/ready`| GET | Readiness check: Verifies all 8 domain databases are reachable. |
| `/cache/status` | GET | **NEW:** Returns current age and status of the Uber-Context cache. |
| `/cache/refresh`| GET/POST | **NEW:** Manually triggers a refresh of the Uber-Context cache. |
| `/health/readiness`| GET | **RECOVERED:** Detailed multi-component readiness diagnostic. |
| `/health/domain/{name}` | GET | Per-domain health probe. Returns circuit breaker status and DB connectivity. |
| `/tools/health`| GET | **RECOVERED:** Runtime validation of all 61+ agent tools. Supports `AUDIT_MODE` check. |
| `/system/gaps`| GET | Scans for script failures, stale data, and missing documentation. |
| `/health/dashboard`| GET | **RECOVERED:** Returns the Unified System Health Dashboard (G11) with sync integrity checks. |
| `/strategic_audit`| GET/POST | **RECOVERED:** Comprehensive strategic alignment audit (Vision vs. Execution). |
| `/audit` | GET/POST | **RECOVERED:** Runs a full G12 standard documentation audit and coherence check. |
| `/map` | GET | Returns the technical architecture and connectivity map of the ecosystem. |
| `/help`| GET/POST | **Dynamic Directory:** Returns a categorized and AI-optimized list of all active API endpoints. |

### 🧬 Domain Telemetry (Deep Data)
Endpoints for domain-specific metrics and granular database queries.

| Endpoint | Method | Description |
|----------|--------|-------------|
| `/health` | GET/POST | Biological status: readiness, sleep score, HRV, and step trends. |
| `/health/history` | POST | Returns raw health metrics for a specific `target_date` (YYYY-MM-DD). |
| `/sleep/trend` | GET/POST | Returns raw sleep and biometric data for the last X days (default 30). |
| `/query` | POST | **Total Recall:** Direct read-only SQL querying across all databases (`twin`, `health`, `finance`, `training`). |
| `/readiness`| GET | Returns the multi-component readiness score (Biological + Operational + Financial). |
| `/hydration`| GET/POST | **REFINED:** Returns Water vs. Coffee breakdown, total hydration (ml), and balance status. |
| `/finance` | GET/POST | High-level financial status and active budget alerts. |
| `/finance/details`| GET/POST | Params: `month` (int), `year` (int). Returns top 5 expenses and detailed budget breaches. |
| `/finance/forecast`| GET | Returns daily burn rate, estimated liquidity runway, and predicted depletion date. |
| `/pantry` | GET/POST | Summary of inventory alerts. **Enhanced:** Supports sub-queries to search specific items across all 9 locations. |
| `/pantry/inventory`| GET/POST | **FULL DUMP:** Returns current quantity, units, and thresholds for every tracked item including location. |
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
| `/health/dashboard`| GET | Returns the Unified System Health Dashboard (G11) with sync integrity checks. |
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
| /decisions/resolve| POST | Body: `{request_id: int, choice: str}`. Standard endpoint to Approve/Deny a decision. |
| `/approve/{id}` | GET/POST | **State-Verified:** Checks if decision is `PENDING` before updating to `APPROVED`. Supports `/approve [ID]` or `/approve_[ID]`. |
| `/deny/{id}` | GET/POST | **State-Verified:** Checks if decision is `PENDING` before updating to `DENIED`. Supports `/deny [ID]` or `/deny_[ID]`. |
| `/state/update` | POST | **Real-Time Telemetry:** Allows external agents to push status updates directly to the Twin. |

### 🛠️ Agentic Tool Framework
Endpoints for autonomous agent script execution.

| Endpoint | Method | Description |
|----------|--------|-------------|
| `/tools` | GET | Returns a list of available tools, optionally filtered by `domain`. |
| `/tool/list`| GET | Returns metadata for all registered G-series scripts in the manifest. |
| `/tool/help`| GET | Returns an AI-optimized guide for using the Tool Framework. |
| `/execute_tool`| POST | Body: `{"tool_id": str, "params": dict}`. Executes a specific script. |

## Processing Logic
1.  **Resilience First**: All JSON endpoints follow the **200 OK Standard**. If internal logic fails, a descriptive error is returned in the `report` field instead of an HTTP exception.
2.  **Redis-First Caching (NEW Apr 25)**: The `/all` endpoint prioritizes Redis (`twin:context:all`) for sub-millisecond response times and persistence across API restarts. Fallback to PostgreSQL is automatic if Redis is unavailable.
3.  **Dynamic Discovery**: The `/help` and `/chat` interfaces now utilize dynamic route introspection to generate a categorized endpoint directory in real-time.
3.  **Help Intercept**: The chat engine intercepts `/help`, `help`, and `/commands` queries, bypassing the LLM to return the technical API directory for zero-latency guidance.
4.  **Domain Isolation**: All database calls are protected by the `DomainIsolator` (Circuit Breaker). If a database is slow or offline, the API fast-fails for that specific domain while keeping other services active.
5.  **Model Hardening (NEW Apr 18)**: Standardized Pydantic models for `/state/update` and `/query` to prevent `NameError` on agent ingestion.
6.  **Syntax Hardening (NEW Apr 18)**: Resolved critical variable truncation in DB connection logic across all domains.
7.  **Background Execution**: Long-running tasks (`/sync`, `/approve`, `/execute_tool`) utilize `BackgroundTasks` or sub-processes to prevent caller timeouts.

## Monitoring
- **Health Check**: `GET /health/ready` returns full dependency status.
- **Circuit Status**: Check `G04_domain_isolator.py` registry via `/health/domain/{name}`.
- **Logs**: API events are recorded in `api_5677.log` (standard port 5677).

---
*Updated: 2026-04-18 | Model Hardening & Syntax Fix Milestone.*
