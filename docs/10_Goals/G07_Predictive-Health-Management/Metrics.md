---
title: "G07: Metrics"
type: "goal_metrics"
status: "active"
owner: "Michal"
updated: "2026-02-07"
---

# Metrics

## KPI list
| Metric | Target | How measured | Frequency | Owner |
|---|---:|---|---|---|
| Body Weight | 80kg | [script: G07_weight_sync.py](../../50_Automations/scripts/G07-weight-sync.md) | Daily | Michal |
| Sleep Score | >85 | [script: G07_zepp_sync.py](../../50_Automations/scripts/G07-zepp-sync.md) | Daily | Michal |
| Daily Steps | 10,000 | [script: G07_zepp_sync.py](../../50_Automations/scripts/G07-zepp-sync.md) | Daily | Michal |
| HRV (ms) | >50 | [script: G07_zepp_sync.py](../../50_Automations/scripts/G07-zepp-sync.md) | Daily | Michal |

## Data Sources
- **Weight/Fat:** Withings API (via `G07_weight_sync.py`)
- **Sleep/HR/Steps:** Zepp Cloud (via `G07_zepp_sync.py`)
- **Caloric Intake:** Manual Log (Obsidian) synced to `autonomous_training`

