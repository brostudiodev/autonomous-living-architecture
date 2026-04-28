---
title: "Stalled Goal Detector (G11)"
type: "automation_spec"
status: "active"
owner: "Michał"
updated: "2026-04-02"
---

# Purpose
The **Stalled Goal Detector** (`G11_stall_detector.py`) ensures that none of the 12 Power Goals lose momentum. It autonomously identifies goals that have pending roadmap tasks but haven't shown any measurable activity (logs, commits, or tasks) in the last 7 days.

# Scope
- **In Scope:** All 12 Power Goals (G01-G12) with active Q2 tasks.
- **Out Scope:** Goals marked as "Completed" or "Planned" (without current active tasks).

# Logic & Thresholds
- **Stall Threshold:** **7 consecutive days** of zero activity.
- **Activity Definition:** 
  - Successful run of a domain-specific script in `system_activity_log`.
  - Git commits in relevant repositories.
  - Completed tasks in the Daily Note mapped to the goal.
- **Reporting:** Stalled goals are injected into the `G11_STALLS` dashboard section and can be used to influence the `G11_goal_recommender`.

# Inputs/Outputs
- **Inputs:** `system_activity_log` (PostgreSQL), `docs/10_Goals/*/Roadmap.md`.
- **Outputs:** Markdown alert report for the daily dashboard.

# Dependencies
- **Systems:** S11 (Meta-System), G12 (Complete Process Documentation)
- **Database:** `digital_twin_michal`

# Procedure
- Automatically executed by `autonomous_daily_manager.py` during the daily sync.

# Failure Modes
| Scenario | Detection | Response |
|----------|-----------|----------|
| DB Offline | Connection error | Script defaults to "No Stalls" to avoid false alarms. |
| Roadmap Missing | Path not found | Goal is skipped from auditing. |

# Security Notes
- Read-only access to system logs and documentation.

# Owner + Review Cadence
- **Owner:** Michał
- **Review:** Monthly (verify stall sensitivity)
