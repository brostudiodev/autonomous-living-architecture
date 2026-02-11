---
title: "G05: Systems"
type: "goal_systems"
status: "active"
goal_id: "goal-g05"
owner: "Michał"
updated: "2026-02-07"
---

# Systems

## Enabling Systems
- [S03 Data Layer](../../20_SYSTEMS/S03_Data-Layer/README.md) - PostgreSQL database and analytics
- [S05 Observability & Dashboards](../../20_SYSTEMS/S05_Observability-Dashboards/README.md) - Grafana visualization
- [S08 Automation Orchestrator](../../20_SYSTEMS/S08_Automation-Orchestrator/README.md) - n8n workflows

## Core PostgreSQL Components

### **Database Schema**
- **Tables:** `transactions`, `budgets`, `categories`, `accounts`
- **Views:** `v_monthly_pnl`, `v_budget_performance`, `v_daily_cashflow`, `v_real_savings_monthly`
- **Functions:** `get_current_budget_alerts()`, `get_budget_optimization_suggestions()`, `get_category_names_from_description()`

### **Grafana Dashboard**
- **Dashboard UID:** `financial-command-center-real`
- **Panels:** Real Savings Rate Gauge, Budget Performance Matrix, Daily Cash Flow, Projections
- **Variables:** `selected_year`, `category_filter`, `account_filter`, `data_source_filter`

## Traceability (Outcome → System → Automation → SOP)

| Outcome | System | Automation / Artifact | SOP / Runbook |
|---|---|---|---|
| **Calculate Real Savings Rate** | S03 Data Layer | `v_real_savings_monthly` view | [Finance-Schema-Changes.md](../../40_RUNBOOKS/Finance-Schema-Changes.md) |
| **Visualize Financial Health** | S05 Observability | Grafana dashboard `financial-command-center-real` | [Dashboard-Maintenance.md](../../30_SOPS/Dashboard-Maintenance.md) |
| **Detect Budget Issues** | S03, S08 | `get_current_budget_alerts()` + `WF102__finance-budget-alerts` | [Budget-Alert-Response.md](../../40_RUNBOOKS/Budget-Alert-Response.md) |
| **Implement Budget Alerts** | S08 Automation Orchestrator | [WF_Finance_Budget_Alerts.json](../../infrastructure/n8n/workflows/WF_Finance_Budget_Alerts.json) | TBD (Alert Response) |
| **Import Transaction Data** | S08 | `WF101__finance-import-transactions` | [Data-Import-Recovery.md](../../40_RUNBOOKS/Data-Import-Recovery.md) |
| Import Transaction Data (CSV) | S08 Automation Orchestrator | [WF_Finance_Import_Transactions_CSV.json](../../infrastructure/n8n/workflows/WF_Finance_Import_Transactions_CSV.json) | TBD (Data Import Runbook) |
| **Project Month-End Savings** | S03 | SQL calculation in dashboard panels | [Projection-Validation.md](../../30_SOPS/Projection-Validation.md) |

**Note:** All PostgreSQL objects must be version-controlled in `docs/20_SYSTEMS/S03_Data-Layer/` with migration scripts.

Complete PostgreSQL Implementation
View: v_real_savings_monthly.sql

-- =====================================================
-- Real Savings Rate View - Fixes the "98% Problem"
-- Excludes INIT positions and internal transfers
-- =====================================================

CREATE OR REPLACE VIEW v_real_savings_monthly AS
WITH monthly_real_analysis AS (
    SELECT 
        DATE_TRUNC('MONTH', t.transaction_date) as period_date,
        EXTRACT(YEAR FROM t.transaction_date) as year,
        EXTRACT(MONTH FROM t.transaction_date) as month,
        
        -- Real operational income (excludes system transactions)
        SUM(CASE 
            WHEN t.type = 'Income' 
                AND c.category_name NOT IN ('Initial Balance', 'INIT', 'Transfer', 'System')
                AND NOT EXISTS (
                    SELECT 1 FROM accounts a 
                    WHERE a.account_id = t.account_id 
                    AND (LOWER(a.account_name) LIKE '%saving%' OR LOWER(a.account_name) LIKE '%investment%')
                )
            THEN t.amount 
            ELSE 0 
        END) as operational_income,
        
        -- Actual wealth-building savings (two detection methods)
        GREATEST(
            -- Method 1: Category-based savings tracking
            SUM(CASE 
                WHEN t.type = 'Expense'
                    AND LOWER(c.category_name) = 'financial'
                    AND LOWER(c.subcategory_name) = 'savings transfers'
                THEN t.amount 
                ELSE 0 
            END),
            -- Method 2: Account-based savings tracking
            SUM(CASE 
                WHEN EXISTS (
                    SELECT 1 FROM accounts a 
                    WHERE a.account_id = t.account_id 
                    AND (LOWER(a.account_name) LIKE '%saving%' OR LOWER(a.account_name) LIKE '%investment%')
                    AND t.amount > 0
                )
                THEN t.amount 
                ELSE 0 
            END)
        ) as actual_savings,
        
        -- Regular expenses (for context)
        SUM(CASE 
            WHEN t.type = 'Expense'
                AND c.category_name NOT IN ('Financial')
                AND NOT EXISTS (
                    SELECT 1 FROM accounts a 
                    WHERE a.account_id = t.account_id 
                    AND (LOWER(a.account_name) LIKE '%saving%' OR LOWER(a.account_name) LIKE '%investment%')
                )
            THEN t.amount 
            ELSE 0 
        END) as operational_expenses
        
    FROM transactions t
    JOIN categories c ON t.category_id = c.category_id
    GROUP BY period_date, year, month
)
SELECT 
    period_date,
    year,
    month,
    TO_CHAR(period_date, 'YYYY-MM') as period,
    operational_income,
    actual_savings,
    operational_expenses,
    
    -- The corrected savings rate calculation
    CASE 
        WHEN operational_income > 0 
        THEN ROUND((actual_savings / operational_income) * 100, 2)
        ELSE 0 
    END as real_savings_rate_pct,
    
    -- Additional metrics for analysis
    operational_income - operational_expenses - actual_savings as discretionary_remaining,
    ROUND((operational_expenses / NULLIF(operational_income, 0)) * 100, 2) as expense_ratio_pct
    
FROM monthly_real_analysis
WHERE operational_income > 0  -- Only include months with real income
ORDER BY period_date DESC;

Function: get_current_budget_alerts.sql

-- =====================================================
-- Autonomous Budget Alert System
-- Returns actionable intelligence for budget management
-- =====================================================

CREATE OR REPLACE FUNCTION get_current_budget_alerts()
RETURNS TABLE (
    alert_id TEXT,
    alert_severity TEXT,
    category_path TEXT,
    budget_amount NUMERIC,
    actual_amount NUMERIC,
    utilization_pct NUMERIC,
    alert_threshold INTEGER,
    projected_month_end NUMERIC,
    days_remaining INTEGER,
    daily_limit_remaining NUMERIC,
    recommended_action TEXT,
    priority TEXT
) AS $$
BEGIN
    RETURN QUERY
    WITH current_month_analysis AS (
        SELECT 
            b.budget_id,
            c.category_name || ' > ' || c.subcategory_name as category_path,
            b.budget_amount,
            b.alert_threshold,
            b.priority,
            COALESCE(SUM(t.amount), 0) as actual_spending,
            
            -- Utilization percentage
            CASE 
                WHEN b.budget_amount > 0 
                THEN ROUND((COALESCE(SUM(t.amount), 0) / b.budget_amount) * 100, 2)
                ELSE 0 
            END as utilization_percentage,
            
            -- Month-end projection based on daily burn rate
            CASE 
                WHEN EXTRACT(DAY FROM CURRENT_DATE) > 0 
                THEN ROUND(
                    (COALESCE(SUM(t.amount), 0) / EXTRACT(DAY FROM CURRENT_DATE)) * 
                    EXTRACT(DAY FROM DATE_TRUNC('MONTH', CURRENT_DATE) + INTERVAL '1 MONTH' - INTERVAL '1 DAY'), 
                    2
                )
                ELSE 0
            END as projected_total,
            
            -- Days remaining in month
            (EXTRACT(DAY FROM DATE_TRUNC('MONTH', CURRENT_DATE) + INTERVAL '1 MONTH' - INTERVAL '1 DAY')::INTEGER - 
             EXTRACT(DAY FROM CURRENT_DATE)::INTEGER) as days_left
             
        FROM budgets b
        JOIN categories c ON b.category_id = c.category_id
        LEFT JOIN transactions t ON 
            t.category_id = b.category_id 
            AND EXTRACT(YEAR FROM t.transaction_date) = EXTRACT(YEAR FROM CURRENT_DATE)
            AND EXTRACT(MONTH FROM t.transaction_date) = EXTRACT(MONTH FROM CURRENT_DATE)
            AND t.type = 'Expense'
        WHERE b.is_active = TRUE
          AND b.budget_year = EXTRACT(YEAR FROM CURRENT_DATE)
          AND b.budget_month = EXTRACT(MONTH FROM CURRENT_DATE)
          AND b.type = 'Expense'
          AND b.budget_amount > 0
        GROUP BY 
            b.budget_id, c.category_name, c.subcategory_name,
            b.budget_amount, b.alert_threshold, b.priority
    )
    SELECT 
        ('ALERT-' || cma.budget_id || '-' || TO_CHAR(NOW(), 'YYYYMMDDHH24MI'))::TEXT,
        (CASE 
            WHEN cma.utilization_percentage >= 100 THEN 'CRITICAL'
            WHEN cma.utilization_percentage >= cma.alert_threshold THEN 'HIGH'
            WHEN cma.projected_total > cma.budget_amount THEN 'MEDIUM'
            ELSE 'LOW'
        END)::TEXT,
        cma.category_path::TEXT,
        cma.budget_amount::NUMERIC,
        cma.actual_spending::NUMERIC,
        cma.utilization_percentage::NUMERIC,
        cma.alert_threshold::INTEGER,
        cma.projected_total::NUMERIC,
        cma.days_left::INTEGER,
        (CASE 
            WHEN cma.days_left > 0 
            THEN ROUND((cma.budget_amount - cma.actual_spending) / cma.days_left, 2)
            ELSE NULL
        END)::NUMERIC,
        (CASE 
            WHEN cma.utilization_percentage >= 100 THEN 
                '🚨 STOP SPENDING: Budget exceeded by ' || ROUND(cma.actual_spending - cma.budget_amount, 2) || ' PLN'
            WHEN cma.utilization_percentage >= cma.alert_threshold THEN 
                '⚠️ SLOW DOWN: ' || ROUND(cma.budget_amount - cma.actual_spending, 2) || ' PLN left for ' || 
                cma.days_left || ' days (max ' || 
                ROUND((cma.budget_amount - cma.actual_spending) / NULLIF(cma.days_left, 0), 2) || ' PLN/day)'
            WHEN cma.projected_total > cma.budget_amount THEN 
                '📊 PROJECTED OVERSPEND: Current rate suggests ' || ROUND(cma.projected_total - cma.budget_amount, 2) || ' PLN overage'
            ELSE 
                '✅ ON TRACK: ' || ROUND(cma.budget_amount - cma.actual_spending, 2) || ' PLN remaining'
        END)::TEXT,
        cma.priority::TEXT
    FROM current_month_analysis cma
    WHERE 
        cma.utilization_percentage >= cma.alert_threshold
        OR cma.projected_total > cma.budget_amount
        OR cma.utilization_percentage >= 100
    ORDER BY 
        CASE cma.priority 
            WHEN 'Critical' THEN 1 
            WHEN 'High' THEN 2 
            WHEN 'Medium' THEN 3 
            ELSE 4 
        END,
        cma.utilization_percentage DESC;
END;

$$ LANGUAGE plpgsql;
