---
title: "SVC: Autonomous Finance - Daily Budget Alerts"
type: "automation_spec"
status: "inactive"
automation_id: "Autonomous Finance - Daily Budget Alerts"
goal_id: "goal-g05"
systems: ["S08", "S03"]
owner: "Michal"
updated: "2026-04-10"
---

# Autonomous Finance - Daily Budget Alerts

## Purpose
Automated budget monitoring workflow that queries PostgreSQL for critical budget alerts (CRITICAL and HIGH severity) and delivers formatted alert summaries. Runs twice daily at 8 AM and 8 PM.

**Status:** Currently inactive (active=false in n8n).

## Triggers
- **Schedule Trigger:** Cron expression `0 8,20 * * *` (8 AM and 8 PM daily) (Schedule Twice Daily (8 AM, 8 PM), lines 6-23).

## Inputs
- **PostgreSQL Query:** `SELECT * FROM get_current_budget_alerts() WHERE alert_severity IN ('CRITICAL', 'HIGH');`

## Processing Logic
1. **Schedule Twice Daily** (Schedule Trigger, lines 6-23): Triggers workflow at 8 AM and 8 PM.
2. **Query Critical Budget Alerts** (PostgreSQL node, lines 25-43): Queries `get_current_budget_alerts()` function for CRITICAL and HIGH severity alerts.
3. **Has Critical Alerts?** (IF node, lines 67-75): Branches based on whether alerts exist.
4. **Format Alert Message** (Code node, lines 78-88): Formats alert summary:
   - Counts CRITICAL and HIGH alerts
   - Builds message with category paths and recommended actions
   - Returns "All budgets on track" if no alerts

## Outputs
- **Formatted Message:** Budget alert summary (logged to console - no Telegram output in this workflow).

## Dependencies
### Systems
- [S08 Automation Orchestrator](../../../20_Systems/S08_Automation-Orchestrator/README.md) - n8n Execution engine.
- [S03 Data Layer](../../../20_Systems/S03_Data-Layer/README.md) - PostgreSQL database.

### External Services
- PostgreSQL (autonomous_finance docker).

## Error Handling
| Failure Scenario | Detection | Response | Alert |
|---|---|---|---|
| No alerts | IF node (alert_id is empty) | Returns "All budgets on track" message | None |
| Database error | PostgreSQL node error | Workflow error logged | n8n Execution log |

## Security Notes
- PostgreSQL credentials stored in n8n credential store.

## Manual Fallback
```bash
# Manually check budget alerts
psql -U michal -d autonomous_finance -c "SELECT * FROM get_current_budget_alerts() WHERE alert_severity IN ('CRITICAL', 'HIGH');"
```