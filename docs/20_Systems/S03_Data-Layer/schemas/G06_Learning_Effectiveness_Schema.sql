-- =====================================================
-- G06: Learning Effectiveness Schema
-- Purpose: Track learning effectiveness and skill application
-- Created: 2026-04-12
-- Database: autonomous_learning
-- =====================================================

-- Learning sessions: Track study time
CREATE TABLE IF NOT EXISTS learning_sessions (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    session_date DATE NOT NULL DEFAULT CURRENT_DATE,
    skill_name VARCHAR(255) NOT NULL,
    technology_category VARCHAR(100),  -- ai, cloud, language, framework, etc.
    study_minutes INTEGER NOT NULL,
    method VARCHAR(50) CHECK (method IN ('course', 'book', 'article', 'practice', 'project', 'mentoring', 'conference', 'other')),
    source VARCHAR(255),  -- Course name, book title, etc.
    self_assessment INTEGER CHECK (self_assessment BETWEEN 1 AND 5),  -- Confidence after session
    notes TEXT,
    created_at TIMESTAMPTZ DEFAULT NOW()
);

-- Skill application: Track when learned skills are used
CREATE TABLE IF NOT EXISTS skill_application (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    application_date DATE NOT NULL DEFAULT CURRENT_DATE,
    skill_name VARCHAR(255) NOT NULL,
    context VARCHAR(255),  -- Project name, work task, etc.
    outcome VARCHAR(50),  -- success, partial, failed
    productivity_impact INTEGER CHECK (productivity_impact BETWEEN 1 AND 5),
    notes TEXT,
    created_at TIMESTAMPTZ DEFAULT NOW()
);

-- Skill retention: Periodic self-assessment
CREATE TABLE IF NOT EXISTS skill_retention (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    assessment_date DATE NOT NULL DEFAULT CURRENT_DATE,
    skill_name VARCHAR(255) NOT NULL,
    retention_score INTEGER CHECK (retention_score BETWEEN 1 AND 5),  -- 1=forgot, 5=fluent
    last_used_days INTEGER,  -- Days since last use
    notes TEXT,
    created_at TIMESTAMPTZ DEFAULT NOW()
);

-- Indexes
CREATE INDEX IF NOT EXISTS idx_learning_sessions_date ON learning_sessions(session_date DESC);
CREATE INDEX IF NOT EXISTS idx_learning_sessions_skill ON learning_sessions(skill_name);
CREATE INDEX IF NOT EXISTS idx_learning_sessions_category ON learning_sessions(technology_category);
CREATE INDEX IF NOT EXISTS idx_skill_application_date ON skill_application(application_date DESC);
CREATE INDEX IF NOT EXISTS idx_skill_application_skill ON skill_application(skill_name);
CREATE INDEX IF NOT EXISTS idx_skill_retention_date ON skill_retention(assessment_date DESC);
CREATE INDEX IF NOT EXISTS idx_skill_retention_skill ON skill_retention(skill_name);

-- View: Learning velocity
CREATE OR REPLACE VIEW v_learning_velocity AS
SELECT 
    DATE_TRUNC('week', session_date) AS week,
    skill_name,
    technology_category,
    SUM(study_minutes) AS total_minutes,
    COUNT(*) AS session_count,
    AVG(self_assessment) AS avg_confidence
FROM learning_sessions
WHERE session_date >= CURRENT_DATE - INTERVAL '12 weeks'
GROUP BY DATE_TRUNC('week', session_date), skill_name, technology_category
ORDER BY week DESC, total_minutes DESC;

-- View: Skill application rate
CREATE OR REPLACE VIEW v_skill_application_rate AS
WITH learned AS (
    SELECT 
        skill_name,
        COUNT(*) AS learning_sessions,
        SUM(study_minutes) AS total_learning_minutes,
        MAX(session_date) AS last_learned
    FROM learning_sessions
    GROUP BY skill_name
),
applied AS (
    SELECT 
        skill_name,
        COUNT(*) AS application_count,
        MAX(application_date) AS last_applied
    FROM skill_application
    GROUP BY skill_name
),
retention AS (
    SELECT 
        skill_name,
        AVG(retention_score) AS avg_retention,
        MAX(assessment_date) AS last_assessed
    FROM skill_retention
    GROUP BY skill_name
)
SELECT 
    l.skill_name,
    l.total_learning_minutes,
    l.learning_sessions,
    l.last_learned,
    COALESCE(a.application_count, 0) AS application_count,
    a.last_applied,
    ROUND(
        (COALESCE(a.application_count, 0)::DECIMAL / NULLIF(l.learning_sessions, 0) * 100)::NUMERIC, 
        1
    ) AS application_rate_pct,
    r.avg_retention,
    r.last_assessed,
    CURRENT_DATE - l.last_learned AS days_since_learning,
    CASE 
        WHEN CURRENT_DATE - l.last_learned > 60 THEN '🔴 Decay Risk'
        WHEN CURRENT_DATE - l.last_learned > 30 THEN '🟡 Review Needed'
        WHEN COALESCE(a.application_count, 0) = 0 THEN '🟡 Not Applied'
        ELSE '🟢 Active'
    END AS skill_status
FROM learned l
LEFT JOIN applied a ON l.skill_name = a.skill_name
LEFT JOIN retention r ON l.skill_name = r.skill_name
ORDER BY l.total_learning_minutes DESC;

-- View: Learning by technology category
CREATE OR REPLACE VIEW v_learning_by_category AS
SELECT 
    DATE_TRUNC('month', session_date) AS month,
    technology_category,
    SUM(study_minutes) AS total_minutes,
    COUNT(DISTINCT skill_name) AS skills_learned,
    AVG(self_assessment) AS avg_confidence
FROM learning_sessions
WHERE session_date >= CURRENT_DATE - INTERVAL '12 months'
GROUP BY DATE_TRUNC('month', session_date), technology_category
ORDER BY month DESC, total_minutes DESC;

-- View: Skill half-life tracking
CREATE OR REPLACE VIEW v_skill_half_life AS
WITH skill_timeline AS (
    SELECT 
        skill_name,
        session_date AS activity_date,
        study_minutes,
        NULL::DATE AS application_date,
        'learned' AS activity_type
    FROM learning_sessions
    UNION ALL
    SELECT 
        skill_name,
        application_date AS activity_date,
        NULL::INTEGER,
        NULL::VARCHAR,
        'applied' AS activity_type
    FROM skill_application
),
skill_gaps AS (
    SELECT 
        skill_name,
        activity_date,
        activity_type,
        LEAD(activity_date) OVER (PARTITION BY skill_name ORDER BY activity_date) AS next_activity,
        LEAD(activity_date) OVER (PARTITION BY skill_name ORDER BY activity_date) - activity_date AS gap_days
    FROM skill_timeline
    WHERE skill_name IN (
        SELECT skill_name FROM skill_timeline GROUP BY skill_name HAVING COUNT(*) > 1
    )
)
SELECT 
    skill_name,
    COUNT(*) AS total_activities,
    AVG(gap_days) AS avg_gap_days,
    MAX(gap_days) AS max_gap_days,
    -- Estimate half-life: time until 50% retention
    CASE 
        WHEN AVG(gap_days) < 14 THEN '2 weeks'
        WHEN AVG(gap_days) < 30 THEN '1 month'
        WHEN AVG(gap_days) < 60 THEN '2 months'
        ELSE '6+ months'
    END AS estimated_half_life,
    CASE 
        WHEN AVG(gap_days) > 60 THEN '🔴 Decay Warning'
        WHEN AVG(gap_days) > 30 THEN '🟡 Review Soon'
        ELSE '🟢 Active'
    END AS retention_status
FROM skill_gaps
WHERE gap_days IS NOT NULL
GROUP BY skill_name
ORDER BY avg_gap_days DESC;

-- View: Weekly learning summary
CREATE OR REPLACE VIEW v_weekly_learning_summary AS
SELECT 
    DATE_TRUNC('week', session_date) AS week,
    SUM(study_minutes) AS total_minutes,
    SUM(study_minutes) / 60.0 AS total_hours,
    COUNT(*) AS sessions,
    COUNT(DISTINCT skill_name) AS unique_skills,
    AVG(self_assessment) AS avg_confidence,
    COUNT(DISTINCT technology_category) AS categories_explored
FROM learning_sessions
WHERE session_date >= CURRENT_DATE - INTERVAL '12 weeks'
GROUP BY DATE_TRUNC('week', session_date)
ORDER BY week DESC;

-- Trigger: Detect decay risk
CREATE OR REPLACE FUNCTION detect_skill_decay()
RETURNS TRIGGER AS $$
DECLARE
    v_last_activity DATE;
    v_decay_threshold INTEGER := 30;  -- Days before decay warning
BEGIN
    -- Check if this is a new application for an old skill
    SELECT GREATEST(
        (SELECT MAX(session_date) FROM learning_sessions WHERE skill_name = NEW.skill_name),
        (SELECT MAX(application_date) FROM skill_application WHERE skill_name = NEW.skill_name)
    ) INTO v_last_activity;
    
    IF v_last_activity IS NOT NULL AND NEW.application_date - v_last_activity > v_decay_threshold * INTERVAL '1 day' THEN
        RAISE NOTICE 'Skill % may be decaying. Last activity: %', NEW.skill_name, v_last_activity;
    END IF;
    
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_detect_decay
    BEFORE INSERT ON skill_application
    FOR EACH ROW
    EXECUTE FUNCTION detect_skill_decay();

-- =====================================================
-- Maintenance
-- =====================================================

COMMENT ON TABLE learning_sessions IS 'Track time spent learning new skills';
COMMENT ON TABLE skill_application IS 'Track when learned skills are used in practice';
COMMENT ON TABLE skill_retention IS 'Periodic self-assessment of skill retention';
COMMENT ON VIEW v_learning_velocity IS 'Learning pace and progress over time';
COMMENT ON VIEW v_skill_application_rate IS 'Ratio of learned skills to applied skills';
COMMENT ON VIEW v_learning_by_category IS 'Learning time distribution by tech category';
COMMENT ON VIEW v_skill_half_life IS 'Skill retention half-life estimates';
COMMENT ON VIEW v_weekly_learning_summary IS 'Weekly aggregated learning metrics';

-- Run after creation:
-- INSERT INTO learning_sessions (skill_name, technology_category, study_minutes, method, self_assessment)
-- VALUES ('Kubernetes basics', 'cloud', 120, 'course', 3);

-- INSERT INTO skill_application (skill_name, context, outcome, productivity_impact)
-- VALUES ('Kubernetes basics', 'Home lab setup', 'success', 4);

-- SELECT * FROM v_skill_application_rate;
-- SELECT * FROM v_learning_velocity;
-- SELECT * FROM v_skill_half_life;
-- SELECT * FROM v_weekly_learning_summary;
