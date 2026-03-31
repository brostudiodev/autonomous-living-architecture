---
title: "S04: Digital Twin API Master Registry"
type: "system_spec"
status: "active"
system_id: "S04"
goal_id: "goal-g04"
version: "5.4"
owner: "Michal"
updated: "2026-03-12"
---

# S04: Digital Twin API Master Registry

## 🎯 Purpose
The Digital Twin API is the central nervous system of the autonomous ecosystem. It translates raw database states and script execution results into actionable intelligence for n8n, Telegram, and the Web UI.

## ⚠️ Mandatory Response Standard
Every endpoint **MUST** return a JSON object with these keys to maintain n8n compatibility:
- `report`: Primary human-readable Markdown/Text.
- `response_text`: Duplicate of `report` (for Telegram).
- `content`: Duplicate of `report` (for legacy parsers).
- `data`: (Optional) Structured JSON data for programmatic use.

---

## 🛠️ Restoration & Recovery Guide
If the API fails (e.g., 404s or 500s):
1.  **Check Process:** `ps aux | grep G04_digital_twin_api.py`.
2.  **Check Container:** `docker logs digital-twin-api`.
3.  **Verify Script Path:** Ensure all imported scripts (G01–G12) exist in `scripts/`.
4.  **Endpoint Restoration:** Every endpoint must be explicitly defined using `@app.api_route` or `@app.get/post` in `G04_digital_twin_api.py`.
5.  **Restart Logic:** After any change, run `docker restart digital-twin-api`.

---

## 🧭 Intelligence & Planning Endpoints

| Endpoint | Method | Description | Primary Logic / Source |
|---|---|---|---|
| `/all` | GET/POST | **Uber-Context.** Full state for LLM reasoning. | `engine.get_full_context()` |
| `/status` | GET/POST | **The Glance.** Summary of Health, Finance, Focus. | `engine.generate_summary()` |
| `/suggested` | GET/POST | **Director's Report.** Connectivity, Insights, Schedule. | `engine.generate_suggested_report()` |
| `/tomorrow` | GET/POST | **Planning.** Tomorrow's mission briefing & events. | `G10_tomorrow_planner.py` |
| `/today` | GET/POST | **Live Dashboard.** Current Obsidian Daily Note. | `G10_today_status.py` |
| `/os` | GET/POST | **Personal Meta-Optimization.** Freshness & Warnings. | `engine.get_system_freshness()` |
| `/roi` | GET/POST | **Value Analysis.** Total time saved today. | `engine.get_roi_summary()` |
| `/vision` | GET/POST | **North Star.** Power Goals & Mission progress. | `G11_vision_monitor.py` |
| `/todos` | GET/POST | **Agenda.** Consolidated Google Tasks. | `G10_google_tasks_sync.py` |
| `/tasks` | GET/POST | **Recommendations.** Biometric-aware next steps. | `engine.get_task_recommendations()` |
| `/search` | GET/POST | **Vault Query.** Keyword search in Obsidian. | `engine.search_vault(query)` |
| `/memory` | GET/POST | **Strategic Archive.** Recent advice and decisions. | `engine.get_memory_status()` |
| `/strategic_audit` | GET/POST | **Truth-First Audit.** Intent vs. Reality analysis. | `G11_strategic_auditor.py` |
| `/simulate` | GET/POST | **Projection.** Q4 goal completion likelihood. | Static heuristic (Engine) |
| /chat | POST | **Terminal.** Handles NL and Slash commands (e.g., `/approve [ID]`, `/approve all`, `/deny [ID]`). | `AgentZero.ask()` |

---

## ⚖️ Decision Engine (The Approval Loop)

The Decision Engine allows the system to propose high-confidence actions that require human consent before execution.

| Endpoint | Method | Description | Primary Logic / Source |
|---|---|---|---|
| `/decisions/pending` | GET | **Inbox.** Fetch all `PENDING` decision requests. | `digital_twin_michal.decision_requests` |
| `/decisions/resolve` | POST | **Action.** Approve or Deny a specific request ID. | `G11_decision_handler.py` |
| `/chat` (Slash) | POST | **Shortcut.** Use `/approve [ID]`, `/approve all`, or `/deny [ID]` for quick triage. | `AgentZero` -> `G11_decision_handler.py` |

### **Approval Workflow:**
1.  **Generation:** `G11_decision_proposer.py` (via Global Sync) inserts `PENDING` requests.
2.  **Notification:** `G11_approval_prompter.py` sends a Telegram message with Inline Buttons.
3.  **Action:** User clicks "Approve" (Telegram) or types `/approve [ID]` (Chat/Terminal).
4.  **Execution:** `G11_decision_handler.py` performs the actual domain change (e.g., rebalancing budgets).


---

| Endpoint | Method | Description | Primary Logic / Source |
|---|---|---|---|
| `/health` | GET/POST | **Biological Vitals.** Readiness, Sleep, HRV, Trends. | `engine.get_health_status()` |
| `/hydration` | GET/POST | **Liquid Log.** Today's Water/Caffeine totals. | `AgentZero.get_water_total()` |
| `/finance` | GET/POST | **Wealth Status.** Budget alerts and breaches. | `engine.get_finance_status()` |
| `/forecast` | GET/POST | **Cashflow.** 30-day outflow projection. | Finance DB View |
| `/pantry` | GET/POST | **Logistics.** Low stock and expiring items. | `engine.get_pantry_status()` |
| `/workout` | GET/POST | **Physical.** Last 5 sessions & progression. | `engine.get_workout_detail()` |
| `/career` | GET/POST | **Professional.** Skill gaps and proficiency. | `engine.get_career_status()` |
| `/home_status` | GET/POST | **Environment.** Temp, device health, battery. | `G08_home_monitor.py` |
| `/home_security`| GET/POST | **Protection.** Alarm, motion, cameras. | `G08_home_monitor.py` |
| `/home_lights` | GET/POST | **Lighting.** List of active (ON) lights. | `G08_home_monitor.py` |
| `/report` | GET/POST | **Strategic Summary.** Monthly progress report. | `G01_monthly_reporter.py` |
| `/growth_report`| GET/POST | **Impact Hub.** Technical wins synthesis. | `G09_career_growth_reporter.py` |
| `/best_day` | GET/POST | **Performance.** Peak day correlation analysis. | `engine.get_historical_trends()` |

---

## ⚡ Actions & Synchronization

| Endpoint | Method | Description | Primary Logic / Source |
|---|---|---|---|
| `/sync` | GET/POST | **Global Sync.** Triggers 30+ scripts (Async). | `G11_global_sync.py` |
| `/health_sync` | GET/POST | **Biometric Extract.** Force Zepp/Amazfit sync. | `G07_zepp_sync.py` |
| `/scale_sync` | GET/POST | **Weight Sync.** Force Withings API extraction. | `withings_to_sheets.py` |
| `/substack_sync`| GET/POST | **Content Sync.** Posts to Obsidian. | `G02_substack_sync.py` |
| `/logistics_sync`| GET/POST | **Deadlines.** Sync legal/admin documents. | `G04_logistics_sync.py` |
| `/shopping_list`| GET/POST | **Procurement.** Generate shopping manifest. | `G03_household_manifest.py` |
| `/shopping/populate_cart` | POST | **One-Click Cart.** Push to Google Tasks. | `G03_cart_aggregator.py` |
| `/log_coffee` | GET/POST | **Caffeine.** Log 100mg cup + return total with timestamp (HH:MM:SS - DD.MM.YYYY). | `AgentZero.log_caffeine()` |
| `/log_water` | GET/POST | **Water.** Log 250ml glass + return total with timestamp (HH:MM:SS - DD.MM.YYYY). | `AgentZero.log_water()` |
| `/log_reflection`| GET/POST | **Evening.** Generate Stoic coach reflection. | `G10_reflection_generator.py` |
| `/log_event` | POST | **Memory.** Record manual decision/event. | `engine.save_to_memory()` |
| `/harvest` | GET/POST | **Idea Gen.** Trigger content idea harvesting. | `G02_content_harvester.py` |
| `/system_health`| GET/POST | **Ops Monitor.** 24h script success report. | `G11_log_system.md` |
| `/audit` | GET/POST | **Governance.** Documentation integrity check. | `G12_documentation_audit.py` |
| `/map` | GET/POST | **Connectivity.** Goal dependency matrix. | `G11_meta_mapper.py` |

---

## 🖥️ UI & Development
- **Root (`/`):** Serves `scripts/static/index.html` (Mission Control).
- **Help (`/help`):** Returns the directory of all valid commands.
- **Ask (`/ask`):** Alias for `/chat` used by n8n Agent tools.

---
*Generated by Digital Twin AI Assistant - March 2026*
