---
title: "Service: Financial AI Categorizer"
type: "automation"
status: "active"
owner: "Michał"
updated: "2026-04-10"
---

# SVC_Financial-AI-Categorizer

## Purpose
The Financial AI Categorizer is an "Automated Bookkeeping" engine that analyzes uncategorized transactions and assigns them to the most appropriate budget categories. It uses merchant metadata and transaction descriptions to maintain the integrity of the financial dashboard without manual intervention.

## Scope
- **In Scope:** Categorizing transactions with `category_id` in (24, 37) [Uncategorized/Pending] from the last 90 days.
- **Out Scope:** Initial bank ingestion (handled by G05_bank_ingest) or budget rebalancing (handled by G05_budget_rebalancer).

## Logic (Managed by n8n)
> ⚠️ **Note:** The core logic of this service is managed within **n8n**.

1.  **Data Harvesting:** 
    - Fetches active category list (IDs and names) from `autonomous_finance.categories`.
    - Fetches up to 20 unapproved transactions from `autonomous_finance.transactions`.
2.  **LLM Categorization:** Uses **Gemini 2.5 Flash** with a specialized prompt to match merchant descriptions to category IDs.
3.  **Confidence Scoring:** The LLM assigns a confidence level (HIGH/MEDIUM/LOW) and a reasoning string for each classification.
4.  **Data Repair & Validation:** 
    - **Aggressive JSON Repair:** Strips markdown fences (` ```json `) and employs regex-based object extraction to handle malformed LLM outputs.
    - **Deduplication:** Ensures each `transaction_id` is processed only once (first occurrence wins).
    - **ID Verification:** Cross-references proposed category IDs against the valid list fetched in step 1.
5.  **Persistence:** Performs a batch update to the `transactions` table, updating `category_id`, `ai_confidence`, and `ai_reasoning`.

## Inputs/Outputs
- **Inputs:**
  - Database: `autonomous_finance.categories`, `autonomous_finance.transactions`
- **Outputs:**
  - Database: `autonomous_finance.transactions` (Updates)
  - Notifications: Gmail alerts for fetch/LLM/update failures.

## Dependencies
- **Systems:** PostgreSQL (S03 - `autonomous_finance` database).
- **Services:** n8n, Google Gemini API.
- **Credentials:** `Postgres account autonomous_finance docker`, `Google Gemini(PaLM) Api account 2`.

## Procedure (Execution)
- **Schedule:** Runs daily at 10:00 via Cron (`0 10 * * *`).
- **Manual Trigger:** Can be executed via n8n UI for immediate cleanup of new imports.

## Failure Modes
| Scenario | Detection | Response |
|----------|-----------|----------|
| Database Credential Error | Postgres node failure | Ensure `autonomous_finance` credential is used (ID: `zrLunD1UbOGzqNzS`) |
| Invalid Category Mapping | Validation Code node failure | LLM proposed an ID not in the valid list; check category sync |
| Rate Limiting | Gemini API error | Notify via Gmail; workflow will retry on next schedule |

## Security Notes
- Processes sensitive financial transaction data.
- Merchant names and amounts are sent to the LLM for analysis but no account numbers or PII (Personal Identifiable Information) are exposed.
