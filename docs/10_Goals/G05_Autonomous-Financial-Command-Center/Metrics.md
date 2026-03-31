---
title: "G05: Metrics"
type: "goal_metrics"
status: "active"
goal_id: "goal-g05"
owner: "Michal"
updated: "2026-02-07"
---

# Metrics

## KPI List
| Metric | Target | How Measured | Frequency | Owner |
|---|---:|---|---|---|
| **Real Savings Rate** | ≥ 25% | PostgreSQL view `v_real_savings_monthly` | Monthly | Michal |
| **Projection Accuracy** | ≤ 5% error | Compare projected vs actual EoM | Monthly | Michal |
| **Data Freshness** | ≤ 24h lag | n8n workflow success rate | Daily | Michal |
| **Dashboard Uptime** | ≥ 99% | Grafana availability monitoring | Weekly | Michal |
| **Auto-categorization Rate** | ≥ 90% | Transactions with automatic categories | Weekly | Michal |
| **Financial Admin ROI** | > 30 mins/month | [Autonomy ROI Tracker](../G04_Digital-Twin-Ecosystem/Systems.md) | Monthly | Digital Twin |

## Leading Indicators
- Daily budget burn rate vs. expected linear progression
- Number of uncategorized transactions requiring manual review
- Count of anomalous transactions (>2 standard deviations)
- Count of anomalous transactions (>2 standard deviations)

## Lagging Indicators
- Month-end actual savings rate
- Year-over-year net worth growth
- Budget variance analysis (planned vs actual spending)

## Data Sources
- **Primary:** PostgreSQL database views and functions
- **Automation:** n8n workflows for data ingestion and alerts
- **Visualization:** Grafana dashboard panels
- **Validation:** Manual spot-checks during weekly reviews

