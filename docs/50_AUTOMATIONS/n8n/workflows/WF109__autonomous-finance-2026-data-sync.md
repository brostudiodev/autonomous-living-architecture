---
title: "WF109: Autonomous Finance - 2026 Data Sync"
type: "automation_spec"
status: "active"
automation_id: "WF109__autonomous-finance-2026-data-sync"
goal_id: "goal-g05"
systems: ["S03", "S08"]
owner: "Michał"
updated: "2026-02-18"
---

# WF109: Autonomous Finance - 2026 Data Sync

## Purpose
This workflow automates the ingestion of financial transaction data from a designated Google Sheet ("Transactions" tab) into the PostgreSQL `autonomous_finance` database, ensuring that the Digital Twin (G04) and Autonomous Financial Command Center (G05) have up-to-date transaction records.

## Triggers
- **When:** Scheduled to run every 12 hours (cron expression `0 */12 * * *`).

## Inputs
- **Google Sheet:** "Zestawienie_finansowe-2026_FG_AI" (Document ID `1CUhzhuPXT3EoF4m35c7SRLhhqzX3NHWG4SWosGeGPzw`), specifically the "Transactions" sheet.
    *   **Expected Columns:** `Month`, `Day`, `Merchant/Source`, `Amount`, `Type`, `Account`, `Description`, `Transaction_ID`, `Date`, `Currency`, `Category`, `Sub-Category`.
-   **PostgreSQL Database:** `autonomous_finance` for existing reference data (accounts, categories, merchants).

## Processing Logic
1.  **Schedule Trigger:** Initiates the workflow every 12 hours.
2.  **Read Transactions Sheet:** Reads all rows from the specified "Transactions" Google Sheet.
3.  **Filter & Transform 2026 Data:**
    *   Filters out empty or invalid rows.
    *   Parses transaction date from `Month`/`Day` columns (prioritized) or `Date` column.
    *   Filters transactions to include only those for the year 2026.
    *   Transforms and validates data into a structured format suitable for PostgreSQL.
4.  **Upsert to PostgreSQL:** Calls the `upsert_transaction_from_sheet` PostgreSQL function for each valid transaction, which handles:
    *   Resolution of `account_id`, `category_id`.
    *   Auto-creation of new merchants if `merchant_source` is not found.
    *   Inserts new transactions or updates existing ones based on `transaction_id` and `transaction_date`.
5.  **Generate Sync Report:** Compiles a report summarizing the processing and database upsert results, including counts of successful upserts and any errors.
6.  **Check for Errors:** Conditional check to determine if any errors occurred during the sync.
7.  **Format Error Alert:** If errors are detected, formats a detailed error message.
8.  **Send Error Alert Email:** If an error alert is formatted, sends it to `{{EMAIL}}`.

*(Note: Several disconnected PostgreSQL nodes are present in the workflow, such as "Daily Health Check", "Missing Merchant Auto-Creation", "Data Integrity Validation", "Updated data validation", "Category Distribution Check", "Weekly validation", "SQL Query Validation". These appear to be for ad-hoc monitoring or additional checks outside the main data ingestion flow.)*

## Outputs
-   **PostgreSQL Database:** Updated `transactions` table in `autonomous_finance` database. New entries in `merchants` table if new merchant sources are encountered.
-   **Email Notification:** Error alerts sent to `{{EMAIL}}` if sync issues occur.
-   **n8n Execution Log:** Detailed logs of workflow execution and any errors.

## Dependencies
### Systems
-   [S03 Data Layer](../../20_SYSTEMS/S03_Data-Layer/README.md) (PostgreSQL `autonomous_finance` database)
-   [S08 Automation Orchestrator](../../20_SYSTEMS/S08_Automation-Orchestrator/README.md) (n8n instance)

### External Services
-   Google Sheets API (for reading transaction data)
-   PostgreSQL database service

### Credentials
-   `Google Sheets account` (n8n credential, Service Account with Editor access to financial Google Sheet).
-   `Postgres account autonomous_finance docker` (n8n credential, with access to `autonomous_finance` database).
-   `Gmail account` (n8n credential for sending email alerts).

## Error Handling
-   **Data Validation:** Performed in the "Filter & Transform 2026 Data" node (e.g., empty rows, invalid amounts, date parsing).
-   **Database Upsert:** `upsert_transaction_from_sheet` function handles invalid accounts/categories, auto-creates merchants, and uses `ON CONFLICT` to prevent duplicates. Returns JSON with `success` flag and `error` messages.
-   **Reporting:** A sync report is generated, and error alerts are sent via email for `PARTIAL_SUCCESS` or `FAILURE` states.
-   **Node Failure:** The "Upsert to PostgreSQL" node has `continueOnFail: true` to allow the workflow to continue and report multiple errors.

## Monitoring
-   **Frequency:** Every 12 hours.
-   **Alert on:** `PARTIAL_SUCCESS` or `FAILURE` status in the generated sync report, sent via email.
-   **Dashboard:** Financial dashboards (expected in G05) will reflect data updates.
-   **Heartbeat Monitor:** This workflow should be monitored by `SVC_Workflow-Heartbeat-Monitor` (WF112) to ensure it runs on schedule.

## Manual Fallback
If automation fails:
1.  Review n8n execution logs for detailed error messages.
2.  Correct data directly in the Google Sheet.
3.  Manually re-run the workflow in n8n for the affected period or data.
4.  If PostgreSQL issues, consult `P - Finance - Autonomous_Financial_Command_Center_Implementation_Guide.md` troubleshooting.
