---
title: "G04: Trend Forecaster"
type: "automation_spec"
status: "active"
automation_id: "G04_trend_forecaster"
goal_id: "goal-g04"
systems: ["S04"]
owner: "Michał"
updated: "2026-04-19"
---

# G04: Trend Forecaster

## Purpose
Provides predictive analytics for the Digital Twin ecosystem. Uses linear regression to estimate the date a specific metric target (e.g., 15% body fat) will be reached based on historical trends.

## Features
- **Linear Regression Modeling:** Calculates the rate of change and R-squared confidence.
- **Smoothing:** Uses a 7-day rolling average to reduce noise from daily fluctuations.
- **Multi-Domain Support:** Handles health (weight, body fat) and finance metrics.
- **Unlocked Long-Term Analysis (Updated Apr 19):** Support for up to **3650 days (10 years)** of historical data. Prediction limits extended to 10 years to support long-term life goals.
- **Confidence Scoring:** Categorizes predictions as High/Medium/Low based on R² values.

## Triggers
- **On-Demand:** Called by Agent Zero when a user asks "When will I reach [target]?"
- **API:** Exposed via the Digital Twin API for programmatic forecasting.

## Inputs
- **Metric Name:** (e.g., `body_fat`, `weight`)
- **Target Value:** (numeric)
- **Domain:** (e.g., `health`, `finance`)
- **History Period:** Defaults to 3650 days.

## Outputs
- **Target Date:** (YYYY-MM-DD)
- **Days Remaining:** (integer)
- **R-Squared:** Accuracy of the linear fit.
- **Formatted Report:** Human-readable summary for Telegram/Obsidian.

## Dependencies
### Python Libraries
- `numpy`, `pandas`, `psycopg2`
- `scikit-learn` (optional, falls back to `numpy.polyfit`)

### Databases
- `autonomous_health`
- `autonomous_finance`

## Error Handling
| Failure Scenario | Detection | Response |
|---|---|---|
| Insufficient Data | `< 5` data points | Return "Insufficient data" error |
| Moving Away from Target | Negative/Positive slope check | Return "Moving away from target" warning |
| R² < 0.2 | R-squared calculation | Flag as "Very Low Confidence" |

---
*Updated: 2026-04-19 | Predictive Intelligence Layer v2.0*
