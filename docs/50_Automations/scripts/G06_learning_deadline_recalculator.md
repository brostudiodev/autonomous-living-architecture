---
title: "Learning Deadline Recalculator (G06)"
type: "automation_spec"
status: "active"
owner: "Michał"
updated: "2026-04-02"
---

# Purpose
The **Learning Deadline Recalculator** (`G06_learning_deadline_recalculator.py`) ensures that certification goals remain mathematically realistic. It autonomously adjusts the `deadline` field in the `career_goals` table based on the user's actual study velocity.

# Scope
- **In Scope:** Active career goals with defined required hours and deadlines.
- **Out Scope:** Non-quantifiable learning goals or goals without deadlines.

# Recalculation Logic
- **Actual Velocity:** Average study hours per day calculated over the **last 14 days** (to provide a stable trend).
- **Realistic Days Remaining:** `(Required Hours - Completed Hours) / Actual Velocity`.
- **New Deadline:** `Current Date + Realistic Days Remaining`.
- **Update Threshold:** The database is updated only if the new deadline differs from the current one by **more than 3 days**, avoiding minor "jitter" from day-to-day fluctuations.

# Inputs/Outputs
- **Inputs:** `career_goals` and `study_sessions` tables from the `autonomous_learning` database.
- **Outputs:** Database updates and a Markdown adjustment report for the Daily Note.

# Dependencies
- **Systems:** S11 (Meta-System), G06 (Certification Exams)
- **Database:** `autonomous_learning`

# Procedure
- Automatically executed by `autonomous_daily_manager.py` during the daily sync.

# Failure Modes
| Scenario | Detection | Response |
|----------|-----------|----------|
| Zero Velocity | `actual_vel = 0` | Script skips calculation (cannot divide by zero). |
| DB Error | psycopg2 exception | Adjustment is skipped; system logs failure. |

# Security Notes
- Read/Write access to the learning database is required.

# Owner + Review Cadence
- **Owner:** Michał
- **Review:** Monthly (verify if recalculated deadlines are driving better adherence)
