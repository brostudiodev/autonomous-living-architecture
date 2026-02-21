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