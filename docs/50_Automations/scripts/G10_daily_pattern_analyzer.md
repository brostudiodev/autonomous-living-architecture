---
title: "G10_daily_pattern_analyzer: Rule-Based Daily Summary"
type: "automation_spec"
status: "active"
automation_id: "G10_daily_pattern_analyzer"
goal_id: "goal-g10"
systems: ["S04", "S11"]
owner: "Michał"
updated: "2026-04-28"
---

# G10_daily_pattern_analyzer: Rule-Based Daily Summary

## Purpose

Generates a structured daily summary using rule-based analysis. No LLM required. Detects patterns, flags, and trends from collected daily data.

## Triggers

- **Scheduled:** Daily at 18:00 via `autonomous_evening_manager.py`
- **Manual:** `python scripts/G10_daily_pattern_analyzer.py`

## Inputs

| Source | Data | Purpose |
|--------|------|---------|
| Journal Data | `_meta/journal_data/daily/YYYY-MM-DD.json` | Raw collected data |
| Yesterday's Data | Same folder | For comparison |

## Processing Logic

### 1. Load Today's Data
- Read JSON from `journal_data/daily/YYYY-MM-DD.json`

### 2. Load Yesterday's Data
- Calculate changes from yesterday

### 3. Health Analysis
```
- Readiness change: ⬆️ / ⬇️ / ➡️
- Compare with yesterday
```

### 4. Goal Completion
```
- Completion rate: X/Y (Z%)
- List completed goals
```

### 5. Automation Stats
```
- Success/failure ratio
- Time saved calculation
```

### 6. Flag Detection
Health keywords: tired, dizzy, headache, sick, sleep
Productivity keywords: procrastinated, distracted, overwhelmed, stuck

### 7. Finance Alerts
```
- Budget alerts count
- Alert icon if > 0
```

### 8. Generate Markdown Report
Inject into daily note via marker

## Outputs

| Output | Location | Format |
|--------|----------|--------|
| Daily Note Update | `01_Daily_Notes/YYYY-MM-DD.md` | Markdown |

### Example Output

```markdown
## 📊 Day Summary

**Friday, Mar 20**

| Metric | Value |
|--------|-------|
| Readiness | 87 ⬆️ +5 |
| Sleep | 92 |
| HRV | 8ms |
| Goals | 4/8 (50%) |
| Done | G10, G04, G03 |
| Automations | 12/13 successful |
| Time Saved | ~45 min |
| Budget Alerts | ⚠️ 2 |

**💡 Remember:** Automation saves time daily

⚠️ **Health:** energy: 2x
```

## Dependencies

### Scripts
- `G10_journal_data_collector.py` - Must run first
- `G11_log_system.py` - Activity logging

### Files
- `_meta/journal_data/daily/YYYY-MM-DD.json`

## Error Handling

| Scenario | Response |
|----------|----------|
| No data file | Warning, continue |
| No marker in note | Warning, skip update |
| Parse error | Log failure |

## Monitoring

- **Success:** Report generated and saved
- **Log:** Check `system_activity_log`

## Related Documentation

- [G10 Journal Data Collector](./G10_journal_data_collector.md)
- [G10 Weekly Rollup](./G10_weekly_rollup.md)
- [SOP: Evening Automation System](../../30_Sops/Evening-Automation-System.md)

## Changelog

| Date | Change |
|------|--------|
| 2026-03-20 | Initial implementation |
