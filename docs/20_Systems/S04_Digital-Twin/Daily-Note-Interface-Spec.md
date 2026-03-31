---
title: "Interface Spec: Obsidian Daily Note"
type: "interface_spec"
status: "active"
owner: "Michal"
updated: "2026-03-30"
---

# 📝 Interface Spec: Obsidian Daily Note

## 🎯 Purpose
The **Obsidian Daily Note** is the primary human interface for the Autonomous Living Ecosystem. It serves as the Command Center where decisions are approved, biometrics are visualized, and daily reflections are stored.

## 🏗️ Structural Integrity (Markers)
The `autonomous_daily_manager.py` uses **Surgical Markers** (`%%TAG_START%%` and `%%TAG_END%%`) to inject data. 

### ⚠️ CRITICAL RULE for AI Engineers
**DO NOT remove or rename these markers.** Removing them causes data loss and breaks the automation flow. If a section is missing from the rendered note, check if the marker exists in the file first.

## 🔐 Data Integrity (YAML Safety)
To prevent sexagesimal (Base-60) parsing errors in YAML (where `23:05` might be interpreted as a number `1385`), the following rules apply:

1.  **Time Quoting:** All time-based strings (e.g., `sleep_start`, `sleep_end`, `workout_time`) **MUST** be wrapped in double quotes (e.g., `sleep_start: "22:00"`).
2.  **String Enforcement:** Any field that could be misinterpreted as a number or boolean by a standard YAML parser must be explicitly quoted.
3.  **Automation Compliance:** The `autonomous_daily_manager.py` script is the primary enforcer of this rule during frontmatter restoration.

## 📋 Required Sections & Content Map
This table defines exactly what must be in the Daily Note.

| Marker | Section Title | Source Script | Expected Content |
| :--- | :--- | :--- | :--- |
| `MISSION` | # 2026 | `G12_context_resumer.py` | A 1-sentence primary directive (CEO focus). |
| `QUICK_WINS` | Quick Wins | `G11_quick_wins.py` | Low-hanging fruit tasks for immediate execution. |
| `CONN` | System Connectivity | `G11_meta_mapper.py` | Status of Digital Twin API, Scripts, and Decisions. |
| `G07` | Daily Health Report | `G07_health_recovery_pro.py` | Biometric readiness and recovery insight. |
| `INSIGHTS` | Director's Insights | `G04_digital_twin_engine.py` | Cross-domain intelligence (Finance alerts, patterns). |
| `G01` | Body Comp Analysis | `G01_progress_analyzer.py` | 7-day average body fat trends. |
| `FIN_ANOMALY` | Financial Anomaly Alert | `G05_finance_anomaly_detector.py` | Unusual spending patterns in last 7d. |
| `FIN_FRICTION` | Financial Friction Forecast | `G05_budget_friction_predictor.py` | Predicted budget breaches by end of month. |
| `REBALANCE` | Budget Rebalancing | `G05_budget_rebalancer.py` | Autonomous surplus-to-deficit transfers. |
| `MEETINGS` | Meeting Intelligence | `G10_meeting_briefing.py` | Briefings for upcoming calendar events. |
| `TASKS` | Google Tasks Sync | `G10_task_sync.py` | Google Tasks integration. |
| `SCHEDULE` | Suggested Schedule | `G10_schedule_optimizer.py` | Bio-optimized time blocks. |
| `FOCUS` | Focus Mode Intelligence | `G10_focus_intelligence.py` | Office environment and cognitive readiness. |
| `MANUAL_TASKS` | Tasks (manual planning) | N/A (User) | Manual task entry block. |
| `AI_PRIORITIES` | AI Suggested Priorities | `autonomous_daily_manager.py` | Top 5 recommended tasks. |
| `G03` | After Work - Overview | `G03_meal_planner.py` | Chef's Choice and Price Intelligence. |
| `LIQUIDITY` | Friction & Liquidity | `G05_liquidity_rebalancer.py` | Cash flow and account liquidity status. |
| `G05_LOOP` | Financial Corrections | `G05_llm_categorizer.py` | Feedback loop for transaction categorization. |
| `TRAINING_DETAILS` | Health & Training | `G01_training_planner.py` | Workout plan and Progressive Overload analysis. |
| `GOAL_PROGRESS` | Goal Progress Tracking | `G12_goal_progress_orchestrator.py` | Automated summary of goal activities. |
| `HABITS` | Recurring Maintenance | `autonomous_daily_manager.py` | Habit checklist from database. |
| `BRIEFING` | Digital Twin Briefing | `autonomous_daily_manager.py` | High-level system status string. |
| `PENDING` | Action Required | `G11_decision_handler.py` | Pending human approvals (#approve_NN). |
| `DECISIONS` | Autonomous Decisions | `G11_decision_handler.py` | Audit log of system actions. |
| `AI_JOURNAL_SUGGESTIONS` | AI Journaling Prompts | `autonomous_daily_manager.py` | Context-aware reflection prompts. |
| `REFLECTION` | Director's Summary | `G04_digital_twin_engine.py` | End-of-day reality summary. |
| `ROADMAP` | Top Roadmap Missions | `G04_digital_twin_engine.py` | Active Q1/Q2 goal tracks. |
| `FOUNDATION` | Foundation First | `G10_foundation_checker.py` | Tomorrow preparation checklist. |
| `JOURNAL` | AI Journaling: Runtime Log | `G10_journal_data_collector.py` | Log of automated decisions and interactions. |
| `PATTERN` | Digital Twin: Pattern Analysis | `G04_digital_twin_engine.py` | Cognitive and behavioral pattern insights. |
| `GHOST` | Ghost Schema Accuracy | `G04_ghost_schema_reporter.py` | Prediction accuracy tracking. |
| `CONTENT` | G02 Audience Growth | `G02_content_performance.py` | Social growth metrics (Substack/LinkedIn). |
| `CONTENT_PIPELINE` | Content Pipeline | `G02_brand_orchestrator.py` | Upcoming content ideas. |
| `VELOCITY` | Productivity & Autonomy ROI | `G10_productivity_roi_reporter.py` | Time reclaimed and system efficiency. |
| `STUDY_VELOCITY` | G06 Study Velocity | `G06_study_velocity.py` | Exam readiness and study progress. |
| `LEARNING_INGEST` | Atomic Learning | `G06_learning_ingester.py` | New concepts captured during the day. |
| `APPLIANCE` | Appliance Maintenance | `G03_appliance_monitor.py` | Dishwasher/Washing machine cycle counts. |
| `HARDWARE` | Host Hardware Vitals | `G08_hardware_monitor.py` | CPU, RAM, and Disk health. |
| `ENVIRONMENT` | Environment Intelligence | `G08_environment_advisor.py` | Home environment optimization advice. |

## 🪵 System Logs & Auditability
The **Subsystem Technical Report** (formerly `%%SYSTEM_REPORT%%`) has been removed from the Daily Note to minimize clutter. However, the system maintains full auditability:
- **Storage:** All script execution results, status codes, and last actions are logged to the `system_activity_log` table in the `digital_twin_michal` database.
- **Access:** To view technical logs, use the Digital Twin CLI or query the database directly.

## 🗺️ Visual Map (Expected Structure)
The sequence is strict:

1.  **YAML Frontmatter**
2.  **# 2026** - `%%MISSION%%`
3.  **Quick Wins** - `%%QUICK_WINS%%`
4.  **System Connectivity** - `%%CONN%%`
5.  **Daily Health Report** - `%%G07%%`
6.  **Director's Insights** - `%%INSIGHTS%%`
7.  **Body Composition Analysis** - `%%G01%%`
8.  **Financial Anomaly Alert** - `%%FIN_ANOMALY%%`
9.  **Financial Friction Forecast** - `%%FIN_FRICTION%%`
10. Budget Rebalancing Suggestions - `%%REBALANCE%%`
11. Meeting Intelligence - `%%MEETINGS%%`
12. Daily Intelligence Summary (DataView Callouts)

14. **# YYYY-MM-DD – Daily** (Header)
15. **Tasks Section** - `%%TASKS%%`
16. **Schedule Section** - `%%SCHEDULE%%`
17. **Focus Mode Intelligence** - `%%FOCUS%%`
18. **Tasks (manual planning)** - `%%MANUAL_TASKS%%` (incl. `%%AI_PRIORITIES%%`)
19. **After Work - Overview** - `%%G03%%`
20. **Autonomy ROI Section**
21. **After Work – Power Goals**
    - **Manual Header:** ### Choose Today’s Power Goals (max 3)
    - **Automated Summary:** ### Goal Progress Tracking (Automated) - `%%GOAL_PROGRESS%%`
22. **Financial Corrections** - `%%G05_LOOP%%` (incl. `%%LIQUIDITY%%`, `%%FIN_ANOMALY%%`, `%%FIN_FRICTION%%`, `%%REBALANCE%%`)
23. **Health & Training Section** - `%%TRAINING_DETAILS%%` (incl. `%%HABITS%%`)
24. **Digital Twin Briefing Section** - `%%BRIEFING%%`, `%%CONTENT%%`, `%%CONTENT_PIPELINE%%`, `%%VELOCITY%%`, `%%STUDY_VELOCITY%%`, `%%LEARNING_INGEST%%`, `%%APPLIANCE%%`, `%%HARDWARE%%`, `%%ENVIRONMENT%%`
25. **Autonomous Decisions Section** - `%%PENDING%%`, `%%DECISIONS%%`
26. **Reflection Section** - `%%AI_JOURNAL_SUGGESTIONS%%`, `%%REFLECTION%%`, `%%ROADMAP%%`, `%%FOUNDATION%%`, `%%JOURNAL%%`, `%%PATTERN%%`, `%%GHOST%%`

---
## 🤖 Manager Logic (`autonomous_daily_manager.py`)
The manager script performs surgical updates using the markers defined above. It runs in three distinct phases:
1. **Fetch:** Aggregates data from 20+ sources.
2. **Inject:** Replaces content between markers in the active Daily Note.
3. **Commit:** Pushes the updated note to the Second Brain repository via Git.

## 🚀 Manual Trigger Automation (ctrl+shift+G)
The Daily Note supports a manual sync trigger for goal activity logs via `G09_sync_daily_goals.py`.
- **Shortcut:** `ctrl+shift+G`
- **Search Header:** `### Choose Today’s Power Goals (max 3)` OR `### Goal Progress Tracking`

---
*Documentation synchronized with exhaustive structural requirements 2026-03-30.*
