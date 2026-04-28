---
title: "Zone-In Orchestrator (G10)"
type: "automation_spec"
status: "active"
owner: "Michał"
updated: "2026-04-02"
---

# Purpose
The **Zone-In Orchestrator** (`G10_zone_in_orchestrator.py`) minimizes context-switching friction by automatically preparing the user's environment for their top daily mission. It eliminates the "setup time" by generating an executable bridge between the strategic mission and the technical workspace.

# Scope
- **In Scope:** Generating `zone_in.sh`, mapping Goal IDs to repository paths and roadmaps.
- **Out Scope:** Managing browser tabs beyond initial URL launch or controlling IDE internal states.

# Logic
- **Context Extraction:** Identifies the primary goal (e.g., G04, G09) from the top-ranked mission in `G11_mission_aggregator`.
- **Script Generation:** Writes a shell script that uses `code` (IDE), `xdg-open` (Roadmap), and `obsidian://` (App focus) to ready the workspace.

# Inputs/Outputs
- **Inputs:** Top 1 mission from the Mission Aggregator.
- **Outputs:** `~/Documents/autonomous-living/zone_in.sh` (Executable).

# Dependencies
- **Systems:** S10 (Daily Goals Automation), G10 (Intelligent Productivity)
- **Tools:** `git`, `code` (Cursor/VSCode), `xdg-utils`

# Procedure
- Executed automatically as part of the daily morning sync.
- The user simply types `./zone_in.sh` in the terminal to begin their deep work block.

# Failure Modes
| Scenario | Response |
|----------|----------|
| No Missions Found | Script exits without overwriting the existing `zone_in.sh`. |
| Unknown Context | Falls back to opening the root repository and main README. |

# Security Notes
- Script generation is local and restricted to the user's home directory.

# Owner + Review Cadence
- **Owner:** Michał
- **Review:** Monthly (update context mappings for new projects)
