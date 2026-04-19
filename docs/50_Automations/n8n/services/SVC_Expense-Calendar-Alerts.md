---
title: "SVC: Expense Calendar Alerts"
type: "automation_spec"
status: "active"
automation_id: "SVC_Expense-Calendar-Alerts"
goal_id: "goal-g05"
systems: ["S08", "S03"]
owner: "Michal"
updated: "2026-04-10"
---

# SVC_Expense-Calendar-Alerts

## Purpose
Monitors upcoming planned expenses and sends alerts. Runs daily at 8 AM to notify of upcoming expenses.

## Triggers
- **Schedule Trigger:** Daily at 8 AM (cron: `0 8 * * *`).

## Inputs
- **PostgreSQL View:** `v_upcoming_expenses` - upcoming expense predictions.

## Processing Logic
1. **Daily 8 AM** (Schedule Trigger): Triggers at 8 AM daily.
2. **Query Upcoming Expenses** (PostgreSQL node): Fetches from `v_upcoming_expenses` view.
3. **Format Alert Message** (Code node): Formats expense list with urgency levels.
4. **Telegram Alert** (Telegram node): Sends to chat ID `{{TELEGRAM_CHAT_ID}}`.

## Outputs
- **Telegram:** Daily expense alerts with amounts and urgency.

## Dependencies
### Systems
- [S08 Automation Orchestrator](../../../20_Systems/S08_Automation-Orchestrator/README.md)
- [S03 Data Layer](../../../20_Systems/S03_Data-Layer/README.md)

### External Services
- Telegram Bot (AndrzejSmartBot).

## Error Handling
| Failure Scenario | Detection | Response | Alert |
|---|---|---|---|
| No upcoming expenses | Query returns empty | "No upcoming expenses" message | None |
| Database error | PostgreSQL node error | Workflow error logged | n8n Execution log |

## Manual Fallback
```bash
psql -U michal -d autonomous_finance -c "SELECT * FROM v_upcoming_expenses ORDER BY expense_date;"
```