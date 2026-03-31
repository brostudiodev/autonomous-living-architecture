---
title: "Daily Note Markers Specification"
type: "specification"
status: "active"
owner: "Michal"
updated: "2026-03-18"
---

# 📍 Daily Note Markers Specification

This document defines the definitive list of surgical injection markers used by `autonomous_daily_manager.py` and other G-series scripts to maintain the Obsidian Daily Note.

## 🏗️ Architecture
Markers follow the format: `%%MARKER_NAME_START%%` and `%%MARKER_NAME_END%%`. 
If a marker is missing from the Daily Note, the system will skip that injection to prevent data corruption.

## 📋 Active Markers

| Marker ID | Source Script | Description |
|-----------|---------------|-------------|
| **MISSION** | `G12_context_resumer.py` | Top-level executive directive (plain text). |
| **QUICK_WINS** | `G11_quick_wins.py` | **[NEW]** Fast execution tasks for the morning. |
| **CONN** | `G11_meta_mapper.py` | System connectivity status (API, Docs, Sync). |
| **G07** | `G07_health_recovery_pro.py` | Biological recovery trends and HRV insights. |
| **INSIGHTS** | `G04_digital_twin_engine.py` | Rich AI-generated cross-domain insights. |
| **G01** | `G01_progress_analyzer.py` | Body composition and weight trends (7-day). |
| **FIN_ANOMALY** | `G05_finance_anomaly_detector.py` | Alerts for non-recurring spending risks. |
| **FIN_FRICTION** | `G05_budget_friction_predictor.py` | Monthly burn rate and budget breach forecasts. |
| **REBALANCE** | `G05_budget_rebalancer.py` | Autonomous budget reallocation suggestions. |
| **RICH_MISSION** | `G12_context_resumer.py` | Detailed goal missions and context links. |
| **MEMORY** | `G10_ai_memory_generator.py` | **[NEW]** Auto-generated 'One thing to remember'. |
| **TASKS** | `G10_google_tasks_sync.py` | Synced tasks from Google Tasks API. |
| **SCHEDULE** | `G10_schedule_optimizer.py` | AI-generated daily time-block schedule. |
| **FOCUS** | `G10_focus_intelligence.py` | **[NEW]** Focus readiness and environment audit. |
| **AI_PRIORITIES** | `autonomous_daily_manager.py` | **[NEW]** Top 4 data-driven priorities including Chef's Choice. |
| **TRAINING_DETAILS** | `G01_training_planner.py` | Combined biometric-aware training plan + Overload analysis. |
| BRIEFING | `G04_digital_twin_engine.py` | Unified system status line for the header (Directive). |
| CONTENT | `G02_content_performance.py` | **[NEW]** Substack and LinkedIn audience metrics. |
| VELOCITY | `G10_productivity_roi_reporter.py` | **[NEW]** Productivity ROI and system efficiency analysis. |
| STUDY_VELOCITY | `G06_study_velocity.py` | **[NEW]** Learning speed and target date tracking. |
| APPLIANCE | `G03_appliance_monitor.py` | **[NEW]** Dishwasher and Washing Machine cycle tracking. |

| **ENVIRONMENT** | `G08_environment_advisor.py` | **[NEW]** Circadian lighting and climate recommendations. |
| **SYSTEM_REPORT** | `autonomous_daily_manager.py` | Detailed success/failure report for all G-series scripts. |
| **PENDING** | `G11_rules_engine.py` | Human approval requests for autonomous actions. |
| **DECISIONS** | `G11_rules_engine.py` | Log of recent autonomous policy decisions. |
| **AI_JOURNAL_SUGGESTIONS** | `autonomous_daily_manager.py` | **[NEW]** Data-driven prompts for manual journaling. |
| **REFLECTION** | `G10_evening_summarizer.py` | Evening summary of metrics and logistics. |
| **ROADMAP** | `G10_evening_summarizer.py` | Top 3 roadmap missions for tomorrow. |
| **FOUNDATION** | `G10_foundation_checker.py` | **[NEW]** Tomorrow's prep status (clothes, lunch, etc.). |
| **JOURNAL** | `G10_evening_summarizer.py` | Contextual data for AI journaling. |
| **PATTERN** | `G10_evening_summarizer.py` | AI-detected behavioral or data patterns. |
| **GHOST** | `G04_ghost_schema_reporter.py` | **[NEW]** Prediction accuracy tracking and self-calibration. |
| **GOAL_PROGRESS** | `G11_mission_refractor.py` | **[NEW]** Automated progress tracking for all 12 goals. |
| **G05_LOOP** | `G05_finance_learner.py` | Financial corrections and budget learning loops. |

## 🛠️ Maintenance
- **Adding Markers:** Add the marker to `Daily Note Template.md` first, then update the injection logic in `autonomous_daily_manager.py`.
- **Sync Issues:** Always ensure markers are on their own lines or clearly delimited to prevent regex mismatching.
- **Verification:** Use `fill-daily.sh --force` to test marker integrity after template changes.

---
*Created during Q1 cleanup to resolve "Strategic Stall" and missing section issues.*
