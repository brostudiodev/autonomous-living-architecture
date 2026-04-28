---
title: "G07: Withings Direct API Sync"
type: "automation_spec"
status: "active"
automation_id: "G07_withings_direct_sync.py"
goal_id: "goal-g07"
systems: ["S03", "S07"]
owner: "Michał"
updated: "2026-04-15"
---

# G07: Withings Direct API Sync

## Purpose
Directly synchronizes comprehensive body composition data from the Withings Health API to the central `autonomous_health.biometrics` database. This script replaces the legacy two-step Google Sheets synchronization to reduce latency, eliminate failure points, and capture additional metrics (muscle, bone, hydration).

## Key Features
- **Direct API Integration:** Connects directly to Withings OAuth2 API for high-reliability data fetching.
- **Comprehensive Metrics:** Tracks weight, body fat %, muscle mass, bone mass, and hydration.
- **Enhanced Data Fidelity:** Automatically calculates body fat percentage if mass data is available.
- **Idempotent Upsert:** Uses PostgreSQL `ON CONFLICT` logic to update daily records without duplication.
- **Audit Mode Support:** Includes a dedicated mode (`AUDIT_MODE=1`) for verifying API and database connectivity.

## Triggers
- **Automated:** Part of the `G11_global_sync.py` registry (runs multiple times daily).
- **Manual:** `python3 scripts/G07_withings_direct_sync.py`

## Inputs
- **API:** Withings Measure API (`getmeas`).
- **Database:** `autonomous_health` (Table: `biometrics`).
- **Credentials:** `withings_tokens.json` (OAuth2 tokens).

## Processing Logic
1.  **Authentication:** Loads and refreshes Withings OAuth2 tokens as needed.
2.  **Extraction:** Fetches the last 30 days of measurement groups from the Withings API.
3.  **Data Transformation:** 
    - Extracts weight, fat mass, muscle mass, bone mass, and hydration.
    - Calculates `body_fat_pct` (Fat Mass / Weight * 100).
4.  **Database Injection:** Upserts data into the `biometrics` table, updating existing records for the same date.

## Outputs
- **PostgreSQL:** Updated records in `autonomous_health.biometrics`.
- **System Activity Log:** Reports success/failure and the number of records processed.

## Dependencies
### Systems
- [S03 Data Layer](../../20_Systems/S03_Data-Layer/README.md)
- [G07 Predictive Health](../../10_Goals/G07_Predictive-Health-Management/README.md)

## Error Handling
| Failure Scenario | Detection | Response | Alert |
|---|---|---|---|
| Auth Token Expired | 401 Response | Attempts token refresh | System Activity Log |
| Refresh Token Expired | Refresh Fail | Logs error, requires manual rerun of `withings_to_sheets.py` | Console / Telegram |
| DB Connection Fail | `psycopg2` exception | Logs error, exits | System Activity Log |

## Manual Fallback
If weight data is missing:
1.  Verify the scale is syncing to the Withings Health app.
2.  Run `python3 scripts/G07_withings_direct_sync.py` manually.
3.  If tokens are dead, run `python3 scripts/withings_to_sheets.py` to trigger the browser-based OAuth2 flow.
