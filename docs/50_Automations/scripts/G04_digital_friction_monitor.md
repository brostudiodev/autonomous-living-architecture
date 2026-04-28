---
title: "G04_digital_friction_monitor: System Resilience Tracker"
type: "automation_spec"
status: "active"
automation_id: "G04_digital_friction_monitor"
goal_id: "goal-g04"
systems: ["S04", "S11"]
owner: "Michał"
updated: "2026-04-28"
---

# G04_digital_friction_monitor: Resilience Analytics

## Purpose
Quantifies "Digital Friction" by analyzing system failures, manual overrides, and recovery patterns. It provides the Digital Twin with a mathematical "Resilience Score" to drive technical debt prioritization.

## Metrics Tracked
- **Friction Events:** Any `FAILURE` in the system activity log.
- **Cognitive Load:** Estimated minutes lost due to manual intervention (Heuristic: Domain Impact * 2).
- **Auto-heal Rate:** Percentage of failures resolved automatically within 1 hour.
- **Decision Overrides:** Frequency of manual `DENIED` status on high-confidence system proposals.

## Triggers
- **System Sync:** Part of the `G11_global_sync.py` pipeline (Consumer phase).
- **Manual:** `python3 G04_digital_friction_monitor.py`

## Inputs
- **Activity Log:** `digital_twin_michal.system_activity_log`
- **Decision Requests:** `digital_twin_michal.decision_requests` (to track overrides)

## Processing Logic
1. **Failure Scan:** Identifies new `FAILURE` entries in the last 24 hours.
2. **Impact Assignment:** Assigns scores based on domain (Infrastructure: 9, Household: 3).
3. **Heal Detection:** Looks for a `SUCCESS` signal from the same script within 60 minutes of a failure.
4. **Data Persistence:** Records incidents into the `system_friction` table.
5. **Reporting:** Generates a Markdown summary for the Obsidian Daily Note.

## Outputs
- **Database Entry:** Populates `system_friction`.
- **Digital Twin State:** Feeds the `resilience` dictionary in `G04_digital_twin_engine.py`.
- **Markdown:** Returns a formatted report used by `autonomous_daily_manager.py`.

## Dependencies
### Systems
- [S04 Digital Twin](../../20_Systems/S04_Digital-Twin/README.md)
- [S11 Meta-Integration](../../20_Systems/S11_Meta-System-Integration/README.md)

## Failure Modes
| Scenario | Detection | Response |
|----------|-----------|----------|
| Table Missing | SQL Error | Auto-creates `system_friction` |
| Invalid Script Name | Heuristic failure | Defaults to 'meta' domain |
