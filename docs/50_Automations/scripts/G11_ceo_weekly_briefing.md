---
title: "G11_ceo_weekly_briefing: CEO Weekly Briefing"
type: "automation_spec"
status: "active"
automation_id: "G11_ceo_weekly_briefing"
goal_id: "goal-g11"
systems: ["S04", "S10", "S11"]
owner: "Michał"
updated: "2026-04-28"
---

# G11_ceo_weekly_briefing: CEO Weekly Briefing

## Purpose

Unified executive summary sent to Telegram every Sunday morning. Aggregates data from all systems into a single view for efficient weekly review.

## Triggers

- **Scheduled:** Sundays at 8:00 AM via crontab
- **Manual:** `python scripts/G11_ceo_weekly_briefing.py [--dry-run]`

## Data Sources

| Source | Data Retrieved |
|--------|---------------|
| PostgreSQL (finance) | Savings rate, MTD income/expenses, budget alerts |
| PostgreSQL (training) | Weight, body fat, training sessions |
| Journal Data (JSON) | Readiness, sleep, energy, time saved, goals |
| Google Tasks API | Stale task counts, oldest overdue task |

## Outputs

### Telegram Message Sections

```
🤖 CEO WEEKLY BRIEFING - Week 13
📅 2026-03-19 to 2026-03-25

📊 WEEK AT A GLANCE
• Days Tracked: 5/7
• Energy: 3.5/5 avg
• Time Saved: 45 min
• Goals Active: 8/12 touched

💰 FINANCE
• Savings Rate: ✅ 28%
• MTD Net: +2,400 PLN
• ⚠️ Budget Alerts: Entertainment (92%)

💪 HEALTH
• Readiness: 78/100 avg
• Sleep: 7.2h avg
• Weight: 82.1 kg | BF: 20.5%
• Training: 2 sessions this week

🏆 TOP WINS
1. G04: Deployed Agent Zero v2

⚠️ STARVED GOALS: G06, G09

📋 TASKS STATUS
• Overdue: 3 tasks
• ⏳ Awaiting Approval: 1
• Oldest: "Nadplacac kredty" (11d)

🎯 NEXT WEEK PRIORITIES
• Continue momentum on G04: 5 sessions
• Continue momentum on G10: 4 sessions
• Address starved goals: G06
```

## Processing Logic

```
1. Fetch finance data from autonomous_finance DB
2. Fetch health data from autonomous_training DB
3. Load journal data from last 7 days
4. Query Google Tasks for stale task status
5. Calculate averages and detect patterns
6. Generate formatted Telegram message
7. Send via send_telegram_message()
8. Log success/failure to system_activity_log
```

## Configuration

### Crontab Entry

```cron
# CEO Weekly Briefing - Sundays 8:00 AM
0 8 * * 0 cd {{ROOT_LOCATION}}/autonomous-living && .venv/bin/python scripts/G11_ceo_weekly_briefing.py >> _meta/daily-logs/ceo_briefing.log 2>&1
```

## Dependencies

### Systems
- [S04 Digital Twin](../../20_Systems/S04_Digital-Twin/README.md) - Data aggregation
- [S10 Daily Goals Automation](../../20_Systems/S10_Daily-Goals-Automation/README.md) - Journal data
- [S11 Meta-System Integration](../../20_Systems/S11_Meta-System-Integration/README.md) - Orchestration

### Scripts
- `G04_digital_twin_notifier.py` - Telegram sending
- `G11_log_system.py` - Activity logging
- `G10_google_tasks_sync.py` - Google Tasks access

### External
- PostgreSQL databases (autonomous_finance, autonomous_training)
- Telegram Bot API

## Error Handling

| Scenario | Detection | Response |
|----------|-----------|----------|
| DB connection fails | Exception | Log error, continue with partial data |
| Telegram send fails | send_telegram_message returns False | Log failure, print to console |
| No journal data | days_tracked = 0 | Show "0/7 tracked", continue |

## Metrics

- **Success:** Message sent to Telegram
- **Partial:** Some data sources failed (still sends)
- **Failure:** Telegram send completely failed

## Related Documentation

- [SOP: Weekly Review Process](../../30_Sops/Weekly-Review-Process.md)
- [G11 Weekly Briefing Enhancement Plan](./G11_weekly_briefing_enhancement.md)
- [G11 Meta-System Roadmap](../../10_Goals/G11_Meta-System-Integration-Optimization/Roadmap.md)

## Changelog

| Date | Change |
|------|--------|
| 2026-03-26 | Initial creation - Unified CEO Briefing |
| 2026-04-16 | Bugfix: Fixed misindented logger calls in task sync except blocks |
