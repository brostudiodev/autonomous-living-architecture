---
title: "Financial Data Ingestion & Notification Pipeline"
type: "technical_specification"
status: "active"
system_id: "system-s03-finance-pipeline"
owner: "Michał"
updated: "2026-03-01"
---

# Financial Data Ingestion & Notification Pipeline

## Overview
This document details the cross-system architecture for synchronizing manual financial records from Google Sheets into the `autonomous_finance` PostgreSQL database and the subsequent real-time notification mechanism.

## Data Flow Sequence

### 1. Source: Manual Entry (Google Sheets)
- **Component:** Google Sheet `Zestawienie_finansowe-2026_FG_AI`
- **Tabs:** `Transactions`, `Budget`, `Expense Calendar`
- **User Action:** Michał adds/updates rows in the spreadsheet.

### 2. Ingestion: n8n Orchestration
- **Workflow:** [WF109: Autonomous Finance - 2026 Data Sync](../../50_Automations/n8n/workflows/WF109__autonomous-finance-2026-data-sync.md)
- **Trigger:** 
    - **Scheduled:** Every 12 hours (`0 */12 * * *`).
    - **Manual:** Triggered via `G11_global_sync.py` or Digital Twin API `/sync`.
- **Logic:** Reads all rows, filters for the current year, and calls the Postgres `upsert_transaction_from_sheet` function.

### 3. Persistence: PostgreSQL Upsert
- **Component:** `autonomous_finance` DB
- **Function:** `upsert_transaction_from_sheet()`
- **Mechanism:** Uses `ON CONFLICT (transaction_id, transaction_date)` to update existing records or insert new ones. It also handles date changes by deleting old IDs if the date has shifted in the spreadsheet.

### 4. Trigger: Real-time Notification (`pg_notify`)
- **Component:** PostgreSQL Triggers `trg_notify_transaction_update` and `trg_notify_budget_update`.
- **Function:** `notify_finance_update()`
- **Logic:**
    ```sql
    PERFORM pg_notify('finance_update', json_build_object(
        'table', TG_TABLE_NAME,
        'action', TG_OP
    )::text);
    ```
- **Purpose:** Dispatches a JSON signal over the PostgreSQL `LISTEN/NOTIFY` protocol to any connected clients.

### 5. Consumption: Real-time Refresh
- **Listeners:**
    - **n8n:** Can listen for `finance_update` to trigger downstream budget alerts (WF111).
    - **Grafana:** Uses the notification to refresh dashboard panels immediately (if configured with streaming or short refresh intervals).

## Monitoring & Manual Fallback
- **Sync Status:** Checked daily via `G11_ceo_status_report.py`.
- **Manual Sync:** Run `python3 scripts/G11_global_sync.py` to force an immediate pull from Google Sheets.
- **Verification:** Query the DB directly:
  ```sql
  SELECT MAX(updated_at) FROM transactions;
  ```

## Traceability
| Goal | System | Workflow | DB Function |
|---|---|---|---|
| G05 | S03 Data Layer | WF109 | `upsert_transaction_from_sheet` |
| G05 | S08 Automation | WF110 | `upsert_budget_from_sheet` |
