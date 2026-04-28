---
title: "G11 CEO Time Reallocator"
type: "automation"
status: "active"
owner: "Michał"
updated: "2026-04-28"
---

# G11: CEO Time Reallocator

## Purpose
Autonomously monitors strategic alignment by comparing actual time spent (via ActivityWatch telemetry) against Roadmap requirements. Suggests pivots to prevent goal stalling.

## Scope
- **In Scope:** ActivityWatch data processing, G01-G12 keyword mapping, strategic advice generation.
- **Out Scope:** Direct calendar rescheduling (output is informational for the CEO).

## Inputs/Outputs
- **Inputs:** `activity_watch_events` table, `G06_study_velocity` alerts.
- **Outputs:** Markdown report with reallocation advice.

## Dependencies
- **Systems:** ActivityWatch, PostgreSQL.
- **Scripts:** `G10_activitywatch_sync.py`, `G06_study_velocity.py`.

## Procedure

### Running the Reallocator
1. **Command:** `python3 scripts/G11_time_reallocator.py`
2. **Review:** Check the generated Markdown for alignment alerts.

## Failure Modes
| Scenario | Detection | Response |
|----------|-----------|----------|
| AW Sync failure | Report shows 0h for all goals | Ensure `G10_activitywatch_sync.py` is running |
| Keywords missing | Time logged as "Unknown" | Update `GOAL_MAPPING` in script |

## Security Notes
- Processes window titles. Ensure sensitive windows (e.g., password managers) are excluded in `aw-watcher-window` configuration.

## Owner + Review Cadence
- **Owner:** Michał
- **Review:** Monthly.
