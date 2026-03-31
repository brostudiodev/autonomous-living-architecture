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
