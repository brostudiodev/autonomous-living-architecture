-- =====================================================
-- Budget Optimization Suggestions Function
-- Provides actionable recommendations for budget improvements
-- =====================================================

CREATE OR REPLACE FUNCTION get_budget_optimization_suggestions()
RETURNS TABLE (
    suggestion_id TEXT,
    category_path TEXT,
    suggestion_type TEXT,
    current_spending NUMERIC,
    suggested_budget NUMERIC,
    potential_savings NUMERIC,
    confidence_score NUMERIC,
    reasoning TEXT,
    implementation_priority TEXT
) AS $$
BEGIN
    RETURN QUERY
    WITH spending_analysis AS (
        -- Analyze spending patterns over last 3 months
        SELECT 
            c.category_name,
            c.subcategory_name,
            c.category_name || ' > ' || c.subcategory_name as category_path,
            AVG(CASE WHEN EXTRACT(MONTH FROM t.transaction_date) = EXTRACT(MONTH FROM CURRENT_DATE) 
                     AND EXTRACT(YEAR FROM t.transaction_date) = EXTRACT(YEAR FROM CURRENT_DATE)
                THEN COALESCE(SUM(t.amount), 0) ELSE 0 END) as current_month_spending,
            AVG(COALESCE(SUM(t.amount), 0)) as avg_monthly_spending,
            STDDEV(COALESCE(SUM(t.amount), 0)) as spending_volatility,
            COUNT(DISTINCT t.transaction_id) as transaction_count,
            b.budget_amount,
            b.budget_id
        FROM categories c
        LEFT JOIN transactions t ON c.category_id = t.category_id
            AND t.type = 'Expense'
            AND t.transaction_date >= CURRENT_DATE - INTERVAL '3 months'
        LEFT JOIN budgets b ON c.category_id = b.category_id
            AND b.budget_year = EXTRACT(YEAR FROM CURRENT_DATE)
            AND b.budget_month = EXTRACT(MONTH FROM CURRENT_DATE)
            AND b.is_active = TRUE
        GROUP BY c.category_name, c.subcategory_name, b.budget_amount, b.budget_id
    ),
    optimization_rules AS (
        SELECT 
            sa.*,
            
            -- Rule 1: Overspending categories
            CASE 
                WHEN sa.current_month_spending > sa.budget_amount * 1.1 THEN 'OVERSPENDING'
                WHEN sa.current_month_spending < sa.budget_amount * 0.5 THEN 'UNDERUTILIZED'
                ELSE 'NORMAL'
            END as spending_status,
            
            -- Rule 2: High volatility categories
            CASE 
                WHEN sa.spending_volatility > (sa.avg_monthly_spending * 0.3) THEN 'VOLATILE'
                ELSE 'STABLE'
            END as volatility_status,
            
            -- Rule 3: Suggested budget adjustments
            CASE 
                WHEN sa.spending_status = 'OVERSPENDING' THEN 
                    GREATEST(sa.current_month_spending * 1.1, sa.avg_monthly_spending * 1.05)
                WHEN sa.spending_status = 'UNDERUTILIZED' THEN 
                    LEAST(sa.current_month_spending * 1.2, sa.avg_monthly_spending * 0.9)
                ELSE sa.budget_amount
            END as suggested_budget_amount
        FROM spending_analysis sa
        WHERE sa.avg_monthly_spending > 0
    )
    SELECT 
        ('SUGGESTION-' || COALESCE(ore.budget_id::TEXT, 'NEW') || '-' || TO_CHAR(NOW(), 'YYYYMMDDHH24MI'))::TEXT,
        ore.category_path::TEXT,
        (CASE 
            WHEN ore.spending_status = 'OVERSPENDING' THEN 'INCREASE_BUDGET'
            WHEN ore.spending_status = 'UNDERUTILIZED' THEN 'DECREASE_BUDGET'
            WHEN ore.volatility_status = 'VOLATILE' THEN 'ADD_BUFFER'
            ELSE 'MONITOR'
        END)::TEXT,
        COALESCE(ore.current_month_spending, 0)::NUMERIC,
        COALESCE(ore.suggested_budget_amount, ore.avg_monthly_spending)::NUMERIC,
        (CASE 
            WHEN ore.spending_status = 'UNDERUTILIZED' 
            THEN (ore.budget_amount - ore.suggested_budget_amount)
            ELSE 0
        END)::NUMERIC,
        
        -- Confidence based on data quality
        (CASE 
            WHEN ore.transaction_count >= 20 THEN 0.9
            WHEN ore.transaction_count >= 10 THEN 0.7
            WHEN ore.transaction_count >= 5 THEN 0.5
            ELSE 0.3
        END)::NUMERIC,
        
        -- Human-readable reasoning
        (CASE 
            WHEN ore.spending_status = 'OVERSPENDING' THEN 
                'Consistently overspending by ' || ROUND(((ore.current_month_spending / NULLIF(ore.budget_amount, 0)) - 1) * 100, 1) || '%. Increase budget to ' || ROUND(ore.suggested_budget_amount, 2) || ' PLN.'
            WHEN ore.spending_status = 'UNDERUTILIZED' THEN 
                'Budget underutilized. Potential savings of ' || ROUND((ore.budget_amount - ore.suggested_budget_amount), 2) || ' PLN by reducing to ' || ROUND(ore.suggested_budget_amount, 2) || ' PLN.'
            WHEN ore.volatility_status = 'VOLATILE' THEN 
                'High spending volatility (±' || ROUND(ore.spending_volatility, 2) || ' PLN). Add buffer of 20% to average spending.'
            ELSE 'Spending within normal range. Continue monitoring.'
        END)::TEXT,
        
        -- Priority based on impact
        (CASE 
            WHEN ore.spending_status = 'OVERSPENDING' AND ore.avg_monthly_spending > 1000 THEN 'HIGH'
            WHEN ore.spending_status = 'UNDERUTILIZED' AND (ore.budget_amount - ore.suggested_budget_amount) > 200 THEN 'MEDIUM'
            WHEN ore.volatility_status = 'VOLATILE' THEN 'LOW'
            ELSE 'LOW'
        END)::TEXT
        
    FROM optimization_rules ore
    WHERE ore.spending_status IN ('OVERSPENDING', 'UNDERUTILIZED')
       OR ore.volatility_status = 'VOLATILE'
    ORDER BY 
        CASE 
            WHEN ore.spending_status = 'OVERSPENDING' THEN 1
            WHEN ore.spending_status = 'UNDERUTILIZED' THEN 2
            ELSE 3
        END,
        (ore.budget_amount - COALESCE(ore.suggested_budget_amount, 0)) DESC NULLS LAST;
END;

$$ LANGUAGE plpgsql;