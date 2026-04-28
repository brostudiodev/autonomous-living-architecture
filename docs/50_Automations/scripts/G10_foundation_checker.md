---
title: "G10_foundation_checker: Tomorrow's Foundation Prep"
type: "automation_spec"
status: "active"
automation_id: "G10_foundation_checker"
goal_id: "goal-g10"
systems: ["S04", "S09"]
owner: "Michał"
updated: "2026-04-28"
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
| Open-Meteo API | Tomorrow's forecast | Gear suggestions (boots, umbrella) |

## Processing Logic

1. **Weather Check (NEW Apr 07)** - Query Open-Meteo for Warsaw
   - Extract temp range and precipitation
   - Map weather codes to gear suggestions (e.g., 🌧️ → Waterproof boots)

2. **Get Tomorrow's Events** - Query Google Calendar for next day
...
6. **Update Daily Note** - Write to Foundation First section
   - **Dynamic Checkbox Labels:** Refines labels for Clothes (weather summary), Lunch (pantry status), and Bag (calendar load).

## Outputs

| Output | Destination | Format |
|--------|-------------|--------|
| Daily Note Update | Today's note Foundation First | Markdown |

### Example Output

```markdown
**🌦️ Weather:** 5.2°C to 12.5°C, 2.1mm precip
- 🌧️ Rain expected: Wear waterproof boots and take an umbrella.

**📅 Tomorrow (Wednesday, Apr 08):**
- 09:00: Team Sync
- 14:00: Deep Work

**🎒 Prep Status:**
- 🛒 Low food items: jajka, chleb
- 📝 Meeting tomorrow - prepare notes

**🎯 Top 3 Priorities (First 90 min):**
1. Fix frontmatter bug #today
2. G10: Weather integration #roadmap
3. Sync logistics #urgent
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
