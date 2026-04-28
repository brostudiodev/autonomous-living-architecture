---
title: "Study Velocity Tracker (G06)"
type: "automation_spec"
status: "active"
owner: "Michał"
updated: "2026-04-02"
---

# Purpose
The **Study Velocity Tracker** (`G06_study_velocity.py`) autonomously monitors progress toward certification exams. It ensures that study habits align with exam deadlines by calculating the required daily effort and flagging risks.

# Scope
- **In Scope:** Active career goals with defined deadlines, study sessions from `study_sessions` table.
- **Out Scope:** General learning without specific deadlines.

# Logic
- **Required Velocity:** `(Required Hours - Completed Hours) / Days Until Deadline`.
- **Actual Velocity:** Average hours per day over the **last 7 days**.
- **Risk Threshold:** If `Actual Velocity < Required Velocity`, an alert is generated.

# Inputs/Outputs
- **Inputs:** `autonomous_learning` PostgreSQL database.
- **Outputs:** Markdown report for Daily Note and risk alerts for `G11_mission_aggregator` (Weight 8).

# Dependencies
- **Systems:** S11 (Meta-System), G06 (Certification Exams)
- **Database:** `autonomous_learning`

# Procedure
- Automatically executed as part of the daily sync via `autonomous_daily_manager.py`.

# Failure Modes
| Scenario | Detection | Response |
|----------|-----------|----------|
| No Deadline Set | deadline IS NULL | Goal is skipped from velocity calculation. |
| Zero Study History | actual_vel = 0 | Triggers a high-priority risk alert. |

# Security Notes
- Read-only access to learning data.

# Owner + Review Cadence
- **Owner:** Michał
- **Review:** Monthly (verify deadline alignment)
