---
title: "SVC: Autonomous Finance - Budget Sync"
type: "automation_spec"
status: "active"
automation_id: "Autonomous Finance - Budget Sync"
goal_id: "goal-g05"
systems: ["S08", "S03"]
owner: "Michal"
updated: "2026-04-10"
---

# Autonomous Finance - Budget Sync

## Purpose
Automated synchronization workflow that reads budget data from Google Sheets "Budget" sheet and syncs it to PostgreSQL database (`autonomous_finance`). Runs every 12 hours to keep budget data current between spreadsheet and database.

## Triggers
- **Schedule Trigger:** Every 12 hours (Schedule Every 12 Hours, lines 6-23).

## Inputs
- **Google Sheets:** Reads from "Zestawienie_finansowe-2026_FG_AI" spreadsheet, "Budget" sheet.
- **PostgreSQL:** Calls `upsert_budget_from_sheet()` stored procedure.

## Processing Logic
1. **Schedule Every 12 Hours** (Schedule Trigger, lines 6-23): Triggers workflow every 12 hours.
2. **Read Budget Sheet** (Google Sheets node, lines 25-56): Reads all budget rows from Google Sheets.
3. **Transform & Validate Budget Data** (Code node, lines 58-69): Validates and transforms budget data:
   - Parses amounts (handles European number format with comma)
   - Validates active status
   - Skips zero budgets and inactive rows
   - Validates required fields (Transaction_ID, Year, Month, Type, Category, Sub-Category, Budget_Type, Priority)
4. **Upsert Budgets to PostgreSQL** (PostgreSQL node, lines 70-92): Calls `upsert_budget_from_sheet()` stored procedure for each budget.
5. **Generate Budget Sync Report** (Code node, lines 94-105): Analyzes database operation results - counts inserts, updates, errors.
6. **Check for Budget Errors** (IF node, lines 108-138): Branches based on `overall_status`.
7. **Send Error Alert Email** (Gmail node, lines 141-161): Sends error alert to `{{EMAIL}}` if sync fails.

## Outputs
- **Database:** Budget records upserted to `autonomous_finance.budgets` table.
- **Email:** Error alert sent if sync fails.

## Dependencies
### Systems
- [S08 Automation Orchestrator](../../../20_Systems/S08_Automation-Orchestrator/README.md) - n8n Execution engine.
- [S03 Data Layer](../../../20_Systems/S03_Data-Layer/README.md) - PostgreSQL database.

### External Services
- Google Sheets API (OAuth2 - "Google Sheets account").
- PostgreSQL (autonomous_finance docker).
- Gmail API (for error alerts).

## Error Handling
| Failure Scenario | Detection | Response | Alert |
|---|---|---|---|
| Sync partial failure | IF node (overall_status != SUCCESS) | Sends error alert email | Email to {{EMAIL}} |
| Database error | PostgreSQL node error with continueOnFail: true | Logs error, continues | n8n Execution log |
| Google Sheets error | Google Sheets node error | Workflow error logged | n8n Execution log |

## Security Notes
- **ISSUE:** Spreadsheet ID uses placeholder `{{SPREADSHEET_ID}}` - should be actual ID.
- Hardcoded recipient email (`{{EMAIL}}`).
- Google Sheets credentials stored in n8n credential store.
- PostgreSQL credentials stored in n8n credential store.
- Gmail credentials stored in n8n credential store.

## Manual Fallback
```bash
# Manually trigger budget sync via PostgreSQL function
psql -U michal -d autonomous_finance -c "SELECT * FROM upsert_budget_from_sheet('BUDGET_ID', 2026, 4, 'expense', 'food', 'groceries', 500.00, 0.8, 'notes', 'fixed', 'high', true);"
```