---
title: "System Integration & Sync Orchestration"
type: "technical_specification"
status: "active"
system_id: "system-orchestration"
owner: "Michał"
updated: "2026-04-16"
---

# System Integration & Sync Orchestration

## Overview
This document describes the high-level orchestration of the Autonomous Living ecosystem. It details how diverse data sources (Health, Finance, Pantry, Tasks) are synchronized, processed by the Digital Twin, and delivered to the user via Obsidian and Telegram.

## The Global Heartbeat (`G11_global_sync.py`)
The system follows a sequential, retry-aware "Heartbeat" pattern to ensure data consistency and freshness.

### 1. Data Ingestion & Sync Loop (Retry Phase)
The system attempts to synchronize all data sources in a loop (up to 3 times, with 10-minute intervals) to ensure biometrics and other cloud data are fresh before proceeding.
- **ActivityWatch (`G10_activitywatch_sync.py`):** Pulls passive app/window usage from aw-server to PostgreSQL.
- **Pantry (`pantry_sync.py`):** Pulls inventory and dictionary from Google Sheets to PostgreSQL.
- **Training (`training_sync.py`):** Pulls workout logs and templates from CSV/Google Sheets.
- **Health (`G07_zepp_sync.py`):** Authenticates with Zepp Cloud and pulls Sleep/HRV/Steps.
- **Finance (`G05_finance_sync.py`):** Triggers n8n workflows (WF109/WF110) to pull bank records from Google Sheets.
- **Learning (`G06_learning_sync.py`):** Updates study progress for certifications.
- **Freshness Check:** After each loop iteration, the system calls `check_data_freshness()`. If biometrics are fresh, it breaks the loop early.

### 2. Analysis & Synthesis Phase
- **Digital Twin (`G04_digital_twin_engine.py`):** Aggregates all DB data into a unified `state` object.
- **Attention Analytics:** Calculates deep work vs. distraction ratios from ActivityWatch telemetry.
- **Mission Refractor (`G11_mission_refractor.py`):** Scans Git commits and Roadmaps to draft "Did/Next" logs.
- **CEO Report (`G11_ceo_status_report.py`):** Evaluates roadmap health and activity freshness.

### 3. Agentic Decision & Self-Calibration Phase
- **Rules Engine (`G11_rules_engine.py`):** Evaluates system suggestions against `autonomy_policies.yaml`. 
    - If `AUTO_ACT`: Executes immediately via `G11_decision_handler.py`.
    - If `ASK_HUMAN`: Triggers `G11_approval_prompter.py` to send interactive Telegram buttons.
- **Ghost Schema (`G04_ghost_schema_reporter.py`):** Compares historical predictions against actual outcomes to calculate system accuracy.
- **Self-Calibration:** If accuracy is below threshold, the Ghost Reporter automatically tightens policy constraints in `autonomy_policies.yaml`.

### 4. Delivery Phase
- **Daily Manager (`autonomous_daily_manager.py`):**
    - Executed only after the sync loop completes.
    - Injects data into the Obsidian Daily Note (Sleep, Connectivity, Insights, Missions, Tasks, Focus, Productivity Analytics).
    - Ensures YAML integrity (quotes time-based strings).
    - Updates `Daily Autonomous Tasks.md` for mobile assistant.
    - Commits and Pushes changes to the Second Brain Git repository.
- **Notification (`G04_morning_briefing_sender.py`):** Dispatches the high-density Mission Briefing to Telegram.

## Synchronization Triggers
| Trigger | Method | Frequency |
|---|---|---|
| **Scheduled** | Crontab on GMKtek-G3 | Every 6-12 hours |
| **Manual (Full)** | `python3 scripts/G11_global_sync.py` | As needed |
| **API** | `GET /sync` on Digital Twin API | Triggered by n8n or Mobile |
| **Mobile** | Telegram Command "/sync" | User-initiated |

## Daily Note & History Persistence
The system uses a **Static Snapshot** model for historical consistency:
1. **Daily Note:** At each sync, the `autonomous_daily_manager.py` injects the current system state, missions, and tasks directly into the daily note as static Markdown text. This ensures that when viewing old notes, you see the tasks as they were *on that day*, not the current state.
2. **Mobile Assistant:** A standalone `Daily Autonomous Tasks.md` is maintained at the vault root for real-time access via the mobile `/todos` API endpoint.

## Mobile Assistant Integration
The mobile view is powered by:
1. **Source:** `Daily Autonomous Tasks.md` (root of vault).
2. **Components:**
    - **Intelligence Focus:** Dynamic recommendations based on system state.
    - **Google Tasks:** Live sync from Google Tasks API.
    - **Active Missions:** High-priority "Next Steps" from Goal Activity logs.

## Data Integrity Guards
- **Lockfile:** `/tmp/autonomous_daily_manager.lock` prevents race conditions and recursive loops.
- **YAML Repair:** `G11_fix_yaml_integrity.py` automatically corrects sexagesimal integer errors in Obsidian.
- **Path Reliability:** `BASE_DIR` enforcement ensures scripts run correctly regardless of the caller's working directory.
