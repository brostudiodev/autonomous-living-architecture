---
title: "G05: Financial Data Synchronization Engine"
type: "automation_spec"
status: "active"
automation_id: "G05_finance_sync.py"
goal_id: "goal-g05"
systems: ["S03", "S05"]
owner: "Michał"
updated: "2026-04-18"
---

# G05: Financial Data Synchronization Engine

## Purpose
Orchestrates the bidirectional transfer of financial records (Transactions and Budgets) between the primary Google Sheet and the PostgreSQL `autonomous_finance` database. This script ensures high-fidelity data alignment between the planning layer (Sheets) and the execution layer (Postgres/Autonomous Rebalancing).

## Key Features
- **Bidirectional Sync:** Can sync data from Sheets to DB (default) and from DB back to Sheets (`--to-sheets` flag).
- **Autonomous Tracking:** Automatically adds and populates `AI changes` and `AI date` columns in Google Sheets to track modifications made by the Digital Twin.
- **Hybrid Operation Logic:** Works in tandem with n8n workflows (WF109/WF110) using shared database functions.

## Triggers
- **Automated (Sheets -> DB):** Part of the `G11_global_sync.py` registry.
- **Automated (DB -> Sheets):** Triggered by `G05_budget_rebalancer.py --execute`.
- **Manual:** 
  - `python3 scripts/G05_finance_sync.py` (Sheets to DB)
  - `python3 scripts/G05_finance_sync.py --to-sheets` (DB to Sheets)

## Inputs
- **Google Sheet ID:** `{{SPREADSHEET_ID}}`
- **Worksheets:** `Budget` (for planning), `Transactions` (for actuals).
- **Credentials:** `google_credentials_digital-twin-michal.json` (Service Account).

## Processing Logic (DB -> Sheets)
1.  **Fetch Active Budgets:** Retrieves all active budgets for the current month from PostgreSQL.
2.  **Header Verification:** Checks if `AI changes` and `AI date` columns exist in the `Budget` worksheet; creates them if missing.
3.  **Delta Detection:** Compares DB amounts with Sheet amounts using `budget_id` matched against the Sheet's `Transaction_ID` column.
4.  **Batch Update:** Updates changed rows in a single API call (`update_cells`) including a description of the change and a timestamp.

## Changelog
- **2026-03-20:** Corrected matching logic to use `budget_id` (matched to `Transaction_ID` column in Budget tab). Removed dependency on non-existent `subcategories` table.

## Outputs
- **PostgreSQL:** Updated `budgets` and `transactions` tables.
- **Google Sheets:** Updated `Budget_Amount`, `AI changes`, and `AI date` columns.
- **Centralized Logging:** Reports `SUCCESS` or `FAILURE` to `system_activity_log`.

## Dependencies
### Systems
- [S03 Data Layer](../../20_Systems/S03_Data-Layer/README.md)
- [S05 Finance System](../../10_Goals/G05_Autonomous-Financial-Command-Center/README.md)

### External Services
- Google Sheets API
- Google Drive API

## Error Handling
| Failure Scenario | Detection | Response | Alert |
|---|---|---|---|
| Sheet ID Not Found | `gspread` exception | Log error, abort sync | System Activity Log |
| Column Missing | `ValueError` in index | Script creates missing columns | Log info |
| Auth Expired | API 401 error | Log failure | CRITICAL Log alert |

## Manual Fallback
If data remains stale:
1.  Verify the Google Sheet connectivity.
2.  Run `python3 scripts/G05_finance_sync.py --to-sheets` manually to verify DB-to-Sheet flow.
3.  Check the `AI changes` column in the Google Sheet for the last recorded autonomous action.
