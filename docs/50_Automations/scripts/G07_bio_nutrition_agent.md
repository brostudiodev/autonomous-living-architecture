---
title: "G07: Bio-Nutrition Agent"
type: "automation"
status: "active"
owner: "Michal"
updated: "2026-04-18"
goal_id: "goal-g07"
---

# G07: Bio-Nutrition Agent

## Purpose
Provides daily nutritional and supplemental recommendations based on the previous day's training volume and today's biological recovery state.

## Scope
- **In Scope:**
    - Analyzing `workout_sets` volume in `autonomous_training`.
    - Analyzing `biometrics` (HRV/Readiness) in `autonomous_health`.
    - Generating rule-based recovery advice.
- **Out Scope:**
    - Medical prescriptions (Advisory only).

## Inputs/Outputs
- **Inputs:**
    - PostgreSQL (`autonomous_training`, `autonomous_health`).
- **Outputs:**
    - Markdown report for the Daily Note.

## Dependencies
- **Systems:** [S03 Data Layer](../../20_Systems/S03_Data-Layer/README.md)
- **Goal:** [G01 Target Body Fat](../../10_Goals/G01_Target-Body-Fat/README.md)

## Procedure
```bash
{{ROOT_LOCATION}}/autonomous-living/.venv/bin/python3 scripts/G07_bio_nutrition_agent.py
```

## Owner + Review Cadence
- **Owner:** Michal
- **Review Cadence:** Quarterly review of recovery performance.
