---
title: "G10: Metrics"
type: "goal_metrics"
status: "active"
goal_id: "goal-g10"
owner: "{{OWNER_NAME}}"
updated: "2026-02-15"
---

# Metrics

## KPI list

### Calendar Management Metrics
| Metric | Target | How measured | Frequency | Owner |
|---|---:|---|---|---|
| Calendar request success rate | ≥ 95% | n8n execution logs + manual validation | Weekly | {{OWNER_NAME}} |
| End-to-end response time | ≤ 10s | n8n workflow duration tracking | Daily | {{OWNER_NAME}} |
| Monthly LLM cost | < $5 USD | Google Cloud billing dashboard | Monthly | {{OWNER_NAME}} |
| User correction rate | ≤ 5% | Manual tracking in activity logs | Weekly | {{OWNER_NAME}} |

### Productivity System Metrics
| Metric | Target | How measured | Frequency | Owner |
|---|---:|---|---|---|
| Example KPI | TBD | TBD | weekly | {{OWNER_NAME}} |

## Leading indicators
### Calendar Management
- Failed n8n executions in SVC_Google-Calendar
- AI model timeout incidents (>30s response time)
- Google Calendar API rate limit hits
- Assumption accuracy (tracked in responses)

### Productivity System
- ...

## Lagging indicators
### Calendar Management
- Subjective trust level in calendar automation (quarterly assessment)
- Ratio of AI-created vs manually-created events
- Time saved on calendar management (estimated monthly)

### Productivity System
- ...

## Data Sources
- n8n execution logs: `SVC_Google-Calendar` workflow
- Google Calendar API usage metrics
- Manual activity tracking in `goal-g11/ACTIVITY.md`
- LLM token usage from Google Cloud Console
