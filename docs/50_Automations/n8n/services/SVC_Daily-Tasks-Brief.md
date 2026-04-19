---
title: "SVC: Daily Tasks Brief"
type: "automation_spec"
status: "active"
automation_id: "SVC_Daily-Tasks-Brief"
goal_id: "goal-g12"
systems: ["S08"]
owner: "Michal"
updated: "2026-04-10"
---

# SVC: Daily-Tasks-Brief

## Purpose
Automated morning briefing that extracts pending tasks from all active Goal Roadmaps and delivers a prioritized top-5 task list to Telegram. Runs daily at 6:46 AM to start the day with clear priorities.

## Triggers
- **Schedule Trigger:** Daily at 6:46 AM (Schedule: Daily 6:46 AM node, lines 6-19).

## Inputs
- **Goal Roadmap Files:** Reads content from:
  - `{{ROOT_LOCATION}}/autonomous-living/docs/10_Goals/G01_Target-Body-Fat/Roadmap.md`
  - `{{ROOT_LOCATION}}/autonomous-living/docs/10_Goals/G02_Automationbro-Recognition/Roadmap.md`
  - `{{ROOT_LOCATION}}/autonomous-living/docs/10_Goals/G03_Autonomous-Household-Operations/Roadmap.md`
  - `{{ROOT_LOCATION}}/autonomous-living/docs/10_Goals/G04_Digital-Twin-Ecosystem/Roadmap.md`
  - `{{ROOT_LOCATION}}/autonomous-living/docs/10_Goals/G05_Autonomous-Financial-Command-Center/Roadmap.md`
  - `{{ROOT_LOCATION}}/autonomous-living/docs/10_Goals/G{{LONG_IDENTIFIER}}/Roadmap.md`
  - `{{ROOT_LOCATION}}/autonomous-living/docs/10_Goals/G12_Complete-Process-Documentation/Roadmap.md`

## Processing Logic
1. **Read Goal Roadmaps** (7x Read Binary File nodes, lines 24-90): Parallel read of all 7 goal Roadmap.md files.
2. **Extract Pending Tasks** (Code node, lines 93-99): Parses each Roadmap.md, detects quarter headers (Q1-Q4), extracts unchecked tasks (`- [ ]`). Filters tasks (5-150 chars). Sorts by goal priority (G04, G05, G10, G12, G03, G01, G02). Takes top 5 tasks.
3. **Telegram: Send Tasks** (Telegram node, lines 103-120): Sends formatted message to chat ID `{{TELEGRAM_CHAT_ID}}` with Markdown parsing.

## Outputs
- **Telegram Message:** Formatted message with total pending count and top 5 prioritized tasks.
- **Example Output:** `📋 **Top Priorities** (23 pending)\n\n1. [G04] Create documentation for workflow X\n2. [G05] Set up budget alerts\n...`

## Dependencies
### Systems
- [S08 Automation Orchestrator](../../../20_Systems/S08_Automation-Orchestrator/README.md) - n8n Execution engine.

### External Services
- Telegram Bot (AndrzejSmartBot credentials).

## Error Handling
| Failure Scenario | Detection | Response | Alert |
|---|---|---|---|
| Roadmap file missing | Read node failure | Task skipped; continues with others | n8n Execution log |
| Telegram send fail | Telegram node error | Workflow error logged | n8n Execution log |

## Security Notes
- Hardcoded Telegram chat_id (`{{TELEGRAM_CHAT_ID}}`) - should use environment variable.
- Telegram credentials stored in n8n credential store.

## Manual Fallback
```bash
# Manually check pending tasks
grep -r "^-\s*\[\s*\]\s*" {{ROOT_LOCATION}}/autonomous-living/docs/10_Goals/*/Roadmap.md | head -20
```