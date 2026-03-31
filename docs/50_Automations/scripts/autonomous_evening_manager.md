---
title: "autonomous_evening_manager: Evening Automation Orchestrator"
type: "automation_spec"
status: "active"
automation_id: "autonomous_evening_manager"
goal_id: "goal-g10"
systems: ["S04", "S11"]
owner: "Michal"
updated: "2026-03-20"
---

# autonomous_evening_manager: Evening Automation Orchestrator

## Purpose

Evening automation runner that orchestrates end-of-day tasks including data collection, memory generation, foundation preparation, and pattern analysis. Designed to run via crontab at 18:00 daily.

## Triggers

- **Scheduled:** Daily at 18:00 via crontab
- **Manual:** `python scripts/autonomous_evening_manager.py`

## Scope

### In Scope
- Data collection (G10_journal_data_collector)
- Memory generation (G10_ai_memory_generator)
- Foundation preparation (G10_foundation_checker)
- Pattern analysis (G10_daily_pattern_analyzer)

### Out of Scope
- Morning briefing (handled by autonomous_daily_manager)
- Git sync (handled by autonomous_daily_manager)
- Weekly review (handled by G10_weekly_rollup)

## Processing Logic

1. **Journal Data Collector** - Execute G10_journal_data_collector
   - Collects daily data from all sources
   - Saves to `_meta/journal_data/daily/YYYY-MM-DD.json`

2. **Memory Generator** - Execute G10_ai_memory_generator
   - Parses daily note for completed goals
   - Queries system activity log for wins
   - Generates "One thing to remember" insight

3. **Foundation Checker** - Execute G10_foundation_checker
   - Gets tomorrow's calendar events
   - Identifies priority tasks
   - Updates Foundation First section

4. **Daily Pattern Analyzer** - Execute G10_daily_pattern_analyzer
   - Loads collected journal data
   - Generates day summary with stats
   - Updates %%PATTERN%% marker

## Outputs

| Output | Destination |
|--------|-------------|
| Journal Data JSON | `_meta/journal_data/daily/` |
| Daily Note Updates | Obsidian Daily Note |
| Console Log | Stdout |

### Example Console Output

```
🌙 Starting evening automation at 18:00...

📊 Running: G10_journal_data_collector...
✅ Data collected for 2026-03-20

📝 Running: G10_ai_memory_generator...
✅ Memory generated: 🤖 G10 Focus Intelligence ran automatically

🏠 Running: G10_foundation_checker...
✅ Foundation checked: Tomorrow's prep ready

📈 Running: G10_daily_pattern_analyzer...
✅ Daily patterns analyzed

🌙 Evening automation complete.
```

## Dependencies

### Systems
- [S04 Digital Twin](../../20_Systems/S04_Digital-Twin/README.md)
- [S11 Meta-System Integration](../../20_Systems/S11_Meta-System-Integration/README.md)

### Scripts
- `G10_journal_data_collector.py` - Data collection
- `G10_ai_memory_generator.py` - Memory generation
- `G10_foundation_checker.py` - Tomorrow's prep
- `G10_daily_pattern_analyzer.py` - Daily patterns

## Crontab Configuration

Add to crontab (`crontab -e`):

```cron
# Evening automation - Daily at 18:00
0 18 * * * cd {{ROOT_LOCATION}}/autonomous-living && .venv/bin/python scripts/autonomous_evening_manager.py >> _meta/daily-logs/evening_manager.log 2>&1

# Weekly rollup - Sundays at 21:00
0 21 * * 0 cd {{ROOT_LOCATION}}/autonomous-living && .venv/bin/python scripts/G10_weekly_rollup.py >> _meta/daily-logs/weekly_rollup.log 2>&1
```

## Error Handling

| Scenario | Detection | Response |
|----------|-----------|----------|
| Script import fails | Exception in `from X import` | Print error, continue |
| Script execution fails | Exception in `run()` | Print error, log failure |

## Security Notes

- No direct file modification (delegates to individual scripts)
- Database credentials via `.env`
- No secrets in code

## Monitoring

- **Success metric:** All automations complete without crash
- **Log location:** `_meta/daily-logs/evening_manager.log`
- **Alert on:** 3 consecutive failures

## Manual Fallback

If evening manager fails:
```bash
cd {{ROOT_LOCATION}}/autonomous-living
source .venv/bin/activate

# Run individual automations manually:
python scripts/G10_journal_data_collector.py
python scripts/G10_ai_memory_generator.py
python scripts/G10_foundation_checker.py
python scripts/G10_daily_pattern_analyzer.py
```

## Related Documentation

- [G10 Journal Data Collector](./G10_journal_data_collector.md)
- [G10 AI Memory Generator](./G10_ai_memory_generator.md)
- [G10 Foundation Checker](./G10_foundation_checker.md)
- [G10 Daily Pattern Analyzer](./G10_daily_pattern_analyzer.md)
- [G10 Weekly Rollup](./G10_weekly_rollup.md)
- [SOP: Evening Automation System](../../30_Sops/Evening-Automation-System.md)

## Changelog

| Date | Change |
|------|--------|
| 2026-03-20 | Initial implementation |
| 2026-03-20 | Added G10_foundation_checker integration |
| 2026-03-20 | Added G10_journal_data_collector and G10_daily_pattern_analyzer |
