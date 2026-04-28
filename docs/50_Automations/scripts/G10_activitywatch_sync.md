---
title: "G10: ActivityWatch Sync"
type: "automation_spec"
status: "active"
owner: "Michał"
goal_id: "goal-g10"
updated: "2026-04-16"
---

# G10: ActivityWatch Sync

## Purpose

Synchronizes ActivityWatch events (window titles, app names, duration) into the Digital Twin database. Provides passive "Deep Work" and attention telemetry to close the productivity blind spot - actual screen time and distraction patterns.

## Scope

### In Scope
- Fetching events from ActivityWatch server API
- Classifying activities as productive/unproductive based on keywords
- Storing events in `activity_watch_events` table
- Logging sync activity to system_activity_log

### Out of Scope
- ActivityWatch server installation (Docker-based)
- Browser extension data (handled by ActivityWatch itself)
- Active interruption logging (see G10 roadmaps)

## Inputs/Outputs

### Input
- **Source:** ActivityWatch server API
- **Endpoint:** `http://localhost:5600/api/0/buckets/{bucket_id}/events`
- **Authentication:** None (local network)

### Output
- **Target:** `digital_twin_michal.public.activity_watch_events`
- **Sync Log:** `system_activity_log`

### Data Flow
```
ActivityWatch (Docker) → Server API → G10_activitywatch_sync.py → PostgreSQL
                                                  ↓
                                          system_activity_log
```

## Dependencies

### Systems
- [S03 Data Layer](../../20_Systems/S03_Data-Layer/README.md)
- [S04 Digital Twin](../../20_Systems/S04_Digital-Twin/README.md)

### Infrastructure
- ActivityWatch server running (Docker: `activitywatch/activitywatch`)
- ActivityWatch port: 5600
- PostgreSQL `digital_twin_michal` database

### External
- ActivityWatch `aw-watcher-window` bucket must be running

## Procedure

### Manual Execution
```bash
cd {{ROOT_LOCATION}}/autonomous-living/scripts
python3 G10_activitywatch_sync.py
```

### Expected Output
```
🚀 Starting ActivityWatch Sync...
✅ Synced 42 events to database.
```

### n8n Workflow Setup
Create workflow to run every hour:
1. **Trigger:** Schedule (every 1 hour)
2. **HTTP Request:** Call `http://localhost:5600/api/0/buckets` to verify connectivity
3. **Execute Workflow:** Call this script via Execute Workflow node
4. **Error Alert:** If events = 0 for 24h, send Telegram alert

## Productivity Classification

### Productive Keywords
| Category | Apps/Sites |
|----------|------------|
| Development | vscode, pycharm, terminal, iterm, tmux |
| Collaboration | github, gitlab, stack overflow |
| Notes | obsidian, jupyter |
| Infrastructure | postgres, docker, n8n |

### Unproductive Keywords
| Category | Apps/Sites |
|----------|------------|
| Social | youtube, facebook, twitter, reddit, instagram, linkedin |
| Entertainment | netflix, disney+, hbo, twitch, gaming |

### Classification Logic
1. Combined app_name + window_title (lowercase)
2. Check unproductive keywords first (priority)
3. Check productive keywords
4. Return `None` for neutral/unknown

## Database Schema

### Table: `activity_watch_events`
| Column | Type | Description |
|--------|------|-------------|
| id | SERIAL | Primary key |
| timestamp | TIMESTAMPTZ | Event start time |
| duration_seconds | DOUBLE PRECISION | Event duration |
| app_name | VARCHAR | Application name |
| window_title | TEXT | Window title |
| is_productive | BOOLEAN | NULL=unknown, TRUE=productive, FALSE=unproductive |
| category | VARCHAR | Development/Leisure/Unknown |
| bucket_id | VARCHAR | ActivityWatch bucket ID |
| created_at | TIMESTAMPTZ | Record creation time |

## Failure Modes

| Scenario | Detection | Response |
|----------|-----------|----------|
| ActivityWatch server down | Connection refused | Log error, return 0 |
| No window bucket | `aw-watcher-window` not found | Log warning |
| API timeout | Request timeout | Retry next cycle |
| Database error | PostgreSQL exception | Log error, return 0 |
| Empty events | No new events | Log success, return 0 |

## Integration with Daily Flow

### Morning Brief (G10)
Add to morning briefing:
```sql
SELECT 
    COUNT(*) as total_events,
    SUM(duration_seconds) as total_seconds,
    COUNT(*) FILTER (WHERE is_productive = TRUE) as productive,
    COUNT(*) FILTER (WHERE is_productive = FALSE) as unproductive
FROM activity_watch_events
WHERE timestamp >= CURRENT_DATE - 1;
```

### Evening Summary (G10)
Add to evening summarizer:
- Top 5 most-used apps
- Unproductive app time
- Focus score (productive hours / total hours)

## Security Notes

- ActivityWatch API has no authentication (local network only)
- No sensitive data stored in events
- Window titles may contain sensitive info - handle accordingly

## Owner + Review Cadence
- **Owner:** Michał
- **Review:** Monthly (during G10 stability audit)
- **Last Updated:** 2026-04-16

## Related Documentation

- [G10 Roadmap](../../10_Goals/G{{LONG_IDENTIFIER}}/Roadmap.md)
- [G10 Focus Intelligence](./G10_focus_intelligence.md)
- [ActivityWatch Official](https://activitywatch.net/)
