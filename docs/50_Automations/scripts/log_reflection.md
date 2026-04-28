---
title: "G10: Daily Reflection Logger"
type: "automation_spec"
status: "active"
automation_id: "log_reflection.py"
goal_id: "goal-g10"
systems: ["S10"]
owner: "Michał"
updated: "2026-03-19"
---

# G10: Daily Reflection Logger

## Purpose
Provides a standardized method for logging evening reflections (mood, energy, highlights) into the Obsidian daily note. It supports both interactive CLI usage and automated logging via the Telegram bot.

## Triggers
- **Manual (Interactive):** `python3 scripts/log_reflection.py`
- **Manual (Obsidian):** Triggered via `[🧠 Log Evening Reflection]` button in Daily Note.
- **Remote (Telegram):** Triggered via `/reflect` command in the Digital Twin Bot.

## Inputs
- **Command Line Arguments:** `--mood`, `--energy`, `--highlight`, `--frustration` (optional).
- **Interactive Prompts:** If no arguments are provided.
- **Target File:** `01_Daily_Notes/YYYY-MM-DD.md`.

## Processing Logic
1.  **Argument Parsing:** Determines if running in interactive or automated mode.
2.  **Mapping:** Converts numeric IDs (1-5) to human-readable labels (e.g., `1` → `😄 great`).
3.  **File Access:** Locates the current day's Obsidian note.
4.  **Surgical Update:** Uses regex to precisely replace the `mood:`, `energy:`, `highlight:`, and `frustration:` fields in the YAML frontmatter without disturbing other data.

## Outputs
- **Obsidian Vault:** Updated frontmatter in the current Daily Note.

## Dependencies
### Systems
- [S10 Daily Goals Automation](../../20_Systems/S10_Daily-Goals-Automation/README.md)
- [G04 Digital Twin Bot](../../10_Goals/G04_Digital-Twin-Ecosystem/README.md)

## Error Handling
| Failure Scenario | Detection | Response | Alert |
|---|---|---|---|
| Note Not Found | `os.path.exists` failure | Log error, abort | Console Error |
| YAML Syntax Error | Regex mismatch | Skip update | Console Error |
| Invalid ID | Key not in map | Fallback to "3 - normal" or "😐 ok" | Console Warn |

## Manual Fallback
If the logger fails:
1.  Open the Obsidian Daily Note manually.
2.  Edit the YAML frontmatter directly using the provided drop-down lists or manual typing.
