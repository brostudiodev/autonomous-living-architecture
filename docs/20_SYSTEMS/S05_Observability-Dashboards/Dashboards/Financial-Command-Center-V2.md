---
title: "Financial Command Center - Real Savings Intelligence V2"
type: "dashboard_spec"
status: "active"
dashboard_id: "financial-command-center-real-v2"
goal_id: "goal-g05"
systems: ["system-s05", "system-s03"]
owner: "{{OWNER_NAME}}"
updated: "2026-02-15"
---

# Financial Command Center - Real Savings Intelligence V2

## Purpose
This Grafana dashboard provides real-time visualization and monitoring of financial data, specifically focusing on a "Real Savings Rate" and overall financial health metrics. It aims to offer complete financial situational awareness for autonomous wealth building, addressing issues with traditional savings rate calculations.

## SQL Query Formatting Requirements
Due to specific and highly sensitive parsing behavior of Grafana's PostgreSQL data source plugin, all SQL queries (`rawSql` fields) within this dashboard's JSON definition **MUST** adhere to the following strict formatting rules:

1.  **Single-Line Only**: The entire SQL query for a given panel must reside on a single logical line. Newline characters (`
` or `
` when escaped in JSON) are *not* supported and will cause syntax errors.
2.  **No SQL Comments**: Neither single-line comments (`--`) nor multi-line comments (`/* ... */`) are permitted within the `rawSql` field, as they will be misinterpreted as part of the query or comment out the entire query.
3.  **Underscores for Spaces in Aliases**: Column aliases containing spaces or special characters **MUST** be converted to use underscores. For example, `AS "Total Expenses"` or `AS Total Expenses` must become `AS Total_Expenses`.
4.  **No Double Quotes for Aliases**: Double quotes (`"`) around column aliases are *not* supported and will lead to `pq: syntax error at or near "` errors. Aliases should be unquoted.
5.  **No Backslashes (``)**: No backslash characters should be present in the `rawSql` string for any purpose, as they are misinterpreted by the plugin.

## Dashboard Details
-   **UID:** `financial-command-center-real-v2`
-   **Title:** `💰 Financial Command Center - Real Savings Intelligence V2`
-   **JSON File:** `docs/Documents/autonomous-living/docs/Financial-Command-Center.json` (Note: The actual file is named `Financial-Command-Center.json` and its contents reflect this V2 dashboard)
-   **Data Source:** `grafana-postgresql-datasource` (provisioned)
    *   **Host:** `{{INTERNAL_IP}}:5432`
    *   **Database:** `autonomous_finance`
    *   **User:** `root`
    *   **Password:** `admin` (from `ai-agents-masterclass/local-ai-packaged/.env`)

## Key Panels (and their cleaned SQL Queries)

### 1. 💰 Real Savings Rate (Current Month)
**Purpose:** Visualizes the actual savings rate for the current month.
**Cleaned SQL:**
```sql
WITH monthly_real_savings AS ( SELECT DATE_TRUNC('MONTH', t.transaction_date) as month, SUM(CASE WHEN t.type = 'Income' AND c.category_name NOT IN ('Initial Balance', 'INIT', 'Transfer', 'System') THEN t.amount ELSE 0 END) as real_income, SUM(CASE WHEN t.type = 'Expense' AND c.category_name = 'Financial' AND c.subcategory_name = 'Savings Transfers' THEN t.amount ELSE 0 END) as actual_savings FROM transactions t JOIN categories c ON t.category_id = c.category_id WHERE t.transaction_date >= CURRENT_DATE - INTERVAL '12 months' AND (EXTRACT(YEAR FROM t.transaction_date)::text = '${selected_year}' OR '${selected_year}' = '*') GROUP BY month ) SELECT month AS time, CASE WHEN real_income > 0 THEN ROUND((actual_savings / real_income) * 100, 2) ELSE 0 END as Real_Savings_Rate_Percent, 30 as Target_Rate, real_income as Income, actual_savings as Savings FROM monthly_real_savings WHERE real_income > 0 ORDER BY month;
```

### 2. 💵 Amount Actually Saved
**Purpose:** Displays the total amount of money actually saved in PLN for the current month.
**Cleaned SQL:**
```sql
SELECT now() AS time, COALESCE( GREATEST( (SELECT SUM(t.amount) FROM transactions t JOIN categories c ON t.category_id = c.category_id WHERE t.type = 'Expense' AND LOWER(c.category_name) = 'financial' AND LOWER(c.subcategory_name) = 'savings transfers' AND EXTRACT(YEAR FROM t.transaction_date) = EXTRACT(YEAR FROM CURRENT_DATE) AND EXTRACT(MONTH FROM t.transaction_date) = EXTRACT(MONTH FROM CURRENT_DATE)), (SELECT SUM(t.amount) FROM transactions t JOIN accounts a ON t.account_id = a.account_id WHERE (LOWER(a.account_name) LIKE '%saving%' OR LOWER(a.account_name) LIKE '%investment%') AND t.amount > 0 AND EXTRACT(YEAR FROM t.transaction_date) = EXTRACT(YEAR FROM CURRENT_DATE) AND EXTRACT(MONTH FROM t.transaction_date) = EXTRACT(MONTH FROM CURRENT_DATE)) ), 0 ) as Total_Saved_PLN;
```

### 3. 🎯 Month-End Projection
**Purpose:** Provides a projection of month-end savings based on current trends.
**Cleaned SQL:**
```sql
WITH current_performance AS ( SELECT EXTRACT(DAY FROM CURRENT_DATE) as days_elapsed, EXTRACT(DAY FROM DATE_TRUNC('MONTH', CURRENT_DATE) + INTERVAL '1 MONTH' - INTERVAL '1 DAY') as days_in_month, COALESCE(SUM(CASE WHEN t.type = 'Expense' AND c.category_name = 'Financial' AND c.subcategory_name = 'Savings Transfers' THEN t.amount ELSE 0 END), 0) AS Savings_mtd FROM transactions t JOIN categories c ON t.category_id = c.category_id WHERE EXTRACT(YEAR FROM t.transaction_date) = EXTRACT(YEAR FROM CURRENT_DATE) AND EXTRACT(MONTH FROM t.transaction_date) = EXTRACT(MONTH FROM CURRENT_DATE) ) SELECT now() AS time, CASE WHEN cp.days_elapsed > 0 THEN ROUND((cp.savings_mtd / cp.days_elapsed) * cp.days_in_month, 0) ELSE 0 END as Projected_Month_End_Savings FROM current_performance cp;
```

### 4. 📈 Real Savings Rate Trajectory (12 Months)
**Purpose:** Shows the historical trend of the real savings rate over the last 12 months.
**Cleaned SQL:**
```sql
WITH monthly_real_savings AS ( SELECT DATE_TRUNC('MONTH', t.transaction_date) as month, SUM(CASE WHEN t.type = 'Income' AND c.category_name NOT IN ('Initial Balance', 'INIT', 'Transfer', 'System') THEN t.amount ELSE 0 END) as real_income, SUM(CASE WHEN t.type = 'Expense' AND c.category_name = 'Financial' AND c.subcategory_name = 'Savings Transfers' THEN t.amount ELSE 0 END) as actual_savings FROM transactions t JOIN categories c ON t.category_id = c.category_id WHERE t.transaction_date >= CURRENT_DATE - INTERVAL '12 months' AND (EXTRACT(YEAR FROM t.transaction_date)::text = '${selected_year}' OR '${selected_year}' = '*') GROUP BY month ) SELECT month AS time, CASE WHEN real_income > 0 THEN ROUND((actual_savings / real_income) * 100, 2) ELSE 0 END as Real_Savings_Rate_Percent, 30 as Target_Rate, real_income as Income, actual_savings as Savings FROM monthly_real_savings WHERE real_income > 0 ORDER BY month;
```

### 5. 📊 Daily Cash Flow Analysis (Current Month)
**Purpose:** Visualizes daily income, expenses, and net cash flow for the current month.
**Cleaned SQL:**
```sql
SELECT date AS time, daily_income as Daily_Income, daily_expense * -1 as Daily_Expenses, daily_net as Daily_Net, month_to_date_net as MTD_Cumulative FROM v_daily_cashflow WHERE date >= DATE_TRUNC('MONTH', CURRENT_DATE) ORDER BY date;
```

### 6. 🎯 Budget Performance Matrix (Current Month)
**Purpose:** Provides a matrix view of budget utilization per category for the current month.
**Cleaned SQL:**
```sql
SELECT category_path as Category, ROUND(utilization_pct, 1) as Usage_Percent, ROUND(budget_amount, 0) as Budget_PLN, ROUND(actual_amount, 0) as Spent_PLN, ROUND(remaining_amount, 0) as Remaining_PLN, budget_status as Status, priority as Priority FROM v_budget_performance WHERE budget_year = EXTRACT(YEAR FROM CURRENT_DATE) AND budget_month = EXTRACT(MONTH FROM CURRENT_DATE) AND (category_name = '${category_filter}' OR '${category_filter}' = '*') ORDER BY utilization_pct DESC;
```

### 7. Actual Income (Monthly)
**Purpose:** Shows the actual total income per month.
**Cleaned SQL:**
```sql
SELECT period_date AS time, total_income AS Total_Income FROM v_monthly_pnl WHERE $__timeFilter(period_date) ORDER BY period_date;
```

### 8. Actual Expenses (Monthly)
**Purpose:** Shows the actual total expenses per month.
**Cleaned SQL:**
```sql
SELECT period_date AS time, total_expense AS Total_Expenses FROM v_monthly_pnl WHERE $__timeFilter(period_date) ORDER BY period_date;
```

## Variables and Filters
-   **selected_year:** Filter data by specific year
    *   `SELECT '*' AS year UNION ALL SELECT DISTINCT EXTRACT(YEAR FROM transaction_date)::text as year FROM transactions ORDER BY year DESC;`
-   **category_filter:** Filter by expense category
    *   `SELECT '*' AS category_name UNION ALL SELECT DISTINCT category_name FROM categories ORDER BY category_name;`
-   **account_filter:** Filter by bank account
    *   `SELECT '*' AS account_name UNION ALL SELECT account_name FROM accounts WHERE is_active = true ORDER BY account_name;`
-   **data_source_filter:** Data source selection (Atomic/Historical) - Custom variable.

## Dependencies
-   **System:** [S03 Data Layer](../../20_SYSTEMS/S03_Data-Layer/README.md) - PostgreSQL views and functions for data queries.
-   **PostgreSQL Database:** `autonomous_finance` (host: `{{INTERNAL_IP}}:5432`).
-   **Grafana Server:** Hosting and visualization.

## Troubleshooting
-   **No Data/Empty Panels**:
    *   Verify the selected time range in Grafana.
    *   Confirm data presence in `autonomous_finance` PostgreSQL database for the queried period (e.g., check `v_monthly_pnl`, `v_daily_cashflow`, `transactions` tables/views).
    *   Ensure Grafana's `grafana-postgresql-datasource` is healthy and configured correctly.
    *   Re-check the SQL Query Formatting Requirements section above. Any deviation can cause silent failures or syntax errors.

## Related Documentation
-   [S05: Observability & Dashboards](../S05_Observability-Dashboards/README.md) - Parent system documentation.
-   [G05: Autonomous Finance Data & Command Center](../../10_GOALS/G05_Autonomous-Financial-Command-Center/README.md) - Primary goal.

