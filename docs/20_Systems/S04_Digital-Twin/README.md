---
title: "S04: Digital Twin (Intelligence Hub)"
type: "system"
status: "active"
system_id: "system-s04"
owner: "Michał"
updated: "2026-04-09"
review_cadence: "monthly"
---

# S04: Digital Twin

## Purpose
The central intelligence hub and orchestration layer for the autonomous living ecosystem. It serves as "Agent Zero"—a strategic partner that aggregates cross-domain data, identifies correlations, and generates proactive guidance to achieve the 2026 North Star.

## Scope
### In Scope
- **Agent Zero:** Natural language interface using Gemini 1.5 Flash.
- **Strategic Memory:** Contextual persistence via PostgreSQL.
- **Mission Briefings:** Proactive morning and evening guidance.
- **Decision Engine:** Interactive Approval/Denial of system-proposed actions.
- **Total Recall (SQL Interface):** Dynamic, read-only SQL querying across all system databases (Health, Finance, Twin, Training), enabling complex cross-domain analysis.
- **REST API:** High-density state retrieval for n8n and mobile apps.

## Architecture
- **Intelligence:** Google Gemini 1.5 Flash (via n8n workflows).
- **Agent Core:** Decoupled `G04_agent_zero_core.py` module for agent logic and command processing.
- **Engine Layer:** `G04_digital_twin_engine.py` with **Lazy Database Initialization**.
- **Domain Isolation:** **Circuit Breaker** pattern implemented via decorators to prevent cascading failures if a specific domain database (e.g., Health, Finance) is offline.
- **Persistence:** `digital_twin_michal` database (PostgreSQL) + 7 domain databases.
- **Interface:** REST API (FastAPI) with standardized n8n-compatible responses.
- **Health & Observability:** Integrated liveness/readiness checks, per-domain probing, and Docker health monitoring.

## Digital Twin API Spec

### Core Endpoints
| Endpoint | Method | Purpose | Output |
|----------|--------|---------|--------|
| `/health/live` | GET | Liveness check (process up) | JSON |
| `/health/ready`| GET | Readiness check (All 8 DBs + Engine) | JSON |
| `/cache/status` | GET | Cache age and staleness audit | Standardized JSON |
| `/cache/refresh`| POST | Manual Uber-Context refresh trigger | Standardized JSON |
| `/tools/health`| GET | Runtime validation of all 61+ tools | JSON |
| `/all` | GET | Full system context aggregation | Standardized JSON |
| `/status` | GET | Quick glance at system health | Standardized JSON |
| `/suggested` | GET | The day's autonomous mission report | Standardized JSON |
| `/vision` | GET | North Star & Power Goals status | Dashboard |
| `/tomorrow` | GET | Evening mission briefing | Plan JSON |
| `/morning_briefing` | GET | Triggers Telegram push notification | Status message |
| `/today` | GET | Mobile-optimized today dashboard | Standardized JSON |
| `/todos` | GET | Current focused tasks from Daily Note | Checklist |
| `/os` | GET | Meta-optimization & ROI report | Standardized JSON |
| `/search` | GET | Real-time search across Obsidian Vault | JSON + Snippets |
| `/hydration` | GET | Detailed water & caffeine daily stats | Standardized JSON |
| `/log_coffee` | GET/POST | Logs caffeine (`amount_mg`, `type`, `note`) | Standardized JSON |
| `/log_water` | GET/POST | Logs water (`amount_ml`, `note`) | Standardized JSON |
| `/reflect` | POST | Surgically updates Daily Note with evening reflection | Status |
| `/career/schedule_substack` | POST | Triggers the scheduling of an Obsidian Substack draft | `{"draft_name": "string"}` |

### Decision & Authority
| Endpoint | Method | Purpose | Input |
|----------|--------|---------|-------|
| `/decisions/pending` | GET | List all system-proposed actions awaiting approval | JSON List |
| `/decisions/resolve` | POST | Approve or Deny a specific decision ID | `{"request_id": int, "choice": "APPROVED|DENIED"}` |

### Strategic Interaction
| Endpoint | Method | Purpose | Input |
|----------|--------|---------|-------|
| `/ask` | POST | Query Agent Zero with context | `{"query": "string"}` |
| `/memory` | GET | Retrieve recent strategic memories | JSON Log |
| `/system/gaps` | GET | Scan for missing documentation or stale data | JSON List |
| `/finance/forecast` | GET | Cashflow burn rate and runway prediction | JSON |

### Operational Sync
| Endpoint | Method | Purpose | Note |
|----------|--------|---------|------|
| `/sync` | GET/POST | Triggers global system synchronization | Background Task |
| `/health_sync` | GET | Triggers Zepp/Health cloud sync | Direct |
| `/scale_sync` | GET | Triggers Withings/Weight sync | Direct |
| `/substack_sync` | GET | Triggers Substack article/metric sync | Direct |
| `/logistics_sync` | GET | Triggers Life Logistics sync | Direct |
| `/pantry_sync` | GET | Triggers Pantry Google Sheets to DB sync | Direct |
| `/shopping/populate_cart` | POST | Aggregates low stock and pushes to cart | Automated |


## Strategic Logic (Engine)
- **Primary Directive:** Heuristic determination of the day's #1 priority.
- **Cross-Domain Correlation:** Identify patterns between health, finance, and productivity.
- **Adaptive Scheduling:** Pivot between Deep Work and Recovery based on biometrics.

## Dependencies
- **System S03:** Data Layer for state persistence.
- **System S10:** Google Tasks for task synchronization.
- **System S11:** Meta-system integration for sync loops.
- **External:** Google Gemini API (API Key in `.env`).

## Related Documentation
- [Goal: G04 Digital Twin Ecosystem](../../10_Goals/G04_Digital-Twin-Ecosystem/README.md)
- [Goal: G11 Meta-System Integration](../../10_Goals/G11_Meta-System-Integration-Optimization/README.md)
- [System Spec: Agent Registry](./Agent-Registry.md)
- [System Spec: Tool Mapping](./Tool-Mapping-Spec.md)
- [Script: Digital Twin Engine](../../50_Automations/scripts/G04_digital_twin_engine.md)
- [Script: Mission Control](../../50_Automations/scripts/G11_mission_control.md)

---
*Updated: 2026-03-23 by Digital Twin Assistant*
