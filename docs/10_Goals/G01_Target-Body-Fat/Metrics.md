---
title: "G01: Metrics"
type: "goal_metrics"
status: "active"
goal_id: "goal-g01"
owner: "Michal"
updated: "2026-02-07"
---

# Metrics

## KPI list
| Metric | Target | How measured | Frequency | Owner |
|---|---:|---|---|---|
| Body fat % (7-day MA) | -2 to -4% vs Jan baseline | `v_body_composition` (PostgreSQL) | Daily log, weekly eval | Michal |
| Waist Circumference | Trending down | `physical_measurements` (PostgreSQL) | Every 15 days | Michal |
| Progress Photos | 100% compliance | `physical_measurements.has_photo` | Monthly | Michal |
| Training frequency | 2–4 sessions/week | `workouts` table (PostgreSQL) | Weekly | Auto (script) |
| Load progression rate | +2.5–5% per exercise per month | `workout_sets` (PostgreSQL) trend | Monthly | Auto (script) |

## Leading indicators (predict success)
- **Biological Readiness:** `readiness_score >= 80` (weighted HRV/Sleep algorithm)
- **Session consistency:** training 2+ times per week without skipping >7 days
- **Form quality:** `form_quality_score >= 4` in 95%+ of logged sets (injury prevention)

## Lagging indicators (confirm success)
- **Body composition trend:** BF% 7-day moving average direction
- **Waist measurement:** primary physical signal (verifies fat loss)
- **Strength trend:** average `weight_kg` per exercise trending up or stable

## Data Sources
- **Training data:** Google Sheets → PostgreSQL (`autonomous_training`)
  - Automation: [n8n: Training-Sync](../../50_Automations/n8n/workflows/WF003__training-data-sync.md)
- **Biometrics:** Zepp Cloud → PostgreSQL (`autonomous_health`)
- **Body measurements:** Manual input → PostgreSQL (`physical_measurements`)
- **Aggregations:** Digital Twin Engine pulling from PostgreSQL

## Measurement Validity Notes
- **Smart scale BF%:** Noisy (±2% day-to-day). Use 7-day moving average only.
- **Waist measurement:** More reliable signal; measure monthly under same conditions (morning, fasted, same location).
- **TUT (time under tension):** Subjective timing during set; ±5s variance acceptable.

