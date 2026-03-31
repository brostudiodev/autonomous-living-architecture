---
title: "G11_pre_flight_check.py: Sync Integrity Audit"
type: "automation_spec"
status: "active"
automation_id: "G11_pre_flight_check"
goal_id: "goal-g11"
systems: ["S11", "S03"]
owner: "Michal"
updated: "2026-03-13"
---

# G11: Pre-Flight Sync Integrity Check

## Purpose
Ensures that the Daily Note is not generated with stale data by verifying today's biometrics (Zepp) and weight (Withings) are present in the database. If missing, it attempts a manual sync before proceeding.

## Triggers
- **When:** Automatically triggered by `G11_global_sync.py` before the Daily Note generation.
- **Manual:** `python3 G11_pre_flight_check.py`

## Inputs
- **PostgreSQL Databases:** `autonomous_health` (biometrics table).
- **Environment:** Database credentials from `.env`.

## Processing Logic
1. **Initial Audit:** Queries the database for records matching `CURRENT_DATE`.
2. **Missing Data Detection:**
    - If `readiness_score` is missing → Triggers `G07_zepp_sync.py`.
    - If `weight_kg` is missing → Triggers `withings_to_sheets.py` followed by `G07_weight_sync.py`.
3. **Re-verification:** Performs a second query to confirm the new data was successfully ingested.
4. **Graceful Exit:** Provides a success/partial status report but allows the orchestrator to continue (preventing a system-wide block).

## Outputs
- **Console Log:** Detailed status of each critical data source.
- **Database State:** Updated biometric records for the current day.

## Dependencies
### Systems
- [S03 Data Layer](../../20_Systems/S03_Data-Layer/README.md)
- [G07 Predictive Health](../../10_Goals/G07_Predictive-Health-Management/README.md)

### External Services
- Zepp Cloud API (via sub-script)
- Withings API (via sub-script)

## Error Handling
| Failure Scenario | Detection | Response | Alert |
|---|---|---|---|
| DB Connection Failure | Exception in `psycopg2` | Log error, exit status 0 | Standard error log |
| Sub-sync Failure | Subprocess exit code != 0 | Log specific missing source | Part of global sync report |

## Monitoring
- **Success metric:** 100% data freshness for current day before Daily Note generation.

---
*Related Documentation:*
- [G11_global_sync.md](G11_global_sync.md)
- [G07_zepp_sync.md](G07_zepp_sync.md)
