---
title: "G04: Life Logistics Sync"
type: "automation_spec"
status: "active"
automation_id: "G04__logistics_sync"
goal_id: "goal-g04"
systems: ["S03", "S04"]
owner: "Michal"
updated: "2026-03-04"
---

# G04: Life Logistics Sync

## Purpose
Synchronizes critical life deadlines (passports, IDs, recurring payments, home maintenance) from the Master Google Sheet to a dedicated PostgreSQL database.

## Triggers
- **Daily:** Triggered via `G11_global_sync.py` during the morning block.
- **On-Demand:** Via `GET /logistics_sync` endpoint on the Digital Twin API.
- **Manual:** `python3 G04_logistics_sync.py`

## Inputs
- **Google Sheet:** `Life_Logistics` (ID: `[SPREADSHEET_ID]`)
- **Tabs:** Identity & Legal, Asset & Home Maintenance, Health & Prevention Calendar, Subscription & Warranty Registry, Personal Specs.
- **Credentials:** `google_credentials_digital-twin-michal.json`

## Processing Logic
1. Connects to `autonomous_life_logistics` PostgreSQL database.
2. Truncates the existing table to ensure a fresh "Source of Truth" sync.
3. Iterates through the 5 predefined tabs in the Google Sheet.
4. Parses dates and numeric values, handling empty fields.
5. **STATUS Capture (New):** Fetches the `STATUS` column (States: empty, DONE, REJECTED).
6. Inserts rows into the `autonomous_life_logistics` table, including the `status` field.
7. **Downstream Impact:** Digital Twin Engine, Calendar Sync, and Quick Wins now automatically filter out items where status is **'DONE'** or **'REJECTED'**.

## Outputs
- **Database Table:** `autonomous_life_logistics.public.autonomous_life_logistics`
- **Database Columns:** `id`, `category`, `item_name`, `due_date`, `amount`, `alert_threshold_days`, `notes`, `status`, `updated_at`.
- **Console Output:** Summary of synced entries per tab.

## Dependencies
### Systems
- [S03 Data Layer](../../20_Systems/S03_Data-Layer/README.md)
- [S04 Digital Twin](../../20_Systems/S04_Digital-Twin/README.md)

### External Services
- Google Sheets API

### Credentials
- Service Account JSON in `/scripts`

## Error Handling
| Failure Scenario | Detection | Response | Alert |
|---|---|---|---|
| API Quota Reached | HTTP 429 from Google | Wait and retry | Log Warning |
| DB Connection Fail | Connection Timeout | Check if Postgres container is running | Log Error |
| Invalid Date Format | Regex/Parser Exception | Skip row, log item name | Log Warning |

## Monitoring
- **Success Metric:** Total rows in DB matches Google Sheet row count (excluding headers).
- **Check:** `GET /audit` flags if logistics sync is older than 24h.

## Manual Fallback
```bash
cd {{ROOT_LOCATION}}/autonomous-living/scripts
./.venv/bin/python3 G04_logistics_sync.py
```
