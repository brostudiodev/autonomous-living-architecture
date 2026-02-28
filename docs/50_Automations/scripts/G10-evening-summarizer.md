---
title: "G10: Evening Summarizer"
type: "automation_spec"
status: "active"
automation_id: "G10-evening-summarizer"
goal_id: "goal-g10"
systems: ["S09"]
owner: "Michal"
updated: "2026-02-28"
---

# G10: Evening Summarizer

## Purpose
Automates the end-of-day reflection by injecting a metrics-driven "Director's Summary" into the current Obsidian daily note.

## Triggers
- Scheduled: 21:00 Daily.
- Manual: `python3 scripts/G10_evening_summarizer.py`

## Inputs
- Obsidian Daily Note: `YYYY-MM-DD.md`
- PostgreSQL Databases:
  - `autonomous_health`: Sleep, HRV, Steps, Weight.
  - `autonomous_finance`: Uncategorized transaction counts.
  - `autonomous_pantry`: Critical threshold alerts.

## Processing Logic
1. Reads today's Obsidian note to identify completed goals.
2. Queries health, finance, and pantry databases for the day's actual performance metrics.
3. Generates a formatted "Director's Summary" comparing reality vs. targets.
4. Injects the summary and an "Evening Prep" checklist into the `## 🧠 Reflection` section of the daily note.

## Outputs
- Updated Obsidian Daily Note with automated insights.
- Consolidation of cross-goal data for final review.

## Dependencies
- [S03 Data Layer](../../20_Systems/S03_Data-Layer/README.md)
- [S09 Productivity & Time](../../20_Systems/S09_Productivity-Time/README.md)

## Error Handling
| Failure Scenario | Detection | Response | Alert |
|---|---|---|---|
| Note not found | File check fails | Create note from template or skip | Log Error |
| DB Timeout | Connection error | Skip metrics, use manual reflection template | Log Warning |
