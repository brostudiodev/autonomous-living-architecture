---
title: "G07_zepp_sync: Biological Truth Synchronizer"
type: "automation_spec"
status: "active"
automation_id: "G07_zepp_sync"
goal_id: "goal-g07"
systems: ["S03", "S06"]
owner: "Michał"
updated: "2026-03-28"
---

# G07_zepp_sync: Biological Truth Synchronizer

## Purpose
Automates the extraction of biometric data from the Zepp (Amazfit) cloud into the `autonomous_health` database. This data is the "Biological Truth" used for readiness-based scheduling and health trend analysis.

## Triggers
- **Scheduled:** Daily at 06:15, 13:15, 16:15 via `G11_obsidian_safe_sync.py` (crontab).
- **Retry Logic:** Integrated into `G11_global_sync.py` with a 3-attempt loop (10-min intervals) if data is missing.
- **Manual:** `python scripts/G07_zepp_sync.py`

## Inputs
- **API:** Zepp (Huami) Cloud API.
- **Cache:** `zepp_token.json` for session persistence.
- **Environment:** `ZEPP_EMAIL`, `ZEPP_PASSWORD`.

## Processing Logic
1. **Freshness Audit:** Checks if `sleep_score > 0` already exists for `CURRENT_DATE`.
2. **Authentication:** Uses cached token or performs a fresh login via `huami_token.zepp`.
3. **Extraction:** Pulls summaries for the last 3 days to catch gaps.
4. **Biometric Sanity Guard:** Implements a strict filter for HRV values. Values < 5ms or > 250ms are rejected as pathological/sensor glitches and marked as unknown (0) to prevent incorrect recovery advice.
5. **Readiness Calculation:** Applies internal algorithm considering Sleep Score, HRV, and RHR.
6. **Hard Verification:** During the morning window (before 09:00), the script reports **FAILURE** if today's sleep data is missing, triggering the global retry loop.
7. **Upsert:** Merges data into `biometrics` and `sleep_log` tables.

## Outputs
- **Database:** Updated `biometrics` and `sleep_log` rows.
- **Console:** Sync status and readiness score summary.

## Dependencies
### Systems
- [S03 Data Layer](../../20_Systems/S03_Data-Layer/README.md)
- [S06 Health Performance](../../20_Systems/S06_Health-Performance/README.md)

### External Services
- Zepp Cloud Services

## Error Handling
| Scenario | Detection | Response |
|----------|-----------|----------|
| Cloud Delay | Data missing before 09:00 | Return `False` to trigger retry |
| Auth Failure | 401/403 Status | Clear cache and re-login |
| Rate Limit | 429 Status | Log warning, skip sync |

## Monitoring
- **Success metric:** 100% of Daily Notes populated with today's biometrics by 07:00.
- **Dashboard:** `v_health_sync_status` view.

## Changelog
| Date | Change |
|------|--------|
| 2026-03-04 | Initial Amazfit API integration |
| 2026-03-27 | Added morning failure reporting for retry logic |
| 2026-03-28 | Hardened freshness check (`sleep_score > 0`) and shifted crontab to 06:15 |
| 2026-04-15 | Migrated hardcoded timezone to centralized `db_config.TIMEZONE` |
