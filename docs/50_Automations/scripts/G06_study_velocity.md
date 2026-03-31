---
title: "G06: Study Velocity Engine"
type: "automation_spec"
status: "active"
automation_id: "G06_study_velocity"
goal_id: "goal-g06"
systems: ["S06", "S11"]
owner: "Michal"
updated: "2026-03-12"
---

# G06: Study Velocity Engine

## Purpose
Monitors certification study progress against hard deadlines to ensure exam readiness. Calculates the specific hourly requirement per day to hit the target date.

## Triggers
- Scheduled: Part of the `autonomous_daily_manager.py` daily sync cycle.

## Inputs
- Database: `autonomous_learning.certifications`.

## Processing Logic
1. **Calculate Delta:** Determine remaining study hours (`total - completed`) and days until exam.
2. **Compute Pace:** `Required Daily Pace = Hours Remaining / Days Remaining`.
3. **Analyze Risk:** 
   - Pace > 2.0h/day -> CRITICAL.
   - Pace > 1.0h/day -> WARNING.
   - Pace <= 1.0h/day -> ON TRACK.
4. **Report:** Generate a status report for each active certification.

## Outputs
- Velocity report injected into the Digital Twin status.
- Activity log entry.

## Error Handling
| Failure Scenario | Detection | Response | Alert |
|---|---|---|---|
| Past Deadline | `target_date < current_date` | Mark as "Overdue" | Log Warning |
| Zero Total Hours | Division error | Log data error | Log Info |
