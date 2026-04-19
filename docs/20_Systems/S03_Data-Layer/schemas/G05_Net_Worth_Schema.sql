-- =====================================================
-- G05: Net Worth Tracking Schema
-- Purpose: Track wealth-building and net worth trajectory
-- Created: 2026-04-12
-- Database: autonomous_finance
-- =====================================================

-- Net worth snapshots (monthly)
CREATE TABLE IF NOT EXISTS net_worth_snapshots (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    snapshot_date DATE NOT NULL UNIQUE,
    -- Totals
    total_assets DECIMAL(15,2) NOT NULL DEFAULT 0,
    total_liabilities DECIMAL(15,2) NOT NULL DEFAULT 0,
    net_worth DECIMAL(15,2) GENERATED ALWAYS AS (total_assets - total_liabilities) STORED,
    -- Asset breakdown
    cash_amount DECIMAL(15,2) DEFAULT 0,
    investment_amount DECIMAL(15,2) DEFAULT 0,  -- Stocks, funds, crypto
    retirement_amount DECIMAL(15,2) DEFAULT 0,  -- Pension, IRA, 401k
    real_estate_value DECIMAL(15,2) DEFAULT 0,
    other_assets DECIMAL(15,2) DEFAULT 0,
    -- Liability breakdown
    mortgage_balance DECIMAL(15,2) DEFAULT 0,
    loan_balance DECIMAL(15,2) DEFAULT 0,
    credit_card_balance DECIMAL(15,2) DEFAULT 0,
    other_liabilities DECIMAL(15,2) DEFAULT 0,
    -- Derived ratios
    savings_rate DECIMAL(5,2),  -- % of income saved this month
    debt_to_income_ratio DECIMAL(5,2),  -- Monthly debt / monthly income
    -- Snapshot metadata
    notes TEXT,
    created_at TIMESTAMPTZ DEFAULT NOW()
);

-- Income sources (for diversification tracking)
CREATE TABLE IF NOT EXISTS income_sources (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    source_name VARCHAR(255) NOT NULL,
    source_type VARCHAR(50) CHECK (source_type IN ('salary', 'freelance', 'investment', 'rental', 'passive', 'royalty', 'gift', 'other')),
    is_active BOOLEAN DEFAULT TRUE,
    monthly_amount DECIMAL(15,2),
    frequency VARCHAR(20) DEFAULT 'monthly',  -- monthly, quarterly, annual
    start_date DATE,
    end_date DATE,
    notes TEXT,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- Income diversification view
CREATE OR REPLACE VIEW v_income_diversification AS
WITH active_sources AS (
    SELECT 
        source_type,
        SUM(monthly_amount) AS monthly_total
    FROM income_sources
    WHERE is_active = TRUE
    GROUP BY source_type
),
totals AS (
    SELECT SUM(monthly_total) AS total_income
    FROM active_sources
)
SELECT 
    a.source_type,
    a.monthly_total,
    ROUND((a.monthly_total / t.total_income * 100)::NUMERIC, 2) AS percentage,
    CASE 
        WHEN a.source_type != 'salary' THEN ROUND(((t.total_income - COALESCE(a.monthly_total, 0)) / t.total_income * 100)::NUMERIC, 2)
        ELSE NULL
    END AS passive_income_ratio
FROM active_sources a
CROSS JOIN totals t
ORDER BY a.monthly_total DESC;

-- Net worth trajectory view
CREATE OR REPLACE VIEW v_net_worth_trajectory AS
SELECT 
    snapshot_date,
    net_worth,
    total_assets,
    total_liabilities,
    LAG(net_worth) OVER (ORDER BY snapshot_date) AS previous_net_worth,
    net_worth - LAG(net_worth) OVER (ORDER BY snapshot_date) AS monthly_change,
    ROUND(
        ((net_worth - LAG(net_worth) OVER (ORDER BY snapshot_date)) / 
         NULLIF(LAG(net_worth) OVER (ORDER BY snapshot_date), 0) * 100)::NUMERIC, 
        2
    ) AS monthly_change_pct
FROM net_worth_snapshots
ORDER BY snapshot_date DESC;

-- FIRE projection (Financial Independence)
CREATE OR REPLACE FUNCTION calculate_fire_number(target_annual_spending DECIMAL)
RETURNS DECIMAL AS $$
BEGIN
    -- Assumes 4% withdrawal rate (25x annual spending)
    RETURN target_annual_spending * 25;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE VIEW v_fire_projection AS
WITH latest_snapshot AS (
    SELECT * FROM net_worth_snapshots ORDER BY snapshot_date DESC LIMIT 1
),
monthly_savings AS (
    -- Calculate average monthly savings from income vs expenses
    SELECT 
        COALESCE(SUM(CASE WHEN type = 'Income' THEN amount ELSE 0 END), 0) -
        COALESCE(SUM(CASE WHEN type = 'Expense' THEN amount ELSE 0 END), 0) AS avg_monthly_savings
    FROM transactions
    WHERE transaction_date >= CURRENT_DATE - INTERVAL '12 months'
),
fire_calc AS (
    SELECT 
        ls.net_worth AS current_net_worth,
        ls.total_liabilities,
        ls.net_worth - ls.total_liabilities AS net_worth_minus_debt,
        ms.avg_monthly_savings,
        -- Assume annual spending = last month expenses * 12
        (SELECT SUM(amount) * 12 FROM transactions 
         WHERE type = 'Expense' 
           AND transaction_date >= CURRENT_DATE - INTERVAL '1 month') AS estimated_annual_spending,
        (SELECT SUM(amount) * 12 FROM transactions 
         WHERE type = 'Expense' 
           AND transaction_date >= CURRENT_DATE - INTERVAL '1 month') * 25 AS fire_number  -- 4% rule
    FROM latest_snapshot ls, monthly_savings ms
)
SELECT 
    current_net_worth,
    net_worth_minus_debt,
    avg_monthly_savings,
    estimated_annual_spending,
    fire_number,
    ROUND((current_net_worth / fire_number * 100)::NUMERIC, 2) AS fire_progress_pct,
    ROUND(((fire_number - current_net_worth) / NULLIF(avg_monthly_savings, 0))::NUMERIC, 1) AS months_to_fire
FROM fire_calc;

-- Indexes
CREATE INDEX IF NOT EXISTS idx_net_worth_date ON net_worth_snapshots(snapshot_date DESC);
CREATE INDEX IF NOT EXISTS idx_income_sources_active ON income_sources(is_active) WHERE is_active = TRUE;
CREATE INDEX IF NOT EXISTS idx_income_sources_type ON income_sources(source_type);

-- =====================================================
-- Maintenance
-- =====================================================

COMMENT ON TABLE net_worth_snapshots IS 'Monthly net worth tracking for wealth trajectory';
COMMENT ON TABLE income_sources IS 'Income diversification tracking';
COMMENT ON VIEW v_income_diversification IS 'Income breakdown by source type';
COMMENT ON VIEW v_net_worth_trajectory IS 'Net worth changes over time';
COMMENT ON VIEW v_fire_projection IS 'Financial independence progress calculation';

-- Run after creation:
-- INSERT INTO net_worth_snapshots (snapshot_date, total_assets, total_liabilities) 
-- VALUES (CURRENT_DATE, 100000, 50000);
-- 
-- INSERT INTO income_sources (source_name, source_type, monthly_amount) VALUES
-- ('Main Job', 'salary', 15000),
-- ('Side Projects', 'freelance', 2000),
-- ('Stock Dividends', 'passive', 500);

-- SELECT * FROM v_income_diversification;
-- SELECT * FROM v_net_worth_trajectory;
-- SELECT * FROM v_fire_projection;
