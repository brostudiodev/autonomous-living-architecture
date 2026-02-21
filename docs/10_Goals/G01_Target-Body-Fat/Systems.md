---
title: "G01: Systems"
type: "goal_systems"
status: "active"
goal_id: "goal-g01"
owner: "{{OWNER_NAME}}"
updated: "2026-02-07"
---

# Systems

## Enabling systems
- **[S03 Data Layer](../../20_Systems/S03_Data-Layer/README.md):** CSV storage, Git versioning
- **[S01 Observability & Monitoring](../../20_Systems/S01_Observability-Monitoring/README.md):** Planned monthly review dashboards
- **[S00 Homelab Platform](../../20_Systems/S00_Homelab-Platform/README.md):** GitHub Actions runner environment

## Traceability (Outcome → System → Automation → SOP)

| Outcome | System | Automation | SOP/Runbook |
|---|---|---|---|
| Capture workout data (mobile) | S03 Data Layer | Google Sheets (manual input) | [Training/README.md](Training/README.md#logging-workflow) |
| Sync Sheets → GitHub | S03 Data Layer | [WF_G01_001__sheets-to-github-sync](../../50_Automations/github-actions/WF_G01_001__sheets-to-github-sync.md) | [Runbook: Sync Failures](../../40_Runbooks/G01/Sheets-Sync-Failure.md) |
| Validate CSV schemas | S03 Data Layer | (built into WF_G01_001) | [Runbook: Schema Validation Failures](../../40_Runbooks/G01/Schema-Validation-Failure.md) |
| Track body composition | S03 Data Layer | Google Sheets `measurements` tab | [Training/README.md](Training/README.md#measurement-logging) |
| Autonomous training data sync | S03 Data Layer | [WF003__training-data-sync](../../50_Automations/n8n/workflows/WF003__training-data-sync.md) | [Weekly-Training-Review.md](../../30_Sops/Weekly-Training-Review.md) |
| Monthly progress review | S01 Observability | [script: g01_monthly_review.py](../../50_Automations/scripts/g01_monthly_review.py) (planned Q1) | [SOP: G01 Monthly Review](../../30_Sops/G01/Monthly-Review.md) (planned) |
| Progression decisions | S01 Observability | [script: g01_next_session_planner.py](../../50_Automations/scripts/g01_next_session_planner.py) (planned Q2) | [SOP: G01 Pre-Workout Brief](../../30_Sops/G01/Pre-Workout-Brief.md) (planned) |

**Note:** All automation/script references link to actual documentation in `docs/50_Automations/`.

