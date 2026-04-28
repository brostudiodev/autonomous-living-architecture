---
title: "G10 Boss Focus"
type: "automation"
status: "active"
owner: "Michał"
updated: "2026-04-24"
---

# G10: Boss Focus (Zero-Friction Context Switching)

## Purpose
Enables instantaneous switching between life domains by preparing the digital environment (IDE, Docs, URLs) for a specific goal, bypassing the daily mission if necessary.

## Scope
- **In Scope:** Manual goal focusing, IDE folder/file opening, Roadmap navigation.
- **Out Scope:** Changing the actual "Golden Mission" in the database (only overrides the local `zone_in.sh`).

## Inputs/Outputs
- **Inputs:** Goal ID (e.g., `G04`).
- **Outputs:** Updated `zone_in.sh` in the repository root.

## Dependencies
- **Systems:** VS Code/Cursor, Obsidian.
- **Scripts:** `G10_zone_in_orchestrator.py`.

## Procedure

### Using Boss Focus
1. **Command:** `python3 scripts/G10_zone_in_orchestrator.py GXX`
2. **Execute:** Run `./zone_in.sh` to apply the environment changes.

## Failure Modes
| Scenario | Detection | Response |
|----------|-----------|----------|
| Invalid Goal ID | Script defaults to root folder | Provide a valid G01-G12 ID |
| Log not found | Briefing shows "None recorded" | Manually log your first action in `Activity-log.md` |

## Security Notes
- No external APIs used. Operates entirely on the local filesystem.

## Owner + Review Cadence
- **Owner:** Michał
- **Review:** Bi-monthly.
