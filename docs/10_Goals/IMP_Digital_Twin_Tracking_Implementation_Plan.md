---
title: "Digital Twin Tracking Implementation Plan"
type: "implementation_plan"
status: "active"
owner: "Michał"
created: "2026-04-12"
last_updated: "2026-04-16"
---

# Digital Twin Tracking Implementation Plan

## Executive Summary

This plan addresses the gaps between current Digital Twin coverage and comprehensive self-knowledge. Based on the Strategic Digital Twin Tracking Matrix analysis, we prioritize metrics that:
1. Can be automated or semi-automated
2. Change behavior when tracked
3. Correlate with things we actually care about

---

## Phase 1: Quick Wins (This Week)

### 1.1 Daily Note Template Enhancement

**Add 3 new fields to `{{ROOT_LOCATION}}/Obsidian Vault/99_System/Templates/Daily/Daily Note Template.md`:**

```yaml
---
# NEW FIELDS TO ADD
stress_level: 3        # 1-5 scale (1=relaxed, 5=overwhelmed)
focus_quality: 3       # 1-5 scale (1=scattered, 5=deep flow)
social_energy: 3       # 1-5 scale (1=reclusive, 5=energized)
---
```

**Estimated Time:** 30 minutes  
**Automation:** Manual entry (30 seconds/day)  
**Impact:** HIGH - explains anomalies, enables pattern detection

---

### 1.2 Weekly Aggregation Script

**Create `G10_weekly_subjective_aggregator.py`:**

```python
# Pseudocode
Weekly metrics to aggregate:
- avg(stress_level) 
- avg(focus_quality)
- avg(social_energy)
- stress_spike_count (days with stress_level > 4)
- flow_day_count (days with focus_quality = 5)
- social_battery_depleted_days (social_energy < 2)
```

**Estimated Time:** 2 hours  
**Output:** Weekly review dashboard showing trends

---

## Phase 2: This Month

### 2.1 Relationship Intelligence System (G09 Extension)

#### Database Schema
```sql
-- New table: autonomous_life_logistics.relationships
CREATE TABLE relationships (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    name VARCHAR(255) NOT NULL,
    relationship_type VARCHAR(50), -- family, friend, colleague, mentor, client
    importance_score INTEGER CHECK (importance_score BETWEEN 1 AND 10),
    contact_frequency_days INTEGER, -- how often to contact
    last_contact_date DATE,
    birthday DATE,
    notes TEXT,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- New table: autonomous_life_logistics.interactions
CREATE TABLE interactions (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    relationship_id UUID REFERENCES relationships(id),
    interaction_date TIMESTAMPTZ NOT NULL,
    interaction_type VARCHAR(50), -- in_person, call, message, video
    duration_minutes INTEGER,
    quality_score INTEGER CHECK (quality_score BETWEEN 1 AND 5), -- how fulfilling
    notes TEXT,
    created_at TIMESTAMPTZ DEFAULT NOW()
);

-- Indexes
CREATE INDEX idx_relationships_last_contact ON relationships(last_contact_date);
CREATE INDEX idx_interactions_date ON interactions(interaction_date);
CREATE INDEX idx_interactions_relationship ON interactions(relationship_id);
```

#### Daily Note Integration
Add to daily note template:
```yaml
---
# NEW FIELD
relationships_touched: []  # List of relationship IDs/names from today's interactions
---
```

#### Automation Scripts
1. **`G09_relationship_reminder.py`** - Daily check, send Telegram alert if contact overdue
2. **`G09_interaction_logger.py`** - Parse daily note for interactions, update DB
3. **`G09_birthday_tracker.py`** - Weekly check for upcoming birthdays

#### n8n Workflow
- `WF_Relationship-Maintenance.json` - Weekly scan for overdue contacts
- `WF_Birthday-Alerts.json` - 7-day advance birthday notification

**Estimated Time:** 8-10 hours  
**Impact:** HUGE - #1 predictor of happiness

---

### 2.2 Net Worth Tracking (G05 Extension)

#### Database Schema
```sql
-- New table: autonomous_finance.net_worth_snapshots
CREATE TABLE net_worth_snapshots (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    snapshot_date DATE NOT NULL UNIQUE,
    total_assets DECIMAL(15,2),
    total_liabilities DECIMAL(15,2),
    net_worth DECIMAL(15,2) GENERATED ALWAYS AS (total_assets - total_liabilities) STORED,
    -- Asset breakdown
    cash_amount DECIMAL(15,2),
    investment_amount DECIMAL(15,2),
    real_estate_value DECIMAL(15,2),
    other_assets DECIMAL(15,2),
    -- Liability breakdown
    mortgage_balance DECIMAL(15,2),
    loan_balance DECIMAL(15,2),
    other_liabilities DECIMAL(15,2),
    -- Ratios
    savings_rate DECIMAL(5,2), -- percentage of income saved
    debt_to_income_ratio DECIMAL(5,2),
    created_at TIMESTAMPTZ DEFAULT NOW()
);

-- Index
CREATE INDEX idx_net_worth_date ON net_worth_snapshots(snapshot_date);
```

#### Script
**`G05_net_worth_tracker.py`:**
```python
# Runs monthly (1st of month)
# Queries all account balances from accounts table
# Queries all liabilities
# Calculates totals and inserts snapshot
```

#### Dashboard
- Monthly net worth chart
- Net worth trajectory vs. goal
- Asset allocation pie chart
- Month-over-month growth

**Estimated Time:** 4-6 hours  
**Impact:** HIGH - financial health visibility

---

### 2.3 Income Diversification Tracking (G05 Extension)

#### Database Schema
```sql
-- New table: autonomous_finance.income_sources
CREATE TABLE income_sources (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    source_name VARCHAR(255) NOT NULL,
    source_type VARCHAR(50), -- salary, freelance, investment, rental, passive
    is_active BOOLEAN DEFAULT TRUE,
    monthly_amount DECIMAL(15,2),
    frequency VARCHAR(20), -- monthly, quarterly, annual
    notes TEXT,
    created_at TIMESTAMPTZ DEFAULT NOW()
);

-- Update transactions to track income type
ALTER TABLE transactions ADD COLUMN income_type VARCHAR(50);
```

#### Script
**`G05_income_analyzer.py`:**
```python
# Runs monthly
# Categorizes income by source_type
# Calculates diversification ratio: (non_salary_income / total_income) * 100
# Tracks passive income separately
```

**Estimated Time:** 3-4 hours  
**Impact:** MEDIUM - career resilience visibility

---

### 2.4 Context Events Logging

#### Database Schema
```sql
-- New table: autonomous_life_logistics.context_events
CREATE TABLE context_events (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    event_date DATE NOT NULL,
    event_type VARCHAR(50), -- stressor, milestone, disruption, achievement, travel
    category VARCHAR(100), -- work, family, health, financial, personal
    title VARCHAR(255) NOT NULL,
    description TEXT,
    impact_level INTEGER CHECK (impact_level BETWEEN 1 AND 5), -- 1=minor, 5=life-changing
    duration_days INTEGER, -- for ongoing events
    resolved BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMPTZ DEFAULT NOW()
);

-- Index
CREATE INDEX idx_context_events_date ON context_events(event_date);
CREATE INDEX idx_context_events_type ON context_events(event_type);
```

#### Daily Note Integration
```yaml
---
# NEW FIELD
context_events: []  # List of event tags: [work_deadline, family_visit, travel]
---
```

#### Automation
**`G11_context_event_parser.py`:**
```python
# Daily run
# Parse frustration, highlight, journal for context events
# Extract keywords: stress, deadline, travel, celebration, etc.
# Update context_events table
```

**Estimated Time:** 4-5 hours  
**Impact:** MEDIUM - explains data anomalies

---

## Phase 3: Next Quarter (Q3 2026)

### 3.1 Screen Time Integration (G10 Extension) ✅ DONE

**Implemented via ActivityWatch (April 2026)**
- **System:** `aw-server-rust` running in Docker
- **Automation:** `G10_activitywatch_sync.py`
- **Data:** Passive window/app tracking with productivity classification

#### Previous Plan (Superseded by ActivityWatch)
**Option A: RescueTime (Recommended)**
- RescueTime API provides app/category breakdown
- Trackable: productive vs. distracting time
- Free tier sufficient for daily summaries

**Option B: iOS Screen Time API**
- Requires Apple Developer account
- More granular but complex

#### Script (Implemented as G10_activitywatch_sync.py)
```python
# Runs daily at midnight
# Fetches yesterday's ActivityWatch data
# Stores: total_screen_time, productive_minutes, distracting_minutes, top_apps
# Stores by category: deep_work_apps, social_media, entertainment
```

#### Daily Note Integration
```yaml
---
# TO BE ADDED in next Daily Note iteration
screen_time_total: 0       # minutes
screen_time_productive: 0  # minutes  
screen_time_distracting: 0 # minutes
focus_interruptions: 0    # count
---
```

**Impact:** HIGH - productivity blind spot removal fully automated with zero cloud dependency.

---

### 3.2 Learning Effectiveness Tracking (G06 Extension)

#### Database Schema
```sql
-- New table: autonomous_learning.learning_effectiveness
CREATE TABLE learning_effectiveness (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    skill_name VARCHAR(255) NOT NULL,
    learning_date DATE NOT NULL,
    study_minutes INTEGER,
    method VARCHAR(50), -- course, book, practice, project
    self_assessment INTEGER CHECK (self_assessment BETWEEN 1 AND 5), -- confidence level
    practical_application BOOLEAN, -- did you use it?
    application_context VARCHAR(255), -- where was it applied?
    retention_test_score INTEGER, -- 0-100 if tested
    created_at TIMESTAMPTZ DEFAULT NOW()
);

-- Skill decay tracking
CREATE TABLE skill_usage (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    skill_name VARCHAR(255) NOT NULL,
    last_used_date DATE,
    usage_count INTEGER DEFAULT 1,
    context VARCHAR(255),
    created_at TIMESTAMPTZ DEFAULT NOW()
);
```

#### Daily Note Integration
```yaml
---
learning_today:
  - skill: "Kubernetes basics"
    confidence: 3  # 1-5
    applied: false
    notes: "Watched course but haven't practiced"
---
```

#### Script
**`G06_learning_effectiveness.py`:**
```python
# Weekly aggregation
# Calculate: skills_learning, skills_applied, application_rate
# Identify: skill decay risk (not used in 30+ days)
# Generate: skill half-life report
```

**Estimated Time:** 8-10 hours  
**Impact:** HIGH - validates learning investment

---

### 3.3 Decision Fatigue Tracking (G11 Extension)

#### Database Schema
```sql
-- New table: autonomous_life_logistics.decision_log
CREATE TABLE decision_log (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    decision_date TIMESTAMPTZ NOT NULL,
    decision_type VARCHAR(50), -- trivial, moderate, significant, major
    domain VARCHAR(50), -- work, health, financial, personal, social
    description TEXT,
    alternatives_considered INTEGER DEFAULT 0,
    time_spent_minutes INTEGER,
    confidence_level INTEGER CHECK (confidence_level BETWEEN 1 AND 5),
    reversible BOOLEAN DEFAULT FALSE,
    outcome_score INTEGER CHECK (outcome_score BETWEEN 1 AND 5), -- post-decision rating
    outcome_date DATE, -- when outcome was evaluated
    notes TEXT,
    created_at TIMESTAMPTZ DEFAULT NOW()
);

-- Daily aggregates
CREATE TABLE daily_decision_metrics (
    date DATE PRIMARY KEY,
    total_decisions INTEGER,
    significant_decisions INTEGER,
    total_time_spent_minutes INTEGER,
    avg_confidence DECIMAL(3,2),
    reversible_rate DECIMAL(3,2),
    evaluated_outcomes INTEGER,
    avg_outcome_score DECIMAL(3,2)
);
```

#### Daily Note Integration
```yaml
---
decisions_today:
  count: 5
  significant: 2
  fatigue_indicator: "moderate"  # low, moderate, high
---
```

#### Script
**`G11_decision_fatigue_analyzer.py`:**
```python
# Daily at end of day
# Calculate: decision count, significant decisions, fatigue indicators
# Correlate: decisions vs. readiness score, stress level
# Alert: if decision count exceeds threshold given low readiness
```

**Estimated Time:** 6-8 hours  
**Impact:** HIGH - prevents decision degradation

---

### 3.4 Technology Relevance Scoring (G09 Extension)

#### Database Schema
```sql
-- New table: autonomous_career.tech_relevance
CREATE TABLE tech_relevance (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    technology VARCHAR(255) NOT NULL,
    category VARCHAR(100), -- language, framework, cloud, ai, etc.
    relevance_score INTEGER CHECK (relevance_score BETWEEN 1 AND 10),
    trend VARCHAR(20), -- emerging, stable, declining
    source VARCHAR(255), -- where the assessment came from
    assessed_at DATE,
    created_at TIMESTAMPTZ DEFAULT NOW()
);

-- Learning time by tech
CREATE TABLE learning_by_technology (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    technology VARCHAR(255) NOT NULL,
    learning_date DATE NOT NULL,
    minutes_spent INTEGER,
    source VARCHAR(100), -- course, book, project, etc.
    created_at TIMESTAMPTZ DEFAULT NOW()
);
```

#### Script
**`G09_tech_relevance_analyzer.py`:**
```python
# Monthly
# Track time spent learning each technology
# Compare with market relevance scores
# Alert: if spending time on declining tech
# Suggest: emerging tech to learn based on relevance
```

**Estimated Time:** 8-10 hours  
**Impact:** MEDIUM - career future-proofing

---

## Phase 4: Future Evolution (Q4 2026+)

### 4.1 Advanced Biometric Integration
- Blood pressure monitoring (if device acquired)
- Blood work integration (manual quarterly entry)
- Advanced body composition (segmental analysis)

### 4.2 Automated Environmental Correlation
- AI-powered analysis of environment → performance correlations
- Automated light/temperature adjustments based on predicted optimal
- Sleep environment scoring

### 4.3 Predictive Performance Modeling
- Machine learning model for next-day readiness prediction
- "What should I do today?" based on all data streams
- Early warning system for burnout risk

---

## Implementation Checklist

### Week 1
- [ ] Update daily note template with 3 new fields (stress_level, focus_quality, social_energy)
- [ ] Create G10_weekly_subjective_aggregator.py
- [ ] Test and validate template updates

### Week 2-3
- [ ] Create relationships table schema
- [ ] Create relationships SQL file
- [ ] Implement G09_relationship_reminder.py
- [ ] Implement G09_interaction_logger.py
- [ ] Add relationships_touched field to daily note
- [ ] Test relationship tracking flow

### Week 4
- [ ] Create net_worth_snapshots table schema
- [ ] Implement G05_net_worth_tracker.py
- [ ] Create net worth dashboard view
- [ ] Test monthly snapshot generation

### Month 2
- [ ] Implement income_sources tracking
- [ ] Implement G05_income_analyzer.py
- [ ] Create context_events table
- [ ] Implement G11_context_event_parser.py
- [ ] Update daily note with context_events field

### Month 3+
- [ ] RescueTime integration
- [ ] Learning effectiveness tracking
- [ ] Decision fatigue logging
- [ ] Technology relevance scoring

---

## Success Metrics

| Phase | Metric | Target |
|-------|--------|--------|
| Week 1 | Daily subjective entries completed | > 90% |
| Month 1 | Relationship database populated | > 20 contacts |
| Month 1 | Net worth snapshots generated | 1 month |
| Month 2 | Context events logged | > 50 events |
| Month 3 | Screen time tracked | 30 days |
| Month 3 | Learning effectiveness measured | > 10 skills tracked |

---

## Cross-References

- Gap Analysis: [GAP_Digital_Twin_Data_Streams.md](./GAP_Digital_Twin_Data_Streams.md)
- Updated Roadmaps:
  - G05: Financial Deep Metrics added
  - G06: Learning Effectiveness added  
  - G09: Relationship Intelligence added
  - G10: Digital Footprint added
  - G11: Cognitive Patterns added

---

*Document created: 2026-04-12*  
*Owner: Michał*  
*Review Cadence: Weekly during implementation*
