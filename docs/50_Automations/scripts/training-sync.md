---
title: "script: Training Data Sync"
type: "automation_spec"
status: "active"
automation_id: "training-sync"
goal_id: "goal-g01"
systems: ["S03", "S08"]
owner: "Michal"
updated: "2026-02-25"
---

# script: training-sync

## Purpose
Automates the bidirectional synchronization of training data (workouts, sets, measurements) between the user-facing Google Sheet (`Training_Journal`) and the canonical PostgreSQL database (`autonomous_training`). This script replaces the legacy GitHub Actions CSV workflow.

## Triggers
- **Scheduled:** Part of the `G11_global_sync` registry (triggered on-demand or by schedule).
- **Manual:** `python3 scripts/training_sync.py`.

## Inputs
- **Google Sheet:** `Training_Journal` (ID: `1L56kLlHljvgkug4XWZ6N2VwTGHosqcqzsjF_2oPatBg`)
  - Worksheets: `workouts`, `sets`, `measurements`.
- **Credentials:** `google_credentials_digital-twin-michal.json` (Service Account).

## Processing Logic
1. **Connect:** Authenticate with Google Sheets API using the dedicated Digital Twin service account.
2. **Fetch:** Retrieve all records from `workouts`, `sets`, and `measurements` sheets.
3. **Parse & Transform:**
   - Convert date strings to Python date objects.
   - Clean numeric values (handle Polish commas, strip units).
   - Convert boolean strings to native `True`/`False`.
4. **Upsert:** Execute PostgreSQL functions (`upsert_workout_from_sheet`, `upsert_set_from_sheet`, `upsert_measurement_from_sheet`) to insert new records or update existing ones based on primary keys.

## Outputs
- **PostgreSQL (`autonomous_training`):** Updated rows in `workouts`, `workout_sets`, and `measurements` tables.
- **Logs:** Console output indicating sync status and record counts.

## Dependencies
### Systems
- [S03 Data Layer](../../../20_Systems/S03_Data-Layer/README.md) - PostgreSQL database.
- [S08 Automation Orchestrator](../../../20_Systems/S08_Automation-Orchestrator/README.md) - Execution environment.

### External Services
- **Google Sheets API:** Source of training data.

### Credentials
- `google_credentials_digital-twin-michal.json`: Service account key with access to the Training Journal sheet.

## Failure Modes
| Scenario | Detection | Response | Alert |
|---|---|---|---|
| Sheets API Error | 403/404 Exception | Script logs error and exits | Console / Twin Health |
| DB Connection Fail | OperationalError | Script logs error and exits | Console / Twin Health |
| SQL Function Missing | UndefinedFunction | Script logs error (schema mismatch) | Console |

## Manual Fallback
Use `smart_log_workout.py` to log directly to the database if the Google Sheet sync is unavailable.
