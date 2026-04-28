---
title: "G01: Training Database Architecture"
type: "documentation"
status: "active"
goal_id: "goal-g01"
owner: "Michał"
updated: "2026-02-10"
---

# G01: Autonomous Training Database Architecture

This document outlines the architecture of the `autonomous_training` PostgreSQL database, which serves as the data backend for **Goal G01: Target Body Fat**. The design mirrors the robust architecture of the `autonomous_finance` database, tailored for High-Intensity Training (HIT) principles and performance tracking.

## 1. Core Design Philosophy

The schema is designed for:
- **Performance:** Key transactional tables (`workouts`, `workout_sets`) are partitioned by date to ensure fast queries, even with large historical datasets.
- **Data Integrity:** Foreign key constraints, checks, and triggers enforce valid and consistent data.
- **Automation:** A suite of `upsert` functions allows for seamless, idempotent data synchronization from external sources like Google Sheets.
- **Intelligence:** A set of analytical views provides actionable insights and recommendations based on HIT principles, such as progressive overload and recovery monitoring.

---

## 2. Database Schema

### Utility Functions

A helper function is used to automatically update the `updated_at` timestamp on any row modification, ensuring data freshness.

```sql
CREATE OR REPLACE FUNCTION public.update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = CURRENT_TIMESTAMP;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;
```

### Reference Tables (Master Data)

These tables store master data for exercises and workout templates.

#### `public.exercises`
Stores a central registry of all possible exercises, including HIT-specific metadata like target Time Under Tension (TUT).

```sql
CREATE TABLE public.exercises (
    exercise_id VARCHAR(50) PRIMARY KEY,
    exercise_name VARCHAR(100) NOT NULL UNIQUE,
    muscle_group VARCHAR(50) NOT NULL,
    movement_type VARCHAR(20) CHECK (movement_type IN ('Compound', 'Isolation')),
    equipment VARCHAR(50),
    target_tut_min INTEGER DEFAULT 45,
    target_tut_max INTEGER DEFAULT 90,
    notes TEXT,
    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
```

#### `public.workout_templates`
Defines reusable workout structures (e.g., 'HIT Upper A') for consistency in logging.

```sql
CREATE TABLE public.workout_templates (
    template_id VARCHAR(50) PRIMARY KEY,
    template_name VARCHAR(100) NOT NULL,
    workout_type VARCHAR(30) NOT NULL,
    target_duration_min INTEGER,
    notes TEXT,
    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
```

### Transactional Tables (Time-Series Data)

These tables store time-series data for workouts, sets, and body measurements. They are partitioned by year for performance.

#### `public.workouts`
Logs each workout session, including subjective metrics like recovery and mood scores.

```sql
CREATE TABLE public.workouts (
    workout_date DATE NOT NULL,
    template_id VARCHAR(50) NOT NULL,
    location VARCHAR(50) DEFAULT 'home',
    duration_min INTEGER NOT NULL,
    days_since_last_workout INTEGER,
    recovery_score INTEGER CHECK (recovery_score BETWEEN 1 AND 5),
    mood_score INTEGER CHECK (mood_score BETWEEN 1 AND 5),
    notes TEXT,
    data_source VARCHAR(20) DEFAULT 'Sheet',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (workout_date, template_id)
) PARTITION BY RANGE (workout_date);
```

#### `public.workout_sets`
Logs each individual exercise set within a workout, capturing weight, TUT, and effort.

```sql
CREATE TABLE public.workout_sets (
    workout_date DATE NOT NULL,
    template_id VARCHAR(50) NOT NULL,
    exercise_id VARCHAR(50) NOT NULL,
    weight_kg NUMERIC(6,2) NOT NULL,
    tut_seconds NUMERIC(6,2) NOT NULL,
    max_effort BOOLEAN DEFAULT TRUE,
    form_ok BOOLEAN DEFAULT TRUE,
    notes TEXT,
    data_source VARCHAR(20) DEFAULT 'Sheet',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (workout_date, template_id, exercise_id)
) PARTITION BY RANGE (workout_date);
```

#### `public.measurements`
Stores daily body composition metrics like weight and body fat percentage.

```sql
CREATE TABLE public.measurements (
    measurement_date DATE PRIMARY KEY,
    bodyweight_kg NUMERIC(5,2) NOT NULL,
    bodyfat_pct NUMERIC(4,2),
    notes TEXT,
    data_source VARCHAR(20) DEFAULT 'Sheet',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
```

### Partitioning

The `workouts` and `workout_sets` tables are partitioned by year from 2020 to 2030 to dramatically speed up queries that filter by date. A default partition catches any data outside this range.

```sql
DO $$
DECLARE
    year_val INTEGER;
BEGIN
    FOR year_val IN 2020..2030 LOOP
        EXECUTE format('
            CREATE TABLE IF NOT EXISTS workouts_%s PARTITION OF workouts
            FOR VALUES FROM (%L) TO (%L)', year_val, make_date(year_val, 1, 1), make_date(year_val + 1, 1, 1));
        
        EXECUTE format('
            CREATE TABLE IF NOT EXISTS workout_sets_%s PARTITION OF workout_sets
            FOR VALUES FROM (%L) TO (%L)', year_val, make_date(year_val, 1, 1), make_date(year_val + 1, 1, 1));
    END LOOP;
END $$;
```

---

## 3. Upsert Functions for Integration

These PostgreSQL functions provide an API for idempotently inserting or updating data. They are designed for integration with Google Sheets, n8n, or other automation tools. They include logic to auto-create missing exercises or templates.

- **`upsert_workout_from_sheet(...)`**: Inserts or updates a workout session.
- **`upsert_set_from_sheet(...)`**: Inserts or updates an exercise set for a given workout.
- **`upsert_measurement_from_sheet(...)`**: Inserts or updates a daily body measurement.

---

## 4. Analytical Views (Training Intelligence)

The database includes several views to provide high-level analysis and actionable training recommendations.

#### `v_hit_progression`
Tracks progressive overload by comparing each set to the previous one for the same exercise. It provides a `progress_status` and a `recommendation` based on HIT principles (e.g., "INCREASE WEIGHT: TUT > 90s with good form").

#### `v_recovery_analysis`
Analyzes recovery signals (`recovery_score`, `mood_score`, `days_since_last_workout`) to generate a `training_recommendation` (e.g., "SKIP SESSION: Poor readiness indicators" or "OPTIMAL: Go for maximum intensity").

#### `v_body_composition`
Tracks trends in body weight, body fat, and estimated lean mass over time, identifying whether the trend is `GAINING`, `LOSING`, or `STABLE`.

---

## 5. Indexes, Triggers, and Constraints

- **Indexes:** Strategic indexes are placed on foreign keys, dates, and frequently filtered columns to ensure query performance.
- **Foreign Keys:** Enforce relationships between tables (e.g., a `workout_set` must belong to a valid `workout`).
- **Triggers:** The `update_updated_at_column` function is attached via triggers to automatically update timestamps on `workouts`, `workout_sets`, and `measurements` tables.
- **Check Constraints:** Enforce valid data ranges for metrics like TUT, weight, and recovery scores.
