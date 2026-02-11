---
title: "S05: Observability & Dashboards"
type: "system"
status: "active"
system_id: "system-s05"
owner: "Michał"
updated: "2026-02-07"
---

# S05: Observability & Dashboards

## Purpose
Provides real-time visualization and monitoring of financial data through Grafana dashboards, enabling autonomous financial decision-making and immediate detection of anomalies.

## Components

### Grafana Dashboard: Financial Command Center
- **UID:** `financial-command-center-real`
- **File:** `financial-command-center-real.json`
- **Purpose:** Complete financial situational awareness in <30 seconds

#### Key Panels
1. **Real Savings Rate Gauge** - Current month savings rate with realistic 5-35% range
2. **Amount Actually Saved** - Total saved in PLN for current month
3. **Expense Ratio** - Percentage of income spent on expenses
4. **12-Month Trajectory** - Historical savings rate trend with target line
5. **Budget Performance Matrix** - Real-time budget utilization with color coding
6. **Monthly Income vs Expenses** - 6-month comparative analysis
7. **Daily Cash Flow** - Last 30 days cash flow visualization

### Variables and Filters
- **selected_year:** Filter data by specific year
- **category_filter:** Filter by expense category
- **account_filter:** Filter by bank account
- **data_source_filter:** Data source selection (Atomic/Historical)

## Dependencies
- **S03 Data Layer:** PostgreSQL views and functions for data queries
- **PostgreSQL Database:** Primary data source for all panels
- **Grafana Server:** Dashboard hosting and visualization

## Configuration
- **Refresh Rate:** 30 seconds
- **Time Range:** Last 6 months (default)
- **Timezone:** Browser local time
- **Theme:** Dark mode optimized

## Deployment Instructions

### Import Dashboard
1. Navigate to Grafana UI → Dashboards → New → Import
2. Paste the JSON from `financial-command-center-real.json`
3. Select PostgreSQL datasource when prompted
4. Verify all variables populate correctly

### Datasource Configuration
- PostgreSQL connection must be configured as `${DS_POSTGRESQL}`
- Database should contain all views from S03 Data Layer
- User must have SELECT permissions on all financial tables and views

### Validation Checklist
- [ ] Real Savings Rate shows 5-35% range (not 98%)
- [ ] Budget Performance Matrix populates with current month data
- [ ] All dropdown variables populate with actual data
- [ ] Panels refresh without errors
- [ ] Color coding works correctly (green/yellow/red)

## Troubleshooting

### Common Issues
- **98% Savings Rate:** Check if `v_real_savings_monthly` view is deployed
- **Empty Budget Matrix:** Verify budget data exists for current month
- **Variable Errors:** Check database connectivity and permissions
- **Panel Errors:** Verify SQL queries match actual table schema

### Health Monitoring
```sql
-- Check dashboard data freshness
SELECT 
    MAX(transaction_date) as latest_transaction,
    COUNT(*) as recent_transactions
FROM transactions
WHERE transaction_date >= CURRENT_DATE - INTERVAL '7 days';
```

## Related Systems
- [S03 Data Layer](../S03_Data-Layer/README.md) - Data source
- [S08 Automation Orchestrator](../S08_Automation-Orchestrator/README.md) - Alerting workflows
- [G05 Autonomous Finance](../../10_GOALS/G05_Autonomous-Financial-Command-Center/README.md) - Primary goal