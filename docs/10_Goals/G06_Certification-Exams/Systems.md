---
title: "G06: Systems"
type: "goal_systems"
status: "active"
goal_id: "goal-g06"
owner: "Michal"
updated: "2026-02-24"
---

# Systems

## Enabling systems
- [S03 Data Layer](../../20_Systems/S03_Data-Layer/README.md) - Dedicated `autonomous_learning` database.
- [S04 Digital Twin](../../20_Systems/S04_Digital-Twin/README.md) - Progress visualization.

## Traceability (Outcome → System → Automation → SOP)
| Outcome | System | Automation | SOP |
|---|---|---|---|
| Study Progress Tracking | S03 Data Layer | [G06_learning_sync.py](../../50_Automations/scripts/learning-sync.md) | - |
| Certification ROI Visualization | S04 Digital Twin | [v_learning_progress view](../../50_Automations/scripts/learning-sync.md) | - |
