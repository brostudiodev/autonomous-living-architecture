---
title: "S05: Observability & Financial Dashboards"
type: "system"
status: "active"
system_id: "system-s05"
owner: "Michał"
updated: "2026-02-16"
review_cadence: "monthly"
---

# S05: Observability & Financial Dashboards

## Purpose
Provides real-time visualization and monitoring of financial data through Grafana dashboards, enabling autonomous financial decision-making and immediate detection of anomalies.

## Components

### Grafana Dashboard: Financial Command Center V2
- **UID:** `financial-command-center-real-v2`
- **File:** `Financial-Command-Center.json` (contains V2 dashboard definition)
- **Purpose:** Complete financial situational awareness in <30 seconds

#### Key Panels
1. **Real_Savings_Rate_Gauge** - Current month savings rate (5-35% range)
2. **Total_Saved_PLN** - Total saved in PLN for current month
3. **Projected_Month_End_Savings** - Provides a projection of month-end savings
4. **Real_Savings_Rate_Trajectory** - Historical savings rate trend with target line
5. **Daily_Cash_Flow** - Last 30 days cash flow visualization
6. **Budget_Performance_Matrix** - Real-time budget utilization with color coding
7. **Actual Income (Monthly)** - Actual total income per month
8. **Actual Expenses (Monthly)** - Actual total expenses per month

#### SQL Query Formatting Requirements
Due to specific and highly sensitive parsing behavior of Grafana's PostgreSQL data source plugin, all SQL queries (`rawSql` fields) within this dashboard's JSON definition **MUST** adhere to the following strict formatting rules:

1.  **Single-Line Only**: The entire SQL query for a given panel must reside on a single logical line. Newline characters (`\n` or `\\n` when escaped in JSON) are *not* supported and will cause syntax errors.
2.  **No SQL Comments**: Neither single-line comments (`--`) nor multi-line comments (`/* ... */`) are permitted within the `rawSql` field, as they will be misinterpreted as part of the query or comment out the entire query.
3.  **Underscores for Spaces in Aliases**: Column aliases containing spaces or special characters **MUST** be converted to use underscores. For example, `AS "Total Expenses"` or `AS Total Expenses` must become `AS Total_Expenses`.
4.  **No Double Quotes for Aliases**: Double quotes (`"`) around column aliases are *not* supported and will lead to `pq: syntax error at or near \"` errors. Aliases should be unquoted.
5.  **No Backslashes (`\`)**: No backslash characters should be present in the `rawSql` string for any purpose, as they are misinterpreted by the plugin.

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
2. Paste the JSON from `Financial-Command-Center.json` (V2 content) located in `/home/michal/Documents/autonomous-living/docs/Financial-Command-Center.json`
3. Select PostgreSQL datasource when prompted
4. Verify all variables populate correctly

### Datasource Configuration
- PostgreSQL connection must be configured as `{{INTERNAL_IP}}:5432`, database `autonomous_finance`, user `root`, password `admin`. This is provisioned via `autonomous-finance-db.yml` in `/home/michal/grafana/provisioning/datasources/`.
- Database should contain all views from S03 Data Layer
- User must have SELECT permissions on all financial tables and views

### Validation Checklist
- [ ] Real_Savings_Rate_Percent shows 5-35% range (not 98%)
- [ ] Budget_Performance_Matrix populates with current month data
- [ ] All dropdown variables populate with actual data
- [ ] Panels refresh without errors
- [ ] Color coding works correctly (green/yellow/red)

## Troubleshooting

### Common Issues
- **No Data / Empty Panels:** Review "SQL Query Formatting Requirements" above, check selected time range in Grafana, and verify data presence in PostgreSQL database.
- **98% Savings Rate:** Check if `v_real_savings_monthly` view is deployed
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
- [Financial Command Center - Real Savings Intelligence V2](./Dashboards/Financial-Command-Center-V2.md) - Detailed dashboard specification

## Procedure
1. **Daily:** Review dashboard for anomalies
2. **Weekly:** Check alert delivery, verify data freshness
3. **Monthly:** Review panel performance, tune queries
4. **Quarterly:** Audit dashboard access, update panels

## Failure Modes
| Scenario | Detection | Response |
|----------|-----------|----------|
| Dashboard not loading | Grafana timeout | Check Grafana container, nginx |
| Data stale | No recent transactions | Check S03 data pipeline |
| Panel error | SQL or rendering error | Debug query, fix data source |
| Alert not sent | Missing notification | Check S08 workflow status |

## Security Notes
- Dashboard behind authentication
- No sensitive data in panel titles
- Data source credentials in Grafana

## Owner & Review
- **Owner:** Michał
- **Review Cadence:** Monthly
- **Last Updated:** 2026-02-16