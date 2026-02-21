-- v_upcoming_30_days.sql
-- View: Upcoming expenses in next 30 days
-- Used by: WF107 Expense Calendar Alerts

CREATE OR REPLACE VIEW v_upcoming_30_days AS
SELECT 
    id,
    transaction_id,
    expense_date,
    name,
    amount,
    currency,
    frequency,
    description,
    category,
    sub_category,
    CASE 
        WHEN frequency = 'monthly' THEN expense_date + INTERVAL '1 month'
        WHEN frequency = 'quarterly' THEN expense_date + INTERVAL '3 months'
        WHEN frequency = 'annual' THEN expense_date + INTERVAL '1 year'
        ELSE expense_date
    END as next_occurrence,
    -- Polish month names
    CASE EXTRACT(MONTH FROM expense_date)
        WHEN 1 THEN 'sty'
        WHEN 2 THEN 'lut'
        WHEN 3 THEN 'mar'
        WHEN 4 THEN 'kwi'
        WHEN 5 THEN 'maj'
        WHEN 6 THEN 'cze'
        WHEN 7 THEN 'lip'
        WHEN 8 THEN 'sie'
        WHEN 9 THEN 'wrz'
        WHEN 10 THEN 'paź'
        WHEN 11 THEN 'lis'
        WHEN 12 THEN 'gru'
    END as month_name,
    EXTRACT(DAY FROM expense_date)::INTEGER as day
FROM upcoming_expenses
WHERE expense_date <= CURRENT_DATE + INTERVAL '30 days'
  AND expense_date >= CURRENT_DATE
ORDER BY expense_date;

-- Grant SELECT access to finance_user
GRANT SELECT ON v_upcoming_30_days TO finance_user;
