---
title: "G04: Digital Twin Ecosystem"
type: "goal"
status: "active"
goal_id: "goal-g04"
owner: "Michał"
updated: "2026-04-08"
review_cadence: "monthly"
---

# G04: Digital Twin Ecosystem

## 🌟 What you achieve
*   **Your Life at a Glance:** A single "brain" that knows your health, finance, tasks, and home status in real-time.
*   **Voice & Text Interface:** Talk to your life via Telegram to ask questions like "How am I doing today?" or "What's my next mission?"
*   **Morning Intelligence:** Wake up to a pre-calculated briefing that optimizes your day based on your biological readiness.
*   **Cross-System Automation:** If your sleep is low, the Digital Twin can automatically suggest a lower-intensity workout.

## Purpose
Create a centralized AI-powered intelligence hub that aggregates data from all systems, provides multi-channel communication interfaces, and enables intelligent automation across the autonomous living ecosystem. The digital twin serves as the real-time, dynamic representation of the user's life.

## Scope
### In Scope
- Multi-channel input processing (text, voice, images, PDFs, YouTube)
- **English-Only Intent Processing:** Standardized internal core logic for accuracy (ADR-0020).
- Data aggregation from all goals (G01-G11)
- Real-time state representation
- Cross-system data ingestion pipelines
- GraphQL API layer for querying twin state

### Out of Scope
- 3D visualization (planned Q2)
- Predictive modeling (planned Q3)
- Autonomous decision making (planned Q3)

## Intent
Create a centralized AI-powered intelligence hub that aggregates data from all systems, provides multi-channel communication interfaces, and enables intelligent automation across the autonomous living ecosystem. **The system core operates in English, utilizing SVC_Language-Gate for input normalization.**

## Definition of Done (2026)
- [x] Production-grade AI router implemented (WF001)
- [x] **Language Standardization:** Internal logic hardened to English (ADR-0020).
- [x] n8n workflows active 24/7
- [x] Autonomy ROI Tracking Engine deployed (G04_log_roi)

- [x] Database-driven Hydration & Caffeine tracking
- [x] **Obsidian Semantic Synthesis:** Project status and vault intelligence active.
- [x] **Cooperative Telegram Bot:** Interactive decisions via n8n webhook (WF001 Agent Router) for inbound, `G04_digital_twin_notifier.py` for outbound.
- [x] **Standardized Daily Interface:** Formalized `Daily-Note-Interface-Spec.md` for Obsidian.
- [x] Monitoring in place - Integrated with S01 observability
- [x] Core data models for Digital Twin entities defined
- [x] Initial data ingestion pipelines from key sources
- [ ] GraphQL API layer established (Planned Q3)
- [x] Basic visualization dashboard (Telegram & Obsidian)

## Inputs
- User commands via Telegram, webhook, n8n chat
- Voice messages (Whisper STT)
- URLs (YouTube, web pages)
- Documents (PDFs, images)
- Scheduled data pulls from other systems
- Biological logs (Water, Coffee, Sleep)

## Outputs
- Processed content saved to Obsidian
- Aggregated metrics for dashboards
- Digital twin state updates in PostgreSQL
- Autonomy ROI metrics
- **Obsidian Intelligence:** Real-time project status and knowledge graph stats.
- Intelligence summaries
- Cross-system coordination commands

## Dependencies
### Systems
- S01 Observability (dashboards)
- S03 Data Layer (PostgreSQL)
- S08 Automation Orchestrator (n8n)
- Google Gemini API
- OpenAI Whisper

### External
- GitHub (Obsidian vault)
- Slack (notifications)
- Telegram Bot

## Key Links
- Outcomes: [Outcomes.md](Outcomes.md)
- Metrics: [Metrics.md](Metrics.md)
- Systems: [Systems.md](Systems.md)
- Roadmap: [Roadmap.md](Roadmap.md)

### 🛠️ API Endpoints (S04 Digital Twin)
| Endpoint | Method | Description | Response Field |
|---|---|---|---|
| `/status` | GET | Full system state (Health, Finance, Pantry) | `summary` |
| `/all` | GET | High-density JSON state for LLM context | `content` |
| `/recurring` | POST | Creates a recurring calendar event via Natural Language or manual | `report` |
| `/roi` | GET | Daily Autonomy ROI analysis (Time Saved) | `report` |
| `/search` | GET | Keyword search across the Obsidian Vault | `report` |
| `/hydration`| GET | Today's water and caffeine daily totals | `report` |
| `/tomorrow`| GET | Mission Briefing: Today's wins, Tomorrow's Calendar, Roadmap Missions | `response_text` |
| `/today` | GET | Mobile Dashboard: Parses biometrics, manual tasks, and goal progress from today's Obsidian Daily Note | `response_text` |
| `/audit` | GET | Self-Healing Audit: Checks database freshness, log staleness, and credential existence | `response_text` |
| `/health` | GET | Raw biometric & recovery status | raw JSON |
| `/tasks` | GET | Consolidated Google and Roadmap tasks | raw JSON |
| `/log_water`| GET/POST | Logs water intake (Supports notes) | `report` |
| `/log_coffee`| GET/POST | Logs caffeine intake (Supports type/note) | `report` |
| `/health/history` | POST | Returns raw health metrics for a specific `target_date` | raw JSON |
| `/query` | POST | **Total Recall:** Direct read-only SQL querying across all databases | Markdown Table |

#### Detailed Endpoint Logic:
- **`/query`**: The "Total Recall" interface. Allows the n8n Agent to write its own SQL to correlate data across `health`, `finance`, `twin`, and `training` databases.
- **`/health/history`**: Provides deterministic historical health data. Decoupled from LLM logic; date extraction is now handled by the n8n supervisor.
- **`/today`**: Uses `G10_today_status.py` to regex-parse the active Daily Note. It extracts YAML frontmatter (Mood, Energy, Sleep) and Markdown task lists. High value for mobile "on-the-go" checking.
- **`/recurring`**: Integrated with `G10_calendar_client.py`. Supports RRULE-based recurring events to automate frequent scheduling.
- **Morning Briefing**: Time-gated in `G11_global_sync.py` to only trigger between 05:00 and 10:00 AM, preventing redundant midday notifications during system syncs.
- P01: Intelligence Hub: [projects/P01_Intelligence-Hub.md](projects/P01_Intelligence-Hub.md)
- P02: Personal Context Integration: [projects/P02_Personal-Context-Integration.md](projects/P02_Personal-Context-Integration.md)
- n8n Workflows: [../../50_Automations/n8n/workflows/WF001_Agent_Router.md](../../50_Automations/n8n/workflows/WF001_Agent_Router.md)

## Procedure
1. **Daily:** Monitor incoming data, check for failures
2. **Weekly:** Review data freshness, update sources
3. **Monthly:** Analyze coverage, add new data sources
4. **Quarterly:** Review architecture, plan next phases

## Failure Modes
| Scenario | Detection | Response |
|----------|-----------|----------|
| AI API fails | Gemini returns error | Retry with backoff, log error |
| Data source unavailable | Scheduled pull fails | Skip cycle, alert on 3+ failures |
| Telegram bot down | /commands return error | Check n8n, restart workflow |
| Webhook timeout | Request times out | Log failure, return error to caller |

## Security Notes
- No PII in Telegram commands
- GitHub tokens stored as n8n credentials
- Assume adversarial reading for any public-facing outputs

## Current Status: **PRODUCTION READY (85% Complete)**

### Core Implemented Systems
- **Telegram Bot (INBOUND):** n8n Webhook via WF001 Agent Router - receives commands, processes intents
- **Telegram Bot (OUTBOUND):** `G04_digital_twin_notifier.py` - sends briefings, alerts, approvals
- **Multi-Channel Input:** text, voice, YouTube, web pages, images, PDFs
- **AI Intelligence:** Google Gemini for content extraction
- **GitHub Integration:** Auto-saves to Obsidian vault

> [!note]
> **Telegram Architecture (2026-04-08):** Inbound messages → n8n Webhook (WF001). Outbound notifications → Python (`G04_digital_twin_notifier.py`)

## Owner & Review
- **Owner:** Michał
- **Review Cadence:** Monthly
- **Last Updated:** 2026-04-25

---

## ☕ Fuel the Architecture

Building and maintaining this level of technical rigor is a massive investment. If this blueprint helps your own engineering journey, I would be grateful for your support.

<a href='https://ko-fi.com/michalnowakowski' target='_blank'><img height='60' style='border:0px;height:60px;' src='https://storage.ko-fi.com/cdn/kofi3.png?v=3' border='0' alt='Buy Me a Coffee at ko-fi.com' /></a>

**Support my hard work in engineering a fully autonomous life.** Every coffee fuels another line of code, another automated insight, and another step toward the 2026 North Star. Your contributions help maintain the infrastructure and research shared in this open-source blueprint.
