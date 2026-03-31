---
title: "G10: Mood & Energy Engine"
type: "automation_spec"
status: "active"
automation_id: "G10_mood_engine"
goal_id: "goal-g10"
systems: ["S09"]
owner: "Michal"
updated: "2026-03-31"
---

# G10: Mood & Energy Engine

## Purpose
Autonomously suggests `mood` and `energy` levels for the Obsidian Daily Note by correlating biometric, financial, and logistical data. This removes the friction of manual state logging when conditions are predictable.

## Triggers
- **Scheduled:** Part of `G11_global_sync.py` (triggers at 06:00).
- **Manual:** `python3 scripts/G10_mood_engine.py`.

## Inputs
- **Health:** Biometric Readiness and Sleep scores (G07).
- **Finance:** Count of active budget alerts (G05).
- **Logistics:** Count of urgent pantry stockouts (G03).

## Logic Flow
1.  **Energy Calculation (1-5):**
    *   `5 - peak`: Readiness > 85
    *   `4 - high`: Readiness > 75
    *   `3 - normal`: Baseline
    *   `2 - low`: Readiness < 65
    *   `1 - exhausted`: Readiness < 55
2.  **Mood Calculation:**
    *   Starts at 100 points.
    *   Deducts 20 pts for Readiness < 60.
    *   Deducts 10 pts for Sleep < 60.
    *   Deducts 10 pts per budget alert.
    *   Deducts 10 pts for >5 pantry stockouts.
    *   Maps result to: 😄 great, 🙂 good, 😐 ok, 😞 low, 💀 dead.
3.  **Persistence:**
    *   Checks if manual data already exists in `daily_intelligence`.
    *   Writes suggestion only if data is null or `is_automated=TRUE`.

## Outputs
- **Database:** `digital_twin_michal.daily_intelligence` (energy, mood, is_automated).
- **Obsidian:** Frontmatter fields updated via `autonomous_daily_manager.py`.

## Failure Modes
- **Stale Data:** If biometrics are missing, defaults to "normal" (3) and "ok".
- **Override:** Manual entries in the Daily Note or DB take precedence.

---
*Updated: 2026-03-31 | Initial automation specification.*
