---
title: "G10: Metrics"
type: "goal_metrics"
status: "active"
goal_id: "goal-g10"
owner: "Michal"
updated: "2026-02-15"
---

# Metrics

## KPI list

### Calendar Management Metrics
| Metric | Target | How measured | Frequency | Owner |
|---|---:|---|---|---|
| Calendar request success rate | ≥ 95% | n8n execution logs + manual validation | Weekly | Michal |
| End-to-end response time | ≤ 10s | n8n workflow duration tracking | Daily | Michal |
| Monthly LLM cost | < $5 USD | Google Cloud billing dashboard | Monthly | Michal |
| User correction rate | ≤ 5% | Manual tracking in activity logs | Weekly | Michal |

### Productivity System Metrics
| Metric | Target | How measured | Frequency | Owner |
|---|---:|---|---|---|
| **Planning ROI** | > 10 mins/day | [Autonomy ROI Tracker](../G04_Digital-Twin-Ecosystem/Systems.md) | Daily | Digital Twin |
| **Readiness Adherence** | > 80% | [G10_tomorrow_planner.py](../../50_Automations/scripts/G10_tomorrow_planner.md) | Weekly | Digital Twin |
| **Deep Work Hours** | > 15h/week | RescueTime / Calendar Audit | Weekly | Michal |

## Leading indicators
### Calendar Management
- Failed n8n executions in SVC_Google-Calendar
- AI model timeout incidents (>30s response time)
- Google Calendar API rate limit hits
- Assumption accuracy (tracked in responses)

### Productivity System
- "Task Scrubber" execution count (G11).
- Biological Readiness Score (G07).

## Lagging indicators
### Calendar Management
- Subjective trust level in calendar automation (quarterly assessment)
- Ratio of AI-created vs manually-created events
- Time saved on calendar management (estimated monthly)

### Productivity System
- Total "Time Saved" reported by G04/G11.

## Data Sources
- n8n execution logs: `SVC_Google-Calendar` workflow
- Google Calendar API usage metrics
- Manual activity tracking in `goal-g11/Activity-log.md`
- LLM token usage from Google Cloud Console
