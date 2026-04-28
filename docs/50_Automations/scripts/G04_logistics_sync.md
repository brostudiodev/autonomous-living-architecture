---
title: "G04: Life Logistics Sync"
type: "automation_spec"
status: "active"
automation_id: "G04__logistics_sync"
goal_id: "goal-g04"
systems: ["S03", "S04"]
owner: "Michał"
updated: "2026-04-14"
---

# G04: Life Logistics Sync (v2.0 - Zero-Clobber)

## Purpose
Synchronizes critical life deadlines (passports, IDs, recurring payments, home maintenance) and yearly events (birthdays, anniversaries) from the Master Google Sheet to a dedicated PostgreSQL database.

## Triggers
- **Daily:** Triggered via `G11_global_sync.py` during the morning block.
- **On-Demand:** Via `GET /logistics_sync` endpoint on the Digital Twin API.
- **Manual:** `python3 G04_logistics_sync.py`

## Inputs
- **Google Sheet:** `Life_Logistics` (ID: `{{LONG_IDENTIFIER}}`)
- **Tabs:** Identity & Legal, Asset & Home Maintenance, Health & Prevention Calendar, Subscription & Warranty Registry, Personal Specs, Anniversaries.
- **Credentials:** `google_credentials_digital-twin-michal.json`

## Processing Logic
1. Connects to `autonomous_life_logistics` PostgreSQL database.
2. **Zero-Clobber UPSERT (Apr 13):** No longer uses TRUNCATE. Instead, it uses `ON CONFLICT` to preserve manual status changes (DONE/REJECTED) while updating metadata.
3. Iterates through the 6 predefined tabs in the Google Sheet.
4. **Anniversaries Tab (NEW Apr 14):** Specialized handling for yearly recurring events. Ingests Name, Relationship, and Original Date.
5. Parses dates and numeric values, handling empty fields.
6. **Post-Sync Cleanup:**
    - Items missing from the logistics tabs are marked as `DONE` in the database.
    - Items missing from the `Anniversaries` tab are deleted from the database.
7. **Downstream Impact:** `G04_life_sentinel.py` now monitors both standard expirations and yearly anniversaries.

## Outputs
- **Database Tables:** 
    - `autonomous_life_logistics` (Standard items)
    - `anniversaries` (Yearly recurring items)
- **Database Columns (Logistics):** `id`, `category`, `item_name`, `due_date`, `amount`, `alert_threshold_days`, `notes`, `status`, `last_synced_at`, `updated_at`.
- **Database Columns (Anniversaries):** `id`, `name`, `relationship_type`, `original_date`, `alert_threshold_days`, `last_synced_at`, `updated_at`.

## Dependencies
...

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
