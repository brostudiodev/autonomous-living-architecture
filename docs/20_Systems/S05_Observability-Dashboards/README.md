---
title: "S05: Observability & Financial Dashboards"
type: "system"
status: "active"
system_id: "system-s05"
owner: "Michal"
updated: "2026-02-16"
review_cadence: "monthly"
---

# S05: Observability & Financial Dashboards

## Purpose
Provides real-time visualization and monitoring of financial data through Grafana dashboards, enabling autonomous financial decision-making and immediate detection of anomalies.

## Scope
### In Scope
- Grafana dashboard definitions (JSON).
- SQL query optimization for visualization performance.
- Automated dashboard provisioning and configuration.
- Real-time monitoring of budget performance and savings rates.

### Out of Scope
- Data processing or normalization (handled by S03).
- Direct data entry or modification.

## Inputs
- Aggregated financial data from S03 (PostgreSQL views).
- Monitoring signals from Prometheus exporters.
- User-defined filter variables (year, category, account).

## Outputs
- Visual charts and gauges for real-time situational awareness.
- PDF/PNG reports of financial performance.
- Visual alerts for budget threshold breaches.

## Components

### Grafana Dashboards (Provisioned)

1) **Goals Dashboard**
- **UID:** `goals-dashboard`
- **Source JSON:** `/home/{{USER}}/grafana/dashboards/goals-dashboard.json`
- **Datasource:** Prometheus (uid `prometheus`)
- **Documentation:** [Dashboards/Goals-Dashboard.md](./Dashboards/Goals-Dashboard.md)

2) **Static Goals Dashboard**
- **UID:** `static-goals-dashboard`
- **Source JSON:** `/home/{{USER}}/grafana/dashboards/static-goals-dashboard.json`
- **Datasource:** JSON API (uid `static-goals-json`)
- **Documentation:** [Dashboards/Static-Goals-Dashboard.md](./Dashboards/Static-Goals-Dashboard.md)

3) **G01: Peak Performance Dashboard (15% Target)**
- **UID:** `g01-performance-sql`
- **Source JSON:** `/home/{{USER}}/grafana/dashboards/g01-target-body-fat.json`
- **Datasource:** PostgreSQL `autonomous_training` (uid `autonomous-training`)
- **Documentation:** [Dashboards/G01-Peak-Performance-Dashboard.md](./Dashboards/G01-Peak-Performance-Dashboard.md)

4) **💰 Financial Command Center - Real Savings Intelligence (V2 - Fixed)**
- **UID:** `financial-command-center-real-v2-fixed`
- **Source JSON:** `/home/{{USER}}/grafana/dashboards/Financial-Command-Center.json`
- **Datasource:** PostgreSQL `autonomous_finance` (uid `autonomous-finance`)
- **Documentation:** [Dashboards/Financial-Command-Center-V2-Fixed.md](./Dashboards/Financial-Command-Center-V2-Fixed.md)

### PostgreSQL Datasource Notes (Critical)
Grafana's PostgreSQL datasource requires a default database name for connections.

In provisioning, set both:
- `database: <db_name>`
- `jsonData.database: <db_name>`

This prevents UI/runtime errors like:
"You do not currently have a default database configured for this data source…".

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
2. Paste the JSON from `Financial-Command-Center.json` (V2 content) located in `{{ROOT_LOCATION}}/autonomous-living/docs/Financial-Command-Center.json`
3. Select PostgreSQL datasource when prompted
4. Verify all variables populate correctly

### Datasource Configuration
- PostgreSQL connection must be configured as `{{INTERNAL_IP}}:5432`, database `autonomous_finance`, user `root`, password `admin`. This is provisioned via `autonomous-finance-db.yml` in `/home/{{USER}}/grafana/provisioning/datasources/`.
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
- [G05 Autonomous Finance](../../10_Goals/G05_Autonomous-Financial-Command-Center/README.md) - Primary goal
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
- **Owner:** Michal
- **Review Cadence:** Monthly
- **Last Updated:** 2026-02-16
---

## ☕ Fuel the Architecture

Building and maintaining this level of technical rigor is a massive investment. If this blueprint helps your own engineering journey, I would be grateful for your support.

<a href='https://ko-fi.com/michalnowakowski' target='_blank'><img height='60' style='border:0px;height:60px;' src='https://storage.ko-fi.com/cdn/kofi3.png?v=3' border='0' alt='Buy Me a Coffee at ko-fi.com' /></a>

**Support my hard work in engineering a fully autonomous life.** Every coffee fuels another line of code, another automated insight, and another step toward the 2026 North Star. Your contributions help maintain the infrastructure and research shared in this open-source blueprint.
