---
title: "G01: Metrics"
type: "goal_metrics"
status: "active"
goal_id: "goal-g01"
owner: "{{OWNER_NAME}}"
updated: "2026-02-07"
---

# Metrics

## KPI list
| Metric | Target | How measured | Frequency | Owner |
|---|---:|---|---|---|
| Body fat % (7-day MA) | -2 to -4% vs Jan baseline | Smart scale morning fasted | Daily log, weekly eval | {{OWNER_NAME}} |
| Training frequency | 2–4 sessions/week | Count rows in `workouts.csv` | Weekly | Auto (script) |
| Load progression rate | +2.5–5% per exercise per month | `weight_kg` trend in `sets.csv` | Monthly | Auto (script) |
| TUT compliance | 80%+ sets achieve 60–90s TUT | `tut_s` column analysis | Monthly | Auto (script) |
| Max effort adherence | 90%+ sessions logged `max_effort=true` | `max_effort` column count | Monthly | Auto (script) |
| Logging latency | <60s post-workout | Manual observation | Quarterly check-in | {{OWNER_NAME}} |

## Leading indicators (predict success)
- **Session consistency:** training 2+ times per week without skipping >7 days
- **Recovery scores:** `recovered_1_5 >= 4` in 70%+ of sessions (good readiness)
- **Form quality:** `form_ok=true` in 95%+ of logged sets (injury prevention)

## Lagging indicators (confirm success)
- **Body composition trend:** BF% 7-day moving average direction
- **Strength trend:** average `weight_kg` per exercise trending up or stable
- **Waist measurement:** monthly manual measurement (backup metric if scale BF% is unreliable)

## Data Sources
- **Training data:** Google Sheets → GitHub Actions sync → `Training/data/*.csv`
  - Automation: [WF_G01_001__sheets-to-github-sync](../../50_Automations/github-actions/WF_G01_001__sheets-to-github-sync.md)
- **Body measurements:** Manual smart scale input to Google Sheets (`measurements` tab)
- **Aggregations:** Monthly review script (planned Q1 2026)
  - Script: `scripts/g01_monthly_review.py` (to be created)

## Measurement Validity Notes
- **Smart scale BF%:** Noisy (±2% day-to-day). Use 7-day moving average only.
- **Waist measurement:** More reliable signal; measure monthly under same conditions (morning, fasted, same location).
- **TUT (time under tension):** Subjective timing during set; ±5s variance acceptable.

