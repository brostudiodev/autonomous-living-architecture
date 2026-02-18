---
title: "G08: Smart Home Data Visualization"
type: "automation_spec"
status: "draft"
goal_id: "goal-g08"
systems: ["S01", "S07"]
owner: "Michał"
updated: "2026-02-18"
---

# G08: Smart Home Data Visualization

## Approach
Use MariaDB directly - no n8n or PostgreSQL duplication needed. Home Assistant already stores all data in MariaDB.

## Data Source

### MariaDB Connection
| Parameter | Value |
|-----------|-------|
| Host | `{{INTERNAL_IP}}` or `core-mariadb` (Docker) |
| Port | 3306 |
| Database | `homeassistant` |
| User | `homeassistant` |
| Password | [your HA password] |

### Key Tables
- `states` - Current entity states
- `states_meta` - Entity metadata
- `statistics` - Historical sensor data
- `events` - HA events

## Grafana Dashboards

Create dashboards in Grafana connecting to MariaDB:

### Dashboard 1: Temperature & Humidity
```sql
-- Temperature by room
SELECT 
    entity_id,
    state as temperature,
    last_changed
FROM states
WHERE entity_id LIKE 'sensor.temp_%'
  AND state NOT IN ('unknown', 'unavailable')
ORDER BY last_changed DESC;
```

### Dashboard 2: Device Status
```sql
-- All sensors with battery
SELECT 
    entity_id,
    state as battery_pct,
    last_changed
FROM states
WHERE entity_id LIKE '%battery%'
ORDER BY last_changed DESC;
```

### Dashboard 3: Energy (if available)
```sql
-- Smart plug power consumption
SELECT 
    entity_id,
    state as power_watts,
    last_changed
FROM states
WHERE entity_id LIKE 'sensor.%power%'
ORDER BY last_changed DESC;
```

## Next Steps

1. Add MariaDB data source in Grafana
2. Create dashboards for:
   - Temperature/humidity by room
   - Battery levels
   - Device online/offline status
   - Energy consumption (if plugs report power)
3. Set up alerts for offline devices

## Files
- [MariaDB connection docs](../S07_Smart-Home/MariaDB.md)
- [Device inventory](../10_GOALS/G08_Predictive-Smart-Home-Orchestration/DEVICE_INVENTORY.md)
