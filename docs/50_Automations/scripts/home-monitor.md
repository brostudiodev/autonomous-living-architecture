---
title: "G08_home_monitor.py: Environmental Intelligence"
type: "automation_spec"
status: "active"
automation_id: "home-monitor"
goal_id: "goal-g08"
systems: ["S04", "S07"]
owner: "Michal"
updated: "2026-02-24"
---

# G08_home_monitor.py: Environmental Intelligence

## Purpose
Extracts real-time environmental metrics (temperature) and device health (battery levels) from the Home Assistant MariaDB to provide the Digital Twin with situational awareness of the physical home environment.

## Triggers
- **Internal Call:** Invoked by the Digital Twin API (`GET /home`).
- **Internal Call:** Invoked by the `DigitalTwinEngine` for unified status reporting.
- **Manual:** `python3 scripts/G08_home_monitor.py`

## Inputs
- **MariaDB:** `homeassistant` database (tables: `states`, `states_meta`).
- **Credentials:** `MARIADB_HOST`, `user`, `password` (configured in script).

## Processing Logic
1. **Temperature Extraction:** Queries for all entities matching `sensor.%temperature%` and filters for the most recent valid state.
2. **Battery Monitoring:** Scans for entities containing `battery` and flags any with a state value `< 20`.
3. **Normalization:** Formats entity IDs into human-readable names (e.g., `sensor.living_room_temperature` → `Living Room`).

## Outputs
- **JSON:** Structured dictionary containing temperature map, low battery list, and timestamped alerts.
- **Text:** Formatted Markdown for Telegram/Dashboard consumption.

## Dependencies
### Systems
- [S04 Digital Twin](../../20_Systems/S04_Digital-Twin/README.md)
- [S07 Smart Home](../../20_Systems/S07_Smart-Home/README.md)

### External Services
- **Home Assistant MariaDB:** Remote database access must be enabled.

## Error Handling
| Failure Scenario | Detection | Response | Alert |
|---|---|---|---|
| DB Connection Fail | `mysql.connector.Error` | Returns error object with description | Digital Twin Status "⚠️" |
| Unknown State | `unknown`/`unavailable` filter | Excludes entities from report | None |

## Monitoring
- **API Health:** `curl http://localhost:5677/home`
- **Dashboard:** "Device Alerts" section in Morning Briefing.
