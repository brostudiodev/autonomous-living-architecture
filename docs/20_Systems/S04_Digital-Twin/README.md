---
title: "S04: Digital Twin (Intelligence Hub)"
type: "system"
status: "active"
system_id: "system-s04"
owner: "Michal"
updated: "2026-03-23"
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
- **Intelligence:** Google Gemini 1.5 Flash (via REST API).
- **Persistence:** `digital_twin_michal` database (PostgreSQL).
- **Interface:** REST API (FastAPI) + Telegram (via n8n/Python).

## Digital Twin API Spec

### Core Endpoints
| Endpoint | Method | Purpose | Output |
|----------|--------|---------|--------|
| `/all` | GET | Full system context aggregation | High-density JSON |
| `/status` | GET | Quick glance at system health | Markdown string |
| `/suggested` | GET | The day's autonomous mission report | Markdown report |
| `/vision` | GET | North Star & Power Goals status | Dashboard |
| `/tomorrow` | GET | Evening mission briefing | Plan JSON |
| `/morning_briefing` | GET | Triggers Telegram push notification | Status message |
| `/today` | GET | Mobile-optimized today dashboard | JSON/Text |
| `/todos` | GET | Current focused tasks from Daily Note | Checklist |
| `/os` | GET | Meta-optimization & ROI report | Markdown report |
| `/search` | GET | Real-time search across Obsidian Vault | JSON + Snippets |
| `/hydration` | GET | Detailed water & caffeine daily stats | JSON/Text |
| `/log_coffee` | GET/POST | Logs caffeine (`amount_mg`, `type`, `note`) | Timestamped confirmation |
| `/log_water` | GET/POST | Logs water (`amount_ml`, `note`) | Timestamped confirmation |
| `/reflect` | POST | Surgically updates Daily Note with evening reflection | Status |

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
- [Script: Digital Twin Engine](../../50_Automations/scripts/G04_digital_twin_engine.md)
- [Script: Mission Control](../../50_Automations/scripts/G11_mission_control.md)

---
*Updated: 2026-03-23 by Digital Twin Assistant*
