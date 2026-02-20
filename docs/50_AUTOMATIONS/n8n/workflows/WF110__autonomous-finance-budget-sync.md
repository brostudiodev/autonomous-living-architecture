---
title: "WF110: Autonomous Finance - Budget Sync"
type: "automation_spec"
status: "active"
automation_id: "WF110__autonomous-finance-budget-sync"
goal_id: "goal-g05"
systems: ["S03", "S08"]
owner: "{{OWNER_NAME}}"
updated: "2026-02-18"
---

# WF110: Autonomous Finance - Budget Sync

## Purpose
This workflow automates the synchronization of budget definitions from a designated Google Sheet ("Budget" tab) into the PostgreSQL `autonomous_finance` database. This ensures that budget alerts (WF111) and financial performance monitoring (G05 dashboards) are based on the latest budget configurations.

## Triggers
-   **When:** Scheduled to run every 12 hours (cron expression `0 */12 * * *`).

## Inputs
-   **Google Sheet:** "Zestawienie_finansowe-2026_FG_AI" (Document ID `1CUhzhuPXT3EoF4m35c7SRLhhqzX3NHWG4SWosGeGPzw`), specifically the "Budget" sheet.
    *   **Expected Columns (in `Transform & Validate Budget Data` node):** `Transaction_ID` (used as `budget_id`), `Year`, `Month`, `Type`, `Category`, `Sub-Category`, `Budget_Amount`, `Alert_Threshold`, `Notes`, `Budget_Type`, `Priority`, `Active`.
-   **PostgreSQL Database:** `autonomous_finance` for existing reference data (categories).

## Processing Logic
1.  **Schedule Trigger:** Initiates the workflow every 12 hours.
2.  **Read Budget Sheet:** Reads all rows from the specified "Budget" Google Sheet.
3.  **Transform & Validate Budget Data:**
    *   Filters out empty rows and inactive budgets.
    *   Parses and validates various budget fields (e.g., amount, boolean flags, integers).
    *   Validates required fields (`Transaction_ID`, `Year`, `Month`, `Type`, `Category`, `Sub-Category`, `Budget_Type`, `Priority`).
    *   Transforms data into a structured format suitable for the `upsert_budget_from_sheet` PostgreSQL function.
4.  **Upsert Budgets to PostgreSQL:** Calls the `upsert_budget_from_sheet` PostgreSQL function for each valid budget entry. This function handles:
    *   Resolution of `category_id`.
    *   Inserts new budget entries or updates existing ones based on `budget_id`.
5.  **Generate Budget Sync Report:** Compiles a report summarizing the budget processing and database upsert results, including counts of inserted/updated budgets and any errors.
6.  **Check for Budget Errors:** Conditional check to determine if any errors occurred during the sync.
7.  **Send Error Alert Email:** If errors are detected, sends a detailed error message to `{{EMAIL}}`.

## Outputs
-   **PostgreSQL Database:** Updated `budgets` table in `autonomous_finance` database.
-   **Email Notification:** Error alerts sent to `{{EMAIL}}` if sync issues occur.
-   **n8n Execution Log:** Detailed logs of workflow execution and any errors.

## Dependencies
### Systems
-   [S03 Data Layer](../../20_SYSTEMS/S03-Data-Layer/README.md) (PostgreSQL `autonomous_finance` database)
-   [S08 Automation Orchestrator](../../20_SYSTEMS/S08-Automation-Orchestrator/README.md) (n8n instance)

### External Services
-   Google Sheets API (for reading budget data)
-   PostgreSQL database service

### Credentials
-   `Google Sheets account` (n8n credential, Service Account with Editor access to financial Google Sheet).
-   `Postgres account autonomous_finance docker` (n8n credential, with access to `autonomous_finance` database).
-   `Gmail account` (n8n credential for sending email alerts).

## Error Handling
-   **Data Validation:** Extensive validation performed in the "Transform & Validate Budget Data" node (e.g., parsing, required fields, active status).
-   **Database Upsert:** `upsert_budget_from_sheet` function handles invalid categories and uses `ON CONFLICT` to update existing budgets. Returns JSON with `success` flag and `error` messages.
-   **Reporting:** A sync report is generated, and error alerts are sent via email for `PARTIAL_SUCCESS` or `FAILURE` states.
-   **Node Failure:** The "Upsert Budgets to PostgreSQL" node has `continueOnFail: true` to allow the workflow to continue and report multiple errors.

## Monitoring
-   **Frequency:** Every 12 hours.
-   **Alert on:** `PARTIAL_SUCCESS` or `FAILURE` status in the generated sync report, sent via email.
-   **Dashboard:** Financial dashboards (expected in G05) will reflect budget updates.
-   **Heartbeat Monitor:** This workflow should be monitored by `SVC_Workflow-Heartbeat-Monitor` (WF112) to ensure it runs on schedule.

## Manual Fallback
If automation fails:
1.  Review n8n execution logs for detailed error messages.
2.  Correct data directly in the "Budget" Google Sheet.
3.  Manually re-run the workflow in n8n.
4.  If PostgreSQL issues, consult `P - Finance - Autonomous_Financial_Command_Center_Implementation_Guide.md` troubleshooting.
