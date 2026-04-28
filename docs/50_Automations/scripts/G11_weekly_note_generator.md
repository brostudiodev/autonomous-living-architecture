---
title: "Automation Spec: G11_weekly_note_generator.py"
type: "automation_spec"
status: "active"
owner: "Michał"
updated: "2026-04-23"
goal_id: "goal-g11"
---

# 🤖 Automation Spec: G11_weekly_note_generator.py

## Purpose
Generates missing Weekly Note files in the Obsidian Vault based on the `Weekly Review Template.md`. This resolves broken Wikilinks (e.g., `[2026-W01](2026-W01.md)`) across the vault by ensuring the target files exist.

## Scope
- **In Scope:** Scanning for missing weeks and "touching" files with basic template population.
- **Out Scope:** Filling in actual content or checking off tasks.

## Inputs/Outputs
- **Inputs:** `99_System/Templates/Weekly/Weekly Review Template.md`
- **Outputs:** `.md` files in `03_Areas/A - Systems/Reviews/`

## Dependencies
- **Systems:** Obsidian Vault
- **Hardware:** Local filesystem

## Procedure
1. Identify missing weeks (manually or via `G11_broken_link_finder.py`).
2. Run script: `python3 G11_weekly_note_generator.py`

## Failure Modes
| Scenario | Detection | Response |
|----------|-----------|----------|
| Template missing | FileNotFoundError | Verify template path in script |
| Permissions error | PermissionError | Ensure write access to Vault |

## Security Notes
- Script runs locally; no external API calls.
- No sensitive data handled.
