---
title: "G12_weekly_note_backfiller: Obsidian Graph Integrity"
type: "automation_spec"
status: "active"
automation_id: "G12_weekly_note_backfiller"
goal_id: "goal-g12"
systems: ["S12"]
owner: "Michał"
updated: "2026-04-27"
---

# G12: Weekly Note Backfiller

## Purpose
Ensures the structural integrity of the Obsidian Second Brain by identifying and backfilling missing weekly review notes. This resolves broken Wikilinks in daily notes and maintains a continuous historical record for the 2026 North Star vision.

## Triggers
- **Manual:** `python scripts/G12_weekly_note_backfiller.py`
- **Maintenance:** Run during system stability audits to clean up navigation debt.

## Inputs
- **Template:** `99_System/Templates/Weekly/Weekly Review Template.md`
- **Target Directory:** `03_Areas/A - Systems/Reviews/`

## Processing Logic
1. **Gap Analysis**: Scans the target directory for missing weekly notes from 2025-W01 to the current 2026 week.
2. **Templating**: For each missing week, it loads the standard Weekly Review Template.
3. **Variable Replacement**:
    - `{{date:YYYY-[W]WW}}` -> Week identifier (e.g., 2026-W17).
    - `{{date:YYYY-MM-DD}}` -> Monday of that week.
    - `{{date+6d:YYYY-MM-DD}}` -> Sunday of that week.
    - `{{north_star}}` -> 2026 North Star link.
4. **File Creation**: Writes the populated template to the appropriate year-prefixed filename.

## Outputs
- **Markdown Files**: Missing weekly notes in the specified reviews folder.
- **Console**: Summary of how many notes were backfilled.

## Dependencies
- **System**: [S11 Meta-System Integration](../../20_Systems/S11_Meta-System-Integration/README.md)
- **Path**: `{{ROOT_LOCATION}}/Obsidian Vault`

## Monitoring
- **Success Metric**: Zero broken links to weekly notes in the Obsidian "Link Audit" report.

---
*Related Documentation:*
- [G12_documentation_audit.md](G12_documentation_audit.md)
- [G11_obsidian_safe_sync.md](G11_obsidian_safe_sync.md)
