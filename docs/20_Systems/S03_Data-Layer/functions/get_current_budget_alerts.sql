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