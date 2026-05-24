---
title: "S04: Digital Twin API Master Registry"
type: "system_spec"
status: "active"
system_id: "S04"
goal_id: "goal-g04"
version: "7.3"
owner: "Michał"
updated: "2026-05-10"
---

# S04: Digital Twin API Master Registry

## 🎯 Purpose
The Digital Twin API is the central nervous system of the autonomous ecosystem. It translates raw database states and script execution results into actionable intelligence for n8n, Telegram, and the Web UI.

## ⚡ Event-Driven Architecture (NEW v7.1)
The system now supports real-time, event-driven updates via RabbitMQ and WebSockets, drastically reducing latency and enabling instant reactions to life events.

| Endpoint | Method | Description | Primary Logic / Source |
|---|---|---|---|
| `/ws` | WS | **Event Stream.** Real-time WebSocket bridge for system events. | `manager.broadcast()` |
| `/emit` | POST | **Event Trigger.** Manually inject an event into the life.events bus. | `G11_event_emitter.py` |
| `/state/update`| POST | **Telemetry.** External agents push snapshots to the Twin. | `engine.update_entity_state()` |

---

## 🏥 Health & Observability

Endpoints designed for Docker healthchecks, monitoring, and system integrity audits.

| Endpoint | Method | Description | Primary Logic / Source |
|---|---|---|---|
| `/health/live` | GET | **Liveness.** Confirms the FastAPI process is running. | Static response |
| `/health/ready`| ANY | **Readiness.** Probes all 8 domain DBs and engine status. | `G04_startup_probe.py` |
| `/health/domain/{name}` | GET | **Domain Health.** Check connectivity for a specific database. | `engine.check_db(name)` |
| `/system_health`| ANY | **Ops Monitor.** 24h script success report and reliability score. | `engine.get_system_reliability()` |
| `/system/activity`| GET | **Activity Log.** Detailed stream of recent script executions. | `system_activity_log` table |
| `/system/gaps` | GET | **Integrity Audit.** Scans for missing docs or failing syncs. | `engine.detect_system_gaps()` |
| `/tools/health`| GET | **Manifest Audit.** Verifies existence and syntax of all tools. | `registry.get_tools()` |
| `/cache/status` | GET | **Cache Audit.** Check age and status of the Uber-Context cache. | `digital_twin_updates` table |
| `/cache/refresh`| ANY | **Cache Control.** Force refresh of the Uber-Context (/all). | `G04_context_cache_manager.py` |
| `/audit` | ANY | **Governance.** Documentation integrity and compliance check. | `G12_documentation_audit.py` |

---

## 🧭 Intelligence & Planning Endpoints

| Endpoint | Method | Description | Primary Logic / Source |
|---|---|---|---|
| `/chat` | POST | **Terminal.** Handles NL and Slash commands. | `AgentZero.ask()` |
| `/ask` | POST | **Agent Bridge.** Alias for /chat used by n8n tools. | `AgentZero.ask()` |
| `/search` | ANY | **Hybrid Search.** Keyword (Grep) + Semantic (Qdrant) retrieval. | `engine.search_docs()` |
| `/all` | ANY | **Uber-Context.** Full state for LLM reasoning. | `engine.get_full_context()` |
| `/status` | ANY | **The Glance.** Current Health, Finance, and Focus summary. | `engine.generate_summary()` |
| `/readiness` | ANY | **Unified Readiness.** Biological + Operational + Financial score. | `engine.get_readiness_score()` |
| `/suggested` | ANY | **Director's Report.** Insights, suggested schedule, missions. | `engine.generate_suggested_report()` |
| `/strategic_audit` | GET | **Truth-First Audit.** Alignment between intent and reality. | `G11_strategic_auditor.py` |
| `/vision` | ANY | **North Star.** Power Goals and Roadmap mission progress. | `G11_vision_monitor.py` |
| `/simulate` | ANY | **Projection.** Predictive Q4 goal completion likelihood. | `G04_life_simulator.py` |
| `/memory` | ANY | **Strategic Archive.** Last 20 advice items and decisions. | `engine.get_memory_status()` |
| `/memory/operation`| POST | **Operational Memory.** Store lessons learned/patterns. | `engine.record_operational_memory()` |
| `/reflection` | GET | **Stoic Coach.** Fetch today's personalized questions. | `G10_reflection_generator.py` |
| `/reflection/submit`| POST | **Injection.** Process and store reflection answers. | `G10_evening_summarizer.py` |

---

## 💸 Finance & Wealth Intelligence

| Endpoint | Method | Description | Primary Logic / Source |
|---|---|---|---|
| `/finance` | ANY | **Wealth Status.** Active budget alerts and breach count. | `engine.get_finance_status()` |
| `/finance/details`| ANY | **Deep Dive.** Monthly P&L with **Person-Specific** filtering. | `engine.get_finance_details()` |
| `/finance/alerts` | GET | **Alert Monitor.** Clean list of active breaches for n8n. | `engine.get_finance_alerts()` |
| `/finance/forecast`| GET | **Cashflow.** Runway and burn-rate projections. | `engine.generate_finance_forecast()` |
| `/forecast` | ANY | **Predictive Metrics.** Body Fat / Weight / Finance projections. | `G04_trend_forecaster.py` |

---

## 🧬 Health & Biological Context

| Endpoint | Method | Description | Primary Logic / Source |
|---|---|---|---|
| `/health` | ANY | **Bio-Vitals.** Sleep, HRV, Steps, and Readiness summary. | `engine.get_health_status()` |
| `/health/history`| ANY | **Historical Vitals.** Full biometric state for a specific date. | `engine.get_historical_health()` |
| `/health/trend` | ANY | **Trend Analysis.** Multi-period sleep and biometric patterns. | `engine.get_sleep_trend()` |
| `/hydration` | ANY | **Liquid Log.** Today's Water vs. Caffeine balance. | `AgentZero.get_water_total()` |
| `/personal` | ANY | **Identity.** CV, Health Baselines, and Personal Identity context. | `engine.get_personal_status()` |
| `/workout` | ANY | **Physical.** Recent HIT sessions and exercise highlights. | `engine.get_workout_detail()` |
| `/workout/stats` | ANY | **Progression.** Aggregate training metrics (1-10 year view). | `engine.get_workout_stats()` |
| `/best_day` | ANY | **Peak Optimization.** Peak day performance correlation analysis. | `engine.get_best_day_insight()` |

---

## 🛒 Logistics & Smart Home

| Endpoint | Method | Description | Primary Logic / Source |
|---|---|---|---|
| `/pantry` | ANY | **Inventory.** Low stock alerts and expiring items. | `engine.get_pantry_status()` |
| `/pantry/inventory`| ANY | **Full Stock.** Complete dump of all pantry items and locations. | `engine.get_pantry_details()` |
| `/pantry/suggestions`| ANY | **Procurement.** AI-driven shopping recommendations. | `pantry_sync.py` |
| `/shopping_list` | ANY | **Manifest.** Generate the weekly household manifest. | `G03_household_manifest.py` |
| `/shopping/populate_cart`| POST | **Execution.** Push manifest items to Google Tasks. | `G03_cart_aggregator.py` |
| `/logistics_sync`| ANY | **Deadlines.** Sync legal and administrative documents. | `G04_logistics_sync.py` |
| `/home_status` | ANY | **Environment.** Temperature, device health, and occupancy. | `G08_home_monitor.py` |
| `/home_security`| ANY | **Protection.** Perimeter alarm and camera status. | `G08_home_monitor.py` |
| `/home_lights` | ANY | **Lighting.** List of active illumination and status. | `G08_home_monitor.py` |

---

## ⚙️ Operations & Tool Framework

| Endpoint | Method | Description | Primary Logic / Source |
|---|---|---|---|
| `/sync` | ANY | **Global Sync.** Triggers asynchronous execution of all domains. | `G11_global_sync.py` |
| `/health_sync` | ANY | **Bio-Extract.** Force cloud sync for sleep/biometrics. | `G07_zepp_sync.py` |
| `/scale_sync` | ANY | **Weight Sync.** Force Withings API data extraction. | `withings_to_sheets.py` |
| `/substack_sync`| ANY | **Content Sync.** Sync Substack posts to Obsidian. | `G02_substack_sync.py` |
| `/pantry_sync` | ANY | **Stock Sync.** Force pantry inventory update. | `pantry_sync.py` |
| `/tools` | ANY | **Discovery.** List all 144 validated tools. | `registry.get_tools()` |
| `/execute_tool`| POST | **Autonomous Act.** Execute a G-series tool by ID. | `registry.execute_tool()` |
| `/repair` | POST | **Self-Heal.** Execute a specific system repair action. | `G11_self_healing_engine.py` |
| `/harvest` | ANY | **Idea Gen.** Trigger content idea harvesting pipeline. | `G02_content_harvester.py` |
| `/approve/{id}` | ANY | **One-Click Approval.** Direct execution of a pending decision. | `G11_decision_handler.py` |
| `/deny/{id}` | ANY | **One-Click Denial.** Direct rejection of a pending decision. | `G11_decision_handler.py` |

---

## 🖥️ Interfaces
- **Mission Control (`/`):** The primary web interface for the Twin.
- **Dependency Map (`/map`):** Interactive visualization of goal connectivity.
- **Data Map (`/map/data`):** Underlying JSON for the connectivity matrix.
- **Directory (`/help`):** Dynamic directory of all available API commands.

---
*Last Updated: 2026-05-06 - Documentation v7.3 Alignment*
