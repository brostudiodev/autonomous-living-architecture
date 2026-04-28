---
title: "PROJ: AI Strategic Auditor"
type: "n8n_workflow"
status: "active"
owner: "Michał"
goal_id: "goal-g11"
updated: "2026-04-16"
---

# PROJ: AI Strategic Auditor

## Purpose

Weekly strategic review system that compares "Intent" (Roadmap progress) vs "Reality" (Execution logs) and delivers a brutally honest assessment via Telegram. Acts as "The Director" - calling out gaps between stated priorities and actual actions.

## Scope

### In Scope
- Weekly execution of strategic audit
- Data aggregation from Digital Twin API
- AI-powered analysis and verdict generation
- Telegram delivery of "Director's Verdict"

### Out of Scope
- Daily monitoring (see SVC workflows)
- Manual intervention triggers
- Cross-goal resource allocation

## Inputs/Outputs

### Trigger
- **Type:** Cron Schedule
- **Schedule:** Every Sunday at 18:00
- **Frequency:** Weekly

### Data Sources
- Digital Twin API `/strategic_audit` endpoint
  - Intent roadmap percentage (`intent_roadmap_pct`)
  - Execution heartbeat (`execution_heartbeat`)
  - Value reclaimed 7 days (`value_reclaimed_7d_mins`)
  - Biological readiness average (`biological_readiness_avg`)

### Outputs
- **Type:** Telegram message
- **Format:** Markdown
- **Content:** "The Director's Verdict" - strategic assessment

## Dependencies

### Systems
- [S04 Digital Twin](../20_Systems/S04_Digital-Twin/README.md)
- Telegram Bot (AndrzejSmartBot)

### Infrastructure
- Digital Twin API (`http://digital-twin-api:5677/strategic_audit`)
- Telegram Bot API

### Credentials
- Telegram API credentials configured in n8n

## Procedure

### Execution Flow
1. **Cron Trigger:** Every Sunday 18:00
2. **Fetch Audit Data:** Query Digital Twin API `/strategic_audit`
3. **AI Analysis:** Gemini-powered analysis comparing intent vs reality
4. **Generate Verdict:** Structured markdown report
5. **Send Telegram:** Deliver verdict to configured chat ID

### Interpretation
The "Director's Verdict" highlights:
- Goal Gaps (high intent, zero activity)
- Misalignment between stated priorities and actual effort
- Actionable recommendations

## Failure Modes

| Scenario | Detection | Response |
|----------|----------|----------|
| Digital Twin API unavailable | HTTP error | Workflow continues with partial data |
| Telegram delivery fails | API error | Check bot token validity |
| AI generates empty response | Empty output | Manual review of logs |

## Security Notes

- Telegram chat ID is hardcoded for secure delivery
- No sensitive data in logs
- AI prompt uses Polish for personalized delivery

## Owner + Review Cadence
- **Owner:** Michał
- **Review:** Monthly (during G11 system audit)
- **Last Updated:** 2026-04-16

## Related Documentation

- [G11 Meta-System Roadmap](../10_Goals/G11_Meta-System-Integration-Optimization/Roadmap.md)
- [Digital Twin Strategic Audit](../20_Systems/S04_Digital-Twin/README.md)
- [Weekly Review SOP](../30_Sops/Weekly-Review-SOP.md)
