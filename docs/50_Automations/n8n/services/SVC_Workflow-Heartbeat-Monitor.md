---
title: "SVC: Workflow Heartbeat Monitor"
type: "automation_spec"
status: "active"
automation_id: "SVC_Workflow-Heartbeat-Monitor"
goal_id: "goal-g01"
systems: ["S08"]
owner: "Michal"
updated: "2026-04-10"
---

# SVC_Workflow-Heartbeat-Monitor

## Purpose
Automated workflow health monitoring system that checks if critical n8n workflows are running within expected intervals. Sends alerts when workflows fail to execute or become inactive. Runs every 60 minutes during active hours (8 AM - 9 PM).

## Triggers
- **Schedule Trigger:** Every 60 minutes (Every 60 minutes, lines 6-25).
- **Quiet Hours Check:** IF node checks if current hour is between 8-21 (Warsaw timezone). Only runs outside quiet hours.

## Inputs
- **Config:** Set node with n8n_baseURL, Telegram_ChatID, Alert_Email, check_window_hours, send_healthy_summary.
- **Workflows To Monitor:** Code node defining list of workflows to check (lines 115-126).

## Processing Logic
1. **Every 60 minutes** (Schedule Trigger): Triggers every hour.
2. **Outside Quiet Hours?** (IF node, lines 58-66): Only proceed if hour is 8-20 (Warsaw time).
3. **Config** (Set node, lines 68-113): Sets configuration values:
   - n8n_baseURL: http://{{INTERNAL_IP}}:5678
   - Telegram_ChatID: {{TELEGRAM_CHAT_ID}}
   - Alert_Email: {{EMAIL}}
4. **Workflows To Monitor** (Code node): Defines workflows to monitor with expected intervals.
5. **Get All Workflows** (HTTP Request node, lines 128-148): Fetches all n8n workflows via API.
6. **Get All Recent Executions** (HTTP Request node, lines 150-171): Fetches recent executions.
7. **Analyze & Build Report** (Code node, lines 174-179): Analyzes workflow health.

## Monitored Workflows
- Export Workflows to GitHub (168 hours = weekly)
- YouTube Video summarizers (1 hour interval for multiple channels)

## Outputs
- **Telegram Alert:** Sends alerts to chat ID {{TELEGRAM_CHAT_ID}}.
- **Email Alert:** Sends error emails to {{EMAIL}}.

## Dependencies
### Systems
- [S08 Automation Orchestrator](../../../20_Systems/S08_Automation-Orchestrator/README.md) - n8n Execution engine.

### External Services
- n8n API (http://{{INTERNAL_IP}}:5678).
- Telegram Bot.
- Gmail.

## Error Handling
| Failure Scenario | Detection | Response | Alert |
|---|---|---|---|
| Workflow inactive | Workflow.active = false | Status: inactive | Telegram + Email |
| No executions | execs.length === 0 | Status: no_runs | Telegram + Email |
| Stale workflow | hours_since > expected | Status: stale | Telegram + Email |
| Not found | wf.matched = false | Status: not_found | Telegram + Email |

## Security Notes
- Hardcoded chat_id (`{{TELEGRAM_CHAT_ID}}`).
- Hardcoded email (`{{EMAIL}}`).
- n8n API credentials stored in n8n credential store.

## Manual Fallback
Check n8n workflow execution history manually via n8n UI.