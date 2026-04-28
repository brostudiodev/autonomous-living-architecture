---
title: "G10: Activity Analyzer"
type: "automation_spec"
status: "active"
owner: "Michał"
goal_id: "goal-g10"
updated: "2026-04-28"
---

# G10: Activity Analyzer

## Purpose

Processes raw ActivityWatch events stored in PostgreSQL to generate high-level productivity insights. It provides the "Focus Score" and identifies "Top Applications" to help the user understand their time allocation and distraction patterns.

## Scope

### In Scope
- Aggregating event durations over a specific time period (default 1 day).
- Calculating the ratio of productive vs. unproductive time (Focus Score).
- Identifying the top 5 most used applications.

### Out of Scope
- Ingesting raw data (handled by G10: ActivityWatch Sync).
- Real-time notification of distractions.

## Inputs/Outputs

### Input
- **Source:** PostgreSQL Table `activity_watch_events`.

### Output
- **Format:** Formatted text report (Markdown compatible).
- **Key Metrics:** Total Screen Time, Focus Score, Productive/Unproductive duration.

## Dependencies

### Systems
- [G10 Intelligent Productivity](../../10_Goals/G{{LONG_IDENTIFIER}}/README.md)

## Procedure

### Manual Execution
```bash
cd {{ROOT_LOCATION}}/autonomous-living/scripts
{{ROOT_LOCATION}}/autonomous-living/.venv/bin/python3 G10_activity_analyzer.py
```

## Owner + Review Cadence
- **Owner:** Michał
- **Review:** Weekly
- **Last Updated:** 2026-04-28
