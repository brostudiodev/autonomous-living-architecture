---
title: "G02: Metrics"
type: "goal_metrics"
status: "active"
goal_id: "goal-g02"
updated: "2026-01-27"
---

# Metrics

## KPI List
| Metric | Target | How Measured | Frequency | Owner |
|---|---:|---|---|---|
| **Real Savings Rate** | ≥ 25% | PostgreSQL view `v_real_savings_monthly` | Monthly | Michał |
| **Projection Accuracy** | ≤ 5% error | Compare projected vs actual EoM | Monthly | Michał |
| **Data Freshness** | ≤ 24h lag | n8n workflow success rate | Daily | Michał |
| **Dashboard Uptime** | ≥ 99% | Grafana availability monitoring | Weekly | Michał |
| **Auto-categorization Rate** | ≥ 90% | Transactions with automatic categories | Weekly | Michał |

## Leading Indicators
- Daily budget burn rate vs. expected linear progression
- Number of uncategorized transactions requiring manual review
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

