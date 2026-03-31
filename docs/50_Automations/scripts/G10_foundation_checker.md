---
title: "G10_foundation_checker: Tomorrow's Foundation Prep"
type: "automation_spec"
status: "active"
automation_id: "G10_foundation_checker"
goal_id: "goal-g10"
systems: ["S04", "S09"]
owner: "Michal"
updated: "2026-03-20"
---

# G10_foundation_checker: Tomorrow's Foundation Prep

## Purpose

Prepares tomorrow's foundation checklist by analyzing calendar events, priority tasks, and pantry status. Updates the daily note's Foundation First section automatically.

## Triggers

- **Scheduled:** Daily at 18:00 via `autonomous_evening_manager.py`
- **Manual:** `python scripts/G10_foundation_checker.py`

## Inputs

| Source | Data | Used For |
|--------|------|----------|
| Google Calendar API | Tomorrow's events | Meeting prep, time requirements |
| Google Tasks API | Priority tasks (#today, #roadmap) | Top 3 tasks |
| Digital Twin Engine | Pantry low stock | Lunch prep |

## Processing Logic

1. **Get Tomorrow's Events** - Query Google Calendar for next day
   - Extract meeting times
   - Identify external/location-based events
   - Check for early meetings (before 8 AM)

2. **Get Priority Tasks** - Query Google Tasks
   - Filter: `#today`, `#roadmap`, `#deep`, `#urgent`
   - Sort by priority
   - Return top 3

3. **Get Pantry Status** - Digital Twin engine
   - Low stock items
   - Food items specifically

4. **Analyze Needs** - Determine what to prepare
   - Early alarm needed?
   - Meeting notes required?
   - Lunch ingredients low?

5. **Build Report** - Markdown for daily note

6. **Update Daily Note** - Write to Foundation First section

## Outputs

| Output | Destination | Format |
|--------|-------------|--------|
| Daily Note Update | Today's note Foundation First | Markdown |

### Example Output

```markdown
**📅 Tomorrow (Saturday, Mar 21):**
- 09:00: Dentist appointment
- 14:00: Team meeting

**🎒 Prep Status:**
- ⚠️ Early meeting - set alarm!
- 📝 Meeting tomorrow - prepare notes

**🎯 Top 3 Priorities (First 90 min):**
1. Review project proposal #today
2. G02: Q2 content calendar #roadmap
3. Respond to emails #today
```

## Dependencies

### Systems
- [S04 Digital Twin](../../20_Systems/S04_Digital-Twin/README.md) - Pantry data
- [S09 Productivity & Time](../../20_Systems/S09_Productivity-Time/README.md) - Tasks/Calendar

### External Services
- Google Calendar API
- Google Tasks API

### Scripts
- `G04_digital_twin_engine.py` - Pantry state
- `G10_calendar_client.py` - Calendar access
- `G10_google_tasks_sync.py` - Tasks access

## Error Handling

| Scenario | Detection | Response |
|----------|-----------|----------|
| Calendar API fails | Exception | Skip calendar section |
| Tasks API fails | Exception | Use roadmap mins fallback |
| Digital Twin fails | Exception | Skip pantry section |
| Daily note not found | File check | Log warning |

## Security Notes

- Read-only API access (calendar, tasks)
- No device control
- Database credentials via `.env`

## Monitoring

- **Success metric:** Foundation section updated
- **Log location:** Check `system_activity_log`
- **Alert on:** 3 consecutive failures

## Manual Fallback

If script fails:
```bash
cd {{ROOT_LOCATION}}/autonomous-living
source .venv/bin/activate
python scripts/G10_foundation_checker.py

# Manual check:
# 1. Open Google Calendar (tomorrow)
# 2. Check pantry low stock
# 3. Review today's tasks
# 4. Fill Foundation First manually
```

## Weather Integration (Future)

Weather check is handled separately via n8n workflow. To integrate:
1. Query Open-Meteo API or Home Assistant
2. Add "Clothes" section with weather recommendation
3. Example: "Rain expected - bring jacket"

## Related Documentation

- [G10 Schedule Optimizer](./G10_schedule_optimizer.md)
- [G10 AI Memory Generator](./G10_ai_memory_generator.md)
- [Autonomous Evening Manager](./autonomous_evening_manager.md)
- [SOP: Daily Task Review & Sync](../../30_Sops/SOP_Daily_Task_Review.md)

## Changelog

| Date | Change |
|------|--------|
| 2026-03-20 | Initial implementation |
