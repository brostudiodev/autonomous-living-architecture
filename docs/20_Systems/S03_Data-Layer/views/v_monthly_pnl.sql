-- =====================================================
-- Monthly Profit & Loss View
-- Comprehensive financial performance analysis
-- =====================================================

CREATE OR REPLACE VIEW v_monthly_pnl AS
WITH monthly_pnl AS (
    SELECT 
        DATE_TRUNC('MONTH', t.transaction_date) as period_date,
        EXTRACT(YEAR FROM t.transaction_date) as year,
        EXTRACT(MONTH FROM t.transaction_date) as month,
        TO_CHAR(DATE_TRUNC('MONTH', t.transaction_date), 'YYYY-MM') as period,
        
        -- Income by category
        SUM(CASE WHEN t.type = 'Income' THEN t.amount ELSE 0 END) as total_income,
        SUM(CASE WHEN t.type = 'Income' AND c.category_name = 'Salary' THEN t.amount ELSE 0 END) as salary_income,
        SUM(CASE WHEN t.type = 'Income' AND c.category_name = 'Business' THEN t.amount ELSE 0 END) as business_income,
        SUM(CASE WHEN t.type = 'Income' AND c.category_name = 'Investments' THEN t.amount ELSE 0 END) as investment_income,
        
        -- Expenses by category
        SUM(CASE WHEN t.type = 'Expense' THEN t.amount ELSE 0 END) as total_expenses,
        SUM(CASE WHEN t.type = 'Expense' AND c.category_name = 'Housing' THEN t.amount ELSE 0 END) as housing_expenses,
        SUM(CASE WHEN t.type = 'Expense' AND c.category_name = 'Food' THEN t.amount ELSE 0 END) as food_expenses,
        SUM(CASE WHEN t.type = 'Expense' AND c.category_name = 'Transport' THEN t.amount ELSE 0 END) as transport_expenses,
        SUM(CASE WHEN t.type = 'Expense' AND c.category_name = 'Financial' THEN t.amount ELSE 0 END) as financial_expenses,
        
        -- Transaction counts
        COUNT(CASE WHEN t.type = 'Income' THEN 1 END) as income_transactions,
        COUNT(CASE WHEN t.type = 'Expense' THEN 1 END) as expense_transactions
        
    FROM transactions t
    JOIN categories c ON t.category_id = c.category_id
    WHERE t.transaction_date >= DATE_TRUNC('YEAR', CURRENT_DATE) - INTERVAL '2 years'
    GROUP BY DATE_TRUNC('MONTH', t.transaction_date), 
             EXTRACT(YEAR FROM t.transaction_date), 
             EXTRACT(MONTH FROM t.transaction_date)
)
SELECT 
    period_date,
    year,
    month,
    period,
    total_income,
    total_expenses,
    (total_income - total_expenses) as net_result,
    
    -- Income breakdown
    salary_income,
    business_income,
    investment_income,
    (total_income - salary_income - business_income - investment_income) as other_income,
    
    -- Expense breakdown
    housing_expenses,
    food_expenses,
    transport_expenses,
    financial_expenses,
    (total_expenses - housing_expenses - food_expenses - transport_expenses - financial_expenses) as other_expenses,
    
    -- Metrics
    ROUND((total_expenses / NULLIF(total_income, 0)) * 100, 2) as expense_ratio_pct,
    ROUND(((total_income - total_expenses) / NULLIF(total_income, 0)) * 100, 2) as savings_rate_pct,
    
    -- Transaction activity
    income_transactions,
    expense_transactions,
    (income_transactions + expense_transactions) as total_transactions
    
FROM monthly_pnl
ORDER BY period_date DESC;