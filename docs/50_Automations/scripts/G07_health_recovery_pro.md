---
title: "G07: Health Recovery Pro"
type: "automation_spec"
status: "active"
automation_id: "G07_health_recovery_pro"
goal_id: "goal-g07"
systems: ["S07"]
owner: "Michał"
updated: "2026-04-28"
---

# G07: Health Recovery Pro

## Purpose
Provides data-driven recovery advice by analyzing short-term biometrics (7-day HRV/Sleep) to determine the ideal training intensity or required deload periods.

## Triggers
- Scheduled: Part of the `autonomous_daily_manager.py` daily sync cycle.

## Inputs
- Database: `autonomous_health.biometrics` (Filtered for last 7 days).

## Processing Logic
1. **Analyze HRV:** Compare latest HRV reading against the 7-day average. 
2. **Detect Trends:** 
   - Suppression: HRV < 90% of average (Overreaching/Stress).
   - Supercompensation: HRV > 110% of average (Peak Readiness).
3. **Analyze Sleep:** Compare average weekly sleep quality and score.
4. **Formulate Advice:** Generate a non-AI recommendation (e.g., "Schedule HIT today" or "Focus on active recovery").

## Outputs
- Recovery insight injected into the Daily Intelligence Summary.
- Activity log entry.

## Error Handling
| Failure Scenario | Detection | Response | Alert |
|---|---|---|---|
| Missing Data | No reading for current date | Skip analysis for that day | Log Warning |
| DB Sync Lag | Data not updated from Zepp | Wait for next sync cycle | Log Info |
