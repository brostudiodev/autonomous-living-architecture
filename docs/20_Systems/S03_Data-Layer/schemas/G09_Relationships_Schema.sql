-- =====================================================
-- G09: Relationship Intelligence Schema
-- Purpose: Track relationships and social capital
-- Created: 2026-04-12
-- Database: autonomous_life_logistics
-- =====================================================

-- Relationships table: Core contact information
CREATE TABLE IF NOT EXISTS relationships (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    name VARCHAR(255) NOT NULL,
    relationship_type VARCHAR(50) CHECK (relationship_type IN ('family', 'friend', 'colleague', 'mentor', 'client', 'partner', 'neighbor', 'other')),
    importance_score INTEGER CHECK (importance_score BETWEEN 1 AND 10),
    contact_frequency_days INTEGER DEFAULT 14,  -- How often to contact (default: 2 weeks)
    last_contact_date DATE,
    next_contact_target DATE,
    birthday DATE,
    phone VARCHAR(50),
    email VARCHAR(255),
    notes TEXT,
    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- Interactions table: Log of meaningful interactions
CREATE TABLE IF NOT EXISTS interactions (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    relationship_id UUID NOT NULL REFERENCES relationships(id) ON DELETE CASCADE,
    interaction_date TIMESTAMPTZ NOT NULL,
    interaction_type VARCHAR(50) CHECK (interaction_type IN ('in_person', 'call', 'video', 'message', 'email', 'social_media')),
    duration_minutes INTEGER,
    quality_score INTEGER CHECK (quality_score BETWEEN 1 AND 5),  -- How fulfilling was the interaction
    topics_discussed TEXT[],  -- Array of topics: ['work', 'personal', 'advice', 'social'
    energy_impact VARCHAR(20) CHECK (energy_impact IN ('energizing', 'neutral', 'draining')),  -- Did interaction energize or drain you?
    notes TEXT,
    created_at TIMESTAMPTZ DEFAULT NOW()
);

-- Indexes for performance
CREATE INDEX IF NOT EXISTS idx_relationships_type ON relationships(relationship_type);
CREATE INDEX IF NOT EXISTS idx_relationships_last_contact ON relationships(last_contact_date);
CREATE INDEX IF NOT EXISTS idx_relationships_next_contact ON relationships(next_contact_target);
CREATE INDEX IF NOT EXISTS idx_relationships_active ON relationships(is_active) WHERE is_active = TRUE;
CREATE INDEX IF NOT EXISTS idx_interactions_date ON interactions(interaction_date);
CREATE INDEX IF NOT EXISTS idx_interactions_relationship ON interactions(relationship_id);

-- Trigger to update next_contact_target based on frequency
CREATE OR REPLACE FUNCTION update_next_contact_target()
RETURNS TRIGGER AS $$
BEGIN
    IF NEW.last_contact_date IS NOT NULL THEN
        UPDATE relationships 
        SET next_contact_target = NEW.last_contact_date + (relationships.contact_frequency_days || ' days')::INTERVAL,
            updated_at = NOW()
        WHERE id = NEW.relationship_id;
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_update_next_contact
    AFTER INSERT ON interactions
    FOR EACH ROW
    EXECUTE FUNCTION update_next_contact_target();

-- View: Overdue contacts (for reminders)
CREATE OR REPLACE VIEW v_overdue_contacts AS
SELECT 
    r.id,
    r.name,
    r.relationship_type,
    r.importance_score,
    r.last_contact_date,
    r.next_contact_target,
    r.contact_frequency_days,
    COALESCE(r.last_contact_date + (r.contact_frequency_days || ' days')::INTERVAL, CURRENT_DATE) - CURRENT_DATE AS days_overdue,
    CASE 
        WHEN r.importance_score >= 8 THEN '🔴 Critical'
        WHEN r.importance_score >= 5 THEN '🟡 Important'
        ELSE '🟢 Normal'
    END AS priority
FROM relationships r
WHERE r.is_active = TRUE
  AND r.next_contact_target <= CURRENT_DATE
ORDER BY days_overdue DESC, r.importance_score DESC;

-- View: Relationship health summary
CREATE OR REPLACE VIEW v_relationship_health AS
SELECT 
    r.id,
    r.name,
    r.relationship_type,
    r.importance_score,
    r.last_contact_date,
    COALESCE(
        (SELECT MAX(i.interaction_date) 
         FROM interactions i 
         WHERE i.relationship_id = r.id),
        r.created_at
    ) AS last_interaction,
    COALESCE(
        (SELECT AVG(i.quality_score::NUMERIC) 
         FROM interactions i 
         WHERE i.relationship_id = r.id 
           AND i.interaction_date > CURRENT_DATE - INTERVAL '30 days'),
        0
    ) AS avg_quality_30d,
    COALESCE(
        (SELECT COUNT(*) 
         FROM interactions i 
         WHERE i.relationship_id = r.id 
           AND i.interaction_date > CURRENT_DATE - INTERVAL '30 days'),
        0
    ) AS interactions_30d
FROM relationships r
WHERE r.is_active = TRUE;

-- View: Social energy map (who energizes vs drains)
CREATE OR REPLACE VIEW v_social_energy_map AS
SELECT 
    r.name,
    r.relationship_type,
    r.importance_score,
    AVG(CASE i.energy_impact 
        WHEN 'energizing' THEN 2 
        WHEN 'neutral' THEN 0 
        WHEN 'draining' THEN -2 
        ELSE 0 END) AS energy_score,
    COUNT(*) AS total_interactions,
    AVG(i.quality_score::NUMERIC) AS avg_quality
FROM relationships r
JOIN interactions i ON r.id = i.relationship_id
WHERE i.interaction_date > CURRENT_DATE - INTERVAL '90 days'
GROUP BY r.id, r.name, r.relationship_type, r.importance_score
ORDER BY energy_score DESC, avg_quality DESC;

-- =====================================================
-- Maintenance
-- =====================================================

COMMENT ON TABLE relationships IS 'Core contact information for relationship intelligence';
COMMENT ON TABLE interactions IS 'Log of meaningful interactions with contacts';
COMMENT ON VIEW v_overdue_contacts IS 'Contacts that need attention based on frequency targets';
COMMENT ON VIEW v_relationship_health IS 'Summary of relationship health metrics';
COMMENT ON VIEW v_social_energy_map IS 'Map of who energizes vs drains you';

-- Run after creation:
-- SELECT * FROM v_overdue_contacts;
-- SELECT * FROM v_relationship_health;
-- SELECT * FROM v_social_energy_map;
