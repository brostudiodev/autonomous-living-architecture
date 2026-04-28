---
title: "G10_weekly_rollup: Weekly Aggregation & Trends"
type: "automation_spec"
status: "active"
automation_id: "G10_weekly_rollup"
goal_id: "goal-g10"
systems: ["S04", "S11"]
owner: "Michał"
updated: "2026-03-20"
---

# G10_weekly_rollup: Weekly Aggregation & Trends

## Purpose

Aggregates 7 days of journal data to generate weekly statistics, trend analysis, and recommendations. No LLM required - uses rule-based analysis.

## Triggers

- **Scheduled:** Sundays at 21:00 via crontab
- **Manual:** `python scripts/G10_weekly_rollup.py`

## Inputs

| Source | Data | Purpose |
|--------|------|---------|
| Journal Data | `_meta/journal_data/daily/*.json` | Last 7 days |

## Processing Logic

### 1. Load Week Data
- Read all `daily/*.json` files from past 7 days
- Require minimum 3 days of data

### 2. Calculate Readiness Stats
```
- Average readiness
- Min/Max values
- Trend: improving / declining / stable
```

### 3. Calculate Goals Stats
```
- Total completed
- Completion rate
- Daily average
```

### 4. Calculate Automation Stats
```
- Successful runs
- Failures
- Time saved (hours)
```

### 5. Detect Health Patterns
Keywords: tired, dizzy, headache, sick, sleep
Reports if mentioned 2+ times

### 6. Day-of-Week Analysis
- Which day has best average readiness
- Which day has worst average readiness

### 7. Generate Recommendations
```
- If declining trend: "Consider more rest"
- Best day scheduling: "Schedule hard tasks on X"
- Health flags: "Investigate recurring mentions"
```

### 8. Save Outputs
- Markdown file to `_meta/journal_data/weekly/`
- Obsidian note to `02_Projects/Weekly Reviews/`

## Outputs

| Output | Location | Format |
|--------|----------|--------|
| Weekly Report | `_meta/journal_data/weekly/Week-N.md` | Markdown |
| Obsidian Note | `02_Projects/Weekly Reviews/Wnn.md` | Markdown |

### Example Output

```markdown
## 📊 Weekly Summary

**Week 12** (2026-03-14 - 2026-03-20)

### 🏃 Readiness

| Metric | Value |
|--------|-------|
| Avg | 82/100 |
| Best | 94/100 |
| Worst | 65/100 |
| Trend | ⬆️ improving |

### 🎯 Goals

| Metric | Value |
|--------|-------|
| Completed | 23 |
| Rate | 71% |
| Daily Avg | 3.3 |

### 🤖 Automation

| Metric | Value |
|--------|-------|
| Runs | 47 successful |
| Failures | 3 |
| Time Saved | ~4.5 hours |

### ⚠️ Health Flags

This week you mentioned:
- energy: 5x
- sleep: 3x

### 📅 Day Patterns

| Metric | Day |
|--------|-----|
| 🏆 Best | Thursday |
| ⚠️ Needs Work | Monday |

### 💡 Recommendations

- Schedule hard tasks on Thursday
- Investigate recurring health mentions
- Keep up the good work! 🎉
```

## Dependencies

### Scripts
- `G10_journal_data_collector.py` - Data source
- `G11_log_system.py` - Activity logging

### Files
- `_meta/journal_data/daily/YYYY-MM-DD.json` (7 files)

## Crontab Configuration

```cron
# Weekly Rollup - Sundays at 21:00
0 21 * * 0 cd {{ROOT_LOCATION}}/autonomous-living && .venv/bin/python scripts/G10_weekly_rollup.py >> _meta/daily-logs/weekly_rollup.log 2>&1
```

## Error Handling

| Scenario | Response |
|----------|----------|
| < 3 days of data | Warning, skip |
| No data at all | Exit with warning |

## Monitoring

- **Success:** Report generated
- **Log:** Check `weekly_rollup.log`

## Related Documentation

- [G10 Journal Data Collector](./G10_journal_data_collector.md)
- [G10 Daily Pattern Analyzer](./G10_daily_pattern_analyzer.md)
- [SOP: Evening Automation System](../../30_Sops/Evening-Automation-System.md)

## Changelog

| Date | Change |
|------|--------|
| 2026-03-20 | Initial implementation |
| 2026-04-16 | Bugfix: Fixed misindented except block in detect_day_of_week_patterns |
