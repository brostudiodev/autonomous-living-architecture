---
title: "G10: Focus Reality Analyzer"
type: "automation_spec"
status: "active"
owner: "Michał"
goal_id: "goal-g10"
updated: "2026-04-17"
---

# G10: Focus Reality Analyzer

## Purpose
Quantifies the "Reality Audit" by analyzing ActivityWatch telemetry. It calculates a daily Focus Score (Productive vs. Distraction) to provide an objective measure of deep work efficiency.

## Scope
### In Scope
- Aggregating today's `activity_watch_events`.
- Calculating Focus Score: `(Productive / (Productive + Unproductive)) * 100`.
- Identifying top 3 focus drivers and distractions.
- Formatting a markdown report for the Obsidian Daily Note.

### Out of Scope
- Data synchronization (handled by `G10_activitywatch_sync.py`).
- Real-time focus blocking.

## Inputs/Outputs
### Input
- **Source:** PostgreSQL `digital_twin_michal.public.activity_watch_events`
- **Mock Mode:** Supports `--mock` flag for UI testing.

### Output
- **Markdown Report:** Injected into Obsidian Daily Note via `%%FOCUS_REALITY%%` marker.
- **Log:** `system_activity_log` with status and focus score.

## Procedure
### Manual Execution
```bash
python3 G10_focus_analyzer.py
```

### Mock Preview
```bash
python3 G10_focus_analyzer.py --mock
```

## Logic & Metrics
- **Focus Score:** Ratio of productive minutes to total classified minutes.
- **Classification:** Inherited from `G10_activitywatch_sync.py` classifications.
- **Report Sections:**
  - Focus Score with Emoji indicator.
  - Duration/Percentage table (Productive, Distraction, Neutral).
  - Top Focus Drivers (Apps/Windows).
  - Top Distractions.

## Integration
- **Orchestrator:** `autonomous_daily_manager.py` (runs in parallel).
- **Template:** `%%FOCUS_REALITY_START%%` / `%%FOCUS_REALITY_END%%` markers in Daily Note Template.

## Owner + Review Cadence
- **Owner:** Michał
- **Review:** Monthly alignment with G10 roadmap.
---
