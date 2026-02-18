# Home Assistant MariaDB

## Connection Details

| Parameter | Value |
|-----------|-------|
| Host | `core-mariadb` (Docker internal) or `{{INTERNAL_IP}}` |
| Port | 3306 |
| Database | `homeassistant` |
| User | `homeassistant` |
| Password | `passwordHere` |

## Docker Internal (from other containers)
```
Host: core-mariadb
Port: 3306
Database: homeassistant
User: homeassistant
Password: [your password]
```

## External Access (from Grafana on homelab)
```
Host: {{INTERNAL_IP}}
Port: 3306
Database: homeassistant  
User: homeassistant
Password: [your password]
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
- Password: [your password]
- TLS/SSL Mode: disabled
