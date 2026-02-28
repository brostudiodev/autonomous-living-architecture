---
title: "G01: Systems"
type: "goal_systems"
status: "active"
goal_id: "goal-g01"
owner: "Michal"
updated: "2026-02-07"
---

# Systems

## Enabling systems
- **[S03 Data Layer](../../20_Systems/S03_Data-Layer/README.md):** PostgreSQL `autonomous_training` database (Single Source of Truth).
- **[S01 Observability & Monitoring](../../20_Systems/S01_Observability-Monitoring/README.md):** Grafana dashboards and Prometheus exporter for real-time KPIs.
- **[S08 Automation Orchestrator](../../20_Systems/S08_Automation-Orchestrator/README.md):** n8n workflows for bidirectional Google Sheets ↔ PostgreSQL sync.

## Traceability (Outcome → System → Automation → SOP)

| Outcome | System | Automation | SOP/Runbook |
|---|---|---|---|
| Capture workout data (CLI) | S06 Health Performance | [smart_log_workout.py](../../50_Automations/scripts/smart-log-workout.md) | - |
| Track body composition | S03 Data Layer | Google Sheets `measurements` tab | [Training/README.md](Training/README.md#measurement-logging) |
| Autonomous training data sync | S03 Data Layer | [n8n: Training-Data-Sync](../../50_Automations/n8n/workflows/WF003__training-data-sync.md) | [Weekly-Training-Review.md](../../30_Sops/Weekly-Training-Review.md) |
| Monthly progress review | S01 Observability | [script: g01-monthly-reporter](../../50_Automations/scripts/g01-monthly-reporter.md) | [SOP: G01 Monthly Review](../../30_Sops/G01/Monthly-Review.md) |
| Weekly Strength Gains Report | S01 Observability | [script: G01_strength_gains_reporter](../../50_Automations/scripts/G01-strength-gains-reporter.md) | - |
| Progression decisions | S04 Digital Twin | [training-planner.py](../../50_Automations/scripts/training-planner.md) | [SOP: G01 Pre-Workout Brief](../../30_Sops/G01/Pre-Workout-Brief.md) |
| Prometheus Metrics | S01 Observability | - | - |

**Note:** All automation/script references link to actual documentation in `docs/50_Automations/`.

