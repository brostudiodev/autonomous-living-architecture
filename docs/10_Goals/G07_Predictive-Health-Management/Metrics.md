---
title: "G07: Metrics"
type: "goal_metrics"
status: "active"
owner: "Michał"
updated: "2026-02-07"
goal_id: "goal-g07"
---

# Metrics

## KPI list
| Metric | Target | How measured | Frequency | Owner |
|---|---:|---|---|---|
| Body Weight | 80kg | [script: G07_weight_sync.py](../../50_Automations/scripts/G07_weight_sync.md) | Daily | Michał |
| Sleep Score | >85 | [script: G07_zepp_sync.py](../../50_Automations/scripts/G07_zepp_sync.md) | Daily | Michał |
| Daily Steps | 10,000 | [script: G07_zepp_sync.py](../../50_Automations/scripts/G07_zepp_sync.md) | Daily | Michał |
| HRV (ms) | >50 | [script: G07_zepp_sync.py](../../50_Automations/scripts/G07_zepp_sync.md) | Daily | Michał |
| Total Hydration | 2500ml | [API: /hydration](../../50_Automations/scripts/G04_digital_twin_api.md) | Daily | Digital Twin |
| Caffeine Intake | < 400mg | [API: /log_coffee](../../50_Automations/scripts/G04_digital_twin_api.md) | Daily | Digital Twin |

## Data Sources
- **Weight/Fat:** Withings API (via `G07_weight_sync.py`)
- **Sleep/HR/Steps:** Zepp Cloud (via `G07_zepp_sync.py`)
- **Hydration/Caffeine:** Manual Log (via Digital Twin API) synced to `autonomous_health`. **Total Hydration** includes the water content of coffee (Espresso: 50ml, Other: 250ml).
- **Caloric Intake:** Manual Log (Obsidian) synced to `autonomous_training`

