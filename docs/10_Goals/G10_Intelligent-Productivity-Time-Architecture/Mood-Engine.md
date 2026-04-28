---
title: "G10: Mood & Energy Engine"
type: "system_documentation"
status: "active"
owner: "Michał"
updated: "2026-03-31"
goal_id: "goal-g10"
---

# Mood & Energy Engine

## Purpose
The Mood & Energy Engine autonomously calculates and suggests daily intelligence markers (mood and energy levels) based on objective biometric and financial data. This eliminates the need for manual logging when states are predictable.

## Scope
- **In Scope:** Biometric-based energy (1-5), finance/logistics-based mood suggestions, integration with Obsidian daily notes.
- **Out Scope:** Manual emotional journaling, clinical psychological assessment.

## Inputs/Outputs
- **Inputs:**
  - `autonomous_health.biometrics`: Readiness score, sleep score, HRV.
  - `autonomous_finance`: Active budget alerts.
  - `autonomous_pantry`: Low stock counts.
- **Outputs:**
  - `digital_twin_michal.daily_intelligence`: Energy (int), Mood (string), is_automated (boolean).
  - Obsidian Frontmatter: `energy:` and `mood:` fields.

## Dependencies
- **Systems:** Digital Twin Engine (G04), Rules Engine (G11).
- **Database:** PostgreSQL (`digital_twin_michal`, `autonomous_health`, `autonomous_finance`).

## Procedure
- **Daily Execution:** Automatically triggered by `G11_global_sync.py` at 06:00.
- **Manual Trigger:** `python3 scripts/G10_mood_engine.py`

## Failure Modes
| Scenario | Detection | Response |
|----------|-----------|----------|
| Missing Biometrics | Script logs "readiness_score" as 0 | Default to "normal" (3) energy and "ok" mood. |
| Database Connection Fail | ConnectionError in logs | Log failure to G11 activity log; skip update. |
| Manual Override Exists | `is_automated` is FALSE in DB | Do not overwrite manual data. |

## Security Notes
- Personal health and financial data used for calculation are kept within the local PostgreSQL environment.

## Owner + Review Cadence
- **Owner:** Michał
- **Review Cadence:** Quarterly (with G10 roadmap review).
