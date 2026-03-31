---
title: "G09: Goal Activity Synchronization Engine"
type: "automation_spec"
status: "active"
automation_id: "G09_sync_daily_goals.py"
goal_id: "goal-g09"
systems: ["S04", "S11"]
owner: "Michal"
updated: "2026-03-20"
---

# G09: Goal Activity Synchronization Engine (Static Tracker)

## Purpose
Acts as the **Static (Activity-Based) Sync** for the goal tracking ecosystem. While G12 automatically populates suggestions, Michal uses G09 via `ctrl+shift+G` to definitively commit the final "Did" and "Next" logs from the Daily Note to the long-term `Activity-log.md` files in the documentation hierarchy.

## Key Features
- **Surgical Parsing:** Scans the "Power Goals" section of Obsidian Daily Notes for completed tasks.
- **Goal Mapping:** Dynamically routes activity descriptions to the correct `docs/10_Goals/GXX_*/Activity-log.md` file.
- **Idempotency:** Re-running the sync for the same day updates the existing entry rather than creating duplicates.
- **Detailed Feedback (NEW Mar 28):** Now reports the exact count of goals tracked (e.g., "Goal Activity Sync Complete (3 goals tracked)") to provide Michal with immediate confirmation of sync volume.

## Triggers
- **Automated:** Part of the `G11_global_sync.py` daily registry (runs 3x daily).
- **Manual (Obsidian):** Triggered via `ctrl+shift+G` using the wrapper at `Obsidian Vault/99_System/scripts/sync_daily_goals.py`.
- **Manual (CLI):** `python3 scripts/G09_sync_daily_goals.py`

## Architecture: Workflow Bridging
To maintain a single source of truth while supporting Obsidian hotkeys, the system uses a **Redirection Wrapper**:
1.  Michal triggers `ctrl+shift+G` in Obsidian.
2.  The script within the Vault (`99_System/scripts/sync_daily_goals.py`) acts as a "thin client."
3.  It redirects the execution to the centralized engine in `autonomous-living/scripts/` using the project's virtual environment.
4.  This ensures that manual syncs are recorded in the `system_activity_log` and follow the same production logic as automated syncs.

## Inputs
- **Obsidian Daily Note:** `01_Daily_Notes/YYYY-MM-DD.md`.
- **Goal Registry:** Internal `GOAL_MAP` and `GOAL_DOCS_MAP` for path resolution.

## Processing Logic
1.  **Extract:** Identifies checked goals (`- [x] **GXX**`) and parses the associated **Did** and **Next** fields.
2.  **Verify:** Checks if the target `Activity-log.md` exists in the `docs/10_Goals/` hierarchy.
3.  **Format:** Generates a Markdown entry with date, weekday, action, and next steps.
4.  **Upsert:** Performs a regex-based search for the current date's header. If found, it replaces the content; if not, it appends to the end of the file.

## Outputs
- **Goal Documentation:** Updated `Activity-log.md` files across all goal directories.
- **Activity Log:** `SUCCESS` or `FAILURE` entry in `system_activity_log`.

## Dependencies
### Systems
- [S04 Digital Twin Hub](../../20_Systems/S04_Digital-Twin/README.md)
- [S11 Meta-System Integration](../../20_Systems/S11_Meta-System-Integration/README.md)

## Error Handling
| Failure Scenario | Detection | Response | Alert |
|---|---|---|---|
| Note Not Found | `os.path.exists` | Logs skip info | Console |
| Doc Folder Missing | `Path.exists` | Logs warning | System Activity Log |
| Parse Error | `yaml.safe_load` | Aborts frontmatter update | Console |

## Manual Fallback
If the auto-sync fails:
1.  Manually copy the **Did** and **Next** content from the Daily Note.
2.  Paste it into the relevant `Activity-log.md` under a `## YYYY-MM-DD` header.
