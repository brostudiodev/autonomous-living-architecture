---
title: "SVC: Expense Calendar Data Sync"
type: "automation_spec"
status: "active"
automation_id: "SVC_Expense-Calendar-Data-Sync"
goal_id: "goal-g05"
systems: ["S08", "S03"]
owner: "Michal"
updated: "2026-04-10"
---

# SVC_Expense-Calendar-Data-Sync

## Purpose
Syncs expense/calendar data from Google Sheets "Expense Calendar" tab to PostgreSQL. Runs every 6 hours to keep planned expenses current.

## Triggers
- **Schedule Trigger:** Every 6 hours (Schedule node, lines 8-24).

## Inputs
- **Google Sheets:** Reads from "Expense Calendar" tab in "Zestawienie_finansowe-2026_FG_AI" spreadsheet.
- **PostgreSQL:** Upserts to `autonomous_finance.expense_calendar` table.

## Processing Logic
1. **Every 6 hours** (Schedule Trigger): Triggers workflow every 6 hours.
2. **Read Expense Calendar Sheet** (Google Sheets node): Reads all rows from "Expense Calendar" tab.
3. **Transform & Validate Data** (Code node): Parses amounts, validates dates/categories.
4. **Upsert to PostgreSQL** (PostgreSQL node): Calls stored procedure for each expense.
5. **Generate Sync Report** (Code node): Counts successful syncs, errors.
6. **IF: Has Errors?** (IF node): Branches based on sync status.
7. **Send Error Alert** (Gmail node): Notifies if sync failed.

## Outputs
- **Database:** Planned expenses in `autonomous_finance.expense_calendar` table.
- **Email:** Error alert if sync fails.

## Dependencies
### Systems
- [S08 Automation Orchestrator](../../../20_Systems/S08_Automation-Orchestrator/README.md) - n8n.
- [S03 Data Layer](../../../20_Systems/S03_Data-Layer/README.md) - PostgreSQL.

### External Services
- Google Sheets API ("Zestawienie_finansowe-2026_FG_AI").
- Gmail (for error alerts).

## Error Handling
| Failure Scenario | Detection | Response | Alert |
|---|---|---|---|
| Sync partial failure | IF node (errors > 0) | Sends error email | Email to user |
| Sheet access error | Google Sheets node error | Workflow error logged | n8n Execution log |

## Security Notes
- **Spreadsheet ID:** `{{LONG_IDENTIFIER}}` - hardcoded.
- Google Sheets credentials in n8n credential store.

## Manual Fallback
```bash
# Manual sync via PostgreSQL function
psql -U michal -d autonomous_finance -c "SELECT * FROM upsert_expense_from_sheet(...);"
```