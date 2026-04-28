---
title: "Mission Aggregator (G11)"
type: "automation_spec"
status: "active"
owner: "Michał"
updated: "2026-04-28"
---

# Purpose
The **Mission Aggregator** (`G11_mission_aggregator.py`) is a meta-automation designed to eliminate morning decision fatigue. It consolidates tasks from multiple autonomous sources, ranks them by strategic priority, and presents a single "Golden Mission" (Top 5) for the day.

# Scope
- **In Scope:** Google Tasks (Triaged), Quick Wins (Logistics/Pantry/Finance/Learning), Roadmap Missions (G01-G12), Digital Twin Primary Directive.
- **Out Scope:** Manual calendar events (handled by G10 Schedule Optimizer), low-priority habits.

# Inputs/Outputs
- **Inputs:** 
  - `_meta/triaged_tasks.json` (G11 Task Triage)
  - `G11_quick_wins.py` (Domain-specific wins)
  - `G04_digital_twin_engine.py` (Strategic context)
  - `morning_mission.txt` (via `engine.get_primary_directive()`)
- **Outputs:** Markdown formatted "Top 5" list for the Obsidian Daily Note.

# Logic Flow (Updated Apr 23)
1. **Directives:** Fetches the top-level mission from `morning_mission.txt`.
2. **Roadmaps:** Scans goal roadmaps for incomplete tasks specifically for the current quarter.
3. **Sentinels:** Pulls alerts from logistics, health, and relationship agents.
4. **Dynamic Weighting (NEW Apr 23):** Fetches the latest biological readiness score (G07).
    *   **Peak State (>85):** Increases the priority weight of **Study Alerts (G06)** to 11.3, ensuring deep work learning tasks rise to the Top 5 when the user's cognitive state is optimal.
5. **Ranking:** Applies weighted scoring (Directive > Sentinel > Heal > Learn (Peak) > Tasks > Wins).

# Dependencies
- **Systems:** S04 (Digital Twin), S08 (Automation Orchestrator)
- **Files:** `.env` (DB Credentials), `G04_digital_twin_engine.py`, `morning_mission.txt`

# Procedure
- Triggered automatically by `autonomous_daily_manager.py` during the morning sync.
- Can be run manually: `python3 scripts/G11_mission_aggregator.py`

# Failure Modes
| Scenario | Detection | Response |
|----------|-----------|----------|
| Missing morning_mission.txt | FileNotFoundError | Fallback to "Execute 2026 Power Goals" |
| Quarter Mismatch | Empty Roadmap results | Engine auto-detects quarter from system clock |
| DB connection error | quick_wins fails | Skip DB-driven wins |

# Security Notes
- No secrets stored in script.
- Uses standard DB environment variables.

# Owner + Review Cadence
- **Owner:** Michał
- **Review:** Monthly (Goal G11 audit)
