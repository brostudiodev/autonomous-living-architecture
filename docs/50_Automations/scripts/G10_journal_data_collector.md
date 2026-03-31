---
title: "G10_journal_data_collector: Daily Data Collection"
type: "automation_spec"
status: "active"
automation_id: "G10_journal_data_collector"
goal_id: "goal-g10"
systems: ["S04", "S11"]
owner: "Michal"
updated: "2026-03-20"
---

# G10_journal_data_collector: Daily Data Collection

## Purpose

Collects all daily context from multiple sources and saves to JSON for pattern analysis and LLM processing. Provides complete data foundation for the journal system.

## Triggers

- **Scheduled:** Daily at 18:00 via `autonomous_evening_manager.py`
- **Manual:** `python scripts/G10_journal_data_collector.py`

## Inputs

| Source | Data | Purpose |
|--------|------|---------|
| Daily Note | Goals, journal, flags | Parse daily context |
| Digital Twin Engine | Health, finance | System state |
| `system_activity_log` | Automation runs | Track wins |
| `autonomous_decisions` | Decisions made | Context |

## Processing Logic

1. **Parse Daily Note**
   - Extract completed goals (G01-G12)
   - Get highlight/frustration entries
   - Find "One thing to remember"
   - Count flagged items

2. **Query System Activity**
   - Last 24h automation runs
   - Success/failure counts
   - Time saved calculations

3. **Query Decisions**
   - Today's autonomous decisions
   - Confidence scores

4. **Get Health Summary**
   - Readiness score
   - Sleep score
   - HRV value

5. **Get Finance Summary**
   - Budget alerts
   - Month progress

6. **Save to JSON**
   - Output: `_meta/journal_data/daily/YYYY-MM-DD.json`

## Outputs

| Output | Location | Format |
|--------|----------|--------|
| Daily Data | `_meta/journal_data/daily/YYYY-MM-DD.json` | JSON |

### Example Output

```json
{
  "date": "2026-03-20",
  "collected_at": "2026-03-20T18:30:00",
  "daily_note": {
    "exists": true,
    "goals_completed": ["G10: Focus Intelligence", "G04: Digital Twin"],
    "goals_total": 8,
    "flags": ["⚠️ Budget alert"],
    "one_thing": "🤖 Automation saves time daily"
  },
  "system_activity": {
    "successful": 12,
    "failed": 1,
    "total_time_saved_minutes": 45
  },
  "health": {
    "readiness_score": 87,
    "sleep_score": 92,
    "hrv_ms": 8
  },
  "finance": {
    "active_budget_alerts": 2
  }
}
```

## Dependencies

### Systems
- [S04 Digital Twin](../../20_Systems/S04_Digital-Twin/README.md)
- [S11 Meta-System Integration](../../20_Systems/S11_Meta-System-Integration/README.md)

### Scripts
- `G04_digital_twin_engine.py` - State provider
- `G11_log_system.py` - Activity logging

## Error Handling

| Scenario | Response |
|----------|----------|
| Daily note not found | Return empty data, continue |
| Database query fails | Log warning, continue |
| Digital Twin fails | Return empty health/finance |

## Data Storage

```
_meta/journal_data/
├── daily/
│   ├── 2026-03-14.json
│   ├── 2026-03-15.json
│   └── ...
└── weekly/
    └── Week-12-2026-03-20.md
```

## Related Documentation

- [G10 Daily Pattern Analyzer](./G10_daily_pattern_analyzer.md)
- [G10 Weekly Rollup](./G10_weekly_rollup.md)
- [SOP: Evening Automation System](../../30_Sops/Evening-Automation-System.md)

## Changelog

| Date | Change |
|------|--------|
| 2026-03-20 | Initial implementation |
| 2026-03-20 | Fixed database column alignment (`items_processed` and `timestamp` fields) |
| 2026-03-21 | **Multi-Signal Journaling Integration:** Upgraded logic to detect journaling from *any* of the three sections (Decisions, Emotions, or Interactions). Integrated direct logging to `G11_behavioral_monitor` for real-time autonomy tracking. |
