---
title: "SOP: Bank Data Ingestion"
type: "sop"
status: "active"
owner: "Michał"
updated: "2026-03-02"
---

# SOP: Bank Data Ingestion

## 📝 Purpose
Standard procedure for manually ingesting bank statements into the `autonomous_finance` database until full PSD2 API integration is achieved (Q3).

## 🛠️ Prerequisites
- CSV export from bank (ING, mBank, etc.).
- Access to the `autonomous-living` repository and Python environment.

## 🚀 Procedure

### 1. File Preparation
1.  Download the CSV statement from your bank's online portal.
2.  Place the file in a temporary directory (e.g., `~/Downloads/statements/`).

### 2. Execution
Run the ingestion script from the `scripts/` directory:
```bash
cd {{ROOT_LOCATION}}/autonomous-living/scripts
../.venv/bin/python3 G05_bank_ingest.py /path/to/statement.csv [bank_type]
```
*Replace `[bank_type]` with `ing` or `mbank` if supported, otherwise leave as `generic`.*

### 3. Verification
1.  Check the console output for "Successfully ingested X new transactions."
2.  Verify the new transactions appear in the `v_upcoming_30_days` view or your Finance Dashboard.

### 4. Cleanup
1.  Delete the temporary CSV file after successful ingestion to protect your privacy.

## ⚠️ Troubleshooting
| Issue | Cause | Resolution |
|---|---|---|
| 0 transactions ingested | Duplicate IDs | The script ignores transactions already in the DB. |
| CSV Parsing Error | Unknown format | Update `G05_bank_ingest.py` mapping logic. |
| DB Connection Fail | Postgres Offline | Restart the PostgreSQL Docker container. |
