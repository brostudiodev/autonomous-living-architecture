---
title: "Autonomous Living - Master Changelog"
type: "changelog"
status: "active"
updated: "2026-03-13"
---

# Changelog

All notable changes to the Autonomous Living system are documented here.
Format: [Keep a Changelog](https://keepachangelog.com/en/1.0.0/)

---

## [2026.Q2.Sprint3] - 2026-04-19

### Added - Predictive Life Simulation (G04)
- **6-Month Outcome Simulator:** Launched `G04_life_simulator.py`. Aggregates cross-domain trends (Health, Finance, Brand, Productivity) to project life status 180 days from today using linear regression on a 90-day rolling baseline.
- **Tool Registration:** Registered `life_simulator` in `G04_tool_manifest.json` with support for Markdown and JSON outputs.

### Changed - G11 Meta-System Hardening
- **Documentation Standard Enforcement:** Upgraded `G11_script_health.py` and `G11_friction_discovery.py` documentation from draft to active, codifying actual logic, dependencies, and failure modes.
- **Predictive Failure Documentation:** Verified and synchronized `G11_failure_predictor.md` with current heuristic logic.

### Fixed - Finance Intelligence Data Source
- **Cashflow Query Realignment:** Corrected the data source for financial projections in the simulator to use `v_daily_cashflow` instead of the non-existent `daily_budget_tracking` table.

---

## [2026.Q2.Sprint3] - 2026-04-17

### Added - Dynamic Reality & Social Autonomy (G09/G10/G11)
- **Focus Reality Analyzer:** Launched `G10_focus_analyzer.py` to automate the daily "Reality Audit". Calculates a daily Focus Score by correlating ActivityWatch telemetry.
- **Relationship Harvester:** Deployed `G09_relationship_harvester.py` to autonomously update social contact dates by correlating Google Calendar events with the relationships database.
- **Friction-to-Fix Pipeline:** Established `digital_friction_log` table and `/ouch` API command for instant logging of system bottlenecks via Telegram.
- **Supplement Orchestrator:** Launched `G07_supplement_orchestrator.py` to automatically push recovery supplement tasks to Google Tasks based on biological readiness.

### Fixed - Digital Twin Architectural Integrity (G04)
- **Race Condition Fix:** Refactored `DigitalTwinEngine` in `G04_digital_twin_engine.py` to be stateless regarding `target_date`. Removed `self.target_date` and moved it to explicit method arguments to prevent data duplication in concurrent API requests.
- **API Realignment:** Removed local LLM dependencies from `G04_digital_twin_api.py` for date extraction, aligning with the "n8n as the Brain" mandate.
- **Historical Data Retrieval:** Fixed `health_history_ep` and `/health/history` to correctly honor the `target_date` parameter.
- **Trend Discovery:** Added `/sleep/trend` endpoint for raw 30-day biometric data access for n8n.

### Changed - System Monitoring
- **Self-Healing Transparency:** Upgraded `G11_self_healing_logic.py` to log its own status to `system_activity_log`.

---

## [2026.Q2.Sprint2] - 2026-04-16

### Added - G11 Reliability Blocking
- **Freshness-Aware Sync:** Implemented retry logic in `G11_global_sync.py` that explicitly waits for fresh Zepp biometric data before allowing `DAILY_NOTE` and `MORNING_BRIEFING` execution.
- **Self-Healing Blacklist:** Added capability to `G11_self_healing_logic.py` to blacklist scripts migrated to n8n, preventing infinite retry loops for archived code.

### Changed - n8n Migration (G10/G11)
- **Orchestration Shift:** Migrated `Schedule Negotiator` and `Friction Resolver` from standalone Python scripts to managed n8n workflows (`WF010`, `WF011`) for better error handling and LLM observability.
- **Archival:** Moved legacy scripts to `scripts/archive/` and updated `G04_tool_manifest.json`.

### Changed - Digital Twin Experience (G04)
- **Briefing Noise Filter:** Modified `G04_digital_twin_engine.py` to filter out "Audit" tasks from roadmap missions, keeping the Morning Briefing tactical and concise.
- **Inbox Transparency:** Upgraded `G11_inbox_processor_pro.py` to tag low-confidence items with specific metadata for manual review instead of skipping them.

### Fixed - System Integrity
- **API Conflict Resolution:** Fixed a critical endpoint clash in `G04_digital_twin_api.py` (duplicate `/status` definition) and increased health check timeouts to 5s in `G11_meta_mapper.py`.
- **Path Standardization:** Corrected `PRICE_SCOUTER` references to use `G03_price_scouter_v2.py` across the entire ecosystem (sync, manager, self-healing).
- **Data Fallback Fix:** Disabled silent yesterday-data fallback in `DigitalTwinEngine` biometrics queries to ensure freshness audits accurately reflect reality.

### Documentation
- Created: `P05_April-Reliability-Hardening.md`.
- Updated: `Roadmap.md` (G03, G04, G10, G11), `Progress-monitor.md`, `Changelog.md`.

---

## [2026.Q2.Sprint1] - 2026-03-31

### Added - G10 Mood & Energy Engine
- **Automated Intelligence Suggestions:** Deployed `G10_mood_engine.py` to calculate suggested energy (1-5) and mood based on biometrics, budget alerts, and pantry status.
- **Sync Integration:** Integrated Mood Engine into `G11_global_sync.py` for zero-touch daily note preparation.
- **System Documentation:** Created `Mood-Engine.md` documenting the autonomous intelligence logic and failure modes.

### Added - G10 Calendar Automation
- **Recurring Event Support:** Added `create_recurring_event` to `G10_calendar_client.py` and a new `/recurring` command to the Digital Twin API for rapid schedule management.

### Changed - G01 Dynamic Progression
- **Readiness-Based Training:** Upgraded `G01_training_planner.py` to provide specific weight and TUT (Time Under Tension) adjustment suggestions based on high/low readiness scores.

### Fixed - Digital Twin Integrity
- **Daily Manager Bug:** Fixed a critical regex bug in `autonomous_daily_manager.py` where mood data was incorrectly overwriting the energy field in Obsidian frontmatter.
- **API Resilience:** Addressed "Internal Server Error" by identifying and resolving port conflicts and permission issues in `G04_digital_twin_api.py`.
- **Timeout Prevention:** Implemented FastAPI `BackgroundTasks` for `/approve` and `/query` operations. Approved actions now execute in the background, preventing n8n/Telegram timeouts (10s limit) for slow integrations like Google Sheets/Tasks.

### Documentation
- Created: `Mood-Engine.md`.
- Updated: `Roadmap.md` (G01, G04, G10), `Changelog.md`.

---

## [2026.Q1.Sprint5] - 2026-03-16

### Added - G11 Interactive Decision Authority
- **Interactive Telegram Bot:** Deployed `G04_telegram_bot.py` as a persistent listener for "Approve/Deny" callbacks, closing the loop on autonomous actions.
- **Proactive Approval Prompter:** Created `G11_approval_prompter.py` to notify the user via Telegram when human intervention is required (e.g., household procurement).
- **Expanded Execution Library:** Enhanced `G11_decision_handler.py` to handle automated Google Task creation for shopping and health pivots, and financial re-categorization.

### Changed - Daily Note Interface (G04/G12)
- **Interface Spec Establishment:** Created `Daily-Note-Interface-Spec.md` as the definitive source of truth for the Obsidian Daily Note structure and surgical markers.
- **Marker Resilience:** Upgraded `autonomous_daily_manager.py` with `inject_marker` safety logic to prevent file truncation and corruption.
- **Briefing Relocation:** Repositioned "Digital Twin Briefing" and "Autonomous Decisions" to the bottom of the Daily Note for better readability, as per user preference.
- **Data Completeness:** Restored missing sections (Google Tasks, Director's Summary, Tomorrow's Intelligence) to the Daily Note template and manager script.

### Fixed - Daily Note Integrity
- **Multi-line Injection:** Fixed `run_cmd` in `autonomous_daily_manager.py` to capture multi-line outputs (e.g., Suggested Schedule) instead of just the last line.
- **Marker Persistence:** Re-inserted `%%PENDING%%` and `%%DECISIONS%%` markers into the daily note template to ensure system judgments are always visible.

### Documentation
- Created: `Daily-Note-Interface-Spec.md`, `G04_telegram_bot.md`, `G11_approval_prompter.md`.
- Updated: `G11_decision_handler.md`, `autonomous_daily_manager.md`, `G04_digital_twin_notifier.md`.

### Metrics
- **Interactivity:** Reduced decision latency from "Daily Note Review" to "Instant Telegram Approval."
- **Robustness:** 100% protection against daily note data truncation via new injection logic.

---

## [2026.Q1.Sprint5] - 2026-03-13

### Added - G11 Meta-System (Stability & Integrity)
- **Pre-Flight Sync Audit:** Implemented `G11_pre_flight_check.py` to verify Zepp and Withings data freshness before allowing Daily Note generation.
- **Automated Morning Briefing:** Scheduled `G04_morning_briefing_sender.py` for 06:15 AM weekdays to provide Telegram-based mission briefings.

### Added - G03 Price Intelligence & Safety
- **Lidl/Biedronka Promo Seeding:** Manually seeded `pantry_prices` with mid-March 2026 promo data, enabling 100% accurate "Cheapest Basket" calculation.
- **Medication Expiry Guard:** Migrated critical medications (Ibuprom, Ventolin, Tamalis) to `pantry_inventory` with 30-day proactive alerting.

### Added - G10 Productivity Architecture
- **Contextual Task Injection:** Enhanced `G10_schedule_optimizer.py` to pull specific tasks from Google Tasks (e.g., #deep, #admin) into optimized time blocks based on biological readiness.

### Changed - Daily Note Experience
- **Surgical Marker Cleanup:** Modified `autonomous_daily_manager.py` to automatically strip `%%` injection markers after the first fill, resulting in 100% clean Obsidian notes.
- **Global Sync Refactor:** Integrated all 2026-Q1 critical syncs into `G11_global_sync.py` with 3x retry logic and error logging.

### Fixed - System Reliability
- **Morning Briefing ImportError:** Fixed non-existent `generate_insights` and `generate_schedule` imports in `G04_digital_twin_engine.py`.
- **Calendar Enforcer ImportError:** Fixed dependency on `autonomous_daily_manager` by switching to `G10_schedule_optimizer`.
- **Digital Twin Monitor Permissions:** Resolved `PermissionError` by moving state files from `root`-owned `_meta` to `michal`-owned `daily-logs`.
- **Meeting Briefing KeyError:** Fixed `start` vs `start_raw` key mismatch and timezone comparison issues in `G10_meeting_briefing.py`.

### Metrics
- **Time Savings:** ~15 minutes/day (automated price comparison + automated task triaging).
- **Data Freshness:** 100% for March 13th (Biometrics, Weight, Tasks).

---

## [2026.Q1.Sprint4] - 2026-02-28

### Added - G03 Predictive Pantry (v1.1)
- **Real-time PostgreSQL Integration:** Refactored `g03_predictive_pantry_simple.py` to use actual DB inventory instead of mock data.
- **Consumption Analysis:** Implemented basic weekly consumption rates for automated restocking predictions.

### Added - G07 Health Management
- **Automated Weight Sync:** Created `G07_weight_sync.py` to pull body composition data from Withings API directly to PostgreSQL.
- **Biometric Dashboards:** Integrated live weight and body fat metrics into Obsidian daily notes.

### Added - G10 Productivity Architecture
- **Director's Summary:** Enhanced `G10_evening_summarizer.py` to auto-generate daily performance reports (Health, Finance, Logistics).
- **Automated Prep:** Added evening checklist injection for next-day foundation readiness.

### Fixed - Repository Integrity
- **Link Audit:** Fixed ~170 broken links and case-sensitivity issues across 333+ documentation files.
- **Mermaid Stability:** Fixed rendering errors in High-Level Design Gantt charts for GitHub compatibility.
- **Pronoun Migration:** Converted all documentation from "we/our" to "I/my" to reflect single-person ownership.

---

## [2026.Q1.Sprint2] - 2026-01-15

### Added - G03 Autonomous Household Operations
- **Pantry Management System v1.0** - AI-powered inventory tracking
  - Multi-channel interface (Telegram, n8n chat, webhook)
  - Natural language processing with Google Gemini
  - Google Sheets backend (Spizarka + Slownik tables)
  - Automated category creation and synonym resolution
  - **Time Investment:** 11 hours total
  - **Documentation:** [Complete specs](docs/10_Goals/G03_Autonomous-Household-Operations/README.md)
  - **Automation:** [WF105 workflow](docs/50_Automations/n8n/workflows/WF105__pantry-management.md)

### Technical Achievements
- First AI-native household automation deployed
- ReAct pattern implementation (get → calculate → update)
- Multi-trigger n8n workflow (25 nodes, 6 Google Sheets tools)
- Polish data schema with English documentation strategy

### Metrics Established
- Manual inventory time reduced: 15min/day → 3min/day (80% reduction)
- AI interpretation accuracy: ~90% (baseline for improvement)
- System response time: 2.1s average (within <3s target)

### Known Issues
- Google Sheets API quota concerns with high-frequency usage
- Synonym coverage needs refinement for edge cases
- No offline fallback mode yet

---

## [2026.Q1.Sprint1] - 2026-01-12

### Added - Foundation
- Repository structure (PARA-inspired)
- All 12 goal documentation templates
- Adr-0001: Repository structure decision
- Basic automation standards and templates

---

## Template for Future Entries

## [YYYY.Q#.Sprint#] - YYYY-MM-DD

### Added
- New systems, features, automations

### Changed
- Modifications to existing systems

### Fixed
- Bug fixes and optimizations

### Metrics
- Performance improvements
- Time savings achieved

### Time Investment
- Development: X hours
- Documentation: Y hours
- Testing: Z hours
