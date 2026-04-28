---
title: "G03: Price Sync Blix"
type: "automation_spec"
status: "active"
automation_id: "G03_price_sync_blix"
goal_id: "goal-g03"
systems: ["S03"]
owner: "Michał"
updated: "2026-04-28"
---

# G03: Price Sync Blix

## Purpose
Automates the ingestion of retail price promotions from Polish aggregators (e.g., blix.pl, Lidl, Biedronka) into the `pantry_prices` table.

## Triggers
- **Scheduled:** Every Monday morning via `G11_global_sync.py`
- **Manual:** `{{ROOT_LOCATION}}/autonomous-living/.venv/bin/python3 G03_price_sync_blix.py`

## Inputs
- **External:** Retail aggregator data (currently simulated via high-fidelity mock).
- **Environment Variables:** `DB_PASSWORD`, `DB_HOST`.

## Processing Logic
1. Connect to `autonomous_pantry` database.
2. Fetch current promotions for common household categories (Mleko, Kawa, etc.).
3. Upsert data into `pantry_prices` table using `category` and `store_name` as unique keys.
4. Log activity to `system_activity_log`.

## Outputs
- **Database:** Updated `pantry_prices` table in `autonomous_pantry`.
- **Logs:** SUCCESS/FAILURE entry in `digital_twin_michal.system_activity_log`.

## Dependencies
### Systems
- [S03 Data Layer](../../20_Systems/S03_Data-Layer/README.md)

### External Services
- Retail Aggregator APIs (future) / Scraper logic.

### Credentials
- PostgreSQL `root` credentials (via `.env`).

## Error Handling
| Failure Scenario | Detection | Response | Alert |
|---|---|---|---|
| DB Connection Fail | Script crash / Log | Retry via `G11_global_sync` (3 attempts) | Log Failure |
| Empty Data | 0 rows ingested | Log Warning | Log Warning |

## Monitoring
- Success metric: Number of prices updated in `pantry_prices`.
- Dashboard: G03 Price Intelligence Dashboard (Grafana).
