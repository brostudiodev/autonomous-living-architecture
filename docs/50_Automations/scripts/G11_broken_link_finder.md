---
title: "Automation Spec: G11_broken_link_finder.py"
type: "automation_spec"
status: "active"
owner: "Michał"
updated: "2026-04-23"
goal_id: "goal-g11"
---

# 🤖 Automation Spec: G11_broken_link_finder.py

## Purpose
Scans the entire Obsidian Vault for broken Wikilinks (links pointing to non-existent files) and provides a ranked list of the most frequent targets to help prioritize vault maintenance.

## Scope
- **In Scope:** `.md` files in Obsidian Vault (excluding `.git` and `.obsidian` folders).
- **Out Scope:** Fixing the links (read-only scan).

## Inputs/Outputs
- **Inputs:** Obsidian Vault directory
- **Outputs:** Console list of unique broken links and their counts.

## Dependencies
- **Systems:** Python 3, Obsidian Vault

## Procedure
1. Run: `python3 G11_broken_link_finder.py`
2. Analyze top broken targets and address via symlinking or note creation.

## Failure Modes
| Scenario | Detection | Response |
|----------|-----------|----------|
| File system error | `OSError` | Verify Vault path |
| Corrupt .md files | Script crash | Wrap `open()` in try/except for encoding issues |

## Security Notes
- Read-only access to vault.
- No sensitive data recorded.
