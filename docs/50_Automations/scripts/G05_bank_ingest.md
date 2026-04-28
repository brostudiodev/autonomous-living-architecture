---
title: "G05_bank_ingest.py: Bank Statement CSV Ingestion"
type: "automation_spec"
status: "active"
automation_id: "g05-bank-ingest"
goal_id: "goal-g05"
systems: ["S03"]
owner: "Michał"
updated: "2026-03-02"
review_cadence: "Monthly"
---

# G05_bank_ingest.py

## Purpose
Provides a command-line interface for ingesting bank transaction statements exported as CSV files into the `autonomous_finance` database. It bridges the gap between manual bank exports and automated financial analysis.

## Scope
### In Scope
- Parsing CSV statements from common Polish banks (ING, mBank, etc.).
- Mapping CSV columns to the `transactions` table schema.
- Preventing duplicate entries via `transaction_id` hash and DB constraints.
- Cleaning and normalizing amount and currency data.

### Out of Scope
- Direct API integration with banks (handled by Q3 roadmap items).
- Real-time transaction monitoring.

## Triggers
- **Manual:** `python3 scripts/G05_bank_ingest.py <file_path> [bank_type]`

## Inputs
- **CSV File:** Exported bank statement.
- **Bank Type:** (Optional) Hint for column mapping (e.g., `ing`, `mbank`).
- **PostgreSQL:** `transactions` table schema.

## Processing Logic
1.  **File Validation:** Checks if the provided CSV path exists.
2.  **Mapping:** Identifies columns for date, description, amount, and merchant based on the bank type.
3.  **Normalization:** Converts European numeric formats (commas, spaces) to standard SQL floats.
4.  **Deduplication:** Generates a unique `transaction_id` hash for each row.
5.  **Ingestion:** Executes an `INSERT ... ON CONFLICT DO NOTHING` statement to ensure data integrity.

## Outputs
- **PostgreSQL:** New rows in the `transactions` table.
- **Console Log:** Count of successfully ingested transactions.

## Dependencies
### Systems
- [S03 Data Layer](../../20_Systems/S03_Data-Layer/README.md) - PostgreSQL persistence.

### External Services
- None (100% Local).

## Error Handling
| Failure Scenario | Detection | Response | Alert |
|---|---|---|---|
| Invalid Column Mapping | `KeyError` | Log mapping error and skip row | Console |
| DB Connection Fail | `psycopg2.connect()` | Exit with error | Console |
| Encoding Error | `UnicodeDecodeError` | Retry with `utf-8-sig` | Console |

## Security Notes
- **Privacy:** 100% Private. Financial statements are processed locally.
- **Credentials:** Uses DB credentials from `.env`.

## Manual Fallback
Transactions can be manually entered into the `transactions` table via SQL or the Google Sheets source.

## Related Documentation
- [Goal: G05 Autonomous Financial Command Center](../../10_Goals/G05_Autonomous-Financial-Command-Center/README.md)
- [System: S03 Data Layer](../../20_Systems/S03_Data-Layer/README.md)
