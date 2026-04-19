---
title: "SVC: Autonomous Finance - 2026 Data Sync"
type: "automation_spec"
status: "active"
automation_id: "Autonomous Finance - 2026 Data Sync"
goal_id: "goal-g05"
systems: ["S08", "S03"]
owner: "Michal"
updated: "2026-04-10"
---

# Autonomous Finance - 2026 Data Sync

## Purpose
Comprehensive financial data synchronization workflow that reads 2026 transactions from Google Sheets "Transactions" sheet and syncs them to PostgreSQL database (`autonomous_finance`). Includes extensive validation, error handling, and auto-creation of missing merchants. Runs every 6 hours.

## Triggers
- **Schedule Trigger:** Every 6 hours (Schedule Every 6 Hours, lines 6-23).

## Inputs
- **Google Sheets:** Reads from "Zestawienie_finansowe-2026_FG_AI" spreadsheet, "Transactions" sheet.
- **PostgreSQL:** Calls `upsert_transaction_from_sheet()` stored procedure.

## Processing Logic
1. **Schedule Every 6 Hours** (Schedule Trigger, lines 6-23): Triggers workflow every 6 hours.
2. **Read Transactions Sheet** (Google Sheets node, lines 25-56): Reads all transaction rows from Google Sheets.
3. **Filter & Transform 2026 Data** (Code node, lines 58-69): Filters for 2026 transactions only, validates date (Month/Day columns), parses amounts, handles invalid entries.
4. **Upsert to PostgreSQL** (PostgreSQL node, lines 70-92): Calls `upsert_transaction_from_sheet()` for each transaction.
5. **Generate Sync Report** (Code node, lines 94-105): Analyzes database operation results, tracks new merchants, counts successes/errors.
6. **Check for Errors** (IF node, lines 108-138): Branches based on `overall_status`.
7. **Format Error Alert** (Code node, lines 141-151): Formats error notification message.
8. **Send Error Alert Email** (Gmail node, lines 291-312): Sends error alert to `{{EMAIL}}` if sync fails.

### Validation Nodes (Parallel, for data quality)
- **Daily Health Check** (lines 154-175): Checks if sync is overdue (>12 hours).
- **Missing Merchant Auto-Creation** (lines 176-197): Creates `create_missing_merchant()` function.
- **Data Integrity Validation** (lines 198-220): Checks for NULL foreign keys, verifies monthly totals.
- **Updated Data Validation** (lines 221-243): Verifies 2026 data imported.
- **Category Distribution Check** (lines 244-266): Verifies category mappings.
- **Weekly Validation** (lines 267-289): Monthly totals by category.
- **SQL Query Validation** (lines 313-335): Verifies 2025 historical data.

## Outputs
- **Database:** Transaction records upserted to `autonomous_finance.transactions` table.
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
| Sync partial failure | IF node (overall_status != SUCCESS) | Sends detailed error alert email | Email to {{EMAIL}} |
| Database error | PostgreSQL node error with continueOnFail: true | Logs error, continues | n8n Execution log |
| Invalid date | Code node validation | Skips row, logs to errors | Processing stats |
| Invalid amount | Code node validation | Skips row, logs to errors | Processing stats |

## Security Notes
- **ISSUE:** Spreadsheet ID uses placeholder `{{SPREADSHEET_ID}}` - should be actual ID.
- Hardcoded recipient email (`{{EMAIL}}`).
- Google Sheets credentials stored in n8n credential store.
- PostgreSQL credentials stored in n8n credential store.
- Gmail credentials stored in n8n credential store.

## Manual Fallback
```bash
# Manually sync a transaction
psql -U michal -d autonomous_finance -c "SELECT * FROM upsert_transaction_from_sheet('TX_001', '2026-04-01', 'expense', 45.00, 'PLN', 'Biedronka', 'Groceries', 'food', 'Food', 'Food');"
```