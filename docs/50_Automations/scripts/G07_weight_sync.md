---
title: "G07: Weight & Body Composition Sync"
type: "automation_spec"
status: "active"
automation_id: "G07_weight_sync.py"
goal_id: "goal-g07"
systems: ["S03", "S07"]
owner: "Michal"
updated: "2026-03-20"
---

# G07: Weight & Body Composition Sync

## Purpose
Automates the transfer of weight and body fat data from the Withings Smart Scale (via Google Sheets) to the central PostgreSQL `autonomous_health` database. It ensures that biological baselines for G01 (Target Body Fat) are maintained with high fidelity and transparency.

## Key Features
- **Bidirectional Traceability:** Updates the source Google Sheet with `AI changes` and `AI date` columns to mark records successfully processed by the system.
- **Automatic Calculation:** Calculates `body_fat_pct` if only weight and fat mass are provided in the source data.
- **Idempotent Upsert:** Uses PostgreSQL `ON CONFLICT` logic to ensure data is updated rather than duplicated if sync is re-run.
- **Audit Mode Support:** Includes a dedicated mode for verifying database and sheet connectivity without modifying data.

## Triggers
- **Automated:** Part of the `G11_global_sync.py` registry.
- **Manual:** `python3 scripts/G07_weight_sync.py`

## Inputs
- **Google Sheet:** `Training_Journal`, Worksheet: `Withings_API`.
- **Database:** `autonomous_health` (Table: `biometrics`).
- **Credentials:** `google_credentials.json` (Service Account).

## Processing Logic
1.  **Extraction:** Reads all records from the `Withings_API` worksheet.
2.  **Tracking Check:** Identifies records that haven't been processed by the AI (where `AI changes` is empty).
3.  **Data Transformation:** Parses dates and calculates body fat percentages.
4.  **Database Injection:** Upserts data into the `biometrics` table.
5.  **Source Attribution:** Batch updates the Google Sheet to mark processed rows with a description and timestamp.

## Outputs
- **PostgreSQL:** Updated `weight_kg` and `body_fat_pct` in the `biometrics` table.
- **Google Sheets:** Populated `AI changes` and `AI date` columns in the source sheet.
- **Activity Log:** Reports processing results to the terminal and system logs.

## Dependencies
### Systems
- [S03 Data Layer](../../20_Systems/S03_Data-Layer/README.md)
- [G01 Target Body Fat](../../10_Goals/G01_Target-Body-Fat/README.md)

## Error Handling
| Failure Scenario | Detection | Response | Alert |
|---|---|---|---|
| Sheet Missing | `gspread` exception | Logs error, exits | Console |
| DB Connection Fail | `psycopg2` exception | Logs error, exits | System Activity Log |
| Row Parse Error | `try-except` block | Skips row, continues | Console Warning |

## Manual Fallback
If weight data is missing from the dashboard:
1.  Verify Withings scale is syncing to the Google Sheet.
2.  Run `python3 scripts/G07_weight_sync.py` manually to force a database refresh.
3.  Check the `AI changes` column in the sheet to see if the record was attempted.
