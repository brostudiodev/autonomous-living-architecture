---
title: "G07_zepp_sync.py: Biological Data Extraction"
type: "automation_spec"
status: "active"
automation_id: "zepp-health-sync"
goal_id: "goal-g07"
systems: ["S03", "S04"]
owner: "Michal"
updated: "2026-02-27"
---

# G07_zepp_sync.py

## Purpose
Automates the extraction of biometric data (Sleep, HRV, Readiness, Steps) from the Zepp (Huami) Cloud and injects it into the `autonomous_health` PostgreSQL database. This data is critical for calculating the **Biological Readiness Score** used in G10 for schedule optimization.

## Triggers
- **Scheduled:** Runs every 3 hours via n8n Schedule Trigger to capture sleep and activity updates.
- **On-Demand:** Can be triggered manually for real-time status updates via the Digital Twin.

## Inputs
- **Provider:** Huami/Zepp Cloud API (Credentials from `.env`).
- **Endpoint:** `/v1/data/band_data.json?query_type=summary`.

## Processing Logic
1.  **Authentication:** Uses `get_cached_token()` from `zepp_token.json` if available. If missing or invalid, performs a fresh login via `ZeppSession` and saves the new token.
2.  **Rate Limit Mitigation:** To avoid "429 Too Many Requests" errors from Zepp Cloud, the script aggressively reuses cached tokens.
3.  **Data Extraction:** Queries the Zepp Cloud for the latest summary data.
4.  **Decoding:** Decodes the Base64-encoded Huami payload.
5.  **Calculations:**
    - Extracts `slp.st` (start) and `slp.ed` (end) to determine the sleep window.
    - Calculates precise sleep duration from Unix epochs.
6.  **Persistence:** Upserts the data into `autonomous_health.biometrics`.

## Silent Success Feature
If a sync attempt fails (e.g., due to a temporary rate limit) but the database already contains fresh data for today or yesterday, the script will return **True (Success)**. This prevents false-positive "Failed" alerts in the Global Sync and Digital Twin briefings.

## Outputs
- **PostgreSQL (`autonomous_health`):**
    - Table: `biometrics` (Sleep start/end, quality, HRV, Readiness).
- **Obsidian Frontmatter:** (Via `autonomous_daily_manager.py`) Injects daily health stats into the current Daily Note.

## Dependencies
### Systems
- [S03 Data Layer](../../20_Systems/S03_Data-Layer/README.md) - PostgreSQL persistence.
- [S04 Digital Twin](../../20_Systems/S04_Digital-Twin/README.md) - Context for biometric state.

### External Services
- **Huami/Zepp Cloud API:** Primary data source.
- **psycopg2:** PostgreSQL adapter.

## Error Handling
| Failure Scenario | Detection | Response | Alert |
|---|---|---|---|
| Auth Failure | `ZeppSession` login error | Check `.env` for correct credentials | Console |
| API Timeout | `requests.exceptions.Timeout` | Exponential backoff (handled by orchestrator) | Log: "Zepp API Timeout" |
| DB Connection Fail | `psycopg2.connect()` | Exit script and log error | Console |
| Parsing Error | `KeyError` in JSON payload | Skip current update and log raw response | Console |

## Security Notes
- **Credential Protection:** Tokens and login credentials are never logged or stored in Git.
- **Local Storage:** All biometric data is stored locally in the `autonomous_health` database.

## Procedure
1.  **Daily:** Verify the previous night's sleep data is present in the Morning Briefing.
2.  **Weekly:** Check for any "Sync Lag" alerts in the Digital Twin.
3.  **Monthly:** Review long-term HRV trends for health baseline drift.

## Related Documentation
- [Goal: G07 Predictive Health Management](../../10_Goals/G07_Predictive-Health-Management/README.md)
- [System: S03 Data Layer](../../20_Systems/S03_Data-Layer/README.md)
