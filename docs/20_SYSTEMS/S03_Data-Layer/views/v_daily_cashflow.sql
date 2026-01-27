-- =====================================================
-- Daily Cash Flow View
-- Transaction flow analysis and trend identification
-- =====================================================

CREATE OR REPLACE VIEW v_daily_cashflow AS
WITH daily_transactions AS (
    SELECT 
        t.transaction_date,
        EXTRACT(YEAR FROM t.transaction_date) as year,
        EXTRACT(MONTH FROM t.transaction_date) as month,
        EXTRACT(DAY FROM t.transaction_date) as day,
        TO_CHAR(t.transaction_date, 'YYYY-MM-DD') as date_key,
        
        -- Cash flow components
        SUM(CASE WHEN t.type = 'Income' THEN t.amount ELSE 0 END) as daily_income,
        SUM(CASE WHEN t.type = 'Expense' THEN t.amount ELSE 0 END) as daily_expenses,
        
        -- Transaction counts
        COUNT(CASE WHEN t.type = 'Income' THEN 1 END) as income_count,
        COUNT(CASE WHEN t.type = 'Expense' THEN 1 END) as expense_count,
        
        -- Category breakdown for major categories
        SUM(CASE WHEN t.type = 'Expense' AND c.category_name = 'Housing' THEN t.amount ELSE 0 END) as housing_spending,
        SUM(CASE WHEN t.type = 'Expense' AND c.category_name = 'Food' THEN t.amount ELSE 0 END) as food_spending,
        SUM(CASE WHEN t.type = 'Expense' AND c.category_name = 'Transport' THEN t.amount ELSE 0 END) as transport_spending,
        SUM(CASE WHEN t.type = 'Income' AND c.category_name = 'Salary' THEN t.amount ELSE 0 END) as salary_income,
        SUM(CASE WHEN t.type = 'Income' AND c.category_name = 'Business' THEN t.amount ELSE 0 END) as business_income
        
    FROM transactions t
    JOIN categories c ON t.category_id = c.category_id
    WHERE t.transaction_date >= CURRENT_DATE - INTERVAL '90 days'
    GROUP BY t.transaction_date, 
             EXTRACT(YEAR FROM t.transaction_date), 
             EXTRACT(MONTH FROM t.transaction_date),
             EXTRACT(DAY FROM t.transaction_date)
),
daily_cashflow AS (
    SELECT 
        *,
        (daily_income - daily_expenses) as net_cashflow,
        -- Moving averages for trend analysis
        AVG(daily_income) OVER (
            ORDER BY transaction_date 
            ROWS BETWEEN 6 PRECEDING AND CURRENT ROW
        ) as income_7day_avg,
        AVG(daily_expenses) OVER (
            ORDER BY transaction_date 
            ROWS BETWEEN 6 PRECEDING AND CURRENT ROW
        ) as expenses_7day_avg,
        AVG(net_cashflow) OVER (
            ORDER BY transaction_date 
            ROWS BETWEEN 6 PRECEDING AND CURRENT ROW
        ) as net_cashflow_7day_avg,
        -- Week-over-week comparison
        LAG(daily_income, 7) OVER (ORDER BY transaction_date) as income_week_ago,
        LAG(daily_expenses, 7) OVER (ORDER BY transaction_date) as expenses_week_ago,
        LAG(net_cashflow, 7) OVER (ORDER BY transaction_date) as net_cashflow_week_ago
    FROM daily_transactions
)
SELECT 
    transaction_date,
    year,
    month,
    day,
    date_key,
    
    -- Current day data
    daily_income,
    daily_expenses,
    net_cashflow,
    
    -- Transaction activity
    income_count,
    expense_count,
    (income_count + expense_count) as total_transactions,
    
    -- Category breakdown
    housing_spending,
    food_spending,
    transport_spending,
    salary_income,
    business_income,
    
    -- Trend analysis
    income_7day_avg,
    expenses_7day_avg,
    net_cashflow_7day_avg,
    
    -- Week-over-week changes
    (daily_income - COALESCE(income_week_ago, 0)) as income_wow_change,
    (daily_expenses - COALESCE(expenses_week_ago, 0)) as expenses_wow_change,
    (net_cashflow - COALESCE(net_cashflow_week_ago, 0)) as net_cashflow_wow_change,
    
    -- Variance from averages
    (daily_income - income_7day_avg) as income_vs_avg,
    (daily_expenses - expenses_7day_avg) as expenses_vs_avg,
    (net_cashflow - net_cashflow_7day_avg) as net_cashflow_vs_avg,
    
    -- Cash flow classification
    CASE 
        WHEN net_cashflow > 0 THEN 'Positive'
        WHEN net_cashflow < 0 THEN 'Negative'
        ELSE 'Neutral'
    END as cashflow_type,
    
    -- Anomaly detection (2 standard deviations)
    CASE 
        WHEN ABS(net_cashflow - net_cashflow_7day_avg) > (STDDEV(net_cashflow) OVER (
            ORDER BY transaction_date 
            ROWS BETWEEN 29 PRECEDING AND CURRENT ROW
        ) * 2)
        THEN TRUE
        ELSE FALSE
    END as is_anomaly
    
FROM daily_cashflow
ORDER BY transaction_date DESC;