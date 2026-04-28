---
title: "G10: Dynamic Morning Rescheduler"
type: "automation_spec"
status: "active"
automation_id: "G10_morning_rescheduler"
goal_id: "goal-g10"
systems: ["S10"]
owner: "Michał"
updated: "2026-04-28"
---

# G10: Dynamic Morning Rescheduler

## Purpose
Automatically realigns the daily schedule at 07:00 AM based on real-time biometric readiness scores. This ensures that high-cognitive "Deep Work" blocks are only scheduled when the body is in a capable state, and promotes recovery or admin tasks when energy is low.

## Triggers
- **CRON:** 07:00 AM daily.
- **Manual:** `python3 G10_morning_rescheduler.py`.

## Inputs
- **Biometrics:** `readiness_score` and `sleep_score` from the `digital_twin_michal` database (via `G04_digital_twin_engine`).
- **Tasks:** Google Tasks with tags like `#deep` or `#roadmap`.

## Processing Logic
1.  **Readiness Check:** Fetches the latest biometrics from Amazfit/Zepp.
2.  **State Determination:** 
    -   `Peak` (>85): Prioritizes Power Goal missions.
    -   `Standard`: Default schedule.
    -   `Recovery` (50-65): Shifts deep work, prioritizes maintenance.
    -   `Critical` (<50): Triggers Minimum Viable Day (MVD) mode.
3.  **Schedule Regeneration:** Calls `G10_schedule_optimizer` to build a new set of time blocks.
4.  **Notification:** Sends a Telegram summary of the realignment and current system state.

## Outputs
- **Digital Twin:** Updates the suggested schedule in the Daily Note.
- **Telegram:** Real-time state alert (e.g., "Recovery Mode Active").

## Dependencies
### Scripts
- [G10 Schedule Optimizer](./G10_schedule_optimizer.md)
- [G04 Digital Twin Engine](./G04_digital_twin_engine.md)
- [G04 Telegram Notifier](./G04_digital_twin_notifier.md)

## Failure Modes
| Scenario | Detection | Response |
|----------|-----------|----------|
| API Timeout | Exception caught | Falls back to standard/last known schedule. |
| Zero Scores | Check for 0 value | Logs warning, assumes 'Standard' state. |
