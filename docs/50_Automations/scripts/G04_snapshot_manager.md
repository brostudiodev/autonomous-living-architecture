---
title: "G04: Digital Twin Snapshot Manager"
type: "automation_spec"
status: "active"
automation_id: "G04_snapshot_manager"
goal_id: "goal-g04"
systems: ["S04", "S03"]
owner: "Michal"
updated: "2026-03-19"
---

# G11: Digital Twin Snapshot Manager

## Purpose
Enables the "Temporal Memory" of the Digital Twin by capturing and persisting the complete system state (Health, Finance, Logistics, etc.) into a historical archive. This allows for long-term trend analysis and prevents data loss when real-time tables are updated or truncated.

## Triggers
- **Scheduled:** Daily at **00:01** via Crontab.
- **Manual:** `python3 G04_snapshot_manager.py`

## Inputs
- **Digital Twin State:** Aggregated data from `G04_digital_twin_engine.py`.
- **Target Database:** `digital_twin_michal` (Table: `twin_state_snapshots`).

## Processing Logic
1.  Initializes the `DigitalTwinEngine` to gather the most recent data from all sub-databases.
2.  Determines the `snapshot_date`. By default (if run at 00:01), it snapshots the state for the day that just concluded.
3.  Serializes the entire `state` dictionary into a JSONB format.
4.  Executes an `UPSERT` into the `twin_state_snapshots` table, ensuring only one snapshot exists per date.

## Outputs
- **Database Entry:** A new row in `public.twin_state_snapshots` containing the `snapshot_date` and `state_json`.
- **Log Entry:** Status recorded in `_meta/daily-logs/snapshot_manager.log`.

## Data Schema
| Column | Type | Description |
|---|---|---|
| `id` | SERIAL | Primary Key |
| `snapshot_date` | DATE | The date being archived (Unique) |
| `state_json` | JSONB | Complete Digital Twin state dictionary |
| `created_at` | TIMESTAMP | Actual time of archival |

## Dependencies
### Systems
- [S04 Digital Twin Hub](../../20_Systems/S04_Digital-Twin/README.md)
- [S03 Data Layer](../../20_Systems/S03_Data-Layer/README.md)

### External Services
- PostgreSQL (JSONB support required).

## Error Handling
- **Database Connection Failure:** Retries internally; if fails, logs to `snapshot_manager.log` and exits with code 1.
- **Serialization Error:** If non-serializable objects (like raw datetime) are found, the custom `json_serial` helper converts them to ISO strings.

---
*Related Documentation:*
- [G04_digital_twin_engine.md](G04_digital_twin_engine.md)
- [G04_Digital-Twin-Ecosystem Roadmap](../Roadmap.md)
