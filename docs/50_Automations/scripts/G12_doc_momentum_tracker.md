---
title: "Automation Spec: G12_doc_momentum_tracker.py"
type: "automation_spec"
status: "active"
automation_id: "G12_doc_momentum_tracker"
goal_id: "goal-g12"
systems: ["S04", "S12"]
owner: "Michal"
updated: "2026-04-09"
---

# 🤖 Automation Spec: G12_doc_momentum_tracker.py

## Purpose
Enforces documentation "Freshness" by automatically updating the metadata of system documentation based on actual script activity. It ensures that the `updated:` field in markdown files reflects the last time the corresponding system component successfully executed.

## Triggers
- **Daily Sync:** Part of the `G11_global_sync.py` pipeline.
- **Manual:** `python3 G12_doc_momentum_tracker.py`

## Inputs
- **Activity Log:** `system_activity_log` from `digital_twin_michal`.
- **Markdown Specs:** `docs/50_Automations/scripts/*.md`.

## Processing Logic
1. **Success Detection:** Identifies all unique scripts that finished with status `SUCCESS` in the last 24 hours.
2. **Path Mapping:** Matches script names (e.g., `G01_workout_sync`) to documentation files.
3. **Regex Update:** Surgically replaces the `updated: "..."` line in the YAML frontmatter with today's date.
4. **No-Change Optimization:** Only writes to the file if the date has actually changed.

## Outputs
- **Frontmatter Updates:** Refreshed timestamps across the system documentation.

## Related Documentation
- [Goal: G12 Process Documentation](../../10_Goals/G12_Complete-Process-Documentation/README.md)
- [System: S12 Documentation Standards](../../20_Systems/S12_Documentation-Standards/README.md)
