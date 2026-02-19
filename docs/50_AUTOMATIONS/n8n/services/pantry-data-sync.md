---
title: "service: Autonomous Pantry - Data Sync"
type: "automation_spec"
status: "active"
automation_id: "pantry-data-sync"
goal_id: "goal-g03"
systems: ["S03", "S08"]
owner: "Michał"
updated: "2026-02-19"
---

# service: Autonomous Pantry - Data Sync

## Purpose
Automates the synchronization of household inventory data from Google Sheets to the `autonomous_pantry` PostgreSQL database. It handles the translation from Polish UI headers to English schema columns and maintains a synchronized dictionary of AI synonyms.

## Triggers
- **Scheduled:** Every 12 hours via n8n Schedule Trigger.
- **Manual:** Can be triggered within n8n UI for immediate refresh.

## Inputs
- **Google Sheet:** `Magazynek_domowy` (ID: `10knY7Tnh5iNLooAxQ8OjI0sRJ-2l0t3rH5ABdVuvFAM`).
- **Sheets:** `Spizarka` (Inventory), `Slownik` (Dictionary).

## Processing Logic
1. **Parallel Extraction:** Reads both sheets simultaneously.
2. **Data Cleaning:** 
   - Converts Polish numeric formats (comma to dot).
   - Trims strings and handles null values.
   - Maps headers: `Kategoria` → `category`, `Aktualna_Ilość` → `current_quantity`, etc.
3. **Database Upsert:**
   - Calls `upsert_pantry_item()` for inventory.
   - Calls `upsert_pantry_dictionary()` for synonyms and defaults.
4. **Reporting:** Aggregates counts of processed items.

## Outputs
- **Database:** Updated rows in `pantry_inventory` and `pantry_dictionary`.
- **Telemetry:** Execution report with success status.

## Dependencies
### Systems
- [S03 Data Layer](../../20_SYSTEMS/S03_Data-Layer/README.md) - `autonomous_pantry` database.
- [S08 Automation Orchestrator](../../20_SYSTEMS/S08_Automation-Orchestrator/README.md) - n8n execution environment.

### External Services
- **Google Sheets API:** Read access to the inventory sheet.

## Manual Fallback
If the sync fails, manually update stock levels in the Google Sheet. The database will reflect changes on the next successful run. SQL can be used for emergency manual corrections:
```sql
SELECT upsert_pantry_item('Chleb', 2, 'szt', NULL, CURRENT_DATE, 'OK', 1, '');
```

## Related Documentation
- [Goal: G03 Autonomous Household Operations](../../10_GOALS/G03_Autonomous-Household-Operations/README.md)
- [Database Schema (Pantry)](../../10_GOALS/G05_Autonomous-Financial-Command-Center/database_schemas/autonomous_pantry_schema.sql)
