---
title: "G11_inbox_router.py: Obsidian Inbox Intelligence"
type: "automation_spec"
status: "active"
automation_id: "g11-inbox-router"
goal_id: "goal-g11"
systems: ["S11", "S04"]
owner: "Michal"
updated: "2026-02-27"
---

# G11_inbox_router.py

## Purpose
Provides automated classification and enrichment for new notes entering the Obsidian `00_Inbox`. It scans content for keywords related to the 12 Power Goals and injects an "Intelligence Router" block with suggested goal mappings and a concise summary.

## Triggers
- **On-Demand:** Can be run via a terminal or shell script.
- **Automated:** Intended to be triggered by a file-watcher (like `fswatch` or `inotify`) or as part of the `autonomous_daily_manager.py` pre-processing step.

## Inputs
- **Obsidian Vault:** Scans files in `{{ROOT_LOCATION}}/Obsidian Vault/00_Inbox/*.md`.
- **Keyword Dictionary:** Hardcoded mapping of Goal IDs to semantic keywords.

## Processing Logic
1.  **File Discovery:** Iterates through all Markdown files in the Inbox.
2.  **Keyword Analysis:** Performs case-insensitive keyword matching against the file content to identify potential goal alignments.
3.  **Summary Extraction:** Captures the first three meaningful lines of the note to generate a "Quick Summary."
4.  **Intelligence Injection:** 
    - Construct a `## 🧠 Intelligence Router` block.
    - Includes suggested `#goal-gXX` tags.
    - Recommends a destination folder (e.g., `02_Projects/Goal-G04`).
    - Prepends this block to the file, preserving existing YAML frontmatter.

## Outputs
- **Modified Markdown Files:** Updated notes in the Obsidian Inbox with the routing header.
- **Console Output:** Success/error log for each processed file.

## Dependencies
### Systems
- **Obsidian Vault:** Local filesystem access to the vault.
- [S11 Intelligence Router](../../20_Systems/S11_Intelligence_Router/README.md) - Conceptual parent system.

### External Services
- None (Local file processing only).

## Error Handling
| Failure Scenario | Detection | Response | Alert |
|---|---|---|---|
| Inbox Missing | Directory existence check | Print "❌ Inbox not found" and exit | Console |
| Read/Write Permission | `OSError` during file IO | Skip file and log error | Console |
| Formatting Error | Invalid frontmatter regex | Fallback to prepending at the start of file | Console |

## Security Notes
- **Local Only:** This script operates entirely on the local filesystem.
- **Data Integrity:** It performs a non-destructive prepend, ensuring no original note content is lost.

## Manual Fallback
Users can manually tag and move files using the suggested goals provided in the injected routing block.

## Related Documentation
- [Goal: G11 Meta-System Integration & Optimization](../../10_Goals/G11_Meta-System-Integration-Optimization/README.md)
- [System: S11 Intelligence Router](../../20_Systems/S11_Intelligence_Router/README.md)
