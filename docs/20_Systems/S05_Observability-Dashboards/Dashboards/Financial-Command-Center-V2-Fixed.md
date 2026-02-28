---
title: "Grafana Dashboard: Financial Command Center (Real Savings Intelligence V2 - Fixed)"
type: "dashboard_spec"
status: "active"
dashboard_uid: "financial-command-center-real-v2-fixed"
goal_id: "goal-g05"
system_id: "system-s05"
owner: "Michal"
updated: "2026-02-25"
review_cadence: "monthly"
---

# Grafana Dashboard: Financial Command Center (Real Savings Intelligence V2 - Fixed)

## Purpose
Provide near-real-time financial situational awareness using a "real savings" interpretation (actual savings transfers / real income), plus supporting panels for cash flow, budget utilization, and month-end projections.

## Scope
### In Scope
- Read-only visualization of `autonomous_finance` database views/tables.
- Variable-driven filtering (year/category/account) for faster diagnosis.

### Out of Scope
- Data modeling, ETL, and view generation (owned by the data layer).
- Data entry.

## Inputs / Outputs
### Inputs
- PostgreSQL database: `autonomous_finance`
- Key tables/views used by this dashboard:
  - `transactions`
  - `categories`
  - `accounts`
  - `v_daily_cashflow`
  - `v_budget_performance`
  - `v_monthly_pnl`

### Outputs
- Gauges and charts for savings rate, actual savings, projection, cashflow, budget, income/expenses.

## Dashboard Details
- **Title:** 💰 Financial Command Center - Real Savings Intelligence (V2 - Fixed)
- **UID:** `financial-command-center-real-v2-fixed`
- **Source JSON:** `/home/{{USER}}/grafana/dashboards/Financial-Command-Center.json`
- **Provisioning:** `/home/{{USER}}/grafana/provisioning/dashboards/dashboard.yml`
- **Default refresh:** `30s`
- **Default time range:** `now-6M → now`

## Data Source
- **Grafana datasource name:** `autonomous_finance`
- **Grafana datasource UID:** `autonomous-finance`
- **Type:** `grafana-postgresql-datasource`
- **Provisioning file:** `/home/{{USER}}/grafana/provisioning/datasources/datasources.yml`

Connection requirements:
- Must have a default database configured:
  - `database: autonomous_finance`
  - `jsonData.database: autonomous_finance`
- DB user must have `SELECT` on all referenced objects.

## Variables
- `selected_year` (query variable)
- `category_filter` (query variable)
- `account_filter` (query variable)
- `data_source_filter` (custom variable)

Operational note:
- Even for custom variables, explicitly pinning a datasource avoids Grafana falling back to a "default" datasource.

## Panels (What They Mean)
1. **💰 Real Savings Rate (V2 - Fixed)**
- Computes savings rate over recent months, filtered by `selected_year`.

2. **💰 Amount Actually Saved**
- Computes actual savings MTD using transfers and/or account heuristics.

3. **🎯 Month-End Projection**
- Projects savings by scaling MTD savings to full month.

4. **📈 Real Savings Rate Trajectory (12 Months)**
- Trend of savings rate over last 12 months plus target line.

5. **📊 Daily Cash Flow Analysis (Current Month)**
- Daily income/expense/net plus MTD cumulative.

6. **🎯 Budget Performance Matrix (Current Month)**
- Utilization and status by category.

7. **Actual Income (Monthly)**
- Monthly income time series.

8. **Actual Expenses (Monthly)**
- Monthly expenses time series.

## Dependencies
- Grafana service (container `grafana`).
- PostgreSQL service (container `local-ai-packaged-postgres-1`).
- Data layer must maintain views: `v_daily_cashflow`, `v_budget_performance`, `v_monthly_pnl`.

## Procedure
### Daily
- Check savings rate gauge + budget matrix for anomalies.
- If anomalies exist, drill into cashflow panel for the day.

### Weekly
- Review budget utilization top categories.
- Verify that variable dropdowns populate correctly.

### Monthly
- Compare month-end projection vs actual.
- Review query performance if panels load slowly.

## Validation
### Validate datasource and a key query
```bash
curl -fsS -u 'admin:autonomous2026' http://localhost:3003/api/datasources/uid/autonomous-finance | jq '{uid,type,database,jsonData}'

curl -fsS -u 'admin:autonomous2026' -H 'Content-Type: application/json' \
  http://localhost:3003/api/ds/query \
  -d '{"queries":[{"refId":"A","datasource":{"uid":"autonomous-finance"},"rawSql":"SELECT COUNT(*) AS n FROM transactions;","format":"table"}],"from":"now-30d","to":"now"}'
```

## Failure Modes
| Scenario | Detection | Response |
|---|---|---|
| Datasource missing default DB | Grafana error: no default database configured | Ensure datasource has `database` and `jsonData.database` set to `autonomous_finance` |
| Variables not populating | Dropdown errors / empty options | Validate datasource connectivity + permissions; check variable SQL |
| Budget matrix empty | Panel shows no rows | Confirm data in `v_budget_performance` for current month |
| Savings rate looks wrong | Gauge unrealistic | Validate category/subcategory mapping; validate view logic upstream |
| Slow dashboard | Panels take seconds to load | Add indexes / optimize views in DB; reduce range or refresh rate |

## Security Notes
- Financial data is sensitive; restrict access.
- Keep DB credentials only in env/provisioning (`AUTONOMOUS_POSTGRES_PASSWORD`).

## Owner + Review Cadence
- **Owner:** Michal
- **Review cadence:** Monthly
- **Last updated:** 2026-02-25
