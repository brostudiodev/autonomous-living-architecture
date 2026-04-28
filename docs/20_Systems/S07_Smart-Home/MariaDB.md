---
title: "Home Assistant MariaDB"
type: "reference"
status: "active"
system_id: "S07"
owner: "Michał"
updated: "2026-02-16"
---

# Home Assistant MariaDB

> [!info] **LEGACY/ANALYTICS NOTICE**
> Direct MariaDB access is now a **Secondary** integration method. For real-time state extraction and event-driven automation, use the **Home Assistant REST API** via `scripts/G08_home_monitor.py`. This SQL-based method is reserved for deep historical analytics and complex batch reporting.

## Connection Details

| Parameter | Value |
|-----------|-------|
| Host | `core-mariadb` (Docker internal) or `{{INTERNAL_IP}}` |
| Port | 3306 |
| Database | `homeassistant` |
| User | `homeassistant` |
| Password | `[See .env]` |

## Docker Internal (from other containers)
```
Host: core-mariadb
Port: 3306
Database: homeassistant
User: homeassistant
Password: [See .env]
```

## External Access (from Grafana on homelab)
```
Host: {{INTERNAL_IP}}
Port: 3306
Database: homeassistant  
User: homeassistant
Password: [See .env]
```

## Key Tables

| Table | Description |
|-------|-------------|
| `states` | Current entity states |
| `states_meta` | Entity metadata (entity_id, etc.) |
| `statistics` | Historical sensor data |
| `statistics_meta` | Statistics metadata |
| `events` | Home Assistant events |
| `recorder` | Recorder configuration |

## Useful Queries

### All Temperature Sensors
```sql
SELECT 
    entity_id,
    state as temperature,
    last_changed
FROM states
WHERE entity_id LIKE 'sensor.temp_%'
  AND state != 'unknown'
ORDER BY last_changed DESC
LIMIT 10;
```

### All Devices by Type
```sql
SELECT 
    SUBSTRING_INDEX(entity_id, '.', 1) as domain,
    COUNT(*) as count
FROM states
GROUP BY domain
ORDER BY count DESC;
```

### Recent State Changes
```sql
SELECT 
    entity_id,
    state,
    last_changed
FROM states
WHERE last_changed > NOW() - INTERVAL 1 HOUR
ORDER BY last_changed DESC;
```

### Battery Levels
```sql
SELECT 
    entity_id,
    state as battery_pct,
    last_changed
FROM states
WHERE entity_id LIKE '%battery%'
ORDER BY last_changed DESC;
```

## Grafana Setup

Add MariaDB data source:
- Host: `{{INTERNAL_IP}}:3306`
- Database: `homeassistant`
- User: `homeassistant`
- Password: [See .env]
- TLS/SSL Mode: disabled
