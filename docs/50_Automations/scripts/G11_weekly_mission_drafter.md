---
title: "Weekly Mission Drafter (G11)"
type: "automation_spec"
status: "active"
owner: "Michał"
updated: "2026-04-02"
---

# Purpose
The **Weekly Mission Drafter** (`G11_weekly_mission_drafter.py`) automates the strategic planning phase for the upcoming week. It eliminates the manual effort of reviewing 12 separate roadmaps by autonomously identifying next-step tasks and drafting a structured review note.

# Scope
- **In Scope:** Scanning `docs/10_Goals/*/Roadmap.md`, identifying "Pending" tasks in the Q2 section, creating new `.md` files in the Reviews directory.
- **Out Scope:** Updating the actual status of tasks (handled by the Goal Progress Orchestrator).

# Logic
- **Selection:** Picks the first 2 "Pending" (`- [ ]`) tasks from each goal's Q2 section.
- **Dating:** Targets the upcoming ISO week (W+1).
- **Format:** Generates a full Markdown note with sections for Suggested Focus, Retrospective, and Energy tracking.

# Inputs/Outputs
- **Inputs:** All 12 Goal Roadmaps.
- **Outputs:** `Obsidian Vault/03_Areas/A - Systems/Reviews/YYYY-WXX.md`.

# Dependencies
- **Systems:** S10 (Daily Goals Automation), G11 (Meta-System)
- **Files:** Obsidian Vault path.

# Procedure
- Automatically executed by `autonomous_daily_manager.py` during the sync.
- Deduplication: Skips generation if the file already exists.

# Failure Modes
| Scenario | Response |
|----------|----------|
| Roadmap Format Changed | Regex might fail to find Q2; script logs warning. |
| Goal Deleted | Script ignores non-existent paths. |

# Security Notes
- Read access to roadmaps, Write access to the Reviews directory.

# Owner + Review Cadence
- **Owner:** Michał
- **Review:** Monthly (verify quality of suggested focus)
