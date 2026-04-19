---
title: "G11_global_sync.py: System Orchestration"
type: "automation_spec"
status: "active"
automation_id: "G11_global_sync"
goal_id: "goal-g11"
systems: ["S11", "S08"]
owner: "Michal"
updated: "2026-04-18"
---

# G11: Global System Synchronization (v2.0)

## Purpose
Acts as the primary orchestrator for the entire autonomous ecosystem. It ensures all data ingestion, analysis, and enforcement scripts run in the correct sequence to maintain a fresh Digital Twin state while preventing duplicate notifications.

## Triggers
- **When:** Scheduled via Crontab (typically via `G11_obsidian_safe_sync.py`):
    - **Daily:** 06:15, 13:15, 16:15.
- **Manual:** `python3 G11_global_sync.py`
- **Wrapper:** `python3 G11_obsidian_safe_sync.py` (Preferred for file safety).

## Tiered Execution Pipeline
To ensure data integrity and respect system dependencies, the orchestrator utilizes a tiered execution model:

### 1. Data Sync Tiers (Sequential)
Scripts are executed in order of dependency groups:
- **Tier 0 (External Source):** Fetches reality from external APIs (Pantry, Health, Withings, Google Tasks, ActivityWatch, Substack).
- **Tier 1 (Local Analysis):** Processes raw data into domain insights (Finance Categorizer, Training Sync, Inbox Triage, Goal Activity).
- **Tier 2 (Higher Order Logic):** Performs cross-domain correlation and complex analysis (Finance Anomaly, Strength Report, Mission Control, Calendar Enforcer).

### 2. Consumer Phase (De-duplicated)
Scripts that perform final reporting or send Telegram notifications are executed **exactly once** after the sync tiers complete.
- **Persistence Check:** Uses `was_successful_today(script_name)` from `G11_log_system.py` to prevent duplicate notifications.
- **Repeatable Consumers:** Scripts like `DAILY_NOTE` and `SYSTEM_MONITOR` are allowed to run multiple times to keep the dashboard fresh.

## Processing Logic
1. **Health Audit:** Triggers `G11_self_healing_supervisor.run_audit()` before syncing.
2. **Auto-Documentation:** Scans for undocumented scripts via `G12_auto_documenter`.
3. **Tiered Execution:** Runs Tiers 0-2 sequentially, reporting each to the `DomainIsolator`.
4. **Misc Scripts:** Runs any registered scripts not explicitly assigned to a tier.
5. **Freshness Check:** Retries the sync tiers (up to 3 attempts) if data is determined to be stale.
6. **Consumer Execution:** Executes `MORNING_BRIEFING`, `DAILY_NOTE`, etc.
5. **Dashboard Refresh:** Executes `autonomous_daily_manager.py` to update the Obsidian Daily Note.
6. **Logging:** Records success/failure of each script in the `system_activity_log` table.

## Outputs
- **Activity Logs:** Entries in `digital_twin_michal.system_activity_log`.
- **Markdown Report:** Summary of all sync operations.
- **De-duplicated Notifications:** Telegram messages sent exactly once per day.

## Error Handling
| Failure Scenario | Detection | Response | Alert |
|---|---|---|---|
| Notification Duplicate | `was_successful_today` returns True | Skip execution, print "already succeeded". |
| Data Still Stale | Max retries reached | Proceed with partial data, log warning. |
| DB Offline | Connection error | Skip DB-dependent checks, fall back to simple loop. |

---
*Related Documentation:*
- [G11_log_system.md](G11_log_system.md)
- [G04_morning_briefing_sender.md](G04_morning_briefing_sender.md)
