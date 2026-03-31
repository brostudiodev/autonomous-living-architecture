---
title: "G12: Auto-Did Logger"
type: "automation_spec"
status: "active"
automation_id: "G12_auto_did_logger"
goal_id: "goal-g12"
systems: ["S03", "S11"]
owner: "Michal"
updated: "2026-03-12"
---

# G12: Auto-Did Logger

## Purpose
Eliminates manual effort by auto-populating the "Did" section of Daily Notes based on actual system activity logs and git commits.

## Triggers
- Triggered by `autonomous_daily_manager.py` during its regular sync cycle.

## Inputs
- Database: `digital_twin_michal.system_activity_log` (last 24h).
- Git: Commit history of the `autonomous-living` repository.
- Goal IDs mapped to script names.

## Processing Logic
1. **Query:** Fetch all `SUCCESS` logs from the last 24 hours.
2. **Deduplicate:** Group multiple runs of the same script into a single summary.
3. **Format:** Generate human-readable strings (e.g., "G03: Cart Aggregator updated (5 items)").
4. **Git Scan:** Check for commits to specific goal folders in `docs/10_Goals/`.
5. **Inject:** Update the YAML `goals_activities` or the "After Work - Power Goals" section in the Daily Note.

## Outputs
- Updated Daily Note with automated activity logs.

## Error Handling
| Failure Scenario | Detection | Response | Alert |
|---|---|---|---|
| DB Connection Loss | psql error | Fallback to manual input placeholder | Log critical |
| Template Mismatch | Regex fail | Append to end of file instead of specific section | Log warning |
