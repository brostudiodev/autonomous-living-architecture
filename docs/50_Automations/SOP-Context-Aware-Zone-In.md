---
title: "SOP: Context-Aware Zone In"
type: "sop"
status: "active"
owner: "Michal"
updated: "2026-04-03"
---

# SOP: Context-Aware Zone In (Deep Work Accelerator)

## Purpose
Minimizes "Time to Focus" by automatically preparing the digital environment based on the current Golden Mission and recent coding activity.

## Scope
- **In Scope:** Mission aggregation, IDE folder/file focusing, Roadmap navigation, context briefing.
- **Out Scope:** Direct code writing or testing execution.

## Inputs/Outputs
- **Inputs:** `docs/10_Goals/GXX_Goal/Activity-log.md`, `digital_twin_michal.missions`.
- **Outputs:** Generated `zone_in.sh` in the project root.

## Dependencies
- **Systems:** VS Code/Cursor (with `code` CLI), Obsidian (with `obsidian://` URL scheme support).
- **Scripts:** `G10_zone_in_orchestrator.py`, `G11_mission_aggregator.py`.

## Procedure

### Using Zone In
1. **Trigger:** Run `./zone_in.sh` from the repository root.
2. **Review:** Read the **🧠 CONTEXT BRIEFING** in the terminal to recall the last action and file.
3. **Execution:** The IDE will open to the project folder AND focus the last edited file. Obsidian will focus the relevant goal roadmap.

### Updating Mission Context
Missions are automatically updated via `G11_mission_aggregator.py`. If the `zone_in.sh` is pointing to the wrong goal:
1. Ensure the `Daily Note` mission has the correct Goal ID (e.g., `G10`).
2. Re-run `G10_zone_in_orchestrator.py` or wait for the global sync.

## Failure Modes
| Scenario | Detection | Response |
|----------|-----------|----------|
| `code` command not found | Script errors in terminal | Ensure VS Code is in PATH |
| Wrong file opened | Context briefing shows old file | Ensure you are logging `**Code:**` in `Activity-log.md` |
| No missions found | Script skips generation | Update Today's Mission in the Daily Note |

## Security Notes
- Script only accesses local file paths and public URL schemes. No external credentials used.

## Owner + Review Cadence
- **Owner:** Michal
- **Review:** Bi-monthly or when new IDE/Vault structures are introduced.
