-- =====================================================
-- G11: Decision Log & Context Events Schema
-- Purpose: Track decisions, cognitive patterns, and life events
-- Created: 2026-04-12
-- Database: autonomous_life_logistics
-- =====================================================

-- Decision log: Track significant decisions
CREATE TABLE IF NOT EXISTS decision_log (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    decision_date TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    decision_type VARCHAR(50) CHECK (decision_type IN ('trivial', 'minor', 'moderate', 'significant', 'major')),
    domain VARCHAR(50) CHECK (domain IN ('work', 'health', 'financial', 'personal', 'social', 'career', 'family')),
    title VARCHAR(255) NOT NULL,
    description TEXT,
    alternatives_considered INTEGER DEFAULT 0,
    time_spent_minutes INTEGER,
    confidence_level INTEGER CHECK (confidence_level BETWEEN 1 AND 5),
    reversible BOOLEAN DEFAULT FALSE,
    outcome_score INTEGER CHECK (outcome_score BETWEEN 1 AND 5),  -- Post-decision rating
    outcome_date DATE,
    outcome_notes TEXT,
    regret_level INTEGER CHECK (regret_level BETWEEN 1 AND 5),  -- 1=would make again, 5=regret
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- Daily decision metrics (aggregated)
CREATE TABLE IF NOT EXISTS daily_decision_metrics (
    date DATE PRIMARY KEY,
    total_decisions INTEGER DEFAULT 0,
    significant_decisions INTEGER DEFAULT 0,  -- Type 'significant' or 'major'
    total_time_spent_minutes INTEGER DEFAULT 0,
    avg_confidence DECIMAL(3,2),
    reversible_rate DECIMAL(3,2),  -- % of reversible decisions
    evaluated_outcomes INTEGER DEFAULT 0,  -- Decisions with outcome scored
    avg_outcome_score DECIMAL(3,2),
    fatigue_indicator VARCHAR(20) CHECK (fatigue_indicator IN ('low', 'moderate', 'high', 'exhausted'))
);

-- Context events: Major life events that explain anomalies
CREATE TABLE IF NOT EXISTS context_events (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    event_date DATE NOT NULL,
    event_type VARCHAR(50) CHECK (event_type IN ('stressor', 'milestone', 'disruption', 'achievement', 'travel', 'health_event', 'relationship', 'financial', 'work')),
    category VARCHAR(100),  -- More specific: deadline, illness, celebration, etc.
    title VARCHAR(255) NOT NULL,
    description TEXT,
    impact_level INTEGER CHECK (impact_level BETWEEN 1 AND 5),  -- 1=minor, 5=life-changing
    duration_days INTEGER,  -- For ongoing events
    resolved BOOLEAN DEFAULT FALSE,
    resolved_date DATE,
    positive_event BOOLEAN DEFAULT FALSE,  -- TRUE for achievements, milestones
    created_at TIMESTAMPTZ DEFAULT NOW()
);

-- Indexes
CREATE INDEX IF NOT EXISTS idx_decision_date ON decision_log(decision_date DESC);
CREATE INDEX IF NOT EXISTS idx_decision_type ON decision_log(decision_type);
CREATE INDEX IF NOT EXISTS idx_decision_domain ON decision_log(domain);
CREATE INDEX IF NOT EXISTS idx_decision_confidence ON decision_log(confidence_level) WHERE confidence_level IS NOT NULL;
CREATE INDEX IF NOT EXISTS idx_daily_metrics_date ON daily_decision_metrics(date DESC);
CREATE INDEX IF NOT EXISTS idx_context_events_date ON context_events(event_date DESC);
CREATE INDEX IF NOT EXISTS idx_context_events_type ON context_events(event_type);
CREATE INDEX IF NOT EXISTS idx_context_events_category ON context_events(category);

-- Trigger to aggregate daily metrics
CREATE OR REPLACE FUNCTION update_daily_decision_metrics()
RETURNS TRIGGER AS $$
BEGIN
    INSERT INTO daily_decision_metrics (date, total_decisions, significant_decisions, total_time_spent_minutes, avg_confidence)
    SELECT 
        CURRENT_DATE,
        COUNT(*) AS total_decisions,
        COUNT(*) FILTER (WHERE decision_type IN ('significant', 'major')) AS significant_decisions,
        COALESCE(SUM(time_spent_minutes), 0) AS total_time_spent_minutes,
        ROUND(AVG(confidence_level)::NUMERIC, 2) AS avg_confidence
    FROM decision_log
    WHERE decision_date::DATE = CURRENT_DATE
    ON CONFLICT (date) DO UPDATE SET
        total_decisions = EXCLUDED.total_decisions,
        significant_decisions = EXCLUDED.significant_decisions,
        total_time_spent_minutes = EXCLUDED.total_time_spent_minutes,
        avg_confidence = EXCLUDED.avg_confidence;
    
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_update_daily_metrics
    AFTER INSERT ON decision_log
    FOR EACH ROW
    EXECUTE FUNCTION update_daily_decision_metrics();

-- Decision fatigue detection
CREATE OR REPLACE FUNCTION calculate_fatigue_indicator(
    p_total_decisions INTEGER,
    p_avg_confidence DECIMAL,
    p_days_decisions INTEGER
) RETURNS VARCHAR(20) AS $$
BEGIN
    -- High decision count + low confidence = fatigue
    IF p_total_decisions > 10 AND p_avg_confidence < 3 THEN
        RETURN 'exhausted';
    ELSIF p_total_decisions > 7 AND p_avg_confidence < 3.5 THEN
        RETURN 'high';
    ELSIF p_total_decisions > 5 OR p_avg_confidence < 3 THEN
        RETURN 'moderate';
    ELSE
        RETURN 'low';
    END IF;
END;
$$ LANGUAGE plpgsql;

-- Update fatigue indicator
CREATE OR REPLACE FUNCTION update_fatigue()
RETURNS TRIGGER AS $$
DECLARE
    v_confidence DECIMAL;
BEGIN
    SELECT avg_confidence INTO v_confidence FROM daily_decision_metrics WHERE date = CURRENT_DATE;
    
    UPDATE daily_decision_metrics
    SET fatigue_indicator = calculate_fatigue_indicator(total_decisions, v_confidence, 1)
    WHERE date = CURRENT_DATE;
    
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_update_fatigue
    AFTER INSERT OR UPDATE ON daily_decision_metrics
    FOR EACH ROW
    WHEN (NEW.date = CURRENT_DATE)
    EXECUTE FUNCTION update_fatigue();

-- Views: Decision patterns
CREATE OR REPLACE VIEW v_decision_patterns AS
SELECT 
    DATE_TRUNC('week', decision_date) AS week,
    COUNT(*) AS total_decisions,
    COUNT(*) FILTER (WHERE decision_type IN ('significant', 'major')) AS significant_decisions,
    AVG(confidence_level) AS avg_confidence,
    COUNT(*) FILTER (WHERE reversible = TRUE) AS reversible_count,
    COUNT(*) FILTER (WHERE outcome_score IS NOT NULL) AS evaluated_count,
    AVG(outcome_score) AS avg_outcome,
    AVG(regret_level) AS avg_regret
FROM decision_log
WHERE decision_date >= CURRENT_DATE - INTERVAL '12 weeks'
GROUP BY DATE_TRUNC('week', decision_date)
ORDER BY week DESC;

-- View: Decision quality by domain
CREATE OR REPLACE VIEW v_decision_quality_by_domain AS
SELECT 
    domain,
    COUNT(*) AS total_decisions,
    AVG(confidence_level) AS avg_confidence,
    AVG(outcome_score) AS avg_outcome,
    AVG(regret_level) AS avg_regret,
    COUNT(*) FILTER (WHERE reversible = TRUE) * 100.0 / NULLIF(COUNT(*), 0) AS reversible_pct
FROM decision_log
WHERE decision_date >= CURRENT_DATE - INTERVAL '90 days'
GROUP BY domain
ORDER BY avg_outcome DESC NULLS LAST;

-- View: Recent context events
CREATE OR REPLACE VIEW v_recent_context_events AS
SELECT 
    event_date,
    event_type,
    category,
    title,
    impact_level,
    positive_event,
    CASE 
        WHEN event_type = 'stressor' THEN '🔴'
        WHEN event_type = 'milestone' OR event_type = 'achievement' THEN '🟢'
        WHEN event_type = 'disruption' THEN '🟡'
        ELSE '⚪'
    END AS icon
FROM context_events
WHERE event_date >= CURRENT_DATE - INTERVAL '30 days'
   OR resolved = FALSE
ORDER BY event_date DESC, impact_level DESC;

-- View: Active stressors
CREATE OR REPLACE VIEW v_active_stressors AS
SELECT 
    id,
    event_date,
    title,
    category,
    impact_level,
    event_date + (duration_days || ' days')::INTERVAL AS expected_end_date,
    CURRENT_DATE - event_date AS days_ongoing
FROM context_events
WHERE event_type = 'stressor' 
  AND resolved = FALSE
ORDER BY impact_level DESC, event_date ASC;

-- View: Decision advisor (similar past decisions)
CREATE OR REPLACE VIEW v_similar_decisions AS
SELECT 
    domain,
    title,
    outcome_score,
    regret_level,
    decision_date,
    description
FROM decision_log
WHERE outcome_score IS NOT NULL
  AND decision_date >= CURRENT_DATE - INTERVAL '6 months'
ORDER BY domain, outcome_score DESC;

-- =====================================================
-- Maintenance
-- =====================================================

COMMENT ON TABLE decision_log IS 'Log of significant decisions with outcomes';
COMMENT ON TABLE daily_decision_metrics IS 'Daily aggregated decision metrics';
COMMENT ON TABLE context_events IS 'Major life events affecting performance';
COMMENT ON VIEW v_decision_patterns IS 'Weekly decision patterns over time';
COMMENT ON VIEW v_decision_quality_by_domain IS 'Decision quality metrics by domain';
COMMENT ON VIEW v_recent_context_events IS 'Recent context events affecting state';
COMMENT ON VIEW v_active_stressors IS 'Unresolved stressors needing attention';
COMMENT ON VIEW v_similar_decisions IS 'Past decisions for AI advisor context';

-- Run after creation:
-- INSERT INTO decision_log (title, decision_type, domain, confidence_level) 
-- VALUES ('Choose training program', 'moderate', 'health', 4);

-- INSERT INTO context_events (event_date, event_type, category, title, impact_level)
-- VALUES (CURRENT_DATE, 'stressor', 'deadline', 'Q2 deliverables due', 4);

-- SELECT * FROM v_decision_patterns;
-- SELECT * FROM v_recent_context_events;
-- SELECT * FROM v_active_stressors;
