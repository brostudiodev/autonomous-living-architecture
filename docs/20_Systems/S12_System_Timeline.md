---
title: "S12: System Timeline (Master Schedule)"
type: "system_doc"
status: "active"
owner: "Michał"
updated: "2026-04-10"
---

# S12: System Timeline

This document provides a unified view of all scheduled activities across the Autonomous Living ecosystem, including System Cron, n8n Workflows, and PostgreSQL Internal Jobs.

## 📅 Chronological Timeline (24h)

| Time (Local) | System | Component / Workflow | Purpose |
|:---|:---|:---|:---|
| **00:01** | Cron | `G04_snapshot_manager.py` | Daily system state snapshot |
| **06:00** | Cron | `autonomous_weekly_manager.py` | (Sunday Only) Weekly Review |
| **06:15** | Cron | `G11_obsidian_safe_sync.py` | First Sync: Daily Note, Health, Finance |
| **06:15** | Cron | `G04_morning_briefing_sender.py` | (Mon-Fri) Initial Morning Briefing |
| **06:45** | n8n | `SVC_Daily-Calendar-Brief` | Daily schedule synthesis |
| **06:46** | n8n | `SVC_Daily-Tasks-Brief` | Task priority overview |
| **06:47** | n8n | `SVC_Daily-Weather-Brief` | Weather-aware gear suggestions |
| **06:48** | n8n | `SVC_Daily-SmartHome-Brief` | Battery & sensor status report |
| **06:49** | n8n | `SVC_Daily-Workout-Suggestion` | Biological readiness-based training |
| **06:55** | n8n | `SVC_Email-Summary-Agent` | Aggregate briefing delivery |
| **07:00** | n8n | `SVC_Task-Triage` | Initial daily task prioritization |
| **07:00** | n8n | `SVC_Autonomous-Schedule-Negotiator` | 1st Schedule Negotiation (Energy-based) |
| **08:00** | n8n | `SVC_Autonomous-Friction-Resolver` | 1st Friction scan (Quick Wins) |
| **08:00** | n8n | `SVC_Expense-Calendar-Alerts` | Upcoming financial obligations |
| **08:00** | Cron | `G11_ceo_weekly_briefing.py` | (Sunday Only) Executive Summary |
| **08:00** | n8n | `Autonomous Finance - Alerts` | 1st Budget breach check |
| **10:00** | n8n | `SVC_Financial-AI-Categorizer` | Automated bookkeeping (Gemini) |
| **10:00** | n8n | `SVC_Autonomous-Schedule-Negotiator` | 2nd Schedule Negotiation |
| **12:00** | n8n | `SVC_Autonomous-Friction-Resolver` | 2nd Friction scan |
| **13:00** | n8n | `SVC_Autonomous-Schedule-Negotiator` | 3rd Schedule Negotiation |
| **13:15** | Cron | `G11_obsidian_safe_sync.py` | Midday Sync: Progress tracking |
| **16:00** | n8n | `SVC_Autonomous-Friction-Resolver` | 3rd Friction scan |
| **16:00** | n8n | `SVC_Autonomous-Schedule-Negotiator` | 4th Schedule Negotiation |
| **16:15** | Cron | `G11_obsidian_safe_sync.py` | Afternoon Sync: Energy/Mood update |
| **18:00** | Cron | `autonomous_evening_manager.py` | Cognitive Shutdown initialization |
| **18:30** | n8n | `WF_proactive_reflection_drafter` | Journal entry drafting |
| **19:00** | n8n | `WF_content_draft_agent` | Social media draft generation |
| **19:00** | n8n | `SVC_Autonomous-Schedule-Negotiator` | 5th Schedule Negotiation |
| **20:00** | n8n | `WF_learning_ingester` | Atomic note transformation |
| **20:00** | n8n | `SVC_Autonomous-Friction-Resolver` | 4th Friction scan |
| **20:00** | n8n | `Autonomous Finance - Alerts` | 2nd Budget breach check |
| **21:00** | n8n | `SVC_Automated-Reflection-Bridge` | Evening synthesis & sleep prep |
| **21:00** | Cron | `G08_pre_bed_advisor.py` | Environment check (Lights/Temp) |
| **22:00** | n8n | `WF_decision_pattern_analyzer` | (Sunday Only) Weekly bias audit |

## 🔄 Recurrent Interval Tasks

| Interval | System | Job | Purpose |
|:---|:---|:---|:---|
| **Every 6h** | DB | `refresh-savings-rate` | Recalculate savings rate (pg_cron) |
| **Every 12h** | n8n | `Finance - Budget Sync` | Financial data sync |
| **Every 12h** | DB | `refresh-budget-performance` | Refresh budget views (pg_cron) |

## 🛠️ Monitoring Commands

```bash
# Check Host Cron Execution
grep CRON /var/log/syslog | tail -20

# Check n8n Service Status
docker ps --filter "name=n8n"

# Check DB Job Status
# SELECT * FROM cron.job_run_details ORDER BY end_time DESC LIMIT 10;
```

---
*Created: 2026-04-10 | Finalized by Gemini CLI*
