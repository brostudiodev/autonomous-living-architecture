-- =====================================================
-- Budget Performance View
-- Real-time budget tracking with utilization metrics
-- =====================================================

CREATE OR REPLACE VIEW v_budget_performance AS
WITH current_month_spending AS (
    SELECT 
        b.budget_id,
        b.category_id,
        c.category_name,
        c.subcategory_name,
        b.budget_amount,
        b.alert_threshold,
        b.priority,
        b.budget_year,
        b.budget_month,
        
        -- Actual spending this month
        COALESCE(SUM(t.amount), 0) as actual_amount,
        
        -- Utilization calculation
        CASE 
            WHEN b.budget_amount > 0 
            THEN ROUND((COALESCE(SUM(t.amount), 0) / b.budget_amount) * 100, 2)
            ELSE 0 
        END as utilization_pct,
        
        -- Days elapsed and remaining
        EXTRACT(DAY FROM CURRENT_DATE) as days_elapsed,
        (EXTRACT(DAY FROM DATE_TRUNC('MONTH', CURRENT_DATE) + INTERVAL '1 MONTH' - INTERVAL '1 DAY')::INTEGER - 
         EXTRACT(DAY FROM CURRENT_DATE)::INTEGER) as days_remaining,
        
        -- Daily burn rate and projection
        CASE 
            WHEN EXTRACT(DAY FROM CURRENT_DATE) > 0 
            THEN ROUND(COALESCE(SUM(t.amount), 0) / EXTRACT(DAY FROM CURRENT_DATE), 2)
            ELSE 0 
        END as daily_burn_rate,
        
        -- Month-end projection
        CASE 
            WHEN EXTRACT(DAY FROM CURRENT_DATE) > 0 
            THEN ROUND(
                (COALESCE(SUM(t.amount), 0) / EXTRACT(DAY FROM CURRENT_DATE)) * 
                EXTRACT(DAY FROM DATE_TRUNC('MONTH', CURRENT_DATE) + INTERVAL '1 MONTH' - INTERVAL '1 DAY'), 
                2
            )
            ELSE 0
        END as projected_month_end,
        
        -- Remaining budget
        (b.budget_amount - COALESCE(SUM(t.amount), 0)) as remaining_amount
        
    FROM budgets b
    JOIN categories c ON b.category_id = c.category_id
    LEFT JOIN transactions t ON 
        t.category_id = b.category_id 
        AND EXTRACT(YEAR FROM t.transaction_date) = b.budget_year
        AND EXTRACT(MONTH FROM t.transaction_date) = b.budget_month
        AND t.type = 'Expense'
    WHERE b.is_active = TRUE
      AND b.budget_year = EXTRACT(YEAR FROM CURRENT_DATE)
      AND b.budget_month = EXTRACT(MONTH FROM CURRENT_DATE)
      AND b.budget_amount > 0
    GROUP BY 
        b.budget_id, b.category_id, c.category_name, c.subcategory_name,
        b.budget_amount, b.alert_threshold, b.priority, b.budget_year, b.budget_month
)
SELECT 
    *,
    c.category_name || ' > ' || c.subcategory_name as category_path,
    
    -- Budget status classification
    CASE 
        WHEN utilization_pct >= 100 THEN 'Exceeded'
        WHEN utilization_pct >= alert_threshold THEN 'Warning'
        WHEN projected_month_end > budget_amount THEN 'Projected Over'
        ELSE 'On Track'
    END as budget_status,
    
    -- Daily limit needed to stay within budget
    CASE 
        WHEN days_remaining > 0 AND remaining_amount > 0 
        THEN ROUND(remaining_amount / days_remaining, 2)
        WHEN days_remaining > 0 AND remaining_amount <= 0
        THEN 0
        ELSE NULL
    END as daily_limit_remaining,
    
    -- Over/under budget amount
    (actual_amount - budget_amount) as variance_amount,
    
    -- Priority score for alerting
    CASE 
        WHEN utilization_pct >= 100 AND priority = 'Critical' THEN 10
        WHEN utilization_pct >= 100 AND priority = 'High' THEN 9
        WHEN utilization_pct >= alert_threshold AND priority = 'Critical' THEN 8
        WHEN utilization_pct >= alert_threshold AND priority = 'High' THEN 7
        WHEN projected_month_end > budget_amount AND priority = 'Critical' THEN 6
        WHEN projected_month_end > budget_amount AND priority = 'High' THEN 5
        WHEN utilization_pct >= alert_threshold THEN 4
        WHEN projected_month_end > budget_amount THEN 3
        WHEN utilization_pct >= 80 THEN 2
        ELSE 1
    END as alert_score
    
FROM current_month_spending cms
JOIN categories c ON cms.category_id = c.category_id
ORDER BY alert_score DESC, utilization_pct DESC;