---
title: "SOP: Daily Briefing Management"
type: "process"
status: "active"
owner: "Michał"
updated: "2026-02-19"
---

# SOP: Daily Briefing Management

## Purpose
Ensures the automated preparation of the Obsidian Daily Note is successful and data is accurate.

## Trigger / Frequency
- **Automatic:** Daily at 05:00 AM (Cron).
- **Manual:** Run when starting work if the Daily Note is missing or lacks autonomous suggestions.

## Inputs
- Python Environment: `autonomous-living/.venv`
- Finance DB: `autonomous_finance` (Docker)
- Workout Data: `Training/workouts.csv`

## Procedure (Checklist)
1. **[ ] Verify Note Creation:** Open Obsidian and ensure the note for today (`YYYY-MM-DD`) exists.
2. **[ ] Review Suggestions:** Check for the `🤖 Autonomous Task Suggestions` block.
    - [ ] Is a workout due? (If > 3 days since last session).
    - [ ] Are there finance alerts? (Utilization % from DB).
3. **[ ] Confirm Schedule:** Verify the `🤖 Suggested Schedule` block matches your 2026 focus.
4. **[ ] Resolve Errors (if any):**
    - If data is missing, check logs: `cat ~/Documents/autonomous-living/_meta/daily_briefing.log`.

## Manual Execution (Emergency)
If the cron fails:
```bash
cd ~/Documents/autonomous-living
./.venv/bin/python scripts/autonomous_daily_manager.py
```

## Failure Modes and Escalation
| Scenario | Detection | Response |
|---|---|---|
| Database Connection Error | Log: "DB Error" | Ensure Finance Docker container is running at `localhost:5432`. |
| Script Syntax Error | Log: "SyntaxError" | Review recent changes to `autonomous_daily_manager.py`. |
| Note already exists | No changes made | The script won't overwrite manual changes but will append tasks if not present. |

## Related Documentation
- [Automation: autonomous-daily-manager.py](../50_AUTOMATIONS/scripts/autonomous-daily-manager.md)
- [Goal: G10 Intelligent Productivity](../10_GOALS/G10_Intelligent-Productivity-Time-Architecture/README.md)
