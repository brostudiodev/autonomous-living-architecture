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
| Training frequency | 2–4 sessions/week | `workouts` table (PostgreSQL) | Weekly | Auto (script) |
| Load progression rate | +2.5–5% per exercise per month | `workout_sets` (PostgreSQL) trend | Monthly | Auto (script) |
| TUT compliance | 80%+ sets achieve 60–90s TUT | `workout_sets.tut_s` (PostgreSQL) | Monthly | Auto (script) |
| Max effort adherence | 90%+ sessions logged `max_effort=true` | `workouts.is_max_effort` (PostgreSQL) | Monthly | Auto (script) |
| Logging latency | <60s post-workout | Manual observation | Quarterly check-in | Michal |

## Leading indicators (predict success)
- **Session consistency:** training 2+ times per week without skipping >7 days
- **Recovery scores:** `recovery_score >= 4` in 70%+ of sessions (good readiness)
- **Form quality:** `form_quality_score >= 4` in 95%+ of logged sets (injury prevention)

## Lagging indicators (confirm success)
- **Body composition trend:** BF% 7-day moving average direction
- **Strength trend:** average `weight_kg` per exercise trending up or stable
- **Waist measurement:** monthly manual measurement (backup metric if scale BF% is unreliable)

## Data Sources
- **Training data:** Google Sheets → PostgreSQL (`autonomous_training`)
  - Automation: [n8n: Training-Sync](../../50_Automations/n8n/workflows/WF003__training-data-sync.md)
- **Body measurements:** Manual smart scale input to Google Sheets → PostgreSQL
- **Aggregations:** Prometheus Exporter (`g01-exporter.py`) pulling from PostgreSQL
  - Exporter: `infrastructure/scripts/g01-exporter.py`

## Measurement Validity Notes
- **Smart scale BF%:** Noisy (±2% day-to-day). Use 7-day moving average only.
- **Waist measurement:** More reliable signal; measure monthly under same conditions (morning, fasted, same location).
- **TUT (time under tension):** Subjective timing during set; ±5s variance acceptable.

