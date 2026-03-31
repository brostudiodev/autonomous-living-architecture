---
title: "SOP: Evening Automation System"
type: "sop"
status: "active"
goal_id: "goal-g10, goal-g11"
owner: "Michal"
updated: "2026-03-23"
---

# SOP: Evening Automation System

## Purpose

The Evening Automation System prepares for the next day and generates daily insights automatically. It runs at 18:00 (via evening manager) and generates key information for the daily journal.

## Scope

### In Scope
- Memory generation ("One thing to remember")
- Tomorrow's foundation preparation
- Mission control injection (Google Tasks)
- Daily note updates

### Out of Scope
- Morning briefing (handled by `autonomous_daily_manager`)
- Weekly review (handled by `autonomous_weekly_manager`)
- Git sync (handled by safe sync)

---

## Architecture

```
┌─────────────────────────────────────────────────────────────┐
│                   Evening Automation Flow                    │
├─────────────────────────────────────────────────────────────┤
│                                                              │
│  18:00 ──► autonomous_evening_manager.py                    │
│                      │                                       │
│                      ▼                                       │
│         ┌────────────────────────────┐                     │
│         │ 1. G10_journal_data_collector│                   │
│         │    ↓                      │                     │
│         │    Saves to:              │                     │
│         │    _meta/journal_data/    │                     │
│         │    daily/YYYY-MM-DD.json │                     │
│         └────────────────────────────┘                     │
│                      │                                       │
│                      ▼                                       │
│         ┌────────────────────────────┐                    │
│         │ 2. G10_ai_memory_generator │                    │
│         │    ↓                      │                    │
│         │    Updates daily note:     │                    │
│         │    "One thing to remember" │                    │
│         └────────────────────────────┘                    │
│                      │                                       │
│                      ▼                                       │
│         ┌────────────────────────────┐                    │
│         │ 3. G10_foundation_checker  │                    │
│         │    ↓                      │                    │
│         │    Updates daily note:     │                    │
│         │    Foundation First       │                    │
│         │    Tomorrow's Calendar    │                    │
│         │    Priority Tasks        │                    │
│         └────────────────────────────┘                    │
│                      │                                       │
│                      ▼                                       │
│         ┌────────────────────────────┐                    │
│         │ 4. G11_mission_control     │                    │
│         │    ↓                      │                    │
│         │    Auto-injects P1 tasks   │                    │
│         │    into Google Tasks       │                    │
│         └────────────────────────────┘                    │
│                      │                                       │
│                      ▼                                       │
│         ┌────────────────────────────┐                    │
│         │ 5. G10_daily_pattern_analyzer│                  │
│         │    ↓                      │                    │
│         │    Updates daily note:     │                    │
│         │    Day Summary section     │                    │
│         └────────────────────────────┘                    │
│                                                              │
├─────────────────────────────────────────────────────────────┤
│                    WEEKLY (Sunday)                          │
├─────────────────────────────────────────────────────────────┤
│                                                              │
│  Sunday 21:00 ──► G10_weekly_rollup.py                     │
│                      │                                      │
│                      ▼                                      │
│         ┌────────────────────────────┐                    │
│         │ Weekly Rollup              │                    │
│         │ - Aggregates 7 days        │                    │
│         │ - Trend analysis          │                    │
│         │ - Pattern detection        │                    │
│         │ - Recommendations         │                    │
│         └────────────────────────────┘                    │
│                      │                                      │
│                      ▼                                      │
│         Outputs to:                                         │
│         - Obsidian: Weekly Reviews/Wnn.md                  │
│         - File: _meta/journal_data/weekly/                 │
│                                                              │
├─────────────────────────────────────────────────────────────┤
│                    WEEKLY (Sunday 10:00)                   │
├─────────────────────────────────────────────────────────────┤
│                                                              │
│  Sunday 10:00 ──► G11_task_archiver.py                     │
│                      │                                      │
│                      ▼                                      │
│         ┌────────────────────────────┐                    │
│         │ Weekly Task Cleanup         │                    │
│         │ - Dry-run first           │                    │
│         │ - Archive stale tasks     │                    │
│         │ - Delete from Google Tasks │                    │
│         └────────────────────────────┘                    │
│                                                              │
└─────────────────────────────────────────────────────────────┘
```

---

## Triggers

| Automation | Schedule | Command |
|------------|----------|---------|
| Evening Manager | Daily 18:00 | `autonomous_evening_manager.py` |
| CEO Weekly Briefing | Sunday 08:00 | `G11_ceo_weekly_briefing.py` |
| Task Archiver | Sunday 10:00 | `G11_task_archiver.py --archive --force` |
| Weekly Manager | Sunday 06:00 | `autonomous_weekly_manager.py` |
| Weekly Rollup | Sunday 21:00 | `G10_weekly_rollup.py` |

---

## Inputs

| Source | Data | Used By |
|--------|------|---------|
| Daily Note | Goal completion, journal entries | All scripts |
| Digital Twin Engine | Readiness, biometrics, finance | Journal Collector |
| `system_activity_log` | Successful automations | Journal Collector |
| Google Calendar | Tomorrow's events | Foundation Checker |
| Google Tasks | Priority tasks (#today, #roadmap) | Foundation Checker |
| Digital Twin Engine | Pantry low stock | Foundation Checker |
| Journal Data | `_meta/journal_data/daily/*.json` | Daily/Weekly Analyzers |

---

## Processing Logic

### 1. G10_journal_data_collector

```
1. Parse today's daily note
   └─> Goals, highlights, frustrations, flags

2. Query Digital Twin Engine
   └─> Health (readiness, sleep, HRV)
   └─> Finance (budget alerts)

3. Query system_activity_log
   └─> Automation runs (last 24h)

4. Save to JSON:
   └─> _meta/journal_data/daily/YYYY-MM-DD.json
```

### 2. G10_ai_memory_generator

```
1. Read collected data from journal_data

2. Generate insight using priority rules:
   IF completed_goals → "✅ G##: task completed"
   ELIF system_wins → "🤖 Automation saved time"
   ELIF readiness >= 85 → "🚀 Peak readiness"
   ELIF readiness < 50 → "💤 Low readiness"
   ELIF budget_alerts >= 5 → "💸 Review finances"
   ELSE → "📊 Standard day"

3. Update daily note marker:
   ## One thing to remember from today
   - [generated insight]
```

### 3. G10_foundation_checker

```
1. Get tomorrow's events (Google Calendar)
   └─> Meeting times, locations, attendees

2. Get priority tasks (Google Tasks)
   └─> Filter: #today, #roadmap, #deep, #urgent
   └─> Return top 3

3. Get pantry status (Digital Twin)
   └─> Low stock food items

4. Analyze needs:
   ├─> Early meeting (< 08:00)? → "Set alarm"
   ├─> Meeting tomorrow? → "Prepare notes"
   ├─> Low food items? → "Add to shopping"

5. Update daily note Foundation First section
```

### 4. G11_mission_control

```
1. Fetch high-priority missions from Digital Twin Engine
2. Identify tasks with 'high' or 'medium' priority
3. Deduplicate against existing Google Tasks
4. Inject into 'Missions (Autonomous)' Google Tasks list
```

### 5. G10_daily_pattern_analyzer

```
1. Load today's collected data (JSON)

2. Calculate metrics:
   ├─> Readiness change vs yesterday
   ├─> Goal completion rate
   ├─> Automation stats
   └─> Finance alerts

3. Detect flags:
   ├─> Health keywords (tired, dizzy, etc.)
   └─> Productivity keywords (procrastinated, etc.)

4. Generate markdown summary
5. Update daily note %%PATTERN%% marker
```

---

## Outputs

| Automation | Output | Destination |
|-----------|--------|------------|
| Journal Data Collector | JSON file | `_meta/journal_data/daily/` |
| Memory Generator | "One thing to remember" | Daily Note |
| Foundation Checker | Tomorrow's prep info | Daily Note |
| Mission Control | High-priority tasks | Google Tasks |
| Daily Pattern Analyzer | Day Summary | Daily Note |
| Weekly Rollup | Weekly Summary | Weekly Reviews folder |
| Task Archiver | Console report | Stdout + Log |

---

## Crontab Configuration

```cron
# Evening Manager - Daily at 18:00
0 18 * * * cd {{ROOT_LOCATION}}/autonomous-living && .venv/bin/python scripts/autonomous_evening_manager.py >> _meta/daily-logs/evening_manager.log 2>&1

# Task Archiver - Sundays at 10:00
0 10 * * 0 cd {{ROOT_LOCATION}}/autonomous-living && .venv/bin/python scripts/G11_task_archiver.py --archive --force >> _meta/daily-logs/task_archiver.log 2>&1
```

---

## Error Handling

| Automation | Failure Mode | Detection | Response |
|------------|-------------|-----------|----------|
| Memory Generator | Daily note not found | File check | Log warning, skip |
| Memory Generator | Marker not found | String search | Log warning, skip |
| Foundation Checker | Calendar API fails | Exception | Skip calendar section |
| Foundation Checker | Tasks API fails | Exception | Use roadmap fallback |
| Task Archiver | Auth fails | Service=None | Log failure |
| Task Archiver | Delete fails | Exception | Count as failed, continue |

---

## Manual Fallback

### If Evening Manager Fails

```bash
cd {{ROOT_LOCATION}}/autonomous-living
source .venv/bin/activate

# Run individual scripts
python scripts/G10_ai_memory_generator.py
python scripts/G10_foundation_checker.py
python scripts/G11_mission_control.py
```

---

## Dependencies

### Systems
- [S04 Digital Twin](../../20_Systems/S04_Digital-Twin/README.md)
- [S09 Productivity & Time](../../20_Systems/S09_Productivity-Time/README.md)
- [S11 Meta-System Integration](../../20_Systems/S11_Meta-System-Integration/README.md)

### Scripts
| Script | Purpose |
|--------|---------|
| `autonomous_evening_manager.py` | Orchestrator |
| `G10_ai_memory_generator.py` | Memory generation |
| `G10_foundation_checker.py` | Tomorrow's prep |
| `G11_mission_control.py` | Mission injection |
| `G11_task_archiver.py` | Weekly cleanup |
| `G04_digital_twin_engine.py` | State provider |
| `G10_calendar_client.py` | Calendar access |
| `G10_google_tasks_sync.py` | Tasks access |
| `G11_log_system.py` | Activity logging |

---

## Related Documentation

### Automation Specs
- [autonomous_evening_manager.md](../50_Automations/scripts/autonomous_evening_manager.md)
- [G10_ai_memory_generator.md](../50_Automations/scripts/G10_ai_memory_generator.md)
- [G10_foundation_checker.md](../50_Automations/scripts/G10_foundation_checker.md)
- [G11_task_archiver.md](../50_Automations/scripts/G11_task_archiver.md)
- [G11_mission_control.md](../50_Automations/scripts/G11_mission_control.md)

### System Docs
- [G10 Roadmap](../../10_Goals/G10_Intelligent-Productivity-Time-Architecture/Roadmap.md)
- [G11 Roadmap](../../10_Goals/G11_Meta-System-Integration-Optimization/Roadmap.md)

---

## Changelog

| Date | Change |
|------|--------|
| 2026-03-23 | Added G11_mission_control integration |
| 2026-03-20 | Initial documentation |

---

*Owner: Michal*  
*Review Cadence: Monthly*
