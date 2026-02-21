--
-- PostgreSQL database dump
--

\restrict r2BZauFlPm8GKQa8rq6m0ExLi1INZxFxUng1TVQ587xxzAgl6ftuXg23dprfwoz

-- Dumped from database version 16.12 (Debian 16.12-1.pgdg12+1)
-- Dumped by pg_dump version 16.12 (Debian 16.12-1.pgdg12+1)

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: update_updated_at_column(); Type: FUNCTION; Schema: public; Owner: root
--

CREATE FUNCTION public.update_updated_at_column() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    NEW.updated_at = CURRENT_TIMESTAMP;
    RETURN NEW;
END;

$$;


ALTER FUNCTION public.update_updated_at_column() OWNER TO root;

--
-- Name: upsert_measurement_from_sheet(date, numeric, numeric, text); Type: FUNCTION; Schema: public; Owner: root
--

CREATE FUNCTION public.upsert_measurement_from_sheet(_measurement_date date, _bodyweight_kg numeric, _bodyfat_pct numeric, _notes text) RETURNS json
    LANGUAGE plpgsql
    AS $$
BEGIN
    INSERT INTO measurements (measurement_date, bodyweight_kg, bodyfat_pct, notes)
    VALUES (_measurement_date, _bodyweight_kg, _bodyfat_pct, _notes)
    ON CONFLICT (measurement_date)
    DO UPDATE SET
        bodyweight_kg = EXCLUDED.bodyweight_kg,
        bodyfat_pct = EXCLUDED.bodyfat_pct,
        notes = EXCLUDED.notes,
        updated_at = CURRENT_TIMESTAMP;

    RETURN json_build_object(
        'success', true,
        'measurement_date', _measurement_date,
        'bodyweight_kg', _bodyweight_kg
    );

EXCEPTION WHEN OTHERS THEN
    RETURN json_build_object(
        'success', false,
        'error', SQLERRM,
        'measurement_date', _measurement_date
    );
END;

$$;


ALTER FUNCTION public.upsert_measurement_from_sheet(_measurement_date date, _bodyweight_kg numeric, _bodyfat_pct numeric, _notes text) OWNER TO root;

--
-- Name: upsert_set_from_sheet(date, character varying, character varying, numeric, numeric, boolean, boolean, text); Type: FUNCTION; Schema: public; Owner: root
--

CREATE FUNCTION public.upsert_set_from_sheet(_workout_date date, _template_id character varying, _exercise_id character varying, _weight_kg numeric, _tut_seconds numeric, _max_effort boolean, _form_ok boolean, _notes text) RETURNS json
    LANGUAGE plpgsql
    AS $$
DECLARE
    v_exercise_exists BOOLEAN;
    result JSON;
BEGIN
    -- Verify workout exists
    PERFORM 1 FROM workouts 
    WHERE workout_date = _workout_date AND template_id = _template_id;
    
    IF NOT FOUND THEN
        RETURN json_build_object(
            'success', false,
            'error', 'Workout session not found',
            'workout_date', _workout_date,
            'template_id', _template_id
        );
    END IF;

    -- Auto-create exercise if missing
    SELECT EXISTS(SELECT 1 FROM exercises WHERE exercise_id = _exercise_id) 
    INTO v_exercise_exists;
    
    IF NOT v_exercise_exists THEN
        INSERT INTO exercises (exercise_id, exercise_name, muscle_group, movement_type)
        VALUES (_exercise_id, 'Auto: ' || _exercise_id, 'Other', 'Compound');
    END IF;

    -- Upsert set (HIT philosophy: one working set per exercise)
    INSERT INTO workout_sets (
        workout_date, template_id, exercise_id, weight_kg, 
        tut_seconds, max_effort, form_ok, notes
    ) VALUES (
        _workout_date, _template_id, _exercise_id, _weight_kg,
        _tut_seconds, _max_effort, _form_ok, _notes
    )
    ON CONFLICT (workout_date, template_id, exercise_id)
    DO UPDATE SET
        weight_kg = EXCLUDED.weight_kg,
        tut_seconds = EXCLUDED.tut_seconds,
        max_effort = EXCLUDED.max_effort,
        form_ok = EXCLUDED.form_ok,
        notes = EXCLUDED.notes,
        updated_at = CURRENT_TIMESTAMP;

    result := json_build_object(
        'success', true,
        'workout_date', _workout_date,
        'template_id', _template_id,
        'exercise_id', _exercise_id,
        'exercise_created', NOT v_exercise_exists
    );
    
    RETURN result;

EXCEPTION WHEN OTHERS THEN
    RETURN json_build_object(
        'success', false,
        'error', SQLERRM,
        'workout_date', _workout_date,
        'exercise_id', _exercise_id
    );
END;

$$;


ALTER FUNCTION public.upsert_set_from_sheet(_workout_date date, _template_id character varying, _exercise_id character varying, _weight_kg numeric, _tut_seconds numeric, _max_effort boolean, _form_ok boolean, _notes text) OWNER TO root;

--
-- Name: upsert_workout_from_sheet(date, character varying, character varying, integer, integer, integer, integer, text); Type: FUNCTION; Schema: public; Owner: root
--

CREATE FUNCTION public.upsert_workout_from_sheet(_workout_date date, _template_id character varying, _location character varying, _duration_min integer, _days_since_last_workout integer, _recovery_score integer, _mood_score integer, _notes text) RETURNS json
    LANGUAGE plpgsql
    AS $$
DECLARE
    v_template_exists BOOLEAN;
    result JSON;
BEGIN
    -- Auto-create template if missing (similar to merchant auto-creation in finance DB)
    SELECT EXISTS(SELECT 1 FROM workout_templates WHERE template_id = _template_id) 
    INTO v_template_exists;
    
    IF NOT v_template_exists THEN
        INSERT INTO workout_templates (template_id, template_name, workout_type)
        VALUES (_template_id, 'Auto: ' || _template_id, 'Other');
    END IF;

    -- Upsert workout
    INSERT INTO workouts (
        workout_date, template_id, location, duration_min,
        days_since_last_workout, recovery_score, mood_score, notes
    ) VALUES (
        _workout_date, _template_id, _location, _duration_min,
        _days_since_last_workout, _recovery_score, _mood_score, _notes
    )
    ON CONFLICT (workout_date, template_id)
    DO UPDATE SET
        location = EXCLUDED.location,
        duration_min = EXCLUDED.duration_min,
        days_since_last_workout = EXCLUDED.days_since_last_workout,
        recovery_score = EXCLUDED.recovery_score,
        mood_score = EXCLUDED.mood_score,
        notes = EXCLUDED.notes,
        updated_at = CURRENT_TIMESTAMP;

    result := json_build_object(
        'success', true,
        'workout_date', _workout_date,
        'template_id', _template_id,
        'template_created', NOT v_template_exists
    );
    
    RETURN result;

EXCEPTION WHEN OTHERS THEN
    RETURN json_build_object(
        'success', false,
        'error', SQLERRM,
        'workout_date', _workout_date,
        'template_id', _template_id
    );
END;

$$;


ALTER FUNCTION public.upsert_workout_from_sheet(_workout_date date, _template_id character varying, _location character varying, _duration_min integer, _days_since_last_workout integer, _recovery_score integer, _mood_score integer, _notes text) OWNER TO root;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: exercises; Type: TABLE; Schema: public; Owner: root
--

CREATE TABLE public.exercises (
    exercise_id character varying(50) NOT NULL,
    exercise_name character varying(100) NOT NULL,
    muscle_group character varying(50) NOT NULL,
    movement_type character varying(20),
    equipment character varying(50),
    target_tut_min integer DEFAULT 45,
    target_tut_max integer DEFAULT 90,
    notes text,
    is_active boolean DEFAULT true,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT exercises_movement_type_check CHECK (((movement_type)::text = ANY ((ARRAY['Compound'::character varying, 'Isolation'::character varying])::text[]))),
    CONSTRAINT exercises_muscle_group_check CHECK (((muscle_group)::text = ANY ((ARRAY['Legs'::character varying, 'Back'::character varying, 'Chest'::character varying, 'Shoulders'::character varying, 'Arms'::character varying, 'Core'::character varying, 'Full Body'::character varying])::text[]))),
    CONSTRAINT exercises_tut_check CHECK (((target_tut_min > 0) AND (target_tut_max > target_tut_min)))
);


ALTER TABLE public.exercises OWNER TO root;

--
-- Name: measurements; Type: TABLE; Schema: public; Owner: root
--

CREATE TABLE public.measurements (
    measurement_date date NOT NULL,
    bodyweight_kg numeric(5,2) NOT NULL,
    bodyfat_pct numeric(4,2),
    notes text,
    data_source character varying(20) DEFAULT 'Sheet'::character varying,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT measurements_bodyfat_check CHECK (((bodyfat_pct >= (3)::numeric) AND (bodyfat_pct <= (50)::numeric))),
    CONSTRAINT measurements_data_source_check CHECK (((data_source)::text = ANY ((ARRAY['Sheet'::character varying, 'Manual'::character varying, 'Import'::character varying])::text[]))),
    CONSTRAINT measurements_weight_check CHECK (((bodyweight_kg >= (40)::numeric) AND (bodyweight_kg <= (200)::numeric)))
);


ALTER TABLE public.measurements OWNER TO root;

--
-- Name: v_body_composition; Type: VIEW; Schema: public; Owner: root
--

CREATE VIEW public.v_body_composition AS
 SELECT measurement_date,
    bodyweight_kg,
    bodyfat_pct,
    round((bodyweight_kg * ((1)::numeric - (COALESCE(bodyfat_pct, (20)::numeric) / (100)::numeric))), 1) AS estimated_lean_mass,
    (bodyweight_kg - lag(bodyweight_kg) OVER (ORDER BY measurement_date)) AS weight_change,
    (bodyfat_pct - lag(bodyfat_pct) OVER (ORDER BY measurement_date)) AS bodyfat_change,
        CASE
            WHEN ((bodyweight_kg - lag(bodyweight_kg) OVER (ORDER BY measurement_date)) > 0.5) THEN 'GAINING'::text
            WHEN ((bodyweight_kg - lag(bodyweight_kg) OVER (ORDER BY measurement_date)) < '-0.5'::numeric) THEN 'LOSING'::text
            ELSE 'STABLE'::text
        END AS weight_trend
   FROM public.measurements
  ORDER BY measurement_date DESC;


ALTER VIEW public.v_body_composition OWNER TO root;

--
-- Name: workout_sets; Type: TABLE; Schema: public; Owner: root
--

CREATE TABLE public.workout_sets (
    workout_date date NOT NULL,
    template_id character varying(50) NOT NULL,
    exercise_id character varying(50) NOT NULL,
    weight_kg numeric(6,2) NOT NULL,
    tut_seconds numeric(6,2) NOT NULL,
    max_effort boolean DEFAULT true,
    form_ok boolean DEFAULT true,
    notes text,
    data_source character varying(20) DEFAULT 'Sheet'::character varying,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT sets_data_source_check CHECK (((data_source)::text = ANY ((ARRAY['Sheet'::character varying, 'Manual'::character varying, 'Import'::character varying])::text[]))),
    CONSTRAINT sets_tut_check CHECK (((tut_seconds > (0)::numeric) AND (tut_seconds <= (300)::numeric))),
    CONSTRAINT sets_weight_check CHECK ((weight_kg >= (0)::numeric))
)
PARTITION BY RANGE (workout_date);


ALTER TABLE public.workout_sets OWNER TO root;

--
-- Name: v_hit_progression; Type: VIEW; Schema: public; Owner: root
--

CREATE VIEW public.v_hit_progression AS
 WITH exercise_progression AS (
         SELECT ws.exercise_id,
            e.exercise_name,
            ws.workout_date,
            ws.weight_kg,
            ws.tut_seconds,
            ws.max_effort,
            ws.form_ok,
            lag(ws.weight_kg) OVER (PARTITION BY ws.exercise_id ORDER BY ws.workout_date) AS prev_weight,
            lag(ws.tut_seconds) OVER (PARTITION BY ws.exercise_id ORDER BY ws.workout_date) AS prev_tut,
            (ws.workout_date - lag(ws.workout_date) OVER (PARTITION BY ws.exercise_id ORDER BY ws.workout_date)) AS days_between
           FROM (public.workout_sets ws
             JOIN public.exercises e ON (((ws.exercise_id)::text = (e.exercise_id)::text)))
        )
 SELECT exercise_id,
    exercise_name,
    workout_date,
    weight_kg,
    tut_seconds,
    prev_weight,
    prev_tut,
    days_between,
        CASE
            WHEN (weight_kg > prev_weight) THEN 'STRENGTH GAIN'::text
            WHEN ((weight_kg = prev_weight) AND (tut_seconds > prev_tut)) THEN 'ENDURANCE GAIN'::text
            WHEN ((weight_kg = prev_weight) AND (tut_seconds < prev_tut)) THEN 'REGRESSION'::text
            WHEN (weight_kg < prev_weight) THEN 'STRENGTH LOSS'::text
            ELSE 'BASELINE'::text
        END AS progress_status,
        CASE
            WHEN ((tut_seconds > (90)::numeric) AND form_ok AND max_effort) THEN (('INCREASE WEIGHT: TUT > 90s with good form - add '::text || round((weight_kg * 0.025), 1)) || 'kg'::text)
            WHEN (tut_seconds < (45)::numeric) THEN 'REDUCE WEIGHT: TUT < 45s indicates weight too heavy'::text
            WHEN (NOT form_ok) THEN 'MAINTAIN WEIGHT: Focus on form improvement'::text
            WHEN (NOT max_effort) THEN 'PUSH HARDER: Increase intensity before adding weight'::text
            WHEN ((tut_seconds >= (60)::numeric) AND (tut_seconds <= (90)::numeric)) THEN 'OPTIMAL RANGE: Continue current progression'::text
            ELSE 'MONITOR NEXT SESSION'::text
        END AS recommendation
   FROM exercise_progression
  WHERE (prev_weight IS NOT NULL)
  ORDER BY workout_date DESC, exercise_id;


ALTER VIEW public.v_hit_progression OWNER TO root;

--
-- Name: workouts; Type: TABLE; Schema: public; Owner: root
--

CREATE TABLE public.workouts (
    workout_date date NOT NULL,
    template_id character varying(50) NOT NULL,
    location character varying(50) DEFAULT 'home'::character varying,
    duration_min integer NOT NULL,
    days_since_last_workout integer,
    recovery_score integer,
    mood_score integer,
    notes text,
    data_source character varying(20) DEFAULT 'Sheet'::character varying,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT workouts_data_source_check CHECK (((data_source)::text = ANY ((ARRAY['Sheet'::character varying, 'Manual'::character varying, 'Import'::character varying])::text[]))),
    CONSTRAINT workouts_days_check CHECK ((days_since_last_workout >= 0)),
    CONSTRAINT workouts_duration_check CHECK (((duration_min > 0) AND (duration_min <= 300))),
    CONSTRAINT workouts_mood_score_check CHECK (((mood_score >= 1) AND (mood_score <= 5))),
    CONSTRAINT workouts_recovery_score_check CHECK (((recovery_score >= 1) AND (recovery_score <= 5)))
)
PARTITION BY RANGE (workout_date);


ALTER TABLE public.workouts OWNER TO root;

--
-- Name: v_recovery_analysis; Type: VIEW; Schema: public; Owner: root
--

CREATE VIEW public.v_recovery_analysis AS
 SELECT w.workout_date,
    w.template_id,
    w.days_since_last_workout,
    w.recovery_score,
    w.mood_score,
    round((((w.recovery_score + w.mood_score))::numeric / 2.0), 1) AS readiness_index,
        CASE
            WHEN (w.days_since_last_workout < 2) THEN 'TOO FREQUENT: CNS needs more recovery'::text
            WHEN ((w.recovery_score + w.mood_score) <= 4) THEN 'SKIP SESSION: Poor readiness indicators'::text
            WHEN ((w.days_since_last_workout < 3) AND ((w.recovery_score + w.mood_score) < 7)) THEN 'LIGHT SESSION: Reduced intensity'::text
            WHEN ((w.days_since_last_workout >= 3) AND ((w.recovery_score + w.mood_score) >= 7)) THEN 'OPTIMAL: Go for maximum intensity'::text
            ELSE 'PROCEED WITH CAUTION'::text
        END AS training_recommendation,
    w.duration_min,
    count(ws.exercise_id) AS exercises_performed,
    avg(ws.tut_seconds) AS avg_tut,
    sum(
        CASE
            WHEN ws.max_effort THEN 1
            ELSE 0
        END) AS max_effort_sets
   FROM (public.workouts w
     LEFT JOIN public.workout_sets ws ON (((w.workout_date = ws.workout_date) AND ((w.template_id)::text = (ws.template_id)::text))))
  GROUP BY w.workout_date, w.template_id, w.days_since_last_workout, w.recovery_score, w.mood_score, w.duration_min
  ORDER BY w.workout_date DESC;


ALTER VIEW public.v_recovery_analysis OWNER TO root;

--
-- Name: workout_sets_2020; Type: TABLE; Schema: public; Owner: root
--

CREATE TABLE public.workout_sets_2020 (
    workout_date date NOT NULL,
    template_id character varying(50) NOT NULL,
    exercise_id character varying(50) NOT NULL,
    weight_kg numeric(6,2) NOT NULL,
    tut_seconds numeric(6,2) NOT NULL,
    max_effort boolean DEFAULT true,
    form_ok boolean DEFAULT true,
    notes text,
    data_source character varying(20) DEFAULT 'Sheet'::character varying,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT sets_data_source_check CHECK (((data_source)::text = ANY ((ARRAY['Sheet'::character varying, 'Manual'::character varying, 'Import'::character varying])::text[]))),
    CONSTRAINT sets_tut_check CHECK (((tut_seconds > (0)::numeric) AND (tut_seconds <= (300)::numeric))),
    CONSTRAINT sets_weight_check CHECK ((weight_kg >= (0)::numeric))
);


ALTER TABLE public.workout_sets_2020 OWNER TO root;

--
-- Name: workout_sets_2021; Type: TABLE; Schema: public; Owner: root
--

CREATE TABLE public.workout_sets_2021 (
    workout_date date NOT NULL,
    template_id character varying(50) NOT NULL,
    exercise_id character varying(50) NOT NULL,
    weight_kg numeric(6,2) NOT NULL,
    tut_seconds numeric(6,2) NOT NULL,
    max_effort boolean DEFAULT true,
    form_ok boolean DEFAULT true,
    notes text,
    data_source character varying(20) DEFAULT 'Sheet'::character varying,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT sets_data_source_check CHECK (((data_source)::text = ANY ((ARRAY['Sheet'::character varying, 'Manual'::character varying, 'Import'::character varying])::text[]))),
    CONSTRAINT sets_tut_check CHECK (((tut_seconds > (0)::numeric) AND (tut_seconds <= (300)::numeric))),
    CONSTRAINT sets_weight_check CHECK ((weight_kg >= (0)::numeric))
);


ALTER TABLE public.workout_sets_2021 OWNER TO root;

--
-- Name: workout_sets_2022; Type: TABLE; Schema: public; Owner: root
--

CREATE TABLE public.workout_sets_2022 (
    workout_date date NOT NULL,
    template_id character varying(50) NOT NULL,
    exercise_id character varying(50) NOT NULL,
    weight_kg numeric(6,2) NOT NULL,
    tut_seconds numeric(6,2) NOT NULL,
    max_effort boolean DEFAULT true,
    form_ok boolean DEFAULT true,
    notes text,
    data_source character varying(20) DEFAULT 'Sheet'::character varying,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT sets_data_source_check CHECK (((data_source)::text = ANY ((ARRAY['Sheet'::character varying, 'Manual'::character varying, 'Import'::character varying])::text[]))),
    CONSTRAINT sets_tut_check CHECK (((tut_seconds > (0)::numeric) AND (tut_seconds <= (300)::numeric))),
    CONSTRAINT sets_weight_check CHECK ((weight_kg >= (0)::numeric))
);


ALTER TABLE public.workout_sets_2022 OWNER TO root;

--
-- Name: workout_sets_2023; Type: TABLE; Schema: public; Owner: root
--

CREATE TABLE public.workout_sets_2023 (
    workout_date date NOT NULL,
    template_id character varying(50) NOT NULL,
    exercise_id character varying(50) NOT NULL,
    weight_kg numeric(6,2) NOT NULL,
    tut_seconds numeric(6,2) NOT NULL,
    max_effort boolean DEFAULT true,
    form_ok boolean DEFAULT true,
    notes text,
    data_source character varying(20) DEFAULT 'Sheet'::character varying,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT sets_data_source_check CHECK (((data_source)::text = ANY ((ARRAY['Sheet'::character varying, 'Manual'::character varying, 'Import'::character varying])::text[]))),
    CONSTRAINT sets_tut_check CHECK (((tut_seconds > (0)::numeric) AND (tut_seconds <= (300)::numeric))),
    CONSTRAINT sets_weight_check CHECK ((weight_kg >= (0)::numeric))
);


ALTER TABLE public.workout_sets_2023 OWNER TO root;

--
-- Name: workout_sets_2024; Type: TABLE; Schema: public; Owner: root
--

CREATE TABLE public.workout_sets_2024 (
    workout_date date NOT NULL,
    template_id character varying(50) NOT NULL,
    exercise_id character varying(50) NOT NULL,
    weight_kg numeric(6,2) NOT NULL,
    tut_seconds numeric(6,2) NOT NULL,
    max_effort boolean DEFAULT true,
    form_ok boolean DEFAULT true,
    notes text,
    data_source character varying(20) DEFAULT 'Sheet'::character varying,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT sets_data_source_check CHECK (((data_source)::text = ANY ((ARRAY['Sheet'::character varying, 'Manual'::character varying, 'Import'::character varying])::text[]))),
    CONSTRAINT sets_tut_check CHECK (((tut_seconds > (0)::numeric) AND (tut_seconds <= (300)::numeric))),
    CONSTRAINT sets_weight_check CHECK ((weight_kg >= (0)::numeric))
);


ALTER TABLE public.workout_sets_2024 OWNER TO root;

--
-- Name: workout_sets_2025; Type: TABLE; Schema: public; Owner: root
--

CREATE TABLE public.workout_sets_2025 (
    workout_date date NOT NULL,
    template_id character varying(50) NOT NULL,
    exercise_id character varying(50) NOT NULL,
    weight_kg numeric(6,2) NOT NULL,
    tut_seconds numeric(6,2) NOT NULL,
    max_effort boolean DEFAULT true,
    form_ok boolean DEFAULT true,
    notes text,
    data_source character varying(20) DEFAULT 'Sheet'::character varying,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT sets_data_source_check CHECK (((data_source)::text = ANY ((ARRAY['Sheet'::character varying, 'Manual'::character varying, 'Import'::character varying])::text[]))),
    CONSTRAINT sets_tut_check CHECK (((tut_seconds > (0)::numeric) AND (tut_seconds <= (300)::numeric))),
    CONSTRAINT sets_weight_check CHECK ((weight_kg >= (0)::numeric))
);


ALTER TABLE public.workout_sets_2025 OWNER TO root;

--
-- Name: workout_sets_2026; Type: TABLE; Schema: public; Owner: root
--

CREATE TABLE public.workout_sets_2026 (
    workout_date date NOT NULL,
    template_id character varying(50) NOT NULL,
    exercise_id character varying(50) NOT NULL,
    weight_kg numeric(6,2) NOT NULL,
    tut_seconds numeric(6,2) NOT NULL,
    max_effort boolean DEFAULT true,
    form_ok boolean DEFAULT true,
    notes text,
    data_source character varying(20) DEFAULT 'Sheet'::character varying,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT sets_data_source_check CHECK (((data_source)::text = ANY ((ARRAY['Sheet'::character varying, 'Manual'::character varying, 'Import'::character varying])::text[]))),
    CONSTRAINT sets_tut_check CHECK (((tut_seconds > (0)::numeric) AND (tut_seconds <= (300)::numeric))),
    CONSTRAINT sets_weight_check CHECK ((weight_kg >= (0)::numeric))
);


ALTER TABLE public.workout_sets_2026 OWNER TO root;

--
-- Name: workout_sets_2027; Type: TABLE; Schema: public; Owner: root
--

CREATE TABLE public.workout_sets_2027 (
    workout_date date NOT NULL,
    template_id character varying(50) NOT NULL,
    exercise_id character varying(50) NOT NULL,
    weight_kg numeric(6,2) NOT NULL,
    tut_seconds numeric(6,2) NOT NULL,
    max_effort boolean DEFAULT true,
    form_ok boolean DEFAULT true,
    notes text,
    data_source character varying(20) DEFAULT 'Sheet'::character varying,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT sets_data_source_check CHECK (((data_source)::text = ANY ((ARRAY['Sheet'::character varying, 'Manual'::character varying, 'Import'::character varying])::text[]))),
    CONSTRAINT sets_tut_check CHECK (((tut_seconds > (0)::numeric) AND (tut_seconds <= (300)::numeric))),
    CONSTRAINT sets_weight_check CHECK ((weight_kg >= (0)::numeric))
);


ALTER TABLE public.workout_sets_2027 OWNER TO root;

--
-- Name: workout_sets_2028; Type: TABLE; Schema: public; Owner: root
--

CREATE TABLE public.workout_sets_2028 (
    workout_date date NOT NULL,
    template_id character varying(50) NOT NULL,
    exercise_id character varying(50) NOT NULL,
    weight_kg numeric(6,2) NOT NULL,
    tut_seconds numeric(6,2) NOT NULL,
    max_effort boolean DEFAULT true,
    form_ok boolean DEFAULT true,
    notes text,
    data_source character varying(20) DEFAULT 'Sheet'::character varying,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT sets_data_source_check CHECK (((data_source)::text = ANY ((ARRAY['Sheet'::character varying, 'Manual'::character varying, 'Import'::character varying])::text[]))),
    CONSTRAINT sets_tut_check CHECK (((tut_seconds > (0)::numeric) AND (tut_seconds <= (300)::numeric))),
    CONSTRAINT sets_weight_check CHECK ((weight_kg >= (0)::numeric))
);


ALTER TABLE public.workout_sets_2028 OWNER TO root;

--
-- Name: workout_sets_2029; Type: TABLE; Schema: public; Owner: root
--

CREATE TABLE public.workout_sets_2029 (
    workout_date date NOT NULL,
    template_id character varying(50) NOT NULL,
    exercise_id character varying(50) NOT NULL,
    weight_kg numeric(6,2) NOT NULL,
    tut_seconds numeric(6,2) NOT NULL,
    max_effort boolean DEFAULT true,
    form_ok boolean DEFAULT true,
    notes text,
    data_source character varying(20) DEFAULT 'Sheet'::character varying,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT sets_data_source_check CHECK (((data_source)::text = ANY ((ARRAY['Sheet'::character varying, 'Manual'::character varying, 'Import'::character varying])::text[]))),
    CONSTRAINT sets_tut_check CHECK (((tut_seconds > (0)::numeric) AND (tut_seconds <= (300)::numeric))),
    CONSTRAINT sets_weight_check CHECK ((weight_kg >= (0)::numeric))
);


ALTER TABLE public.workout_sets_2029 OWNER TO root;

--
-- Name: workout_sets_2030; Type: TABLE; Schema: public; Owner: root
--

CREATE TABLE public.workout_sets_2030 (
    workout_date date NOT NULL,
    template_id character varying(50) NOT NULL,
    exercise_id character varying(50) NOT NULL,
    weight_kg numeric(6,2) NOT NULL,
    tut_seconds numeric(6,2) NOT NULL,
    max_effort boolean DEFAULT true,
    form_ok boolean DEFAULT true,
    notes text,
    data_source character varying(20) DEFAULT 'Sheet'::character varying,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT sets_data_source_check CHECK (((data_source)::text = ANY ((ARRAY['Sheet'::character varying, 'Manual'::character varying, 'Import'::character varying])::text[]))),
    CONSTRAINT sets_tut_check CHECK (((tut_seconds > (0)::numeric) AND (tut_seconds <= (300)::numeric))),
    CONSTRAINT sets_weight_check CHECK ((weight_kg >= (0)::numeric))
);


ALTER TABLE public.workout_sets_2030 OWNER TO root;

--
-- Name: workout_sets_default; Type: TABLE; Schema: public; Owner: root
--

CREATE TABLE public.workout_sets_default (
    workout_date date NOT NULL,
    template_id character varying(50) NOT NULL,
    exercise_id character varying(50) NOT NULL,
    weight_kg numeric(6,2) NOT NULL,
    tut_seconds numeric(6,2) NOT NULL,
    max_effort boolean DEFAULT true,
    form_ok boolean DEFAULT true,
    notes text,
    data_source character varying(20) DEFAULT 'Sheet'::character varying,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT sets_data_source_check CHECK (((data_source)::text = ANY ((ARRAY['Sheet'::character varying, 'Manual'::character varying, 'Import'::character varying])::text[]))),
    CONSTRAINT sets_tut_check CHECK (((tut_seconds > (0)::numeric) AND (tut_seconds <= (300)::numeric))),
    CONSTRAINT sets_weight_check CHECK ((weight_kg >= (0)::numeric))
);


ALTER TABLE public.workout_sets_default OWNER TO root;

--
-- Name: workout_templates; Type: TABLE; Schema: public; Owner: root
--

CREATE TABLE public.workout_templates (
    template_id character varying(50) NOT NULL,
    template_name character varying(100) NOT NULL,
    workout_type character varying(30) NOT NULL,
    target_duration_min integer,
    notes text,
    is_active boolean DEFAULT true,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT templates_type_check CHECK (((workout_type)::text = ANY ((ARRAY['HIT Lower'::character varying, 'HIT Upper'::character varying, 'HIT Full Body'::character varying, 'Cardio'::character varying, 'Other'::character varying])::text[])))
);


ALTER TABLE public.workout_templates OWNER TO root;

--
-- Name: workouts_2020; Type: TABLE; Schema: public; Owner: root
--

CREATE TABLE public.workouts_2020 (
    workout_date date NOT NULL,
    template_id character varying(50) NOT NULL,
    location character varying(50) DEFAULT 'home'::character varying,
    duration_min integer NOT NULL,
    days_since_last_workout integer,
    recovery_score integer,
    mood_score integer,
    notes text,
    data_source character varying(20) DEFAULT 'Sheet'::character varying,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT workouts_data_source_check CHECK (((data_source)::text = ANY ((ARRAY['Sheet'::character varying, 'Manual'::character varying, 'Import'::character varying])::text[]))),
    CONSTRAINT workouts_days_check CHECK ((days_since_last_workout >= 0)),
    CONSTRAINT workouts_duration_check CHECK (((duration_min > 0) AND (duration_min <= 300))),
    CONSTRAINT workouts_mood_score_check CHECK (((mood_score >= 1) AND (mood_score <= 5))),
    CONSTRAINT workouts_recovery_score_check CHECK (((recovery_score >= 1) AND (recovery_score <= 5)))
);


ALTER TABLE public.workouts_2020 OWNER TO root;

--
-- Name: workouts_2021; Type: TABLE; Schema: public; Owner: root
--

CREATE TABLE public.workouts_2021 (
    workout_date date NOT NULL,
    template_id character varying(50) NOT NULL,
    location character varying(50) DEFAULT 'home'::character varying,
    duration_min integer NOT NULL,
    days_since_last_workout integer,
    recovery_score integer,
    mood_score integer,
    notes text,
    data_source character varying(20) DEFAULT 'Sheet'::character varying,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT workouts_data_source_check CHECK (((data_source)::text = ANY ((ARRAY['Sheet'::character varying, 'Manual'::character varying, 'Import'::character varying])::text[]))),
    CONSTRAINT workouts_days_check CHECK ((days_since_last_workout >= 0)),
    CONSTRAINT workouts_duration_check CHECK (((duration_min > 0) AND (duration_min <= 300))),
    CONSTRAINT workouts_mood_score_check CHECK (((mood_score >= 1) AND (mood_score <= 5))),
    CONSTRAINT workouts_recovery_score_check CHECK (((recovery_score >= 1) AND (recovery_score <= 5)))
);


ALTER TABLE public.workouts_2021 OWNER TO root;

--
-- Name: workouts_2022; Type: TABLE; Schema: public; Owner: root
--

CREATE TABLE public.workouts_2022 (
    workout_date date NOT NULL,
    template_id character varying(50) NOT NULL,
    location character varying(50) DEFAULT 'home'::character varying,
    duration_min integer NOT NULL,
    days_since_last_workout integer,
    recovery_score integer,
    mood_score integer,
    notes text,
    data_source character varying(20) DEFAULT 'Sheet'::character varying,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT workouts_data_source_check CHECK (((data_source)::text = ANY ((ARRAY['Sheet'::character varying, 'Manual'::character varying, 'Import'::character varying])::text[]))),
    CONSTRAINT workouts_days_check CHECK ((days_since_last_workout >= 0)),
    CONSTRAINT workouts_duration_check CHECK (((duration_min > 0) AND (duration_min <= 300))),
    CONSTRAINT workouts_mood_score_check CHECK (((mood_score >= 1) AND (mood_score <= 5))),
    CONSTRAINT workouts_recovery_score_check CHECK (((recovery_score >= 1) AND (recovery_score <= 5)))
);


ALTER TABLE public.workouts_2022 OWNER TO root;

--
-- Name: workouts_2023; Type: TABLE; Schema: public; Owner: root
--

CREATE TABLE public.workouts_2023 (
    workout_date date NOT NULL,
    template_id character varying(50) NOT NULL,
    location character varying(50) DEFAULT 'home'::character varying,
    duration_min integer NOT NULL,
    days_since_last_workout integer,
    recovery_score integer,
    mood_score integer,
    notes text,
    data_source character varying(20) DEFAULT 'Sheet'::character varying,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT workouts_data_source_check CHECK (((data_source)::text = ANY ((ARRAY['Sheet'::character varying, 'Manual'::character varying, 'Import'::character varying])::text[]))),
    CONSTRAINT workouts_days_check CHECK ((days_since_last_workout >= 0)),
    CONSTRAINT workouts_duration_check CHECK (((duration_min > 0) AND (duration_min <= 300))),
    CONSTRAINT workouts_mood_score_check CHECK (((mood_score >= 1) AND (mood_score <= 5))),
    CONSTRAINT workouts_recovery_score_check CHECK (((recovery_score >= 1) AND (recovery_score <= 5)))
);


ALTER TABLE public.workouts_2023 OWNER TO root;

--
-- Name: workouts_2024; Type: TABLE; Schema: public; Owner: root
--

CREATE TABLE public.workouts_2024 (
    workout_date date NOT NULL,
    template_id character varying(50) NOT NULL,
    location character varying(50) DEFAULT 'home'::character varying,
    duration_min integer NOT NULL,
    days_since_last_workout integer,
    recovery_score integer,
    mood_score integer,
    notes text,
    data_source character varying(20) DEFAULT 'Sheet'::character varying,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT workouts_data_source_check CHECK (((data_source)::text = ANY ((ARRAY['Sheet'::character varying, 'Manual'::character varying, 'Import'::character varying])::text[]))),
    CONSTRAINT workouts_days_check CHECK ((days_since_last_workout >= 0)),
    CONSTRAINT workouts_duration_check CHECK (((duration_min > 0) AND (duration_min <= 300))),
    CONSTRAINT workouts_mood_score_check CHECK (((mood_score >= 1) AND (mood_score <= 5))),
    CONSTRAINT workouts_recovery_score_check CHECK (((recovery_score >= 1) AND (recovery_score <= 5)))
);


ALTER TABLE public.workouts_2024 OWNER TO root;

--
-- Name: workouts_2025; Type: TABLE; Schema: public; Owner: root
--

CREATE TABLE public.workouts_2025 (
    workout_date date NOT NULL,
    template_id character varying(50) NOT NULL,
    location character varying(50) DEFAULT 'home'::character varying,
    duration_min integer NOT NULL,
    days_since_last_workout integer,
    recovery_score integer,
    mood_score integer,
    notes text,
    data_source character varying(20) DEFAULT 'Sheet'::character varying,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT workouts_data_source_check CHECK (((data_source)::text = ANY ((ARRAY['Sheet'::character varying, 'Manual'::character varying, 'Import'::character varying])::text[]))),
    CONSTRAINT workouts_days_check CHECK ((days_since_last_workout >= 0)),
    CONSTRAINT workouts_duration_check CHECK (((duration_min > 0) AND (duration_min <= 300))),
    CONSTRAINT workouts_mood_score_check CHECK (((mood_score >= 1) AND (mood_score <= 5))),
    CONSTRAINT workouts_recovery_score_check CHECK (((recovery_score >= 1) AND (recovery_score <= 5)))
);


ALTER TABLE public.workouts_2025 OWNER TO root;

--
-- Name: workouts_2026; Type: TABLE; Schema: public; Owner: root
--

CREATE TABLE public.workouts_2026 (
    workout_date date NOT NULL,
    template_id character varying(50) NOT NULL,
    location character varying(50) DEFAULT 'home'::character varying,
    duration_min integer NOT NULL,
    days_since_last_workout integer,
    recovery_score integer,
    mood_score integer,
    notes text,
    data_source character varying(20) DEFAULT 'Sheet'::character varying,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT workouts_data_source_check CHECK (((data_source)::text = ANY ((ARRAY['Sheet'::character varying, 'Manual'::character varying, 'Import'::character varying])::text[]))),
    CONSTRAINT workouts_days_check CHECK ((days_since_last_workout >= 0)),
    CONSTRAINT workouts_duration_check CHECK (((duration_min > 0) AND (duration_min <= 300))),
    CONSTRAINT workouts_mood_score_check CHECK (((mood_score >= 1) AND (mood_score <= 5))),
    CONSTRAINT workouts_recovery_score_check CHECK (((recovery_score >= 1) AND (recovery_score <= 5)))
);


ALTER TABLE public.workouts_2026 OWNER TO root;

--
-- Name: workouts_2027; Type: TABLE; Schema: public; Owner: root
--

CREATE TABLE public.workouts_2027 (
    workout_date date NOT NULL,
    template_id character varying(50) NOT NULL,
    location character varying(50) DEFAULT 'home'::character varying,
    duration_min integer NOT NULL,
    days_since_last_workout integer,
    recovery_score integer,
    mood_score integer,
    notes text,
    data_source character varying(20) DEFAULT 'Sheet'::character varying,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT workouts_data_source_check CHECK (((data_source)::text = ANY ((ARRAY['Sheet'::character varying, 'Manual'::character varying, 'Import'::character varying])::text[]))),
    CONSTRAINT workouts_days_check CHECK ((days_since_last_workout >= 0)),
    CONSTRAINT workouts_duration_check CHECK (((duration_min > 0) AND (duration_min <= 300))),
    CONSTRAINT workouts_mood_score_check CHECK (((mood_score >= 1) AND (mood_score <= 5))),
    CONSTRAINT workouts_recovery_score_check CHECK (((recovery_score >= 1) AND (recovery_score <= 5)))
);


ALTER TABLE public.workouts_2027 OWNER TO root;

--
-- Name: workouts_2028; Type: TABLE; Schema: public; Owner: root
--

CREATE TABLE public.workouts_2028 (
    workout_date date NOT NULL,
    template_id character varying(50) NOT NULL,
    location character varying(50) DEFAULT 'home'::character varying,
    duration_min integer NOT NULL,
    days_since_last_workout integer,
    recovery_score integer,
    mood_score integer,
    notes text,
    data_source character varying(20) DEFAULT 'Sheet'::character varying,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT workouts_data_source_check CHECK (((data_source)::text = ANY ((ARRAY['Sheet'::character varying, 'Manual'::character varying, 'Import'::character varying])::text[]))),
    CONSTRAINT workouts_days_check CHECK ((days_since_last_workout >= 0)),
    CONSTRAINT workouts_duration_check CHECK (((duration_min > 0) AND (duration_min <= 300))),
    CONSTRAINT workouts_mood_score_check CHECK (((mood_score >= 1) AND (mood_score <= 5))),
    CONSTRAINT workouts_recovery_score_check CHECK (((recovery_score >= 1) AND (recovery_score <= 5)))
);


ALTER TABLE public.workouts_2028 OWNER TO root;

--
-- Name: workouts_2029; Type: TABLE; Schema: public; Owner: root
--

CREATE TABLE public.workouts_2029 (
    workout_date date NOT NULL,
    template_id character varying(50) NOT NULL,
    location character varying(50) DEFAULT 'home'::character varying,
    duration_min integer NOT NULL,
    days_since_last_workout integer,
    recovery_score integer,
    mood_score integer,
    notes text,
    data_source character varying(20) DEFAULT 'Sheet'::character varying,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT workouts_data_source_check CHECK (((data_source)::text = ANY ((ARRAY['Sheet'::character varying, 'Manual'::character varying, 'Import'::character varying])::text[]))),
    CONSTRAINT workouts_days_check CHECK ((days_since_last_workout >= 0)),
    CONSTRAINT workouts_duration_check CHECK (((duration_min > 0) AND (duration_min <= 300))),
    CONSTRAINT workouts_mood_score_check CHECK (((mood_score >= 1) AND (mood_score <= 5))),
    CONSTRAINT workouts_recovery_score_check CHECK (((recovery_score >= 1) AND (recovery_score <= 5)))
);


ALTER TABLE public.workouts_2029 OWNER TO root;

--
-- Name: workouts_2030; Type: TABLE; Schema: public; Owner: root
--

CREATE TABLE public.workouts_2030 (
    workout_date date NOT NULL,
    template_id character varying(50) NOT NULL,
    location character varying(50) DEFAULT 'home'::character varying,
    duration_min integer NOT NULL,
    days_since_last_workout integer,
    recovery_score integer,
    mood_score integer,
    notes text,
    data_source character varying(20) DEFAULT 'Sheet'::character varying,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT workouts_data_source_check CHECK (((data_source)::text = ANY ((ARRAY['Sheet'::character varying, 'Manual'::character varying, 'Import'::character varying])::text[]))),
    CONSTRAINT workouts_days_check CHECK ((days_since_last_workout >= 0)),
    CONSTRAINT workouts_duration_check CHECK (((duration_min > 0) AND (duration_min <= 300))),
    CONSTRAINT workouts_mood_score_check CHECK (((mood_score >= 1) AND (mood_score <= 5))),
    CONSTRAINT workouts_recovery_score_check CHECK (((recovery_score >= 1) AND (recovery_score <= 5)))
);


ALTER TABLE public.workouts_2030 OWNER TO root;

--
-- Name: workouts_default; Type: TABLE; Schema: public; Owner: root
--

CREATE TABLE public.workouts_default (
    workout_date date NOT NULL,
    template_id character varying(50) NOT NULL,
    location character varying(50) DEFAULT 'home'::character varying,
    duration_min integer NOT NULL,
    days_since_last_workout integer,
    recovery_score integer,
    mood_score integer,
    notes text,
    data_source character varying(20) DEFAULT 'Sheet'::character varying,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT workouts_data_source_check CHECK (((data_source)::text = ANY ((ARRAY['Sheet'::character varying, 'Manual'::character varying, 'Import'::character varying])::text[]))),
    CONSTRAINT workouts_days_check CHECK ((days_since_last_workout >= 0)),
    CONSTRAINT workouts_duration_check CHECK (((duration_min > 0) AND (duration_min <= 300))),
    CONSTRAINT workouts_mood_score_check CHECK (((mood_score >= 1) AND (mood_score <= 5))),
    CONSTRAINT workouts_recovery_score_check CHECK (((recovery_score >= 1) AND (recovery_score <= 5)))
);


ALTER TABLE public.workouts_default OWNER TO root;

--
-- Name: workout_sets_2020; Type: TABLE ATTACH; Schema: public; Owner: root
--

ALTER TABLE ONLY public.workout_sets ATTACH PARTITION public.workout_sets_2020 FOR VALUES FROM ('2020-01-01') TO ('2021-01-01');


--
-- Name: workout_sets_2021; Type: TABLE ATTACH; Schema: public; Owner: root
--

ALTER TABLE ONLY public.workout_sets ATTACH PARTITION public.workout_sets_2021 FOR VALUES FROM ('2021-01-01') TO ('2022-01-01');


--
-- Name: workout_sets_2022; Type: TABLE ATTACH; Schema: public; Owner: root
--

ALTER TABLE ONLY public.workout_sets ATTACH PARTITION public.workout_sets_2022 FOR VALUES FROM ('2022-01-01') TO ('2023-01-01');


--
-- Name: workout_sets_2023; Type: TABLE ATTACH; Schema: public; Owner: root
--

ALTER TABLE ONLY public.workout_sets ATTACH PARTITION public.workout_sets_2023 FOR VALUES FROM ('2023-01-01') TO ('2024-01-01');


--
-- Name: workout_sets_2024; Type: TABLE ATTACH; Schema: public; Owner: root
--

ALTER TABLE ONLY public.workout_sets ATTACH PARTITION public.workout_sets_2024 FOR VALUES FROM ('2024-01-01') TO ('2025-01-01');


--
-- Name: workout_sets_2025; Type: TABLE ATTACH; Schema: public; Owner: root
--

ALTER TABLE ONLY public.workout_sets ATTACH PARTITION public.workout_sets_2025 FOR VALUES FROM ('2025-01-01') TO ('2026-01-01');


--
-- Name: workout_sets_2026; Type: TABLE ATTACH; Schema: public; Owner: root
--

ALTER TABLE ONLY public.workout_sets ATTACH PARTITION public.workout_sets_2026 FOR VALUES FROM ('2026-01-01') TO ('2027-01-01');


--
-- Name: workout_sets_2027; Type: TABLE ATTACH; Schema: public; Owner: root
--

ALTER TABLE ONLY public.workout_sets ATTACH PARTITION public.workout_sets_2027 FOR VALUES FROM ('2027-01-01') TO ('2028-01-01');


--
-- Name: workout_sets_2028; Type: TABLE ATTACH; Schema: public; Owner: root
--

ALTER TABLE ONLY public.workout_sets ATTACH PARTITION public.workout_sets_2028 FOR VALUES FROM ('2028-01-01') TO ('2029-01-01');


--
-- Name: workout_sets_2029; Type: TABLE ATTACH; Schema: public; Owner: root
--

ALTER TABLE ONLY public.workout_sets ATTACH PARTITION public.workout_sets_2029 FOR VALUES FROM ('2029-01-01') TO ('2030-01-01');


--
-- Name: workout_sets_2030; Type: TABLE ATTACH; Schema: public; Owner: root
--

ALTER TABLE ONLY public.workout_sets ATTACH PARTITION public.workout_sets_2030 FOR VALUES FROM ('2030-01-01') TO ('2031-01-01');


--
-- Name: workout_sets_default; Type: TABLE ATTACH; Schema: public; Owner: root
--

ALTER TABLE ONLY public.workout_sets ATTACH PARTITION public.workout_sets_default DEFAULT;


--
-- Name: workouts_2020; Type: TABLE ATTACH; Schema: public; Owner: root
--

ALTER TABLE ONLY public.workouts ATTACH PARTITION public.workouts_2020 FOR VALUES FROM ('2020-01-01') TO ('2021-01-01');


--
-- Name: workouts_2021; Type: TABLE ATTACH; Schema: public; Owner: root
--

ALTER TABLE ONLY public.workouts ATTACH PARTITION public.workouts_2021 FOR VALUES FROM ('2021-01-01') TO ('2022-01-01');


--
-- Name: workouts_2022; Type: TABLE ATTACH; Schema: public; Owner: root
--

ALTER TABLE ONLY public.workouts ATTACH PARTITION public.workouts_2022 FOR VALUES FROM ('2022-01-01') TO ('2023-01-01');


--
-- Name: workouts_2023; Type: TABLE ATTACH; Schema: public; Owner: root
--

ALTER TABLE ONLY public.workouts ATTACH PARTITION public.workouts_2023 FOR VALUES FROM ('2023-01-01') TO ('2024-01-01');


--
-- Name: workouts_2024; Type: TABLE ATTACH; Schema: public; Owner: root
--

ALTER TABLE ONLY public.workouts ATTACH PARTITION public.workouts_2024 FOR VALUES FROM ('2024-01-01') TO ('2025-01-01');


--
-- Name: workouts_2025; Type: TABLE ATTACH; Schema: public; Owner: root
--

ALTER TABLE ONLY public.workouts ATTACH PARTITION public.workouts_2025 FOR VALUES FROM ('2025-01-01') TO ('2026-01-01');


--
-- Name: workouts_2026; Type: TABLE ATTACH; Schema: public; Owner: root
--

ALTER TABLE ONLY public.workouts ATTACH PARTITION public.workouts_2026 FOR VALUES FROM ('2026-01-01') TO ('2027-01-01');


--
-- Name: workouts_2027; Type: TABLE ATTACH; Schema: public; Owner: root
--

ALTER TABLE ONLY public.workouts ATTACH PARTITION public.workouts_2027 FOR VALUES FROM ('2027-01-01') TO ('2028-01-01');


--
-- Name: workouts_2028; Type: TABLE ATTACH; Schema: public; Owner: root
--

ALTER TABLE ONLY public.workouts ATTACH PARTITION public.workouts_2028 FOR VALUES FROM ('2028-01-01') TO ('2029-01-01');


--
-- Name: workouts_2029; Type: TABLE ATTACH; Schema: public; Owner: root
--

ALTER TABLE ONLY public.workouts ATTACH PARTITION public.workouts_2029 FOR VALUES FROM ('2029-01-01') TO ('2030-01-01');


--
-- Name: workouts_2030; Type: TABLE ATTACH; Schema: public; Owner: root
--

ALTER TABLE ONLY public.workouts ATTACH PARTITION public.workouts_2030 FOR VALUES FROM ('2030-01-01') TO ('2031-01-01');


--
-- Name: workouts_default; Type: TABLE ATTACH; Schema: public; Owner: root
--

ALTER TABLE ONLY public.workouts ATTACH PARTITION public.workouts_default DEFAULT;


--
-- Name: exercises exercises_exercise_name_key; Type: CONSTRAINT; Schema: public; Owner: root
--

ALTER TABLE ONLY public.exercises
    ADD CONSTRAINT exercises_exercise_name_key UNIQUE (exercise_name);


--
-- Name: exercises exercises_pkey; Type: CONSTRAINT; Schema: public; Owner: root
--

ALTER TABLE ONLY public.exercises
    ADD CONSTRAINT exercises_pkey PRIMARY KEY (exercise_id);


--
-- Name: measurements measurements_pkey; Type: CONSTRAINT; Schema: public; Owner: root
--

ALTER TABLE ONLY public.measurements
    ADD CONSTRAINT measurements_pkey PRIMARY KEY (measurement_date);


--
-- Name: workout_sets sets_pkey; Type: CONSTRAINT; Schema: public; Owner: root
--

ALTER TABLE ONLY public.workout_sets
    ADD CONSTRAINT sets_pkey PRIMARY KEY (workout_date, template_id, exercise_id);


--
-- Name: workout_sets_2020 workout_sets_2020_pkey; Type: CONSTRAINT; Schema: public; Owner: root
--

ALTER TABLE ONLY public.workout_sets_2020
    ADD CONSTRAINT workout_sets_2020_pkey PRIMARY KEY (workout_date, template_id, exercise_id);


--
-- Name: workout_sets_2021 workout_sets_2021_pkey; Type: CONSTRAINT; Schema: public; Owner: root
--

ALTER TABLE ONLY public.workout_sets_2021
    ADD CONSTRAINT workout_sets_2021_pkey PRIMARY KEY (workout_date, template_id, exercise_id);


--
-- Name: workout_sets_2022 workout_sets_2022_pkey; Type: CONSTRAINT; Schema: public; Owner: root
--

ALTER TABLE ONLY public.workout_sets_2022
    ADD CONSTRAINT workout_sets_2022_pkey PRIMARY KEY (workout_date, template_id, exercise_id);


--
-- Name: workout_sets_2023 workout_sets_2023_pkey; Type: CONSTRAINT; Schema: public; Owner: root
--

ALTER TABLE ONLY public.workout_sets_2023
    ADD CONSTRAINT workout_sets_2023_pkey PRIMARY KEY (workout_date, template_id, exercise_id);


--
-- Name: workout_sets_2024 workout_sets_2024_pkey; Type: CONSTRAINT; Schema: public; Owner: root
--

ALTER TABLE ONLY public.workout_sets_2024
    ADD CONSTRAINT workout_sets_2024_pkey PRIMARY KEY (workout_date, template_id, exercise_id);


--
-- Name: workout_sets_2025 workout_sets_2025_pkey; Type: CONSTRAINT; Schema: public; Owner: root
--

ALTER TABLE ONLY public.workout_sets_2025
    ADD CONSTRAINT workout_sets_2025_pkey PRIMARY KEY (workout_date, template_id, exercise_id);


--
-- Name: workout_sets_2026 workout_sets_2026_pkey; Type: CONSTRAINT; Schema: public; Owner: root
--

ALTER TABLE ONLY public.workout_sets_2026
    ADD CONSTRAINT workout_sets_2026_pkey PRIMARY KEY (workout_date, template_id, exercise_id);


--
-- Name: workout_sets_2027 workout_sets_2027_pkey; Type: CONSTRAINT; Schema: public; Owner: root
--

ALTER TABLE ONLY public.workout_sets_2027
    ADD CONSTRAINT workout_sets_2027_pkey PRIMARY KEY (workout_date, template_id, exercise_id);


--
-- Name: workout_sets_2028 workout_sets_2028_pkey; Type: CONSTRAINT; Schema: public; Owner: root
--

ALTER TABLE ONLY public.workout_sets_2028
    ADD CONSTRAINT workout_sets_2028_pkey PRIMARY KEY (workout_date, template_id, exercise_id);


--
-- Name: workout_sets_2029 workout_sets_2029_pkey; Type: CONSTRAINT; Schema: public; Owner: root
--

ALTER TABLE ONLY public.workout_sets_2029
    ADD CONSTRAINT workout_sets_2029_pkey PRIMARY KEY (workout_date, template_id, exercise_id);


--
-- Name: workout_sets_2030 workout_sets_2030_pkey; Type: CONSTRAINT; Schema: public; Owner: root
--

ALTER TABLE ONLY public.workout_sets_2030
    ADD CONSTRAINT workout_sets_2030_pkey PRIMARY KEY (workout_date, template_id, exercise_id);


--
-- Name: workout_sets_default workout_sets_default_pkey; Type: CONSTRAINT; Schema: public; Owner: root
--

ALTER TABLE ONLY public.workout_sets_default
    ADD CONSTRAINT workout_sets_default_pkey PRIMARY KEY (workout_date, template_id, exercise_id);


--
-- Name: workout_templates workout_templates_pkey; Type: CONSTRAINT; Schema: public; Owner: root
--

ALTER TABLE ONLY public.workout_templates
    ADD CONSTRAINT workout_templates_pkey PRIMARY KEY (template_id);


--
-- Name: workouts workouts_pkey; Type: CONSTRAINT; Schema: public; Owner: root
--

ALTER TABLE ONLY public.workouts
    ADD CONSTRAINT workouts_pkey PRIMARY KEY (workout_date, template_id);


--
-- Name: workouts_2020 workouts_2020_pkey; Type: CONSTRAINT; Schema: public; Owner: root
--

ALTER TABLE ONLY public.workouts_2020
    ADD CONSTRAINT workouts_2020_pkey PRIMARY KEY (workout_date, template_id);


--
-- Name: workouts_2021 workouts_2021_pkey; Type: CONSTRAINT; Schema: public; Owner: root
--

ALTER TABLE ONLY public.workouts_2021
    ADD CONSTRAINT workouts_2021_pkey PRIMARY KEY (workout_date, template_id);


--
-- Name: workouts_2022 workouts_2022_pkey; Type: CONSTRAINT; Schema: public; Owner: root
--

ALTER TABLE ONLY public.workouts_2022
    ADD CONSTRAINT workouts_2022_pkey PRIMARY KEY (workout_date, template_id);


--
-- Name: workouts_2023 workouts_2023_pkey; Type: CONSTRAINT; Schema: public; Owner: root
--

ALTER TABLE ONLY public.workouts_2023
    ADD CONSTRAINT workouts_2023_pkey PRIMARY KEY (workout_date, template_id);


--
-- Name: workouts_2024 workouts_2024_pkey; Type: CONSTRAINT; Schema: public; Owner: root
--

ALTER TABLE ONLY public.workouts_2024
    ADD CONSTRAINT workouts_2024_pkey PRIMARY KEY (workout_date, template_id);


--
-- Name: workouts_2025 workouts_2025_pkey; Type: CONSTRAINT; Schema: public; Owner: root
--

ALTER TABLE ONLY public.workouts_2025
    ADD CONSTRAINT workouts_2025_pkey PRIMARY KEY (workout_date, template_id);


--
-- Name: workouts_2026 workouts_2026_pkey; Type: CONSTRAINT; Schema: public; Owner: root
--

ALTER TABLE ONLY public.workouts_2026
    ADD CONSTRAINT workouts_2026_pkey PRIMARY KEY (workout_date, template_id);


--
-- Name: workouts_2027 workouts_2027_pkey; Type: CONSTRAINT; Schema: public; Owner: root
--

ALTER TABLE ONLY public.workouts_2027
    ADD CONSTRAINT workouts_2027_pkey PRIMARY KEY (workout_date, template_id);


--
-- Name: workouts_2028 workouts_2028_pkey; Type: CONSTRAINT; Schema: public; Owner: root
--

ALTER TABLE ONLY public.workouts_2028
    ADD CONSTRAINT workouts_2028_pkey PRIMARY KEY (workout_date, template_id);


--
-- Name: workouts_2029 workouts_2029_pkey; Type: CONSTRAINT; Schema: public; Owner: root
--

ALTER TABLE ONLY public.workouts_2029
    ADD CONSTRAINT workouts_2029_pkey PRIMARY KEY (workout_date, template_id);


--
-- Name: workouts_2030 workouts_2030_pkey; Type: CONSTRAINT; Schema: public; Owner: root
--

ALTER TABLE ONLY public.workouts_2030
    ADD CONSTRAINT workouts_2030_pkey PRIMARY KEY (workout_date, template_id);


--
-- Name: workouts_default workouts_default_pkey; Type: CONSTRAINT; Schema: public; Owner: root
--

ALTER TABLE ONLY public.workouts_default
    ADD CONSTRAINT workouts_default_pkey PRIMARY KEY (workout_date, template_id);


--
-- Name: idx_measurements_date; Type: INDEX; Schema: public; Owner: root
--

CREATE INDEX idx_measurements_date ON public.measurements USING btree (measurement_date);


--
-- Name: idx_sets_date; Type: INDEX; Schema: public; Owner: root
--

CREATE INDEX idx_sets_date ON ONLY public.workout_sets USING btree (workout_date);


--
-- Name: idx_sets_effort; Type: INDEX; Schema: public; Owner: root
--

CREATE INDEX idx_sets_effort ON ONLY public.workout_sets USING btree (max_effort, form_ok);


--
-- Name: idx_sets_exercise; Type: INDEX; Schema: public; Owner: root
--

CREATE INDEX idx_sets_exercise ON ONLY public.workout_sets USING btree (exercise_id);


--
-- Name: idx_workouts_date; Type: INDEX; Schema: public; Owner: root
--

CREATE INDEX idx_workouts_date ON ONLY public.workouts USING btree (workout_date);


--
-- Name: idx_workouts_recovery; Type: INDEX; Schema: public; Owner: root
--

CREATE INDEX idx_workouts_recovery ON ONLY public.workouts USING btree (recovery_score, mood_score);


--
-- Name: idx_workouts_template; Type: INDEX; Schema: public; Owner: root
--

CREATE INDEX idx_workouts_template ON ONLY public.workouts USING btree (template_id);


--
-- Name: workout_sets_2020_exercise_id_idx; Type: INDEX; Schema: public; Owner: root
--

CREATE INDEX workout_sets_2020_exercise_id_idx ON public.workout_sets_2020 USING btree (exercise_id);


--
-- Name: workout_sets_2020_max_effort_form_ok_idx; Type: INDEX; Schema: public; Owner: root
--

CREATE INDEX workout_sets_2020_max_effort_form_ok_idx ON public.workout_sets_2020 USING btree (max_effort, form_ok);


--
-- Name: workout_sets_2020_workout_date_idx; Type: INDEX; Schema: public; Owner: root
--

CREATE INDEX workout_sets_2020_workout_date_idx ON public.workout_sets_2020 USING btree (workout_date);


--
-- Name: workout_sets_2021_exercise_id_idx; Type: INDEX; Schema: public; Owner: root
--

CREATE INDEX workout_sets_2021_exercise_id_idx ON public.workout_sets_2021 USING btree (exercise_id);


--
-- Name: workout_sets_2021_max_effort_form_ok_idx; Type: INDEX; Schema: public; Owner: root
--

CREATE INDEX workout_sets_2021_max_effort_form_ok_idx ON public.workout_sets_2021 USING btree (max_effort, form_ok);


--
-- Name: workout_sets_2021_workout_date_idx; Type: INDEX; Schema: public; Owner: root
--

CREATE INDEX workout_sets_2021_workout_date_idx ON public.workout_sets_2021 USING btree (workout_date);


--
-- Name: workout_sets_2022_exercise_id_idx; Type: INDEX; Schema: public; Owner: root
--

CREATE INDEX workout_sets_2022_exercise_id_idx ON public.workout_sets_2022 USING btree (exercise_id);


--
-- Name: workout_sets_2022_max_effort_form_ok_idx; Type: INDEX; Schema: public; Owner: root
--

CREATE INDEX workout_sets_2022_max_effort_form_ok_idx ON public.workout_sets_2022 USING btree (max_effort, form_ok);


--
-- Name: workout_sets_2022_workout_date_idx; Type: INDEX; Schema: public; Owner: root
--

CREATE INDEX workout_sets_2022_workout_date_idx ON public.workout_sets_2022 USING btree (workout_date);


--
-- Name: workout_sets_2023_exercise_id_idx; Type: INDEX; Schema: public; Owner: root
--

CREATE INDEX workout_sets_2023_exercise_id_idx ON public.workout_sets_2023 USING btree (exercise_id);


--
-- Name: workout_sets_2023_max_effort_form_ok_idx; Type: INDEX; Schema: public; Owner: root
--

CREATE INDEX workout_sets_2023_max_effort_form_ok_idx ON public.workout_sets_2023 USING btree (max_effort, form_ok);


--
-- Name: workout_sets_2023_workout_date_idx; Type: INDEX; Schema: public; Owner: root
--

CREATE INDEX workout_sets_2023_workout_date_idx ON public.workout_sets_2023 USING btree (workout_date);


--
-- Name: workout_sets_2024_exercise_id_idx; Type: INDEX; Schema: public; Owner: root
--

CREATE INDEX workout_sets_2024_exercise_id_idx ON public.workout_sets_2024 USING btree (exercise_id);


--
-- Name: workout_sets_2024_max_effort_form_ok_idx; Type: INDEX; Schema: public; Owner: root
--

CREATE INDEX workout_sets_2024_max_effort_form_ok_idx ON public.workout_sets_2024 USING btree (max_effort, form_ok);


--
-- Name: workout_sets_2024_workout_date_idx; Type: INDEX; Schema: public; Owner: root
--

CREATE INDEX workout_sets_2024_workout_date_idx ON public.workout_sets_2024 USING btree (workout_date);


--
-- Name: workout_sets_2025_exercise_id_idx; Type: INDEX; Schema: public; Owner: root
--

CREATE INDEX workout_sets_2025_exercise_id_idx ON public.workout_sets_2025 USING btree (exercise_id);


--
-- Name: workout_sets_2025_max_effort_form_ok_idx; Type: INDEX; Schema: public; Owner: root
--

CREATE INDEX workout_sets_2025_max_effort_form_ok_idx ON public.workout_sets_2025 USING btree (max_effort, form_ok);


--
-- Name: workout_sets_2025_workout_date_idx; Type: INDEX; Schema: public; Owner: root
--

CREATE INDEX workout_sets_2025_workout_date_idx ON public.workout_sets_2025 USING btree (workout_date);


--
-- Name: workout_sets_2026_exercise_id_idx; Type: INDEX; Schema: public; Owner: root
--

CREATE INDEX workout_sets_2026_exercise_id_idx ON public.workout_sets_2026 USING btree (exercise_id);


--
-- Name: workout_sets_2026_max_effort_form_ok_idx; Type: INDEX; Schema: public; Owner: root
--

CREATE INDEX workout_sets_2026_max_effort_form_ok_idx ON public.workout_sets_2026 USING btree (max_effort, form_ok);


--
-- Name: workout_sets_2026_workout_date_idx; Type: INDEX; Schema: public; Owner: root
--

CREATE INDEX workout_sets_2026_workout_date_idx ON public.workout_sets_2026 USING btree (workout_date);


--
-- Name: workout_sets_2027_exercise_id_idx; Type: INDEX; Schema: public; Owner: root
--

CREATE INDEX workout_sets_2027_exercise_id_idx ON public.workout_sets_2027 USING btree (exercise_id);


--
-- Name: workout_sets_2027_max_effort_form_ok_idx; Type: INDEX; Schema: public; Owner: root
--

CREATE INDEX workout_sets_2027_max_effort_form_ok_idx ON public.workout_sets_2027 USING btree (max_effort, form_ok);


--
-- Name: workout_sets_2027_workout_date_idx; Type: INDEX; Schema: public; Owner: root
--

CREATE INDEX workout_sets_2027_workout_date_idx ON public.workout_sets_2027 USING btree (workout_date);


--
-- Name: workout_sets_2028_exercise_id_idx; Type: INDEX; Schema: public; Owner: root
--

CREATE INDEX workout_sets_2028_exercise_id_idx ON public.workout_sets_2028 USING btree (exercise_id);


--
-- Name: workout_sets_2028_max_effort_form_ok_idx; Type: INDEX; Schema: public; Owner: root
--

CREATE INDEX workout_sets_2028_max_effort_form_ok_idx ON public.workout_sets_2028 USING btree (max_effort, form_ok);


--
-- Name: workout_sets_2028_workout_date_idx; Type: INDEX; Schema: public; Owner: root
--

CREATE INDEX workout_sets_2028_workout_date_idx ON public.workout_sets_2028 USING btree (workout_date);


--
-- Name: workout_sets_2029_exercise_id_idx; Type: INDEX; Schema: public; Owner: root
--

CREATE INDEX workout_sets_2029_exercise_id_idx ON public.workout_sets_2029 USING btree (exercise_id);


--
-- Name: workout_sets_2029_max_effort_form_ok_idx; Type: INDEX; Schema: public; Owner: root
--

CREATE INDEX workout_sets_2029_max_effort_form_ok_idx ON public.workout_sets_2029 USING btree (max_effort, form_ok);


--
-- Name: workout_sets_2029_workout_date_idx; Type: INDEX; Schema: public; Owner: root
--

CREATE INDEX workout_sets_2029_workout_date_idx ON public.workout_sets_2029 USING btree (workout_date);


--
-- Name: workout_sets_2030_exercise_id_idx; Type: INDEX; Schema: public; Owner: root
--

CREATE INDEX workout_sets_2030_exercise_id_idx ON public.workout_sets_2030 USING btree (exercise_id);


--
-- Name: workout_sets_2030_max_effort_form_ok_idx; Type: INDEX; Schema: public; Owner: root
--

CREATE INDEX workout_sets_2030_max_effort_form_ok_idx ON public.workout_sets_2030 USING btree (max_effort, form_ok);


--
-- Name: workout_sets_2030_workout_date_idx; Type: INDEX; Schema: public; Owner: root
--

CREATE INDEX workout_sets_2030_workout_date_idx ON public.workout_sets_2030 USING btree (workout_date);


--
-- Name: workout_sets_default_exercise_id_idx; Type: INDEX; Schema: public; Owner: root
--

CREATE INDEX workout_sets_default_exercise_id_idx ON public.workout_sets_default USING btree (exercise_id);


--
-- Name: workout_sets_default_max_effort_form_ok_idx; Type: INDEX; Schema: public; Owner: root
--

CREATE INDEX workout_sets_default_max_effort_form_ok_idx ON public.workout_sets_default USING btree (max_effort, form_ok);


--
-- Name: workout_sets_default_workout_date_idx; Type: INDEX; Schema: public; Owner: root
--

CREATE INDEX workout_sets_default_workout_date_idx ON public.workout_sets_default USING btree (workout_date);


--
-- Name: workouts_2020_recovery_score_mood_score_idx; Type: INDEX; Schema: public; Owner: root
--

CREATE INDEX workouts_2020_recovery_score_mood_score_idx ON public.workouts_2020 USING btree (recovery_score, mood_score);


--
-- Name: workouts_2020_template_id_idx; Type: INDEX; Schema: public; Owner: root
--

CREATE INDEX workouts_2020_template_id_idx ON public.workouts_2020 USING btree (template_id);


--
-- Name: workouts_2020_workout_date_idx; Type: INDEX; Schema: public; Owner: root
--

CREATE INDEX workouts_2020_workout_date_idx ON public.workouts_2020 USING btree (workout_date);


--
-- Name: workouts_2021_recovery_score_mood_score_idx; Type: INDEX; Schema: public; Owner: root
--

CREATE INDEX workouts_2021_recovery_score_mood_score_idx ON public.workouts_2021 USING btree (recovery_score, mood_score);


--
-- Name: workouts_2021_template_id_idx; Type: INDEX; Schema: public; Owner: root
--

CREATE INDEX workouts_2021_template_id_idx ON public.workouts_2021 USING btree (template_id);


--
-- Name: workouts_2021_workout_date_idx; Type: INDEX; Schema: public; Owner: root
--

CREATE INDEX workouts_2021_workout_date_idx ON public.workouts_2021 USING btree (workout_date);


--
-- Name: workouts_2022_recovery_score_mood_score_idx; Type: INDEX; Schema: public; Owner: root
--

CREATE INDEX workouts_2022_recovery_score_mood_score_idx ON public.workouts_2022 USING btree (recovery_score, mood_score);


--
-- Name: workouts_2022_template_id_idx; Type: INDEX; Schema: public; Owner: root
--

CREATE INDEX workouts_2022_template_id_idx ON public.workouts_2022 USING btree (template_id);


--
-- Name: workouts_2022_workout_date_idx; Type: INDEX; Schema: public; Owner: root
--

CREATE INDEX workouts_2022_workout_date_idx ON public.workouts_2022 USING btree (workout_date);


--
-- Name: workouts_2023_recovery_score_mood_score_idx; Type: INDEX; Schema: public; Owner: root
--

CREATE INDEX workouts_2023_recovery_score_mood_score_idx ON public.workouts_2023 USING btree (recovery_score, mood_score);


--
-- Name: workouts_2023_template_id_idx; Type: INDEX; Schema: public; Owner: root
--

CREATE INDEX workouts_2023_template_id_idx ON public.workouts_2023 USING btree (template_id);


--
-- Name: workouts_2023_workout_date_idx; Type: INDEX; Schema: public; Owner: root
--

CREATE INDEX workouts_2023_workout_date_idx ON public.workouts_2023 USING btree (workout_date);


--
-- Name: workouts_2024_recovery_score_mood_score_idx; Type: INDEX; Schema: public; Owner: root
--

CREATE INDEX workouts_2024_recovery_score_mood_score_idx ON public.workouts_2024 USING btree (recovery_score, mood_score);


--
-- Name: workouts_2024_template_id_idx; Type: INDEX; Schema: public; Owner: root
--

CREATE INDEX workouts_2024_template_id_idx ON public.workouts_2024 USING btree (template_id);


--
-- Name: workouts_2024_workout_date_idx; Type: INDEX; Schema: public; Owner: root
--

CREATE INDEX workouts_2024_workout_date_idx ON public.workouts_2024 USING btree (workout_date);


--
-- Name: workouts_2025_recovery_score_mood_score_idx; Type: INDEX; Schema: public; Owner: root
--

CREATE INDEX workouts_2025_recovery_score_mood_score_idx ON public.workouts_2025 USING btree (recovery_score, mood_score);


--
-- Name: workouts_2025_template_id_idx; Type: INDEX; Schema: public; Owner: root
--

CREATE INDEX workouts_2025_template_id_idx ON public.workouts_2025 USING btree (template_id);


--
-- Name: workouts_2025_workout_date_idx; Type: INDEX; Schema: public; Owner: root
--

CREATE INDEX workouts_2025_workout_date_idx ON public.workouts_2025 USING btree (workout_date);


--
-- Name: workouts_2026_recovery_score_mood_score_idx; Type: INDEX; Schema: public; Owner: root
--

CREATE INDEX workouts_2026_recovery_score_mood_score_idx ON public.workouts_2026 USING btree (recovery_score, mood_score);


--
-- Name: workouts_2026_template_id_idx; Type: INDEX; Schema: public; Owner: root
--

CREATE INDEX workouts_2026_template_id_idx ON public.workouts_2026 USING btree (template_id);


--
-- Name: workouts_2026_workout_date_idx; Type: INDEX; Schema: public; Owner: root
--

CREATE INDEX workouts_2026_workout_date_idx ON public.workouts_2026 USING btree (workout_date);


--
-- Name: workouts_2027_recovery_score_mood_score_idx; Type: INDEX; Schema: public; Owner: root
--

CREATE INDEX workouts_2027_recovery_score_mood_score_idx ON public.workouts_2027 USING btree (recovery_score, mood_score);


--
-- Name: workouts_2027_template_id_idx; Type: INDEX; Schema: public; Owner: root
--

CREATE INDEX workouts_2027_template_id_idx ON public.workouts_2027 USING btree (template_id);


--
-- Name: workouts_2027_workout_date_idx; Type: INDEX; Schema: public; Owner: root
--

CREATE INDEX workouts_2027_workout_date_idx ON public.workouts_2027 USING btree (workout_date);


--
-- Name: workouts_2028_recovery_score_mood_score_idx; Type: INDEX; Schema: public; Owner: root
--

CREATE INDEX workouts_2028_recovery_score_mood_score_idx ON public.workouts_2028 USING btree (recovery_score, mood_score);


--
-- Name: workouts_2028_template_id_idx; Type: INDEX; Schema: public; Owner: root
--

CREATE INDEX workouts_2028_template_id_idx ON public.workouts_2028 USING btree (template_id);


--
-- Name: workouts_2028_workout_date_idx; Type: INDEX; Schema: public; Owner: root
--

CREATE INDEX workouts_2028_workout_date_idx ON public.workouts_2028 USING btree (workout_date);


--
-- Name: workouts_2029_recovery_score_mood_score_idx; Type: INDEX; Schema: public; Owner: root
--

CREATE INDEX workouts_2029_recovery_score_mood_score_idx ON public.workouts_2029 USING btree (recovery_score, mood_score);


--
-- Name: workouts_2029_template_id_idx; Type: INDEX; Schema: public; Owner: root
--

CREATE INDEX workouts_2029_template_id_idx ON public.workouts_2029 USING btree (template_id);


--
-- Name: workouts_2029_workout_date_idx; Type: INDEX; Schema: public; Owner: root
--

CREATE INDEX workouts_2029_workout_date_idx ON public.workouts_2029 USING btree (workout_date);


--
-- Name: workouts_2030_recovery_score_mood_score_idx; Type: INDEX; Schema: public; Owner: root
--

CREATE INDEX workouts_2030_recovery_score_mood_score_idx ON public.workouts_2030 USING btree (recovery_score, mood_score);


--
-- Name: workouts_2030_template_id_idx; Type: INDEX; Schema: public; Owner: root
--

CREATE INDEX workouts_2030_template_id_idx ON public.workouts_2030 USING btree (template_id);


--
-- Name: workouts_2030_workout_date_idx; Type: INDEX; Schema: public; Owner: root
--

CREATE INDEX workouts_2030_workout_date_idx ON public.workouts_2030 USING btree (workout_date);


--
-- Name: workouts_default_recovery_score_mood_score_idx; Type: INDEX; Schema: public; Owner: root
--

CREATE INDEX workouts_default_recovery_score_mood_score_idx ON public.workouts_default USING btree (recovery_score, mood_score);


--
-- Name: workouts_default_template_id_idx; Type: INDEX; Schema: public; Owner: root
--

CREATE INDEX workouts_default_template_id_idx ON public.workouts_default USING btree (template_id);


--
-- Name: workouts_default_workout_date_idx; Type: INDEX; Schema: public; Owner: root
--

CREATE INDEX workouts_default_workout_date_idx ON public.workouts_default USING btree (workout_date);


--
-- Name: workout_sets_2020_exercise_id_idx; Type: INDEX ATTACH; Schema: public; Owner: root
--

ALTER INDEX public.idx_sets_exercise ATTACH PARTITION public.workout_sets_2020_exercise_id_idx;


--
-- Name: workout_sets_2020_max_effort_form_ok_idx; Type: INDEX ATTACH; Schema: public; Owner: root
--

ALTER INDEX public.idx_sets_effort ATTACH PARTITION public.workout_sets_2020_max_effort_form_ok_idx;


--
-- Name: workout_sets_2020_pkey; Type: INDEX ATTACH; Schema: public; Owner: root
--

ALTER INDEX public.sets_pkey ATTACH PARTITION public.workout_sets_2020_pkey;


--
-- Name: workout_sets_2020_workout_date_idx; Type: INDEX ATTACH; Schema: public; Owner: root
--

ALTER INDEX public.idx_sets_date ATTACH PARTITION public.workout_sets_2020_workout_date_idx;


--
-- Name: workout_sets_2021_exercise_id_idx; Type: INDEX ATTACH; Schema: public; Owner: root
--

ALTER INDEX public.idx_sets_exercise ATTACH PARTITION public.workout_sets_2021_exercise_id_idx;


--
-- Name: workout_sets_2021_max_effort_form_ok_idx; Type: INDEX ATTACH; Schema: public; Owner: root
--

ALTER INDEX public.idx_sets_effort ATTACH PARTITION public.workout_sets_2021_max_effort_form_ok_idx;


--
-- Name: workout_sets_2021_pkey; Type: INDEX ATTACH; Schema: public; Owner: root
--

ALTER INDEX public.sets_pkey ATTACH PARTITION public.workout_sets_2021_pkey;


--
-- Name: workout_sets_2021_workout_date_idx; Type: INDEX ATTACH; Schema: public; Owner: root
--

ALTER INDEX public.idx_sets_date ATTACH PARTITION public.workout_sets_2021_workout_date_idx;


--
-- Name: workout_sets_2022_exercise_id_idx; Type: INDEX ATTACH; Schema: public; Owner: root
--

ALTER INDEX public.idx_sets_exercise ATTACH PARTITION public.workout_sets_2022_exercise_id_idx;


--
-- Name: workout_sets_2022_max_effort_form_ok_idx; Type: INDEX ATTACH; Schema: public; Owner: root
--

ALTER INDEX public.idx_sets_effort ATTACH PARTITION public.workout_sets_2022_max_effort_form_ok_idx;


--
-- Name: workout_sets_2022_pkey; Type: INDEX ATTACH; Schema: public; Owner: root
--

ALTER INDEX public.sets_pkey ATTACH PARTITION public.workout_sets_2022_pkey;


--
-- Name: workout_sets_2022_workout_date_idx; Type: INDEX ATTACH; Schema: public; Owner: root
--

ALTER INDEX public.idx_sets_date ATTACH PARTITION public.workout_sets_2022_workout_date_idx;


--
-- Name: workout_sets_2023_exercise_id_idx; Type: INDEX ATTACH; Schema: public; Owner: root
--

ALTER INDEX public.idx_sets_exercise ATTACH PARTITION public.workout_sets_2023_exercise_id_idx;


--
-- Name: workout_sets_2023_max_effort_form_ok_idx; Type: INDEX ATTACH; Schema: public; Owner: root
--

ALTER INDEX public.idx_sets_effort ATTACH PARTITION public.workout_sets_2023_max_effort_form_ok_idx;


--
-- Name: workout_sets_2023_pkey; Type: INDEX ATTACH; Schema: public; Owner: root
--

ALTER INDEX public.sets_pkey ATTACH PARTITION public.workout_sets_2023_pkey;


--
-- Name: workout_sets_2023_workout_date_idx; Type: INDEX ATTACH; Schema: public; Owner: root
--

ALTER INDEX public.idx_sets_date ATTACH PARTITION public.workout_sets_2023_workout_date_idx;


--
-- Name: workout_sets_2024_exercise_id_idx; Type: INDEX ATTACH; Schema: public; Owner: root
--

ALTER INDEX public.idx_sets_exercise ATTACH PARTITION public.workout_sets_2024_exercise_id_idx;


--
-- Name: workout_sets_2024_max_effort_form_ok_idx; Type: INDEX ATTACH; Schema: public; Owner: root
--

ALTER INDEX public.idx_sets_effort ATTACH PARTITION public.workout_sets_2024_max_effort_form_ok_idx;


--
-- Name: workout_sets_2024_pkey; Type: INDEX ATTACH; Schema: public; Owner: root
--

ALTER INDEX public.sets_pkey ATTACH PARTITION public.workout_sets_2024_pkey;


--
-- Name: workout_sets_2024_workout_date_idx; Type: INDEX ATTACH; Schema: public; Owner: root
--

ALTER INDEX public.idx_sets_date ATTACH PARTITION public.workout_sets_2024_workout_date_idx;


--
-- Name: workout_sets_2025_exercise_id_idx; Type: INDEX ATTACH; Schema: public; Owner: root
--

ALTER INDEX public.idx_sets_exercise ATTACH PARTITION public.workout_sets_2025_exercise_id_idx;


--
-- Name: workout_sets_2025_max_effort_form_ok_idx; Type: INDEX ATTACH; Schema: public; Owner: root
--

ALTER INDEX public.idx_sets_effort ATTACH PARTITION public.workout_sets_2025_max_effort_form_ok_idx;


--
-- Name: workout_sets_2025_pkey; Type: INDEX ATTACH; Schema: public; Owner: root
--

ALTER INDEX public.sets_pkey ATTACH PARTITION public.workout_sets_2025_pkey;


--
-- Name: workout_sets_2025_workout_date_idx; Type: INDEX ATTACH; Schema: public; Owner: root
--

ALTER INDEX public.idx_sets_date ATTACH PARTITION public.workout_sets_2025_workout_date_idx;


--
-- Name: workout_sets_2026_exercise_id_idx; Type: INDEX ATTACH; Schema: public; Owner: root
--

ALTER INDEX public.idx_sets_exercise ATTACH PARTITION public.workout_sets_2026_exercise_id_idx;


--
-- Name: workout_sets_2026_max_effort_form_ok_idx; Type: INDEX ATTACH; Schema: public; Owner: root
--

ALTER INDEX public.idx_sets_effort ATTACH PARTITION public.workout_sets_2026_max_effort_form_ok_idx;


--
-- Name: workout_sets_2026_pkey; Type: INDEX ATTACH; Schema: public; Owner: root
--

ALTER INDEX public.sets_pkey ATTACH PARTITION public.workout_sets_2026_pkey;


--
-- Name: workout_sets_2026_workout_date_idx; Type: INDEX ATTACH; Schema: public; Owner: root
--

ALTER INDEX public.idx_sets_date ATTACH PARTITION public.workout_sets_2026_workout_date_idx;


--
-- Name: workout_sets_2027_exercise_id_idx; Type: INDEX ATTACH; Schema: public; Owner: root
--

ALTER INDEX public.idx_sets_exercise ATTACH PARTITION public.workout_sets_2027_exercise_id_idx;


--
-- Name: workout_sets_2027_max_effort_form_ok_idx; Type: INDEX ATTACH; Schema: public; Owner: root
--

ALTER INDEX public.idx_sets_effort ATTACH PARTITION public.workout_sets_2027_max_effort_form_ok_idx;


--
-- Name: workout_sets_2027_pkey; Type: INDEX ATTACH; Schema: public; Owner: root
--

ALTER INDEX public.sets_pkey ATTACH PARTITION public.workout_sets_2027_pkey;


--
-- Name: workout_sets_2027_workout_date_idx; Type: INDEX ATTACH; Schema: public; Owner: root
--

ALTER INDEX public.idx_sets_date ATTACH PARTITION public.workout_sets_2027_workout_date_idx;


--
-- Name: workout_sets_2028_exercise_id_idx; Type: INDEX ATTACH; Schema: public; Owner: root
--

ALTER INDEX public.idx_sets_exercise ATTACH PARTITION public.workout_sets_2028_exercise_id_idx;


--
-- Name: workout_sets_2028_max_effort_form_ok_idx; Type: INDEX ATTACH; Schema: public; Owner: root
--

ALTER INDEX public.idx_sets_effort ATTACH PARTITION public.workout_sets_2028_max_effort_form_ok_idx;


--
-- Name: workout_sets_2028_pkey; Type: INDEX ATTACH; Schema: public; Owner: root
--

ALTER INDEX public.sets_pkey ATTACH PARTITION public.workout_sets_2028_pkey;


--
-- Name: workout_sets_2028_workout_date_idx; Type: INDEX ATTACH; Schema: public; Owner: root
--

ALTER INDEX public.idx_sets_date ATTACH PARTITION public.workout_sets_2028_workout_date_idx;


--
-- Name: workout_sets_2029_exercise_id_idx; Type: INDEX ATTACH; Schema: public; Owner: root
--

ALTER INDEX public.idx_sets_exercise ATTACH PARTITION public.workout_sets_2029_exercise_id_idx;


--
-- Name: workout_sets_2029_max_effort_form_ok_idx; Type: INDEX ATTACH; Schema: public; Owner: root
--

ALTER INDEX public.idx_sets_effort ATTACH PARTITION public.workout_sets_2029_max_effort_form_ok_idx;


--
-- Name: workout_sets_2029_pkey; Type: INDEX ATTACH; Schema: public; Owner: root
--

ALTER INDEX public.sets_pkey ATTACH PARTITION public.workout_sets_2029_pkey;


--
-- Name: workout_sets_2029_workout_date_idx; Type: INDEX ATTACH; Schema: public; Owner: root
--

ALTER INDEX public.idx_sets_date ATTACH PARTITION public.workout_sets_2029_workout_date_idx;


--
-- Name: workout_sets_2030_exercise_id_idx; Type: INDEX ATTACH; Schema: public; Owner: root
--

ALTER INDEX public.idx_sets_exercise ATTACH PARTITION public.workout_sets_2030_exercise_id_idx;


--
-- Name: workout_sets_2030_max_effort_form_ok_idx; Type: INDEX ATTACH; Schema: public; Owner: root
--

ALTER INDEX public.idx_sets_effort ATTACH PARTITION public.workout_sets_2030_max_effort_form_ok_idx;


--
-- Name: workout_sets_2030_pkey; Type: INDEX ATTACH; Schema: public; Owner: root
--

ALTER INDEX public.sets_pkey ATTACH PARTITION public.workout_sets_2030_pkey;


--
-- Name: workout_sets_2030_workout_date_idx; Type: INDEX ATTACH; Schema: public; Owner: root
--

ALTER INDEX public.idx_sets_date ATTACH PARTITION public.workout_sets_2030_workout_date_idx;


--
-- Name: workout_sets_default_exercise_id_idx; Type: INDEX ATTACH; Schema: public; Owner: root
--

ALTER INDEX public.idx_sets_exercise ATTACH PARTITION public.workout_sets_default_exercise_id_idx;


--
-- Name: workout_sets_default_max_effort_form_ok_idx; Type: INDEX ATTACH; Schema: public; Owner: root
--

ALTER INDEX public.idx_sets_effort ATTACH PARTITION public.workout_sets_default_max_effort_form_ok_idx;


--
-- Name: workout_sets_default_pkey; Type: INDEX ATTACH; Schema: public; Owner: root
--

ALTER INDEX public.sets_pkey ATTACH PARTITION public.workout_sets_default_pkey;


--
-- Name: workout_sets_default_workout_date_idx; Type: INDEX ATTACH; Schema: public; Owner: root
--

ALTER INDEX public.idx_sets_date ATTACH PARTITION public.workout_sets_default_workout_date_idx;


--
-- Name: workouts_2020_pkey; Type: INDEX ATTACH; Schema: public; Owner: root
--

ALTER INDEX public.workouts_pkey ATTACH PARTITION public.workouts_2020_pkey;


--
-- Name: workouts_2020_recovery_score_mood_score_idx; Type: INDEX ATTACH; Schema: public; Owner: root
--

ALTER INDEX public.idx_workouts_recovery ATTACH PARTITION public.workouts_2020_recovery_score_mood_score_idx;


--
-- Name: workouts_2020_template_id_idx; Type: INDEX ATTACH; Schema: public; Owner: root
--

ALTER INDEX public.idx_workouts_template ATTACH PARTITION public.workouts_2020_template_id_idx;


--
-- Name: workouts_2020_workout_date_idx; Type: INDEX ATTACH; Schema: public; Owner: root
--

ALTER INDEX public.idx_workouts_date ATTACH PARTITION public.workouts_2020_workout_date_idx;


--
-- Name: workouts_2021_pkey; Type: INDEX ATTACH; Schema: public; Owner: root
--

ALTER INDEX public.workouts_pkey ATTACH PARTITION public.workouts_2021_pkey;


--
-- Name: workouts_2021_recovery_score_mood_score_idx; Type: INDEX ATTACH; Schema: public; Owner: root
--

ALTER INDEX public.idx_workouts_recovery ATTACH PARTITION public.workouts_2021_recovery_score_mood_score_idx;


--
-- Name: workouts_2021_template_id_idx; Type: INDEX ATTACH; Schema: public; Owner: root
--

ALTER INDEX public.idx_workouts_template ATTACH PARTITION public.workouts_2021_template_id_idx;


--
-- Name: workouts_2021_workout_date_idx; Type: INDEX ATTACH; Schema: public; Owner: root
--

ALTER INDEX public.idx_workouts_date ATTACH PARTITION public.workouts_2021_workout_date_idx;


--
-- Name: workouts_2022_pkey; Type: INDEX ATTACH; Schema: public; Owner: root
--

ALTER INDEX public.workouts_pkey ATTACH PARTITION public.workouts_2022_pkey;


--
-- Name: workouts_2022_recovery_score_mood_score_idx; Type: INDEX ATTACH; Schema: public; Owner: root
--

ALTER INDEX public.idx_workouts_recovery ATTACH PARTITION public.workouts_2022_recovery_score_mood_score_idx;


--
-- Name: workouts_2022_template_id_idx; Type: INDEX ATTACH; Schema: public; Owner: root
--

ALTER INDEX public.idx_workouts_template ATTACH PARTITION public.workouts_2022_template_id_idx;


--
-- Name: workouts_2022_workout_date_idx; Type: INDEX ATTACH; Schema: public; Owner: root
--

ALTER INDEX public.idx_workouts_date ATTACH PARTITION public.workouts_2022_workout_date_idx;


--
-- Name: workouts_2023_pkey; Type: INDEX ATTACH; Schema: public; Owner: root
--

ALTER INDEX public.workouts_pkey ATTACH PARTITION public.workouts_2023_pkey;


--
-- Name: workouts_2023_recovery_score_mood_score_idx; Type: INDEX ATTACH; Schema: public; Owner: root
--

ALTER INDEX public.idx_workouts_recovery ATTACH PARTITION public.workouts_2023_recovery_score_mood_score_idx;


--
-- Name: workouts_2023_template_id_idx; Type: INDEX ATTACH; Schema: public; Owner: root
--

ALTER INDEX public.idx_workouts_template ATTACH PARTITION public.workouts_2023_template_id_idx;


--
-- Name: workouts_2023_workout_date_idx; Type: INDEX ATTACH; Schema: public; Owner: root
--

ALTER INDEX public.idx_workouts_date ATTACH PARTITION public.workouts_2023_workout_date_idx;


--
-- Name: workouts_2024_pkey; Type: INDEX ATTACH; Schema: public; Owner: root
--

ALTER INDEX public.workouts_pkey ATTACH PARTITION public.workouts_2024_pkey;


--
-- Name: workouts_2024_recovery_score_mood_score_idx; Type: INDEX ATTACH; Schema: public; Owner: root
--

ALTER INDEX public.idx_workouts_recovery ATTACH PARTITION public.workouts_2024_recovery_score_mood_score_idx;


--
-- Name: workouts_2024_template_id_idx; Type: INDEX ATTACH; Schema: public; Owner: root
--

ALTER INDEX public.idx_workouts_template ATTACH PARTITION public.workouts_2024_template_id_idx;


--
-- Name: workouts_2024_workout_date_idx; Type: INDEX ATTACH; Schema: public; Owner: root
--

ALTER INDEX public.idx_workouts_date ATTACH PARTITION public.workouts_2024_workout_date_idx;


--
-- Name: workouts_2025_pkey; Type: INDEX ATTACH; Schema: public; Owner: root
--

ALTER INDEX public.workouts_pkey ATTACH PARTITION public.workouts_2025_pkey;


--
-- Name: workouts_2025_recovery_score_mood_score_idx; Type: INDEX ATTACH; Schema: public; Owner: root
--

ALTER INDEX public.idx_workouts_recovery ATTACH PARTITION public.workouts_2025_recovery_score_mood_score_idx;


--
-- Name: workouts_2025_template_id_idx; Type: INDEX ATTACH; Schema: public; Owner: root
--

ALTER INDEX public.idx_workouts_template ATTACH PARTITION public.workouts_2025_template_id_idx;


--
-- Name: workouts_2025_workout_date_idx; Type: INDEX ATTACH; Schema: public; Owner: root
--

ALTER INDEX public.idx_workouts_date ATTACH PARTITION public.workouts_2025_workout_date_idx;


--
-- Name: workouts_2026_pkey; Type: INDEX ATTACH; Schema: public; Owner: root
--

ALTER INDEX public.workouts_pkey ATTACH PARTITION public.workouts_2026_pkey;


--
-- Name: workouts_2026_recovery_score_mood_score_idx; Type: INDEX ATTACH; Schema: public; Owner: root
--

ALTER INDEX public.idx_workouts_recovery ATTACH PARTITION public.workouts_2026_recovery_score_mood_score_idx;


--
-- Name: workouts_2026_template_id_idx; Type: INDEX ATTACH; Schema: public; Owner: root
--

ALTER INDEX public.idx_workouts_template ATTACH PARTITION public.workouts_2026_template_id_idx;


--
-- Name: workouts_2026_workout_date_idx; Type: INDEX ATTACH; Schema: public; Owner: root
--

ALTER INDEX public.idx_workouts_date ATTACH PARTITION public.workouts_2026_workout_date_idx;


--
-- Name: workouts_2027_pkey; Type: INDEX ATTACH; Schema: public; Owner: root
--

ALTER INDEX public.workouts_pkey ATTACH PARTITION public.workouts_2027_pkey;


--
-- Name: workouts_2027_recovery_score_mood_score_idx; Type: INDEX ATTACH; Schema: public; Owner: root
--

ALTER INDEX public.idx_workouts_recovery ATTACH PARTITION public.workouts_2027_recovery_score_mood_score_idx;


--
-- Name: workouts_2027_template_id_idx; Type: INDEX ATTACH; Schema: public; Owner: root
--

ALTER INDEX public.idx_workouts_template ATTACH PARTITION public.workouts_2027_template_id_idx;


--
-- Name: workouts_2027_workout_date_idx; Type: INDEX ATTACH; Schema: public; Owner: root
--

ALTER INDEX public.idx_workouts_date ATTACH PARTITION public.workouts_2027_workout_date_idx;


--
-- Name: workouts_2028_pkey; Type: INDEX ATTACH; Schema: public; Owner: root
--

ALTER INDEX public.workouts_pkey ATTACH PARTITION public.workouts_2028_pkey;


--
-- Name: workouts_2028_recovery_score_mood_score_idx; Type: INDEX ATTACH; Schema: public; Owner: root
--

ALTER INDEX public.idx_workouts_recovery ATTACH PARTITION public.workouts_2028_recovery_score_mood_score_idx;


--
-- Name: workouts_2028_template_id_idx; Type: INDEX ATTACH; Schema: public; Owner: root
--

ALTER INDEX public.idx_workouts_template ATTACH PARTITION public.workouts_2028_template_id_idx;


--
-- Name: workouts_2028_workout_date_idx; Type: INDEX ATTACH; Schema: public; Owner: root
--

ALTER INDEX public.idx_workouts_date ATTACH PARTITION public.workouts_2028_workout_date_idx;


--
-- Name: workouts_2029_pkey; Type: INDEX ATTACH; Schema: public; Owner: root
--

ALTER INDEX public.workouts_pkey ATTACH PARTITION public.workouts_2029_pkey;


--
-- Name: workouts_2029_recovery_score_mood_score_idx; Type: INDEX ATTACH; Schema: public; Owner: root
--

ALTER INDEX public.idx_workouts_recovery ATTACH PARTITION public.workouts_2029_recovery_score_mood_score_idx;


--
-- Name: workouts_2029_template_id_idx; Type: INDEX ATTACH; Schema: public; Owner: root
--

ALTER INDEX public.idx_workouts_template ATTACH PARTITION public.workouts_2029_template_id_idx;


--
-- Name: workouts_2029_workout_date_idx; Type: INDEX ATTACH; Schema: public; Owner: root
--

ALTER INDEX public.idx_workouts_date ATTACH PARTITION public.workouts_2029_workout_date_idx;


--
-- Name: workouts_2030_pkey; Type: INDEX ATTACH; Schema: public; Owner: root
--

ALTER INDEX public.workouts_pkey ATTACH PARTITION public.workouts_2030_pkey;


--
-- Name: workouts_2030_recovery_score_mood_score_idx; Type: INDEX ATTACH; Schema: public; Owner: root
--

ALTER INDEX public.idx_workouts_recovery ATTACH PARTITION public.workouts_2030_recovery_score_mood_score_idx;


--
-- Name: workouts_2030_template_id_idx; Type: INDEX ATTACH; Schema: public; Owner: root
--

ALTER INDEX public.idx_workouts_template ATTACH PARTITION public.workouts_2030_template_id_idx;


--
-- Name: workouts_2030_workout_date_idx; Type: INDEX ATTACH; Schema: public; Owner: root
--

ALTER INDEX public.idx_workouts_date ATTACH PARTITION public.workouts_2030_workout_date_idx;


--
-- Name: workouts_default_pkey; Type: INDEX ATTACH; Schema: public; Owner: root
--

ALTER INDEX public.workouts_pkey ATTACH PARTITION public.workouts_default_pkey;


--
-- Name: workouts_default_recovery_score_mood_score_idx; Type: INDEX ATTACH; Schema: public; Owner: root
--

ALTER INDEX public.idx_workouts_recovery ATTACH PARTITION public.workouts_default_recovery_score_mood_score_idx;


--
-- Name: workouts_default_template_id_idx; Type: INDEX ATTACH; Schema: public; Owner: root
--

ALTER INDEX public.idx_workouts_template ATTACH PARTITION public.workouts_default_template_id_idx;


--
-- Name: workouts_default_workout_date_idx; Type: INDEX ATTACH; Schema: public; Owner: root
--

ALTER INDEX public.idx_workouts_date ATTACH PARTITION public.workouts_default_workout_date_idx;


--
-- Name: measurements update_measurements_updated_at; Type: TRIGGER; Schema: public; Owner: root
--

CREATE TRIGGER update_measurements_updated_at BEFORE UPDATE ON public.measurements FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();


--
-- Name: workout_sets update_sets_updated_at; Type: TRIGGER; Schema: public; Owner: root
--

CREATE TRIGGER update_sets_updated_at BEFORE UPDATE ON public.workout_sets FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();


--
-- Name: workouts update_workouts_updated_at; Type: TRIGGER; Schema: public; Owner: root
--

CREATE TRIGGER update_workouts_updated_at BEFORE UPDATE ON public.workouts FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();


--
-- Name: workout_sets fk_sets_exercise; Type: FK CONSTRAINT; Schema: public; Owner: root
--

ALTER TABLE public.workout_sets
    ADD CONSTRAINT fk_sets_exercise FOREIGN KEY (exercise_id) REFERENCES public.exercises(exercise_id);


--
-- Name: workout_sets fk_sets_workout; Type: FK CONSTRAINT; Schema: public; Owner: root
--

ALTER TABLE public.workout_sets
    ADD CONSTRAINT fk_sets_workout FOREIGN KEY (workout_date, template_id) REFERENCES public.workouts(workout_date, template_id);


--
-- Name: workouts fk_workouts_template; Type: FK CONSTRAINT; Schema: public; Owner: root
--

ALTER TABLE public.workouts
    ADD CONSTRAINT fk_workouts_template FOREIGN KEY (template_id) REFERENCES public.workout_templates(template_id);


--
-- PostgreSQL database dump complete
--

\unrestrict r2BZauFlPm8GKQa8rq6m0ExLi1INZxFxUng1TVQ587xxzAgl6ftuXg23dprfwoz

