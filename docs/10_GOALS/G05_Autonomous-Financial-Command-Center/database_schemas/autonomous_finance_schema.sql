--
-- PostgreSQL database dump
--

\restrict dLuQX4dxNb9c5DBHLYXPUlyC0GMUvxwCnGmBdj5TMuUVftp6bxLYd8cCLHkOFuw

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
-- Name: pgcrypto; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS pgcrypto WITH SCHEMA public;


--
-- Name: EXTENSION pgcrypto; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION pgcrypto IS 'cryptographic functions';


--
-- Name: create_missing_merchant(character varying, character varying, character varying); Type: FUNCTION; Schema: public; Owner: root
--

CREATE FUNCTION public.create_missing_merchant(_merchant_name character varying, _default_category_name character varying DEFAULT 'Lifestyle'::character varying, _default_subcategory_name character varying DEFAULT 'Other'::character varying) RETURNS integer
    LANGUAGE plpgsql
    AS $$
DECLARE
    v_category_id INTEGER;
    v_merchant_id INTEGER;
BEGIN
    -- Get default category ID
    SELECT category_id INTO v_category_id
    FROM categories
    WHERE category_name = _default_category_name
      AND subcategory_name = _default_subcategory_name;
    
    -- Insert new merchant
    INSERT INTO merchants (merchant_name, default_category_id, data_type)
    VALUES (_merchant_name, v_category_id, 'atomic')
    RETURNING merchant_id INTO v_merchant_id;
    
    RETURN v_merchant_id;
END;

$$;


ALTER FUNCTION public.create_missing_merchant(_merchant_name character varying, _default_category_name character varying, _default_subcategory_name character varying) OWNER TO root;

--
-- Name: find_merchant_id(text); Type: FUNCTION; Schema: public; Owner: root
--

CREATE FUNCTION public.find_merchant_id(merchant_name_input text) RETURNS integer
    LANGUAGE plpgsql
    AS $$
DECLARE
    result INTEGER;
BEGIN
    SELECT merchant_id
    INTO result
    FROM merchants
    WHERE LOWER(merchant_name) = LOWER(merchant_name_input);
    
    RETURN result;
END;

$$;


ALTER FUNCTION public.find_merchant_id(merchant_name_input text) OWNER TO root;

--
-- Name: get_account_id(text); Type: FUNCTION; Schema: public; Owner: root
--

CREATE FUNCTION public.get_account_id(account_name_input text) RETURNS integer
    LANGUAGE plpgsql
    AS $$
DECLARE
    result INTEGER;
BEGIN
    SELECT account_id
    INTO result
    FROM accounts
    WHERE account_name = account_name_input;
    
    RETURN result;
END;

$$;


ALTER FUNCTION public.get_account_id(account_name_input text) OWNER TO root;

--
-- Name: get_category_path(integer); Type: FUNCTION; Schema: public; Owner: root
--

CREATE FUNCTION public.get_category_path(cat_id integer) RETURNS text
    LANGUAGE plpgsql
    AS $$
DECLARE
    result TEXT;
BEGIN
    SELECT category_name || ' > ' || subcategory_name
    INTO result
    FROM categories
    WHERE category_id = cat_id;
    
    RETURN result;
END;

$$;


ALTER FUNCTION public.get_category_path(cat_id integer) OWNER TO root;

--
-- Name: get_current_budget_alerts(); Type: FUNCTION; Schema: public; Owner: root
--

CREATE FUNCTION public.get_current_budget_alerts() RETURNS TABLE(alert_id text, alert_severity text, category_path text, budget_amount numeric, actual_amount numeric, utilization_pct numeric, alert_threshold integer, projected_month_end numeric, days_remaining integer, daily_limit_remaining numeric, recommended_action text, priority text)
    LANGUAGE plpgsql
    AS $$
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
            CASE 
                WHEN b.budget_amount > 0 
                THEN ROUND((COALESCE(SUM(t.amount), 0) / b.budget_amount) * 100, 2)
                ELSE 0 
            END as utilization_percentage,
            -- Project month-end based on current daily burn rate
            CASE 
                WHEN EXTRACT(DAY FROM CURRENT_DATE) > 0 
                THEN ROUND(
                    (COALESCE(SUM(t.amount), 0) / EXTRACT(DAY FROM CURRENT_DATE)) * 
                    EXTRACT(DAY FROM DATE_TRUNC('MONTH', CURRENT_DATE) + INTERVAL '1 MONTH' - INTERVAL '1 DAY'), 
                    2
                )
                ELSE 0
            END as projected_total,
            (
                EXTRACT(DAY FROM DATE_TRUNC('MONTH', CURRENT_DATE) + INTERVAL '1 MONTH' - INTERVAL '1 DAY')::INTEGER - 
                EXTRACT(DAY FROM CURRENT_DATE)::INTEGER
            ) as days_left
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
        -- EXPLICIT TYPE CASTING for every column
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
                CASE WHEN cma.days_left > 0 
                     THEN ROUND((cma.budget_amount - cma.actual_spending) / cma.days_left, 2) 
                     ELSE 0 
                END || ' PLN/day)'
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

$$;


ALTER FUNCTION public.get_current_budget_alerts() OWNER TO root;

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
-- Name: upsert_budget_from_sheet(character varying, integer, integer, character varying, character varying, character varying, numeric, integer, text, character varying, character varying, boolean); Type: FUNCTION; Schema: public; Owner: root
--

CREATE FUNCTION public.upsert_budget_from_sheet(_budget_id character varying, _budget_year integer, _budget_month integer, _type character varying, _category_name character varying, _subcategory_name character varying, _budget_amount numeric, _alert_threshold integer, _notes text, _budget_type character varying, _priority character varying, _is_active boolean) RETURNS json
    LANGUAGE plpgsql
    AS $$
DECLARE
    v_category_id   INTEGER;
    v_action        TEXT;
    v_rowcount      INTEGER;
    result          JSON;
BEGIN
    -- Validate input parameters
    IF _budget_year < 2000 OR _budget_year > 2100 THEN
        RETURN json_build_object(
            'success', false,
            'error', 'Invalid budget year: ' || _budget_year,
            'budget_id', _budget_id
        );
    END IF;
    
    IF _budget_month < 1 OR _budget_month > 12 THEN
        RETURN json_build_object(
            'success', false,
            'error', 'Invalid budget month: ' || _budget_month,
            'budget_id', _budget_id
        );
    END IF;
    
    -- Resolve category_id
    SELECT category_id INTO v_category_id
    FROM categories
    WHERE category_name = _category_name
      AND subcategory_name = _subcategory_name;
    
    IF v_category_id IS NULL THEN
        RETURN json_build_object(
            'success', false,
            'error', 'Category not found: ' || _category_name || ' > ' || _subcategory_name,
            'budget_id', _budget_id,
            'suggestion', 'Check category spelling or add to categories table'
        );
    END IF;
    
    -- Upsert budget with proper conflict handling
    INSERT INTO budgets (
        budget_id,
        budget_year,
        budget_month,
        type,
        category_id,
        budget_amount,
        alert_threshold,
        notes,
        budget_type,
        priority,
        is_active
    ) VALUES (
        _budget_id,
        _budget_year,
        _budget_month,
        _type,
        v_category_id,
        _budget_amount,
        _alert_threshold,
        _notes,
        _budget_type,
        _priority,
        _is_active
    )
    ON CONFLICT (budget_id)
    DO UPDATE SET
        budget_year = EXCLUDED.budget_year,
        budget_month = EXCLUDED.budget_month,
        type = EXCLUDED.type,
        category_id = EXCLUDED.category_id,
        budget_amount = EXCLUDED.budget_amount,
        alert_threshold = EXCLUDED.alert_threshold,
        notes = EXCLUDED.notes,
        budget_type = EXCLUDED.budget_type,
        priority = EXCLUDED.priority,
        is_active = EXCLUDED.is_active,
        updated_at = CURRENT_TIMESTAMP;
    
    -- Determine if this was an insert or update
    GET DIAGNOSTICS v_rowcount = ROW_COUNT;
    IF v_rowcount > 0 THEN
        -- Check if this was an actual insert by looking for the record
        PERFORM 1 FROM budgets WHERE budget_id = _budget_id AND created_at = updated_at;
        IF FOUND THEN
            v_action := 'inserted';
        ELSE
            v_action := 'updated';
        END IF;
    ELSE
        v_action := 'no_change';
    END IF;
    
    -- Optional logging
    RAISE NOTICE 'Budget %: % - Amount: %, Threshold: %', 
        v_action, _budget_id, _budget_amount, _alert_threshold;
    
    RETURN json_build_object(
        'success', true,
        'budget_id', _budget_id,
        'category_id', v_category_id,
        'action', v_action,
        'amount', _budget_amount
    );
    
EXCEPTION WHEN OTHERS THEN
    RETURN json_build_object(
        'success', false,
        'error', SQLERRM,
        'budget_id', _budget_id,
        'error_detail', SQLSTATE
    );
END;

$$;


ALTER FUNCTION public.upsert_budget_from_sheet(_budget_id character varying, _budget_year integer, _budget_month integer, _type character varying, _category_name character varying, _subcategory_name character varying, _budget_amount numeric, _alert_threshold integer, _notes text, _budget_type character varying, _priority character varying, _is_active boolean) OWNER TO root;

--
-- Name: upsert_expense_from_sheet(integer, integer, character varying, numeric, character varying, character varying, character varying, date, character varying, character varying, character varying); Type: FUNCTION; Schema: public; Owner: root
--

CREATE FUNCTION public.upsert_expense_from_sheet(p_month integer, p_day integer, p_name character varying, p_amount numeric, p_frequency character varying, p_description character varying, p_transaction_id character varying, p_expense_date date, p_currency character varying, p_category character varying, p_sub_category character varying) RETURNS json
    LANGUAGE plpgsql
    AS $$
DECLARE
    v_result JSON;
    v_action VARCHAR;
BEGIN
    -- Try to insert, on conflict update
    INSERT INTO expense_calendar (
        transaction_id,
        name,
        amount,
        currency,
        category,
        sub_category,
        frequency,
        expense_date,
        month,
        day,
        description,
        updated_at
    ) VALUES (
        p_transaction_id,
        p_name,
        p_amount,
        p_currency,
        p_category,
        p_sub_category,
        p_frequency,
        p_expense_date,
        p_month,
        p_day,
        p_description,
        CURRENT_TIMESTAMP
    )
    ON CONFLICT (transaction_id) DO UPDATE SET
        name = EXCLUDED.name,
        amount = EXCLUDED.amount,
        currency = EXCLUDED.currency,
        category = EXCLUDED.category,
        sub_category = EXCLUDED.sub_category,
        frequency = EXCLUDED.frequency,
        expense_date = EXCLUDED.expense_date,
        month = EXCLUDED.month,
        day = EXCLUDED.day,
        description = EXCLUDED.description,
        updated_at = CURRENT_TIMESTAMP;
    
    -- Determine if it was insert or update
    IF NOT FOUND THEN
        v_action := 'inserted';
    ELSE
        v_action := 'upserted';
    END IF;
    
    v_result := json_build_object(
        'success', true,
        'transaction_id', p_transaction_id,
        'action', v_action,
        'name', p_name,
        'amount', p_amount
    );
    
    RETURN v_result;
    
EXCEPTION WHEN OTHERS THEN
    RETURN json_build_object(
        'success', false,
        'transaction_id', p_transaction_id,
        'error', SQLERRM
    );
END;

$$;


ALTER FUNCTION public.upsert_expense_from_sheet(p_month integer, p_day integer, p_name character varying, p_amount numeric, p_frequency character varying, p_description character varying, p_transaction_id character varying, p_expense_date date, p_currency character varying, p_category character varying, p_sub_category character varying) OWNER TO root;

--
-- Name: upsert_transaction_from_sheet(character varying, date, character varying, numeric, character varying, character varying, text, character varying, character varying, character varying); Type: FUNCTION; Schema: public; Owner: root
--

CREATE FUNCTION public.upsert_transaction_from_sheet(_transaction_id character varying, _transaction_date date, _type character varying, _amount numeric, _currency character varying, _merchant_source character varying, _description text, _account_name character varying, _category_name character varying, _subcategory_name character varying) RETURNS json
    LANGUAGE plpgsql
    AS $$
DECLARE
    v_account_id   INTEGER;
    v_category_id  INTEGER;
    v_merchant_id  INTEGER;
    v_data_source  VARCHAR;
    v_merchant_created BOOLEAN := FALSE;
    result         JSON;
BEGIN
    -- FIXED: Use proper case matching the CHECK constraint
    v_data_source := CASE 
        WHEN LOWER(_merchant_source) LIKE 'hist_%' THEN 'Historical'
        ELSE 'Atomic'
    END;
    
    -- 1) Resolve account_id
    SELECT account_id INTO v_account_id
    FROM accounts
    WHERE account_name = _account_name;
    
    IF v_account_id IS NULL THEN
        result := json_build_object(
            'success', false,
            'error', 'Account not found: ' || _account_name,
            'transaction_id', _transaction_id
        );
        RETURN result;
    END IF;
    
    -- 2) Resolve category_id
    SELECT category_id INTO v_category_id
    FROM categories
    WHERE category_name = _category_name
      AND subcategory_name = _subcategory_name;
    
    IF v_category_id IS NULL THEN
        result := json_build_object(
            'success', false,
            'error', 'Category not found: ' || _category_name || ' > ' || _subcategory_name,
            'transaction_id', _transaction_id
        );
        RETURN result;
    END IF;
    
    -- 3) Resolve or auto-create merchant_id
    SELECT merchant_id INTO v_merchant_id
    FROM merchants
    WHERE LOWER(merchant_name) = LOWER(_merchant_source);
    
    -- AUTO-REGISTER NEW MERCHANT if not found
    IF v_merchant_id IS NULL THEN
        INSERT INTO merchants (
            merchant_name, 
            default_category_id, 
            data_type
        ) VALUES (
            _merchant_source,
            v_category_id,
            v_data_source  -- Now uses 'Historical' or 'Atomic' (proper case)
        )
        RETURNING merchant_id INTO v_merchant_id;
        
        v_merchant_created := TRUE;
        
        -- Log merchant creation for monitoring
        RAISE NOTICE 'Auto-registered merchant: % (ID: %) with category: % > %', 
            _merchant_source, v_merchant_id, _category_name, _subcategory_name;
    END IF;
    
    -- 4) Upsert transaction
    INSERT INTO transactions (
        transaction_id,
        transaction_date,
        type,
        amount,
        currency,
        merchant_source,
        description,
        account_id,
        category_id,
        merchant_id,
        data_source
    ) VALUES (
        _transaction_id,
        _transaction_date,
        _type,
        _amount,
        _currency,
        _merchant_source,
        _description,
        v_account_id,
        v_category_id,
        v_merchant_id,
        v_data_source
    )
    ON CONFLICT (transaction_id, transaction_date)
    DO UPDATE SET
        type = EXCLUDED.type,
        amount = EXCLUDED.amount,
        currency = EXCLUDED.currency,
        merchant_source = EXCLUDED.merchant_source,
        description = EXCLUDED.description,
        account_id = EXCLUDED.account_id,
        category_id = EXCLUDED.category_id,
        merchant_id = EXCLUDED.merchant_id,
        data_source = EXCLUDED.data_source,
        updated_at = CURRENT_TIMESTAMP;
    
    -- Return success with merchant creation flag
    result := json_build_object(
        'success', true,
        'transaction_id', _transaction_id,
        'merchant_id', v_merchant_id,
        'merchant_created', v_merchant_created,
        'action', CASE 
            WHEN v_merchant_created THEN 'merchant_auto_registered'
            ELSE 'upserted'
        END
    );
    
    RETURN result;
    
EXCEPTION WHEN OTHERS THEN
    result := json_build_object(
        'success', false,
        'error', SQLERRM,
        'transaction_id', _transaction_id
    );
    RETURN result;
END;

$$;


ALTER FUNCTION public.upsert_transaction_from_sheet(_transaction_id character varying, _transaction_date date, _type character varying, _amount numeric, _currency character varying, _merchant_source character varying, _description text, _account_name character varying, _category_name character varying, _subcategory_name character varying) OWNER TO root;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: accounts; Type: TABLE; Schema: public; Owner: root
--

CREATE TABLE public.accounts (
    account_id integer NOT NULL,
    account_name character varying(100) NOT NULL,
    account_type character varying(50) NOT NULL,
    institution_name character varying(100),
    currency character varying(3) DEFAULT 'PLN'::character varying,
    is_active boolean DEFAULT true,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT accounts_account_type_check CHECK (((account_type)::text = ANY ((ARRAY['Checking'::character varying, 'Savings'::character varying, 'Investment'::character varying, 'Cash'::character varying, 'Credit'::character varying, 'Historical'::character varying])::text[])))
);


ALTER TABLE public.accounts OWNER TO root;

--
-- Name: TABLE accounts; Type: COMMENT; Schema: public; Owner: root
--

COMMENT ON TABLE public.accounts IS 'Financial account registry for transaction tracking';


--
-- Name: accounts_account_id_seq; Type: SEQUENCE; Schema: public; Owner: root
--

CREATE SEQUENCE public.accounts_account_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.accounts_account_id_seq OWNER TO root;

--
-- Name: accounts_account_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: root
--

ALTER SEQUENCE public.accounts_account_id_seq OWNED BY public.accounts.account_id;


--
-- Name: budgets; Type: TABLE; Schema: public; Owner: root
--

CREATE TABLE public.budgets (
    budget_id character varying(100) NOT NULL,
    budget_year integer NOT NULL,
    budget_month integer NOT NULL,
    type character varying(20) NOT NULL,
    category_id integer NOT NULL,
    budget_amount numeric(12,2) DEFAULT 0.00 NOT NULL,
    alert_threshold integer DEFAULT 100 NOT NULL,
    notes text,
    budget_type character varying(20) NOT NULL,
    priority character varying(20) NOT NULL,
    is_active boolean DEFAULT true,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT budgets_alert_threshold_check CHECK (((alert_threshold >= 0) AND (alert_threshold <= 200))),
    CONSTRAINT budgets_budget_month_check CHECK (((budget_month >= 1) AND (budget_month <= 12))),
    CONSTRAINT budgets_budget_type_check CHECK (((budget_type)::text = ANY ((ARRAY['Fixed'::character varying, 'Variable'::character varying, 'Flexible'::character varying])::text[]))),
    CONSTRAINT budgets_priority_check CHECK (((priority)::text = ANY ((ARRAY['Critical'::character varying, 'High'::character varying, 'Medium'::character varying, 'Low'::character varying])::text[]))),
    CONSTRAINT budgets_type_check CHECK (((type)::text = ANY ((ARRAY['Income'::character varying, 'Expense'::character varying, 'Transfer'::character varying, 'Savings'::character varying])::text[])))
);


ALTER TABLE public.budgets OWNER TO root;

--
-- Name: TABLE budgets; Type: COMMENT; Schema: public; Owner: root
--

COMMENT ON TABLE public.budgets IS 'Monthly budget definitions with alert thresholds and autonomous decision rules';


--
-- Name: categories; Type: TABLE; Schema: public; Owner: root
--

CREATE TABLE public.categories (
    category_id integer NOT NULL,
    category_name character varying(100) NOT NULL,
    subcategory_name character varying(100) NOT NULL,
    category_type character varying(20) NOT NULL,
    is_active boolean DEFAULT true,
    display_order integer DEFAULT 0,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT categories_category_type_check CHECK (((category_type)::text = ANY ((ARRAY['Income'::character varying, 'Expense'::character varying, 'Transfer'::character varying])::text[])))
);


ALTER TABLE public.categories OWNER TO root;

--
-- Name: TABLE categories; Type: COMMENT; Schema: public; Owner: root
--

COMMENT ON TABLE public.categories IS 'Hierarchical category structure for income/expense classification';


--
-- Name: categories_category_id_seq; Type: SEQUENCE; Schema: public; Owner: root
--

CREATE SEQUENCE public.categories_category_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.categories_category_id_seq OWNER TO root;

--
-- Name: categories_category_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: root
--

ALTER SEQUENCE public.categories_category_id_seq OWNED BY public.categories.category_id;


--
-- Name: digital_twin_updates; Type: TABLE; Schema: public; Owner: root
--

CREATE TABLE public.digital_twin_updates (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    entity_type character varying(50) NOT NULL,
    entity_id uuid NOT NULL,
    update_data jsonb NOT NULL,
    source_system character varying(50) NOT NULL,
    update_type character varying(50) NOT NULL,
    created_at timestamp with time zone DEFAULT now(),
    processed_at timestamp with time zone,
    CONSTRAINT valid_entity_type CHECK (((entity_type)::text = ANY ((ARRAY['person'::character varying, 'goal'::character varying, 'health'::character varying, 'training'::character varying, 'finance'::character varying, 'pantry'::character varying])::text[])))
);


ALTER TABLE public.digital_twin_updates OWNER TO root;

--
-- Name: expense_calendar; Type: TABLE; Schema: public; Owner: root
--

CREATE TABLE public.expense_calendar (
    id integer NOT NULL,
    transaction_id character varying(100) NOT NULL,
    name character varying(255) NOT NULL,
    amount numeric(12,2) NOT NULL,
    currency character varying(10) DEFAULT 'PLN'::character varying,
    category character varying(100),
    sub_category character varying(100),
    frequency character varying(50) DEFAULT 'one-time'::character varying,
    expense_date date NOT NULL,
    month integer,
    day integer,
    description text,
    is_paid boolean DEFAULT false,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.expense_calendar OWNER TO root;

--
-- Name: expense_calendar_id_seq; Type: SEQUENCE; Schema: public; Owner: root
--

CREATE SEQUENCE public.expense_calendar_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.expense_calendar_id_seq OWNER TO root;

--
-- Name: expense_calendar_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: root
--

ALTER SEQUENCE public.expense_calendar_id_seq OWNED BY public.expense_calendar.id;


--
-- Name: merchants; Type: TABLE; Schema: public; Owner: root
--

CREATE TABLE public.merchants (
    merchant_id integer NOT NULL,
    merchant_name character varying(100) NOT NULL,
    default_category_id integer,
    data_type character varying(20) NOT NULL,
    is_active boolean DEFAULT true,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT merchants_data_type_check CHECK (((data_type)::text = ANY ((ARRAY['Historical'::character varying, 'Atomic'::character varying])::text[])))
);


ALTER TABLE public.merchants OWNER TO root;

--
-- Name: TABLE merchants; Type: COMMENT; Schema: public; Owner: root
--

COMMENT ON TABLE public.merchants IS 'Merchant registry with auto-classification rules';


--
-- Name: merchants_merchant_id_seq; Type: SEQUENCE; Schema: public; Owner: root
--

CREATE SEQUENCE public.merchants_merchant_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.merchants_merchant_id_seq OWNER TO root;

--
-- Name: merchants_merchant_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: root
--

ALTER SEQUENCE public.merchants_merchant_id_seq OWNED BY public.merchants.merchant_id;


--
-- Name: transactions; Type: TABLE; Schema: public; Owner: root
--

CREATE TABLE public.transactions (
    transaction_id character varying(50) NOT NULL,
    transaction_date date NOT NULL,
    type character varying(20) NOT NULL,
    amount numeric(12,2) NOT NULL,
    currency character varying(3) DEFAULT 'PLN'::character varying,
    merchant_source character varying(100) NOT NULL,
    description text,
    account_id integer,
    category_id integer,
    merchant_id integer,
    data_source character varying(20) DEFAULT 'atomic'::character varying,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT transactions_amount_check CHECK ((amount > (0)::numeric)),
    CONSTRAINT transactions_type_check CHECK (((type)::text = ANY ((ARRAY['Income'::character varying, 'Expense'::character varying, 'Transfer'::character varying])::text[])))
)
PARTITION BY RANGE (transaction_date);


ALTER TABLE public.transactions OWNER TO root;

--
-- Name: TABLE transactions; Type: COMMENT; Schema: public; Owner: root
--

COMMENT ON TABLE public.transactions IS 'Core transaction table partitioned by date for optimal time-series performance';


--
-- Name: transactions_2012; Type: TABLE; Schema: public; Owner: root
--

CREATE TABLE public.transactions_2012 (
    transaction_id character varying(50) NOT NULL,
    transaction_date date NOT NULL,
    type character varying(20) NOT NULL,
    amount numeric(12,2) NOT NULL,
    currency character varying(3) DEFAULT 'PLN'::character varying,
    merchant_source character varying(100) NOT NULL,
    description text,
    account_id integer,
    category_id integer,
    merchant_id integer,
    data_source character varying(20) DEFAULT 'atomic'::character varying,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT transactions_amount_check CHECK ((amount > (0)::numeric)),
    CONSTRAINT transactions_type_check CHECK (((type)::text = ANY ((ARRAY['Income'::character varying, 'Expense'::character varying, 'Transfer'::character varying])::text[])))
);


ALTER TABLE public.transactions_2012 OWNER TO root;

--
-- Name: transactions_2013; Type: TABLE; Schema: public; Owner: root
--

CREATE TABLE public.transactions_2013 (
    transaction_id character varying(50) NOT NULL,
    transaction_date date NOT NULL,
    type character varying(20) NOT NULL,
    amount numeric(12,2) NOT NULL,
    currency character varying(3) DEFAULT 'PLN'::character varying,
    merchant_source character varying(100) NOT NULL,
    description text,
    account_id integer,
    category_id integer,
    merchant_id integer,
    data_source character varying(20) DEFAULT 'atomic'::character varying,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT transactions_amount_check CHECK ((amount > (0)::numeric)),
    CONSTRAINT transactions_type_check CHECK (((type)::text = ANY ((ARRAY['Income'::character varying, 'Expense'::character varying, 'Transfer'::character varying])::text[])))
);


ALTER TABLE public.transactions_2013 OWNER TO root;

--
-- Name: transactions_2014; Type: TABLE; Schema: public; Owner: root
--

CREATE TABLE public.transactions_2014 (
    transaction_id character varying(50) NOT NULL,
    transaction_date date NOT NULL,
    type character varying(20) NOT NULL,
    amount numeric(12,2) NOT NULL,
    currency character varying(3) DEFAULT 'PLN'::character varying,
    merchant_source character varying(100) NOT NULL,
    description text,
    account_id integer,
    category_id integer,
    merchant_id integer,
    data_source character varying(20) DEFAULT 'atomic'::character varying,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT transactions_amount_check CHECK ((amount > (0)::numeric)),
    CONSTRAINT transactions_type_check CHECK (((type)::text = ANY ((ARRAY['Income'::character varying, 'Expense'::character varying, 'Transfer'::character varying])::text[])))
);


ALTER TABLE public.transactions_2014 OWNER TO root;

--
-- Name: transactions_2015; Type: TABLE; Schema: public; Owner: root
--

CREATE TABLE public.transactions_2015 (
    transaction_id character varying(50) NOT NULL,
    transaction_date date NOT NULL,
    type character varying(20) NOT NULL,
    amount numeric(12,2) NOT NULL,
    currency character varying(3) DEFAULT 'PLN'::character varying,
    merchant_source character varying(100) NOT NULL,
    description text,
    account_id integer,
    category_id integer,
    merchant_id integer,
    data_source character varying(20) DEFAULT 'atomic'::character varying,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT transactions_amount_check CHECK ((amount > (0)::numeric)),
    CONSTRAINT transactions_type_check CHECK (((type)::text = ANY ((ARRAY['Income'::character varying, 'Expense'::character varying, 'Transfer'::character varying])::text[])))
);


ALTER TABLE public.transactions_2015 OWNER TO root;

--
-- Name: transactions_2016; Type: TABLE; Schema: public; Owner: root
--

CREATE TABLE public.transactions_2016 (
    transaction_id character varying(50) NOT NULL,
    transaction_date date NOT NULL,
    type character varying(20) NOT NULL,
    amount numeric(12,2) NOT NULL,
    currency character varying(3) DEFAULT 'PLN'::character varying,
    merchant_source character varying(100) NOT NULL,
    description text,
    account_id integer,
    category_id integer,
    merchant_id integer,
    data_source character varying(20) DEFAULT 'atomic'::character varying,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT transactions_amount_check CHECK ((amount > (0)::numeric)),
    CONSTRAINT transactions_type_check CHECK (((type)::text = ANY ((ARRAY['Income'::character varying, 'Expense'::character varying, 'Transfer'::character varying])::text[])))
);


ALTER TABLE public.transactions_2016 OWNER TO root;

--
-- Name: transactions_2017; Type: TABLE; Schema: public; Owner: root
--

CREATE TABLE public.transactions_2017 (
    transaction_id character varying(50) NOT NULL,
    transaction_date date NOT NULL,
    type character varying(20) NOT NULL,
    amount numeric(12,2) NOT NULL,
    currency character varying(3) DEFAULT 'PLN'::character varying,
    merchant_source character varying(100) NOT NULL,
    description text,
    account_id integer,
    category_id integer,
    merchant_id integer,
    data_source character varying(20) DEFAULT 'atomic'::character varying,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT transactions_amount_check CHECK ((amount > (0)::numeric)),
    CONSTRAINT transactions_type_check CHECK (((type)::text = ANY ((ARRAY['Income'::character varying, 'Expense'::character varying, 'Transfer'::character varying])::text[])))
);


ALTER TABLE public.transactions_2017 OWNER TO root;

--
-- Name: transactions_2018; Type: TABLE; Schema: public; Owner: root
--

CREATE TABLE public.transactions_2018 (
    transaction_id character varying(50) NOT NULL,
    transaction_date date NOT NULL,
    type character varying(20) NOT NULL,
    amount numeric(12,2) NOT NULL,
    currency character varying(3) DEFAULT 'PLN'::character varying,
    merchant_source character varying(100) NOT NULL,
    description text,
    account_id integer,
    category_id integer,
    merchant_id integer,
    data_source character varying(20) DEFAULT 'atomic'::character varying,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT transactions_amount_check CHECK ((amount > (0)::numeric)),
    CONSTRAINT transactions_type_check CHECK (((type)::text = ANY ((ARRAY['Income'::character varying, 'Expense'::character varying, 'Transfer'::character varying])::text[])))
);


ALTER TABLE public.transactions_2018 OWNER TO root;

--
-- Name: transactions_2019; Type: TABLE; Schema: public; Owner: root
--

CREATE TABLE public.transactions_2019 (
    transaction_id character varying(50) NOT NULL,
    transaction_date date NOT NULL,
    type character varying(20) NOT NULL,
    amount numeric(12,2) NOT NULL,
    currency character varying(3) DEFAULT 'PLN'::character varying,
    merchant_source character varying(100) NOT NULL,
    description text,
    account_id integer,
    category_id integer,
    merchant_id integer,
    data_source character varying(20) DEFAULT 'atomic'::character varying,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT transactions_amount_check CHECK ((amount > (0)::numeric)),
    CONSTRAINT transactions_type_check CHECK (((type)::text = ANY ((ARRAY['Income'::character varying, 'Expense'::character varying, 'Transfer'::character varying])::text[])))
);


ALTER TABLE public.transactions_2019 OWNER TO root;

--
-- Name: transactions_2020; Type: TABLE; Schema: public; Owner: root
--

CREATE TABLE public.transactions_2020 (
    transaction_id character varying(50) NOT NULL,
    transaction_date date NOT NULL,
    type character varying(20) NOT NULL,
    amount numeric(12,2) NOT NULL,
    currency character varying(3) DEFAULT 'PLN'::character varying,
    merchant_source character varying(100) NOT NULL,
    description text,
    account_id integer,
    category_id integer,
    merchant_id integer,
    data_source character varying(20) DEFAULT 'atomic'::character varying,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT transactions_amount_check CHECK ((amount > (0)::numeric)),
    CONSTRAINT transactions_type_check CHECK (((type)::text = ANY ((ARRAY['Income'::character varying, 'Expense'::character varying, 'Transfer'::character varying])::text[])))
);


ALTER TABLE public.transactions_2020 OWNER TO root;

--
-- Name: transactions_2021; Type: TABLE; Schema: public; Owner: root
--

CREATE TABLE public.transactions_2021 (
    transaction_id character varying(50) NOT NULL,
    transaction_date date NOT NULL,
    type character varying(20) NOT NULL,
    amount numeric(12,2) NOT NULL,
    currency character varying(3) DEFAULT 'PLN'::character varying,
    merchant_source character varying(100) NOT NULL,
    description text,
    account_id integer,
    category_id integer,
    merchant_id integer,
    data_source character varying(20) DEFAULT 'atomic'::character varying,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT transactions_amount_check CHECK ((amount > (0)::numeric)),
    CONSTRAINT transactions_type_check CHECK (((type)::text = ANY ((ARRAY['Income'::character varying, 'Expense'::character varying, 'Transfer'::character varying])::text[])))
);


ALTER TABLE public.transactions_2021 OWNER TO root;

--
-- Name: transactions_2022; Type: TABLE; Schema: public; Owner: root
--

CREATE TABLE public.transactions_2022 (
    transaction_id character varying(50) NOT NULL,
    transaction_date date NOT NULL,
    type character varying(20) NOT NULL,
    amount numeric(12,2) NOT NULL,
    currency character varying(3) DEFAULT 'PLN'::character varying,
    merchant_source character varying(100) NOT NULL,
    description text,
    account_id integer,
    category_id integer,
    merchant_id integer,
    data_source character varying(20) DEFAULT 'atomic'::character varying,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT transactions_amount_check CHECK ((amount > (0)::numeric)),
    CONSTRAINT transactions_type_check CHECK (((type)::text = ANY ((ARRAY['Income'::character varying, 'Expense'::character varying, 'Transfer'::character varying])::text[])))
);


ALTER TABLE public.transactions_2022 OWNER TO root;

--
-- Name: transactions_2023; Type: TABLE; Schema: public; Owner: root
--

CREATE TABLE public.transactions_2023 (
    transaction_id character varying(50) NOT NULL,
    transaction_date date NOT NULL,
    type character varying(20) NOT NULL,
    amount numeric(12,2) NOT NULL,
    currency character varying(3) DEFAULT 'PLN'::character varying,
    merchant_source character varying(100) NOT NULL,
    description text,
    account_id integer,
    category_id integer,
    merchant_id integer,
    data_source character varying(20) DEFAULT 'atomic'::character varying,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT transactions_amount_check CHECK ((amount > (0)::numeric)),
    CONSTRAINT transactions_type_check CHECK (((type)::text = ANY ((ARRAY['Income'::character varying, 'Expense'::character varying, 'Transfer'::character varying])::text[])))
);


ALTER TABLE public.transactions_2023 OWNER TO root;

--
-- Name: transactions_2024; Type: TABLE; Schema: public; Owner: root
--

CREATE TABLE public.transactions_2024 (
    transaction_id character varying(50) NOT NULL,
    transaction_date date NOT NULL,
    type character varying(20) NOT NULL,
    amount numeric(12,2) NOT NULL,
    currency character varying(3) DEFAULT 'PLN'::character varying,
    merchant_source character varying(100) NOT NULL,
    description text,
    account_id integer,
    category_id integer,
    merchant_id integer,
    data_source character varying(20) DEFAULT 'atomic'::character varying,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT transactions_amount_check CHECK ((amount > (0)::numeric)),
    CONSTRAINT transactions_type_check CHECK (((type)::text = ANY ((ARRAY['Income'::character varying, 'Expense'::character varying, 'Transfer'::character varying])::text[])))
);


ALTER TABLE public.transactions_2024 OWNER TO root;

--
-- Name: transactions_2025; Type: TABLE; Schema: public; Owner: root
--

CREATE TABLE public.transactions_2025 (
    transaction_id character varying(50) NOT NULL,
    transaction_date date NOT NULL,
    type character varying(20) NOT NULL,
    amount numeric(12,2) NOT NULL,
    currency character varying(3) DEFAULT 'PLN'::character varying,
    merchant_source character varying(100) NOT NULL,
    description text,
    account_id integer,
    category_id integer,
    merchant_id integer,
    data_source character varying(20) DEFAULT 'atomic'::character varying,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT transactions_amount_check CHECK ((amount > (0)::numeric)),
    CONSTRAINT transactions_type_check CHECK (((type)::text = ANY ((ARRAY['Income'::character varying, 'Expense'::character varying, 'Transfer'::character varying])::text[])))
);


ALTER TABLE public.transactions_2025 OWNER TO root;

--
-- Name: transactions_2026; Type: TABLE; Schema: public; Owner: root
--

CREATE TABLE public.transactions_2026 (
    transaction_id character varying(50) NOT NULL,
    transaction_date date NOT NULL,
    type character varying(20) NOT NULL,
    amount numeric(12,2) NOT NULL,
    currency character varying(3) DEFAULT 'PLN'::character varying,
    merchant_source character varying(100) NOT NULL,
    description text,
    account_id integer,
    category_id integer,
    merchant_id integer,
    data_source character varying(20) DEFAULT 'atomic'::character varying,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT transactions_amount_check CHECK ((amount > (0)::numeric)),
    CONSTRAINT transactions_type_check CHECK (((type)::text = ANY ((ARRAY['Income'::character varying, 'Expense'::character varying, 'Transfer'::character varying])::text[])))
);


ALTER TABLE public.transactions_2026 OWNER TO root;

--
-- Name: transactions_2027; Type: TABLE; Schema: public; Owner: root
--

CREATE TABLE public.transactions_2027 (
    transaction_id character varying(50) NOT NULL,
    transaction_date date NOT NULL,
    type character varying(20) NOT NULL,
    amount numeric(12,2) NOT NULL,
    currency character varying(3) DEFAULT 'PLN'::character varying,
    merchant_source character varying(100) NOT NULL,
    description text,
    account_id integer,
    category_id integer,
    merchant_id integer,
    data_source character varying(20) DEFAULT 'atomic'::character varying,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT transactions_amount_check CHECK ((amount > (0)::numeric)),
    CONSTRAINT transactions_type_check CHECK (((type)::text = ANY ((ARRAY['Income'::character varying, 'Expense'::character varying, 'Transfer'::character varying])::text[])))
);


ALTER TABLE public.transactions_2027 OWNER TO root;

--
-- Name: transactions_default; Type: TABLE; Schema: public; Owner: root
--

CREATE TABLE public.transactions_default (
    transaction_id character varying(50) NOT NULL,
    transaction_date date NOT NULL,
    type character varying(20) NOT NULL,
    amount numeric(12,2) NOT NULL,
    currency character varying(3) DEFAULT 'PLN'::character varying,
    merchant_source character varying(100) NOT NULL,
    description text,
    account_id integer,
    category_id integer,
    merchant_id integer,
    data_source character varying(20) DEFAULT 'atomic'::character varying,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT transactions_amount_check CHECK ((amount > (0)::numeric)),
    CONSTRAINT transactions_type_check CHECK (((type)::text = ANY ((ARRAY['Income'::character varying, 'Expense'::character varying, 'Transfer'::character varying])::text[])))
);


ALTER TABLE public.transactions_default OWNER TO root;

--
-- Name: upcoming_expenses; Type: TABLE; Schema: public; Owner: root
--

CREATE TABLE public.upcoming_expenses (
    id integer NOT NULL,
    transaction_id character varying(50) NOT NULL,
    expense_date date NOT NULL,
    name character varying(255) NOT NULL,
    amount numeric(10,2) NOT NULL,
    currency character varying(3) DEFAULT 'PLN'::character varying,
    frequency character varying(20),
    description text,
    category character varying(100) DEFAULT 'UNCATEGORIZED'::character varying,
    sub_category character varying(100) DEFAULT 'UNCATEGORIZED'::character varying,
    source character varying(20) DEFAULT 'google_sheets'::character varying,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT upcoming_expenses_frequency_check CHECK (((frequency)::text = ANY ((ARRAY['monthly'::character varying, 'quarterly'::character varying, 'annual'::character varying, 'one-time'::character varying])::text[])))
);


ALTER TABLE public.upcoming_expenses OWNER TO root;

--
-- Name: upcoming_expenses_id_seq; Type: SEQUENCE; Schema: public; Owner: root
--

CREATE SEQUENCE public.upcoming_expenses_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.upcoming_expenses_id_seq OWNER TO root;

--
-- Name: upcoming_expenses_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: root
--

ALTER SEQUENCE public.upcoming_expenses_id_seq OWNED BY public.upcoming_expenses.id;


--
-- Name: v_annual_summary; Type: VIEW; Schema: public; Owner: root
--

CREATE VIEW public.v_annual_summary AS
 SELECT EXTRACT(year FROM transaction_date) AS year,
    sum(
        CASE
            WHEN ((type)::text = 'Income'::text) THEN amount
            ELSE (0)::numeric
        END) AS total_income,
    sum(
        CASE
            WHEN ((type)::text = 'Expense'::text) THEN amount
            ELSE (0)::numeric
        END) AS total_expense,
    sum(
        CASE
            WHEN ((type)::text = 'Income'::text) THEN amount
            WHEN ((type)::text = 'Expense'::text) THEN (- amount)
            ELSE (0)::numeric
        END) AS net_savings
   FROM public.transactions
  GROUP BY (EXTRACT(year FROM transaction_date))
  ORDER BY (EXTRACT(year FROM transaction_date));


ALTER VIEW public.v_annual_summary OWNER TO root;

--
-- Name: v_budget_performance; Type: VIEW; Schema: public; Owner: root
--

CREATE VIEW public.v_budget_performance AS
 SELECT b.budget_year,
    b.budget_month,
    (((c.category_name)::text || ' > '::text) || (c.subcategory_name)::text) AS category_path,
    c.category_name,
    b.budget_amount,
    b.alert_threshold,
    b.priority,
    COALESCE(sum(t.amount), (0)::numeric) AS actual_amount,
    (b.budget_amount - COALESCE(sum(t.amount), (0)::numeric)) AS remaining_amount,
        CASE
            WHEN (b.budget_amount > (0)::numeric) THEN round(((COALESCE(sum(t.amount), (0)::numeric) / b.budget_amount) * (100)::numeric), 2)
            ELSE (0)::numeric
        END AS utilization_pct,
        CASE
            WHEN (((b.budget_year)::numeric = EXTRACT(year FROM CURRENT_DATE)) AND ((b.budget_month)::numeric = EXTRACT(month FROM CURRENT_DATE))) THEN round((b.budget_amount * (EXTRACT(day FROM CURRENT_DATE) / EXTRACT(day FROM ((date_trunc('MONTH'::text, (CURRENT_DATE)::timestamp with time zone) + '1 mon'::interval) - '1 day'::interval)))), 2)
            ELSE NULL::numeric
        END AS expected_burn_today,
        CASE
            WHEN (COALESCE(sum(t.amount), (0)::numeric) > b.budget_amount) THEN 'OVER_BUDGET'::text
            WHEN ((b.budget_amount > (0)::numeric) AND (((COALESCE(sum(t.amount), (0)::numeric) / b.budget_amount) * (100)::numeric) >= (b.alert_threshold)::numeric)) THEN 'WARNING'::text
            WHEN (COALESCE(sum(t.amount), (0)::numeric) = (0)::numeric) THEN 'UNUSED'::text
            ELSE 'ON_TRACK'::text
        END AS budget_status
   FROM ((public.budgets b
     JOIN public.categories c ON ((b.category_id = c.category_id)))
     LEFT JOIN public.transactions t ON (((t.category_id = b.category_id) AND (EXTRACT(year FROM t.transaction_date) = (b.budget_year)::numeric) AND (EXTRACT(month FROM t.transaction_date) = (b.budget_month)::numeric) AND ((t.type)::text = (b.type)::text))))
  WHERE (b.is_active = true)
  GROUP BY b.budget_year, b.budget_month, c.category_name, c.subcategory_name, b.budget_amount, b.alert_threshold, b.priority
  ORDER BY b.budget_year DESC, b.budget_month DESC,
        CASE
            WHEN (b.budget_amount > (0)::numeric) THEN round(((COALESCE(sum(t.amount), (0)::numeric) / b.budget_amount) * (100)::numeric), 2)
            ELSE (0)::numeric
        END DESC;


ALTER VIEW public.v_budget_performance OWNER TO root;

--
-- Name: v_daily_cashflow; Type: VIEW; Schema: public; Owner: root
--

CREATE VIEW public.v_daily_cashflow AS
 SELECT transaction_date AS date,
    sum(
        CASE
            WHEN ((type)::text = 'Income'::text) THEN amount
            ELSE (0)::numeric
        END) AS daily_income,
    sum(
        CASE
            WHEN ((type)::text = 'Expense'::text) THEN amount
            ELSE (0)::numeric
        END) AS daily_expense,
    sum(
        CASE
            WHEN ((type)::text = 'Income'::text) THEN amount
            ELSE (- amount)
        END) AS daily_net,
    sum(sum(
        CASE
            WHEN ((type)::text = 'Income'::text) THEN amount
            ELSE (- amount)
        END)) OVER (PARTITION BY (EXTRACT(year FROM transaction_date)), (EXTRACT(month FROM transaction_date)) ORDER BY transaction_date) AS month_to_date_net
   FROM public.transactions
  WHERE ((transaction_date >= (CURRENT_DATE - '90 days'::interval)) AND ((type)::text = ANY ((ARRAY['Income'::character varying, 'Expense'::character varying])::text[])))
  GROUP BY transaction_date
  ORDER BY transaction_date DESC;


ALTER VIEW public.v_daily_cashflow OWNER TO root;

--
-- Name: v_monthly_category_spending; Type: VIEW; Schema: public; Owner: root
--

CREATE VIEW public.v_monthly_category_spending AS
 SELECT date_trunc('month'::text, (t.transaction_date)::timestamp with time zone) AS period_date,
    c.category_name,
    sum(t.amount) AS total_spent
   FROM (public.transactions t
     JOIN public.categories c ON ((t.category_id = c.category_id)))
  WHERE ((t.type)::text = 'Expense'::text)
  GROUP BY (date_trunc('month'::text, (t.transaction_date)::timestamp with time zone)), c.category_name
  ORDER BY (date_trunc('month'::text, (t.transaction_date)::timestamp with time zone)), c.category_name;


ALTER VIEW public.v_monthly_category_spending OWNER TO root;

--
-- Name: v_monthly_merchant_spending; Type: VIEW; Schema: public; Owner: root
--

CREATE VIEW public.v_monthly_merchant_spending AS
 SELECT date_trunc('month'::text, (t.transaction_date)::timestamp with time zone) AS period_date,
    m.merchant_name,
    sum(t.amount) AS total_spent
   FROM (public.transactions t
     JOIN public.merchants m ON ((t.merchant_id = m.merchant_id)))
  WHERE ((t.type)::text = 'Expense'::text)
  GROUP BY (date_trunc('month'::text, (t.transaction_date)::timestamp with time zone)), m.merchant_name
  ORDER BY (date_trunc('month'::text, (t.transaction_date)::timestamp with time zone)), m.merchant_name;


ALTER VIEW public.v_monthly_merchant_spending OWNER TO root;

--
-- Name: v_monthly_pnl; Type: VIEW; Schema: public; Owner: root
--

CREATE VIEW public.v_monthly_pnl AS
 SELECT EXTRACT(year FROM transaction_date) AS year,
    EXTRACT(month FROM transaction_date) AS month,
    to_char((transaction_date)::timestamp with time zone, 'YYYY-MM'::text) AS period,
    date_trunc('MONTH'::text, (transaction_date)::timestamp with time zone) AS period_date,
    sum(
        CASE
            WHEN ((type)::text = 'Income'::text) THEN amount
            ELSE (0)::numeric
        END) AS total_income,
    sum(
        CASE
            WHEN ((type)::text = 'Expense'::text) THEN amount
            ELSE (0)::numeric
        END) AS total_expense,
    sum(
        CASE
            WHEN ((type)::text = 'Income'::text) THEN amount
            ELSE (- amount)
        END) AS net_savings,
        CASE
            WHEN (sum(
            CASE
                WHEN ((type)::text = 'Income'::text) THEN amount
                ELSE (0)::numeric
            END) > (0)::numeric) THEN round(((sum(
            CASE
                WHEN ((type)::text = 'Income'::text) THEN amount
                ELSE (- amount)
            END) / sum(
            CASE
                WHEN ((type)::text = 'Income'::text) THEN amount
                ELSE (0)::numeric
            END)) * (100)::numeric), 2)
            ELSE (0)::numeric
        END AS savings_rate_pct,
    count(*) AS transaction_count,
    count(DISTINCT transaction_date) AS active_days
   FROM public.transactions
  WHERE ((type)::text = ANY ((ARRAY['Income'::character varying, 'Expense'::character varying])::text[]))
  GROUP BY (EXTRACT(year FROM transaction_date)), (EXTRACT(month FROM transaction_date)), (to_char((transaction_date)::timestamp with time zone, 'YYYY-MM'::text)), (date_trunc('MONTH'::text, (transaction_date)::timestamp with time zone))
  ORDER BY (EXTRACT(year FROM transaction_date)) DESC, (EXTRACT(month FROM transaction_date)) DESC;


ALTER VIEW public.v_monthly_pnl OWNER TO root;

--
-- Name: v_upcoming_30_days; Type: VIEW; Schema: public; Owner: root
--

CREATE VIEW public.v_upcoming_30_days AS
 SELECT id,
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
            WHEN ((frequency)::text = 'monthly'::text) THEN (expense_date + '1 mon'::interval)
            WHEN ((frequency)::text = 'quarterly'::text) THEN (expense_date + '3 mons'::interval)
            WHEN ((frequency)::text = 'annual'::text) THEN (expense_date + '1 year'::interval)
            ELSE (expense_date)::timestamp without time zone
        END AS next_occurrence,
        CASE EXTRACT(month FROM expense_date)
            WHEN 1 THEN 'sty'::text
            WHEN 2 THEN 'lut'::text
            WHEN 3 THEN 'mar'::text
            WHEN 4 THEN 'kwi'::text
            WHEN 5 THEN 'maj'::text
            WHEN 6 THEN 'cze'::text
            WHEN 7 THEN 'lip'::text
            WHEN 8 THEN 'sie'::text
            WHEN 9 THEN 'wrz'::text
            WHEN 10 THEN 'paź'::text
            WHEN 11 THEN 'lis'::text
            WHEN 12 THEN 'gru'::text
            ELSE NULL::text
        END AS month_name,
    (EXTRACT(day FROM expense_date))::integer AS day
   FROM public.upcoming_expenses
  WHERE ((expense_date <= (CURRENT_DATE + '30 days'::interval)) AND (expense_date >= CURRENT_DATE))
  ORDER BY expense_date;


ALTER VIEW public.v_upcoming_30_days OWNER TO root;

--
-- Name: v_upcoming_expenses; Type: VIEW; Schema: public; Owner: root
--

CREATE VIEW public.v_upcoming_expenses AS
 SELECT id,
    transaction_id,
    name,
    amount,
    currency,
    category,
    sub_category,
    frequency,
    expense_date,
    to_char((expense_date)::timestamp with time zone, 'FMMonth'::text) AS month_name,
    (EXTRACT(day FROM expense_date))::integer AS day_of_month,
        CASE
            WHEN (expense_date = CURRENT_DATE) THEN 'today'::text
            WHEN (expense_date = (CURRENT_DATE + 1)) THEN 'tomorrow'::text
            WHEN (expense_date <= (CURRENT_DATE + 7)) THEN 'this_week'::text
            ELSE 'later'::text
        END AS urgency,
    (expense_date - CURRENT_DATE) AS days_until,
    is_paid
   FROM public.expense_calendar
  WHERE ((expense_date >= CURRENT_DATE) AND (expense_date <= (CURRENT_DATE + 30)) AND (is_paid = false))
  ORDER BY expense_date;


ALTER VIEW public.v_upcoming_expenses OWNER TO root;

--
-- Name: transactions_2012; Type: TABLE ATTACH; Schema: public; Owner: root
--

ALTER TABLE ONLY public.transactions ATTACH PARTITION public.transactions_2012 FOR VALUES FROM ('2012-01-01') TO ('2013-01-01');


--
-- Name: transactions_2013; Type: TABLE ATTACH; Schema: public; Owner: root
--

ALTER TABLE ONLY public.transactions ATTACH PARTITION public.transactions_2013 FOR VALUES FROM ('2013-01-01') TO ('2014-01-01');


--
-- Name: transactions_2014; Type: TABLE ATTACH; Schema: public; Owner: root
--

ALTER TABLE ONLY public.transactions ATTACH PARTITION public.transactions_2014 FOR VALUES FROM ('2014-01-01') TO ('2015-01-01');


--
-- Name: transactions_2015; Type: TABLE ATTACH; Schema: public; Owner: root
--

ALTER TABLE ONLY public.transactions ATTACH PARTITION public.transactions_2015 FOR VALUES FROM ('2015-01-01') TO ('2016-01-01');


--
-- Name: transactions_2016; Type: TABLE ATTACH; Schema: public; Owner: root
--

ALTER TABLE ONLY public.transactions ATTACH PARTITION public.transactions_2016 FOR VALUES FROM ('2016-01-01') TO ('2017-01-01');


--
-- Name: transactions_2017; Type: TABLE ATTACH; Schema: public; Owner: root
--

ALTER TABLE ONLY public.transactions ATTACH PARTITION public.transactions_2017 FOR VALUES FROM ('2017-01-01') TO ('2018-01-01');


--
-- Name: transactions_2018; Type: TABLE ATTACH; Schema: public; Owner: root
--

ALTER TABLE ONLY public.transactions ATTACH PARTITION public.transactions_2018 FOR VALUES FROM ('2018-01-01') TO ('2019-01-01');


--
-- Name: transactions_2019; Type: TABLE ATTACH; Schema: public; Owner: root
--

ALTER TABLE ONLY public.transactions ATTACH PARTITION public.transactions_2019 FOR VALUES FROM ('2019-01-01') TO ('2020-01-01');


--
-- Name: transactions_2020; Type: TABLE ATTACH; Schema: public; Owner: root
--

ALTER TABLE ONLY public.transactions ATTACH PARTITION public.transactions_2020 FOR VALUES FROM ('2020-01-01') TO ('2021-01-01');


--
-- Name: transactions_2021; Type: TABLE ATTACH; Schema: public; Owner: root
--

ALTER TABLE ONLY public.transactions ATTACH PARTITION public.transactions_2021 FOR VALUES FROM ('2021-01-01') TO ('2022-01-01');


--
-- Name: transactions_2022; Type: TABLE ATTACH; Schema: public; Owner: root
--

ALTER TABLE ONLY public.transactions ATTACH PARTITION public.transactions_2022 FOR VALUES FROM ('2022-01-01') TO ('2023-01-01');


--
-- Name: transactions_2023; Type: TABLE ATTACH; Schema: public; Owner: root
--

ALTER TABLE ONLY public.transactions ATTACH PARTITION public.transactions_2023 FOR VALUES FROM ('2023-01-01') TO ('2024-01-01');


--
-- Name: transactions_2024; Type: TABLE ATTACH; Schema: public; Owner: root
--

ALTER TABLE ONLY public.transactions ATTACH PARTITION public.transactions_2024 FOR VALUES FROM ('2024-01-01') TO ('2025-01-01');


--
-- Name: transactions_2025; Type: TABLE ATTACH; Schema: public; Owner: root
--

ALTER TABLE ONLY public.transactions ATTACH PARTITION public.transactions_2025 FOR VALUES FROM ('2025-01-01') TO ('2026-01-01');


--
-- Name: transactions_2026; Type: TABLE ATTACH; Schema: public; Owner: root
--

ALTER TABLE ONLY public.transactions ATTACH PARTITION public.transactions_2026 FOR VALUES FROM ('2026-01-01') TO ('2027-01-01');


--
-- Name: transactions_2027; Type: TABLE ATTACH; Schema: public; Owner: root
--

ALTER TABLE ONLY public.transactions ATTACH PARTITION public.transactions_2027 FOR VALUES FROM ('2027-01-01') TO ('2028-01-01');


--
-- Name: transactions_default; Type: TABLE ATTACH; Schema: public; Owner: root
--

ALTER TABLE ONLY public.transactions ATTACH PARTITION public.transactions_default DEFAULT;


--
-- Name: accounts account_id; Type: DEFAULT; Schema: public; Owner: root
--

ALTER TABLE ONLY public.accounts ALTER COLUMN account_id SET DEFAULT nextval('public.accounts_account_id_seq'::regclass);


--
-- Name: categories category_id; Type: DEFAULT; Schema: public; Owner: root
--

ALTER TABLE ONLY public.categories ALTER COLUMN category_id SET DEFAULT nextval('public.categories_category_id_seq'::regclass);


--
-- Name: expense_calendar id; Type: DEFAULT; Schema: public; Owner: root
--

ALTER TABLE ONLY public.expense_calendar ALTER COLUMN id SET DEFAULT nextval('public.expense_calendar_id_seq'::regclass);


--
-- Name: merchants merchant_id; Type: DEFAULT; Schema: public; Owner: root
--

ALTER TABLE ONLY public.merchants ALTER COLUMN merchant_id SET DEFAULT nextval('public.merchants_merchant_id_seq'::regclass);


--
-- Name: upcoming_expenses id; Type: DEFAULT; Schema: public; Owner: root
--

ALTER TABLE ONLY public.upcoming_expenses ALTER COLUMN id SET DEFAULT nextval('public.upcoming_expenses_id_seq'::regclass);


--
-- Name: accounts accounts_account_name_key; Type: CONSTRAINT; Schema: public; Owner: root
--

ALTER TABLE ONLY public.accounts
    ADD CONSTRAINT accounts_account_name_key UNIQUE (account_name);


--
-- Name: accounts accounts_pkey; Type: CONSTRAINT; Schema: public; Owner: root
--

ALTER TABLE ONLY public.accounts
    ADD CONSTRAINT accounts_pkey PRIMARY KEY (account_id);


--
-- Name: budgets budgets_budget_year_budget_month_category_id_type_budget_id_key; Type: CONSTRAINT; Schema: public; Owner: root
--

ALTER TABLE ONLY public.budgets
    ADD CONSTRAINT budgets_budget_year_budget_month_category_id_type_budget_id_key UNIQUE (budget_year, budget_month, category_id, type, budget_id);


--
-- Name: budgets budgets_pkey; Type: CONSTRAINT; Schema: public; Owner: root
--

ALTER TABLE ONLY public.budgets
    ADD CONSTRAINT budgets_pkey PRIMARY KEY (budget_id);


--
-- Name: categories categories_category_name_subcategory_name_key; Type: CONSTRAINT; Schema: public; Owner: root
--

ALTER TABLE ONLY public.categories
    ADD CONSTRAINT categories_category_name_subcategory_name_key UNIQUE (category_name, subcategory_name);


--
-- Name: categories categories_pkey; Type: CONSTRAINT; Schema: public; Owner: root
--

ALTER TABLE ONLY public.categories
    ADD CONSTRAINT categories_pkey PRIMARY KEY (category_id);


--
-- Name: digital_twin_updates digital_twin_updates_pkey; Type: CONSTRAINT; Schema: public; Owner: root
--

ALTER TABLE ONLY public.digital_twin_updates
    ADD CONSTRAINT digital_twin_updates_pkey PRIMARY KEY (id);


--
-- Name: expense_calendar expense_calendar_pkey; Type: CONSTRAINT; Schema: public; Owner: root
--

ALTER TABLE ONLY public.expense_calendar
    ADD CONSTRAINT expense_calendar_pkey PRIMARY KEY (id);


--
-- Name: expense_calendar expense_calendar_transaction_id_key; Type: CONSTRAINT; Schema: public; Owner: root
--

ALTER TABLE ONLY public.expense_calendar
    ADD CONSTRAINT expense_calendar_transaction_id_key UNIQUE (transaction_id);


--
-- Name: merchants merchants_merchant_name_key; Type: CONSTRAINT; Schema: public; Owner: root
--

ALTER TABLE ONLY public.merchants
    ADD CONSTRAINT merchants_merchant_name_key UNIQUE (merchant_name);


--
-- Name: merchants merchants_pkey; Type: CONSTRAINT; Schema: public; Owner: root
--

ALTER TABLE ONLY public.merchants
    ADD CONSTRAINT merchants_pkey PRIMARY KEY (merchant_id);


--
-- Name: transactions transactions_pkey; Type: CONSTRAINT; Schema: public; Owner: root
--

ALTER TABLE ONLY public.transactions
    ADD CONSTRAINT transactions_pkey PRIMARY KEY (transaction_id, transaction_date);


--
-- Name: transactions_2012 transactions_2012_pkey; Type: CONSTRAINT; Schema: public; Owner: root
--

ALTER TABLE ONLY public.transactions_2012
    ADD CONSTRAINT transactions_2012_pkey PRIMARY KEY (transaction_id, transaction_date);


--
-- Name: transactions_2013 transactions_2013_pkey; Type: CONSTRAINT; Schema: public; Owner: root
--

ALTER TABLE ONLY public.transactions_2013
    ADD CONSTRAINT transactions_2013_pkey PRIMARY KEY (transaction_id, transaction_date);


--
-- Name: transactions_2014 transactions_2014_pkey; Type: CONSTRAINT; Schema: public; Owner: root
--

ALTER TABLE ONLY public.transactions_2014
    ADD CONSTRAINT transactions_2014_pkey PRIMARY KEY (transaction_id, transaction_date);


--
-- Name: transactions_2015 transactions_2015_pkey; Type: CONSTRAINT; Schema: public; Owner: root
--

ALTER TABLE ONLY public.transactions_2015
    ADD CONSTRAINT transactions_2015_pkey PRIMARY KEY (transaction_id, transaction_date);


--
-- Name: transactions_2016 transactions_2016_pkey; Type: CONSTRAINT; Schema: public; Owner: root
--

ALTER TABLE ONLY public.transactions_2016
    ADD CONSTRAINT transactions_2016_pkey PRIMARY KEY (transaction_id, transaction_date);


--
-- Name: transactions_2017 transactions_2017_pkey; Type: CONSTRAINT; Schema: public; Owner: root
--

ALTER TABLE ONLY public.transactions_2017
    ADD CONSTRAINT transactions_2017_pkey PRIMARY KEY (transaction_id, transaction_date);


--
-- Name: transactions_2018 transactions_2018_pkey; Type: CONSTRAINT; Schema: public; Owner: root
--

ALTER TABLE ONLY public.transactions_2018
    ADD CONSTRAINT transactions_2018_pkey PRIMARY KEY (transaction_id, transaction_date);


--
-- Name: transactions_2019 transactions_2019_pkey; Type: CONSTRAINT; Schema: public; Owner: root
--

ALTER TABLE ONLY public.transactions_2019
    ADD CONSTRAINT transactions_2019_pkey PRIMARY KEY (transaction_id, transaction_date);


--
-- Name: transactions_2020 transactions_2020_pkey; Type: CONSTRAINT; Schema: public; Owner: root
--

ALTER TABLE ONLY public.transactions_2020
    ADD CONSTRAINT transactions_2020_pkey PRIMARY KEY (transaction_id, transaction_date);


--
-- Name: transactions_2021 transactions_2021_pkey; Type: CONSTRAINT; Schema: public; Owner: root
--

ALTER TABLE ONLY public.transactions_2021
    ADD CONSTRAINT transactions_2021_pkey PRIMARY KEY (transaction_id, transaction_date);


--
-- Name: transactions_2022 transactions_2022_pkey; Type: CONSTRAINT; Schema: public; Owner: root
--

ALTER TABLE ONLY public.transactions_2022
    ADD CONSTRAINT transactions_2022_pkey PRIMARY KEY (transaction_id, transaction_date);


--
-- Name: transactions_2023 transactions_2023_pkey; Type: CONSTRAINT; Schema: public; Owner: root
--

ALTER TABLE ONLY public.transactions_2023
    ADD CONSTRAINT transactions_2023_pkey PRIMARY KEY (transaction_id, transaction_date);


--
-- Name: transactions_2024 transactions_2024_pkey; Type: CONSTRAINT; Schema: public; Owner: root
--

ALTER TABLE ONLY public.transactions_2024
    ADD CONSTRAINT transactions_2024_pkey PRIMARY KEY (transaction_id, transaction_date);


--
-- Name: transactions_2025 transactions_2025_pkey; Type: CONSTRAINT; Schema: public; Owner: root
--

ALTER TABLE ONLY public.transactions_2025
    ADD CONSTRAINT transactions_2025_pkey PRIMARY KEY (transaction_id, transaction_date);


--
-- Name: transactions_2026 transactions_2026_pkey; Type: CONSTRAINT; Schema: public; Owner: root
--

ALTER TABLE ONLY public.transactions_2026
    ADD CONSTRAINT transactions_2026_pkey PRIMARY KEY (transaction_id, transaction_date);


--
-- Name: transactions_2027 transactions_2027_pkey; Type: CONSTRAINT; Schema: public; Owner: root
--

ALTER TABLE ONLY public.transactions_2027
    ADD CONSTRAINT transactions_2027_pkey PRIMARY KEY (transaction_id, transaction_date);


--
-- Name: transactions_default transactions_default_pkey; Type: CONSTRAINT; Schema: public; Owner: root
--

ALTER TABLE ONLY public.transactions_default
    ADD CONSTRAINT transactions_default_pkey PRIMARY KEY (transaction_id, transaction_date);


--
-- Name: upcoming_expenses upcoming_expenses_pkey; Type: CONSTRAINT; Schema: public; Owner: root
--

ALTER TABLE ONLY public.upcoming_expenses
    ADD CONSTRAINT upcoming_expenses_pkey PRIMARY KEY (id);


--
-- Name: upcoming_expenses upcoming_expenses_transaction_id_key; Type: CONSTRAINT; Schema: public; Owner: root
--

ALTER TABLE ONLY public.upcoming_expenses
    ADD CONSTRAINT upcoming_expenses_transaction_id_key UNIQUE (transaction_id);


--
-- Name: idx_accounts_type; Type: INDEX; Schema: public; Owner: root
--

CREATE INDEX idx_accounts_type ON public.accounts USING btree (account_type);


--
-- Name: idx_budgets_category; Type: INDEX; Schema: public; Owner: root
--

CREATE INDEX idx_budgets_category ON public.budgets USING btree (category_id);


--
-- Name: idx_budgets_period; Type: INDEX; Schema: public; Owner: root
--

CREATE INDEX idx_budgets_period ON public.budgets USING btree (budget_year, budget_month);


--
-- Name: idx_budgets_priority; Type: INDEX; Schema: public; Owner: root
--

CREATE INDEX idx_budgets_priority ON public.budgets USING btree (priority, is_active);


--
-- Name: idx_budgets_type_active; Type: INDEX; Schema: public; Owner: root
--

CREATE INDEX idx_budgets_type_active ON public.budgets USING btree (type, is_active);


--
-- Name: idx_categories_type; Type: INDEX; Schema: public; Owner: root
--

CREATE INDEX idx_categories_type ON public.categories USING btree (category_type);


--
-- Name: idx_expense_calendar_date; Type: INDEX; Schema: public; Owner: root
--

CREATE INDEX idx_expense_calendar_date ON public.expense_calendar USING btree (expense_date);


--
-- Name: idx_expense_calendar_frequency; Type: INDEX; Schema: public; Owner: root
--

CREATE INDEX idx_expense_calendar_frequency ON public.expense_calendar USING btree (frequency);


--
-- Name: idx_expense_calendar_is_paid; Type: INDEX; Schema: public; Owner: root
--

CREATE INDEX idx_expense_calendar_is_paid ON public.expense_calendar USING btree (is_paid);


--
-- Name: idx_merchants_data_type; Type: INDEX; Schema: public; Owner: root
--

CREATE INDEX idx_merchants_data_type ON public.merchants USING btree (data_type);


--
-- Name: idx_transactions_account; Type: INDEX; Schema: public; Owner: root
--

CREATE INDEX idx_transactions_account ON ONLY public.transactions USING btree (account_id);


--
-- Name: idx_transactions_category; Type: INDEX; Schema: public; Owner: root
--

CREATE INDEX idx_transactions_category ON ONLY public.transactions USING btree (category_id);


--
-- Name: idx_transactions_data_source; Type: INDEX; Schema: public; Owner: root
--

CREATE INDEX idx_transactions_data_source ON ONLY public.transactions USING btree (data_source);


--
-- Name: idx_transactions_date; Type: INDEX; Schema: public; Owner: root
--

CREATE INDEX idx_transactions_date ON ONLY public.transactions USING btree (transaction_date);


--
-- Name: idx_transactions_merchant; Type: INDEX; Schema: public; Owner: root
--

CREATE INDEX idx_transactions_merchant ON ONLY public.transactions USING btree (merchant_id);


--
-- Name: idx_transactions_type; Type: INDEX; Schema: public; Owner: root
--

CREATE INDEX idx_transactions_type ON ONLY public.transactions USING btree (type);


--
-- Name: transactions_2012_account_id_idx; Type: INDEX; Schema: public; Owner: root
--

CREATE INDEX transactions_2012_account_id_idx ON public.transactions_2012 USING btree (account_id);


--
-- Name: transactions_2012_category_id_idx; Type: INDEX; Schema: public; Owner: root
--

CREATE INDEX transactions_2012_category_id_idx ON public.transactions_2012 USING btree (category_id);


--
-- Name: transactions_2012_data_source_idx; Type: INDEX; Schema: public; Owner: root
--

CREATE INDEX transactions_2012_data_source_idx ON public.transactions_2012 USING btree (data_source);


--
-- Name: transactions_2012_merchant_id_idx; Type: INDEX; Schema: public; Owner: root
--

CREATE INDEX transactions_2012_merchant_id_idx ON public.transactions_2012 USING btree (merchant_id);


--
-- Name: transactions_2012_transaction_date_idx; Type: INDEX; Schema: public; Owner: root
--

CREATE INDEX transactions_2012_transaction_date_idx ON public.transactions_2012 USING btree (transaction_date);


--
-- Name: transactions_2012_type_idx; Type: INDEX; Schema: public; Owner: root
--

CREATE INDEX transactions_2012_type_idx ON public.transactions_2012 USING btree (type);


--
-- Name: transactions_2013_account_id_idx; Type: INDEX; Schema: public; Owner: root
--

CREATE INDEX transactions_2013_account_id_idx ON public.transactions_2013 USING btree (account_id);


--
-- Name: transactions_2013_category_id_idx; Type: INDEX; Schema: public; Owner: root
--

CREATE INDEX transactions_2013_category_id_idx ON public.transactions_2013 USING btree (category_id);


--
-- Name: transactions_2013_data_source_idx; Type: INDEX; Schema: public; Owner: root
--

CREATE INDEX transactions_2013_data_source_idx ON public.transactions_2013 USING btree (data_source);


--
-- Name: transactions_2013_merchant_id_idx; Type: INDEX; Schema: public; Owner: root
--

CREATE INDEX transactions_2013_merchant_id_idx ON public.transactions_2013 USING btree (merchant_id);


--
-- Name: transactions_2013_transaction_date_idx; Type: INDEX; Schema: public; Owner: root
--

CREATE INDEX transactions_2013_transaction_date_idx ON public.transactions_2013 USING btree (transaction_date);


--
-- Name: transactions_2013_type_idx; Type: INDEX; Schema: public; Owner: root
--

CREATE INDEX transactions_2013_type_idx ON public.transactions_2013 USING btree (type);


--
-- Name: transactions_2014_account_id_idx; Type: INDEX; Schema: public; Owner: root
--

CREATE INDEX transactions_2014_account_id_idx ON public.transactions_2014 USING btree (account_id);


--
-- Name: transactions_2014_category_id_idx; Type: INDEX; Schema: public; Owner: root
--

CREATE INDEX transactions_2014_category_id_idx ON public.transactions_2014 USING btree (category_id);


--
-- Name: transactions_2014_data_source_idx; Type: INDEX; Schema: public; Owner: root
--

CREATE INDEX transactions_2014_data_source_idx ON public.transactions_2014 USING btree (data_source);


--
-- Name: transactions_2014_merchant_id_idx; Type: INDEX; Schema: public; Owner: root
--

CREATE INDEX transactions_2014_merchant_id_idx ON public.transactions_2014 USING btree (merchant_id);


--
-- Name: transactions_2014_transaction_date_idx; Type: INDEX; Schema: public; Owner: root
--

CREATE INDEX transactions_2014_transaction_date_idx ON public.transactions_2014 USING btree (transaction_date);


--
-- Name: transactions_2014_type_idx; Type: INDEX; Schema: public; Owner: root
--

CREATE INDEX transactions_2014_type_idx ON public.transactions_2014 USING btree (type);


--
-- Name: transactions_2015_account_id_idx; Type: INDEX; Schema: public; Owner: root
--

CREATE INDEX transactions_2015_account_id_idx ON public.transactions_2015 USING btree (account_id);


--
-- Name: transactions_2015_category_id_idx; Type: INDEX; Schema: public; Owner: root
--

CREATE INDEX transactions_2015_category_id_idx ON public.transactions_2015 USING btree (category_id);


--
-- Name: transactions_2015_data_source_idx; Type: INDEX; Schema: public; Owner: root
--

CREATE INDEX transactions_2015_data_source_idx ON public.transactions_2015 USING btree (data_source);


--
-- Name: transactions_2015_merchant_id_idx; Type: INDEX; Schema: public; Owner: root
--

CREATE INDEX transactions_2015_merchant_id_idx ON public.transactions_2015 USING btree (merchant_id);


--
-- Name: transactions_2015_transaction_date_idx; Type: INDEX; Schema: public; Owner: root
--

CREATE INDEX transactions_2015_transaction_date_idx ON public.transactions_2015 USING btree (transaction_date);


--
-- Name: transactions_2015_type_idx; Type: INDEX; Schema: public; Owner: root
--

CREATE INDEX transactions_2015_type_idx ON public.transactions_2015 USING btree (type);


--
-- Name: transactions_2016_account_id_idx; Type: INDEX; Schema: public; Owner: root
--

CREATE INDEX transactions_2016_account_id_idx ON public.transactions_2016 USING btree (account_id);


--
-- Name: transactions_2016_category_id_idx; Type: INDEX; Schema: public; Owner: root
--

CREATE INDEX transactions_2016_category_id_idx ON public.transactions_2016 USING btree (category_id);


--
-- Name: transactions_2016_data_source_idx; Type: INDEX; Schema: public; Owner: root
--

CREATE INDEX transactions_2016_data_source_idx ON public.transactions_2016 USING btree (data_source);


--
-- Name: transactions_2016_merchant_id_idx; Type: INDEX; Schema: public; Owner: root
--

CREATE INDEX transactions_2016_merchant_id_idx ON public.transactions_2016 USING btree (merchant_id);


--
-- Name: transactions_2016_transaction_date_idx; Type: INDEX; Schema: public; Owner: root
--

CREATE INDEX transactions_2016_transaction_date_idx ON public.transactions_2016 USING btree (transaction_date);


--
-- Name: transactions_2016_type_idx; Type: INDEX; Schema: public; Owner: root
--

CREATE INDEX transactions_2016_type_idx ON public.transactions_2016 USING btree (type);


--
-- Name: transactions_2017_account_id_idx; Type: INDEX; Schema: public; Owner: root
--

CREATE INDEX transactions_2017_account_id_idx ON public.transactions_2017 USING btree (account_id);


--
-- Name: transactions_2017_category_id_idx; Type: INDEX; Schema: public; Owner: root
--

CREATE INDEX transactions_2017_category_id_idx ON public.transactions_2017 USING btree (category_id);


--
-- Name: transactions_2017_data_source_idx; Type: INDEX; Schema: public; Owner: root
--

CREATE INDEX transactions_2017_data_source_idx ON public.transactions_2017 USING btree (data_source);


--
-- Name: transactions_2017_merchant_id_idx; Type: INDEX; Schema: public; Owner: root
--

CREATE INDEX transactions_2017_merchant_id_idx ON public.transactions_2017 USING btree (merchant_id);


--
-- Name: transactions_2017_transaction_date_idx; Type: INDEX; Schema: public; Owner: root
--

CREATE INDEX transactions_2017_transaction_date_idx ON public.transactions_2017 USING btree (transaction_date);


--
-- Name: transactions_2017_type_idx; Type: INDEX; Schema: public; Owner: root
--

CREATE INDEX transactions_2017_type_idx ON public.transactions_2017 USING btree (type);


--
-- Name: transactions_2018_account_id_idx; Type: INDEX; Schema: public; Owner: root
--

CREATE INDEX transactions_2018_account_id_idx ON public.transactions_2018 USING btree (account_id);


--
-- Name: transactions_2018_category_id_idx; Type: INDEX; Schema: public; Owner: root
--

CREATE INDEX transactions_2018_category_id_idx ON public.transactions_2018 USING btree (category_id);


--
-- Name: transactions_2018_data_source_idx; Type: INDEX; Schema: public; Owner: root
--

CREATE INDEX transactions_2018_data_source_idx ON public.transactions_2018 USING btree (data_source);


--
-- Name: transactions_2018_merchant_id_idx; Type: INDEX; Schema: public; Owner: root
--

CREATE INDEX transactions_2018_merchant_id_idx ON public.transactions_2018 USING btree (merchant_id);


--
-- Name: transactions_2018_transaction_date_idx; Type: INDEX; Schema: public; Owner: root
--

CREATE INDEX transactions_2018_transaction_date_idx ON public.transactions_2018 USING btree (transaction_date);


--
-- Name: transactions_2018_type_idx; Type: INDEX; Schema: public; Owner: root
--

CREATE INDEX transactions_2018_type_idx ON public.transactions_2018 USING btree (type);


--
-- Name: transactions_2019_account_id_idx; Type: INDEX; Schema: public; Owner: root
--

CREATE INDEX transactions_2019_account_id_idx ON public.transactions_2019 USING btree (account_id);


--
-- Name: transactions_2019_category_id_idx; Type: INDEX; Schema: public; Owner: root
--

CREATE INDEX transactions_2019_category_id_idx ON public.transactions_2019 USING btree (category_id);


--
-- Name: transactions_2019_data_source_idx; Type: INDEX; Schema: public; Owner: root
--

CREATE INDEX transactions_2019_data_source_idx ON public.transactions_2019 USING btree (data_source);


--
-- Name: transactions_2019_merchant_id_idx; Type: INDEX; Schema: public; Owner: root
--

CREATE INDEX transactions_2019_merchant_id_idx ON public.transactions_2019 USING btree (merchant_id);


--
-- Name: transactions_2019_transaction_date_idx; Type: INDEX; Schema: public; Owner: root
--

CREATE INDEX transactions_2019_transaction_date_idx ON public.transactions_2019 USING btree (transaction_date);


--
-- Name: transactions_2019_type_idx; Type: INDEX; Schema: public; Owner: root
--

CREATE INDEX transactions_2019_type_idx ON public.transactions_2019 USING btree (type);


--
-- Name: transactions_2020_account_id_idx; Type: INDEX; Schema: public; Owner: root
--

CREATE INDEX transactions_2020_account_id_idx ON public.transactions_2020 USING btree (account_id);


--
-- Name: transactions_2020_category_id_idx; Type: INDEX; Schema: public; Owner: root
--

CREATE INDEX transactions_2020_category_id_idx ON public.transactions_2020 USING btree (category_id);


--
-- Name: transactions_2020_data_source_idx; Type: INDEX; Schema: public; Owner: root
--

CREATE INDEX transactions_2020_data_source_idx ON public.transactions_2020 USING btree (data_source);


--
-- Name: transactions_2020_merchant_id_idx; Type: INDEX; Schema: public; Owner: root
--

CREATE INDEX transactions_2020_merchant_id_idx ON public.transactions_2020 USING btree (merchant_id);


--
-- Name: transactions_2020_transaction_date_idx; Type: INDEX; Schema: public; Owner: root
--

CREATE INDEX transactions_2020_transaction_date_idx ON public.transactions_2020 USING btree (transaction_date);


--
-- Name: transactions_2020_type_idx; Type: INDEX; Schema: public; Owner: root
--

CREATE INDEX transactions_2020_type_idx ON public.transactions_2020 USING btree (type);


--
-- Name: transactions_2021_account_id_idx; Type: INDEX; Schema: public; Owner: root
--

CREATE INDEX transactions_2021_account_id_idx ON public.transactions_2021 USING btree (account_id);


--
-- Name: transactions_2021_category_id_idx; Type: INDEX; Schema: public; Owner: root
--

CREATE INDEX transactions_2021_category_id_idx ON public.transactions_2021 USING btree (category_id);


--
-- Name: transactions_2021_data_source_idx; Type: INDEX; Schema: public; Owner: root
--

CREATE INDEX transactions_2021_data_source_idx ON public.transactions_2021 USING btree (data_source);


--
-- Name: transactions_2021_merchant_id_idx; Type: INDEX; Schema: public; Owner: root
--

CREATE INDEX transactions_2021_merchant_id_idx ON public.transactions_2021 USING btree (merchant_id);


--
-- Name: transactions_2021_transaction_date_idx; Type: INDEX; Schema: public; Owner: root
--

CREATE INDEX transactions_2021_transaction_date_idx ON public.transactions_2021 USING btree (transaction_date);


--
-- Name: transactions_2021_type_idx; Type: INDEX; Schema: public; Owner: root
--

CREATE INDEX transactions_2021_type_idx ON public.transactions_2021 USING btree (type);


--
-- Name: transactions_2022_account_id_idx; Type: INDEX; Schema: public; Owner: root
--

CREATE INDEX transactions_2022_account_id_idx ON public.transactions_2022 USING btree (account_id);


--
-- Name: transactions_2022_category_id_idx; Type: INDEX; Schema: public; Owner: root
--

CREATE INDEX transactions_2022_category_id_idx ON public.transactions_2022 USING btree (category_id);


--
-- Name: transactions_2022_data_source_idx; Type: INDEX; Schema: public; Owner: root
--

CREATE INDEX transactions_2022_data_source_idx ON public.transactions_2022 USING btree (data_source);


--
-- Name: transactions_2022_merchant_id_idx; Type: INDEX; Schema: public; Owner: root
--

CREATE INDEX transactions_2022_merchant_id_idx ON public.transactions_2022 USING btree (merchant_id);


--
-- Name: transactions_2022_transaction_date_idx; Type: INDEX; Schema: public; Owner: root
--

CREATE INDEX transactions_2022_transaction_date_idx ON public.transactions_2022 USING btree (transaction_date);


--
-- Name: transactions_2022_type_idx; Type: INDEX; Schema: public; Owner: root
--

CREATE INDEX transactions_2022_type_idx ON public.transactions_2022 USING btree (type);


--
-- Name: transactions_2023_account_id_idx; Type: INDEX; Schema: public; Owner: root
--

CREATE INDEX transactions_2023_account_id_idx ON public.transactions_2023 USING btree (account_id);


--
-- Name: transactions_2023_category_id_idx; Type: INDEX; Schema: public; Owner: root
--

CREATE INDEX transactions_2023_category_id_idx ON public.transactions_2023 USING btree (category_id);


--
-- Name: transactions_2023_data_source_idx; Type: INDEX; Schema: public; Owner: root
--

CREATE INDEX transactions_2023_data_source_idx ON public.transactions_2023 USING btree (data_source);


--
-- Name: transactions_2023_merchant_id_idx; Type: INDEX; Schema: public; Owner: root
--

CREATE INDEX transactions_2023_merchant_id_idx ON public.transactions_2023 USING btree (merchant_id);


--
-- Name: transactions_2023_transaction_date_idx; Type: INDEX; Schema: public; Owner: root
--

CREATE INDEX transactions_2023_transaction_date_idx ON public.transactions_2023 USING btree (transaction_date);


--
-- Name: transactions_2023_type_idx; Type: INDEX; Schema: public; Owner: root
--

CREATE INDEX transactions_2023_type_idx ON public.transactions_2023 USING btree (type);


--
-- Name: transactions_2024_account_id_idx; Type: INDEX; Schema: public; Owner: root
--

CREATE INDEX transactions_2024_account_id_idx ON public.transactions_2024 USING btree (account_id);


--
-- Name: transactions_2024_category_id_idx; Type: INDEX; Schema: public; Owner: root
--

CREATE INDEX transactions_2024_category_id_idx ON public.transactions_2024 USING btree (category_id);


--
-- Name: transactions_2024_data_source_idx; Type: INDEX; Schema: public; Owner: root
--

CREATE INDEX transactions_2024_data_source_idx ON public.transactions_2024 USING btree (data_source);


--
-- Name: transactions_2024_merchant_id_idx; Type: INDEX; Schema: public; Owner: root
--

CREATE INDEX transactions_2024_merchant_id_idx ON public.transactions_2024 USING btree (merchant_id);


--
-- Name: transactions_2024_transaction_date_idx; Type: INDEX; Schema: public; Owner: root
--

CREATE INDEX transactions_2024_transaction_date_idx ON public.transactions_2024 USING btree (transaction_date);


--
-- Name: transactions_2024_type_idx; Type: INDEX; Schema: public; Owner: root
--

CREATE INDEX transactions_2024_type_idx ON public.transactions_2024 USING btree (type);


--
-- Name: transactions_2025_account_id_idx; Type: INDEX; Schema: public; Owner: root
--

CREATE INDEX transactions_2025_account_id_idx ON public.transactions_2025 USING btree (account_id);


--
-- Name: transactions_2025_category_id_idx; Type: INDEX; Schema: public; Owner: root
--

CREATE INDEX transactions_2025_category_id_idx ON public.transactions_2025 USING btree (category_id);


--
-- Name: transactions_2025_data_source_idx; Type: INDEX; Schema: public; Owner: root
--

CREATE INDEX transactions_2025_data_source_idx ON public.transactions_2025 USING btree (data_source);


--
-- Name: transactions_2025_merchant_id_idx; Type: INDEX; Schema: public; Owner: root
--

CREATE INDEX transactions_2025_merchant_id_idx ON public.transactions_2025 USING btree (merchant_id);


--
-- Name: transactions_2025_transaction_date_idx; Type: INDEX; Schema: public; Owner: root
--

CREATE INDEX transactions_2025_transaction_date_idx ON public.transactions_2025 USING btree (transaction_date);


--
-- Name: transactions_2025_type_idx; Type: INDEX; Schema: public; Owner: root
--

CREATE INDEX transactions_2025_type_idx ON public.transactions_2025 USING btree (type);


--
-- Name: transactions_2026_account_id_idx; Type: INDEX; Schema: public; Owner: root
--

CREATE INDEX transactions_2026_account_id_idx ON public.transactions_2026 USING btree (account_id);


--
-- Name: transactions_2026_category_id_idx; Type: INDEX; Schema: public; Owner: root
--

CREATE INDEX transactions_2026_category_id_idx ON public.transactions_2026 USING btree (category_id);


--
-- Name: transactions_2026_data_source_idx; Type: INDEX; Schema: public; Owner: root
--

CREATE INDEX transactions_2026_data_source_idx ON public.transactions_2026 USING btree (data_source);


--
-- Name: transactions_2026_merchant_id_idx; Type: INDEX; Schema: public; Owner: root
--

CREATE INDEX transactions_2026_merchant_id_idx ON public.transactions_2026 USING btree (merchant_id);


--
-- Name: transactions_2026_transaction_date_idx; Type: INDEX; Schema: public; Owner: root
--

CREATE INDEX transactions_2026_transaction_date_idx ON public.transactions_2026 USING btree (transaction_date);


--
-- Name: transactions_2026_type_idx; Type: INDEX; Schema: public; Owner: root
--

CREATE INDEX transactions_2026_type_idx ON public.transactions_2026 USING btree (type);


--
-- Name: transactions_2027_account_id_idx; Type: INDEX; Schema: public; Owner: root
--

CREATE INDEX transactions_2027_account_id_idx ON public.transactions_2027 USING btree (account_id);


--
-- Name: transactions_2027_category_id_idx; Type: INDEX; Schema: public; Owner: root
--

CREATE INDEX transactions_2027_category_id_idx ON public.transactions_2027 USING btree (category_id);


--
-- Name: transactions_2027_data_source_idx; Type: INDEX; Schema: public; Owner: root
--

CREATE INDEX transactions_2027_data_source_idx ON public.transactions_2027 USING btree (data_source);


--
-- Name: transactions_2027_merchant_id_idx; Type: INDEX; Schema: public; Owner: root
--

CREATE INDEX transactions_2027_merchant_id_idx ON public.transactions_2027 USING btree (merchant_id);


--
-- Name: transactions_2027_transaction_date_idx; Type: INDEX; Schema: public; Owner: root
--

CREATE INDEX transactions_2027_transaction_date_idx ON public.transactions_2027 USING btree (transaction_date);


--
-- Name: transactions_2027_type_idx; Type: INDEX; Schema: public; Owner: root
--

CREATE INDEX transactions_2027_type_idx ON public.transactions_2027 USING btree (type);


--
-- Name: transactions_default_account_id_idx; Type: INDEX; Schema: public; Owner: root
--

CREATE INDEX transactions_default_account_id_idx ON public.transactions_default USING btree (account_id);


--
-- Name: transactions_default_category_id_idx; Type: INDEX; Schema: public; Owner: root
--

CREATE INDEX transactions_default_category_id_idx ON public.transactions_default USING btree (category_id);


--
-- Name: transactions_default_data_source_idx; Type: INDEX; Schema: public; Owner: root
--

CREATE INDEX transactions_default_data_source_idx ON public.transactions_default USING btree (data_source);


--
-- Name: transactions_default_merchant_id_idx; Type: INDEX; Schema: public; Owner: root
--

CREATE INDEX transactions_default_merchant_id_idx ON public.transactions_default USING btree (merchant_id);


--
-- Name: transactions_default_transaction_date_idx; Type: INDEX; Schema: public; Owner: root
--

CREATE INDEX transactions_default_transaction_date_idx ON public.transactions_default USING btree (transaction_date);


--
-- Name: transactions_default_type_idx; Type: INDEX; Schema: public; Owner: root
--

CREATE INDEX transactions_default_type_idx ON public.transactions_default USING btree (type);


--
-- Name: transactions_2012_account_id_idx; Type: INDEX ATTACH; Schema: public; Owner: root
--

ALTER INDEX public.idx_transactions_account ATTACH PARTITION public.transactions_2012_account_id_idx;


--
-- Name: transactions_2012_category_id_idx; Type: INDEX ATTACH; Schema: public; Owner: root
--

ALTER INDEX public.idx_transactions_category ATTACH PARTITION public.transactions_2012_category_id_idx;


--
-- Name: transactions_2012_data_source_idx; Type: INDEX ATTACH; Schema: public; Owner: root
--

ALTER INDEX public.idx_transactions_data_source ATTACH PARTITION public.transactions_2012_data_source_idx;


--
-- Name: transactions_2012_merchant_id_idx; Type: INDEX ATTACH; Schema: public; Owner: root
--

ALTER INDEX public.idx_transactions_merchant ATTACH PARTITION public.transactions_2012_merchant_id_idx;


--
-- Name: transactions_2012_pkey; Type: INDEX ATTACH; Schema: public; Owner: root
--

ALTER INDEX public.transactions_pkey ATTACH PARTITION public.transactions_2012_pkey;


--
-- Name: transactions_2012_transaction_date_idx; Type: INDEX ATTACH; Schema: public; Owner: root
--

ALTER INDEX public.idx_transactions_date ATTACH PARTITION public.transactions_2012_transaction_date_idx;


--
-- Name: transactions_2012_type_idx; Type: INDEX ATTACH; Schema: public; Owner: root
--

ALTER INDEX public.idx_transactions_type ATTACH PARTITION public.transactions_2012_type_idx;


--
-- Name: transactions_2013_account_id_idx; Type: INDEX ATTACH; Schema: public; Owner: root
--

ALTER INDEX public.idx_transactions_account ATTACH PARTITION public.transactions_2013_account_id_idx;


--
-- Name: transactions_2013_category_id_idx; Type: INDEX ATTACH; Schema: public; Owner: root
--

ALTER INDEX public.idx_transactions_category ATTACH PARTITION public.transactions_2013_category_id_idx;


--
-- Name: transactions_2013_data_source_idx; Type: INDEX ATTACH; Schema: public; Owner: root
--

ALTER INDEX public.idx_transactions_data_source ATTACH PARTITION public.transactions_2013_data_source_idx;


--
-- Name: transactions_2013_merchant_id_idx; Type: INDEX ATTACH; Schema: public; Owner: root
--

ALTER INDEX public.idx_transactions_merchant ATTACH PARTITION public.transactions_2013_merchant_id_idx;


--
-- Name: transactions_2013_pkey; Type: INDEX ATTACH; Schema: public; Owner: root
--

ALTER INDEX public.transactions_pkey ATTACH PARTITION public.transactions_2013_pkey;


--
-- Name: transactions_2013_transaction_date_idx; Type: INDEX ATTACH; Schema: public; Owner: root
--

ALTER INDEX public.idx_transactions_date ATTACH PARTITION public.transactions_2013_transaction_date_idx;


--
-- Name: transactions_2013_type_idx; Type: INDEX ATTACH; Schema: public; Owner: root
--

ALTER INDEX public.idx_transactions_type ATTACH PARTITION public.transactions_2013_type_idx;


--
-- Name: transactions_2014_account_id_idx; Type: INDEX ATTACH; Schema: public; Owner: root
--

ALTER INDEX public.idx_transactions_account ATTACH PARTITION public.transactions_2014_account_id_idx;


--
-- Name: transactions_2014_category_id_idx; Type: INDEX ATTACH; Schema: public; Owner: root
--

ALTER INDEX public.idx_transactions_category ATTACH PARTITION public.transactions_2014_category_id_idx;


--
-- Name: transactions_2014_data_source_idx; Type: INDEX ATTACH; Schema: public; Owner: root
--

ALTER INDEX public.idx_transactions_data_source ATTACH PARTITION public.transactions_2014_data_source_idx;


--
-- Name: transactions_2014_merchant_id_idx; Type: INDEX ATTACH; Schema: public; Owner: root
--

ALTER INDEX public.idx_transactions_merchant ATTACH PARTITION public.transactions_2014_merchant_id_idx;


--
-- Name: transactions_2014_pkey; Type: INDEX ATTACH; Schema: public; Owner: root
--

ALTER INDEX public.transactions_pkey ATTACH PARTITION public.transactions_2014_pkey;


--
-- Name: transactions_2014_transaction_date_idx; Type: INDEX ATTACH; Schema: public; Owner: root
--

ALTER INDEX public.idx_transactions_date ATTACH PARTITION public.transactions_2014_transaction_date_idx;


--
-- Name: transactions_2014_type_idx; Type: INDEX ATTACH; Schema: public; Owner: root
--

ALTER INDEX public.idx_transactions_type ATTACH PARTITION public.transactions_2014_type_idx;


--
-- Name: transactions_2015_account_id_idx; Type: INDEX ATTACH; Schema: public; Owner: root
--

ALTER INDEX public.idx_transactions_account ATTACH PARTITION public.transactions_2015_account_id_idx;


--
-- Name: transactions_2015_category_id_idx; Type: INDEX ATTACH; Schema: public; Owner: root
--

ALTER INDEX public.idx_transactions_category ATTACH PARTITION public.transactions_2015_category_id_idx;


--
-- Name: transactions_2015_data_source_idx; Type: INDEX ATTACH; Schema: public; Owner: root
--

ALTER INDEX public.idx_transactions_data_source ATTACH PARTITION public.transactions_2015_data_source_idx;


--
-- Name: transactions_2015_merchant_id_idx; Type: INDEX ATTACH; Schema: public; Owner: root
--

ALTER INDEX public.idx_transactions_merchant ATTACH PARTITION public.transactions_2015_merchant_id_idx;


--
-- Name: transactions_2015_pkey; Type: INDEX ATTACH; Schema: public; Owner: root
--

ALTER INDEX public.transactions_pkey ATTACH PARTITION public.transactions_2015_pkey;


--
-- Name: transactions_2015_transaction_date_idx; Type: INDEX ATTACH; Schema: public; Owner: root
--

ALTER INDEX public.idx_transactions_date ATTACH PARTITION public.transactions_2015_transaction_date_idx;


--
-- Name: transactions_2015_type_idx; Type: INDEX ATTACH; Schema: public; Owner: root
--

ALTER INDEX public.idx_transactions_type ATTACH PARTITION public.transactions_2015_type_idx;


--
-- Name: transactions_2016_account_id_idx; Type: INDEX ATTACH; Schema: public; Owner: root
--

ALTER INDEX public.idx_transactions_account ATTACH PARTITION public.transactions_2016_account_id_idx;


--
-- Name: transactions_2016_category_id_idx; Type: INDEX ATTACH; Schema: public; Owner: root
--

ALTER INDEX public.idx_transactions_category ATTACH PARTITION public.transactions_2016_category_id_idx;


--
-- Name: transactions_2016_data_source_idx; Type: INDEX ATTACH; Schema: public; Owner: root
--

ALTER INDEX public.idx_transactions_data_source ATTACH PARTITION public.transactions_2016_data_source_idx;


--
-- Name: transactions_2016_merchant_id_idx; Type: INDEX ATTACH; Schema: public; Owner: root
--

ALTER INDEX public.idx_transactions_merchant ATTACH PARTITION public.transactions_2016_merchant_id_idx;


--
-- Name: transactions_2016_pkey; Type: INDEX ATTACH; Schema: public; Owner: root
--

ALTER INDEX public.transactions_pkey ATTACH PARTITION public.transactions_2016_pkey;


--
-- Name: transactions_2016_transaction_date_idx; Type: INDEX ATTACH; Schema: public; Owner: root
--

ALTER INDEX public.idx_transactions_date ATTACH PARTITION public.transactions_2016_transaction_date_idx;


--
-- Name: transactions_2016_type_idx; Type: INDEX ATTACH; Schema: public; Owner: root
--

ALTER INDEX public.idx_transactions_type ATTACH PARTITION public.transactions_2016_type_idx;


--
-- Name: transactions_2017_account_id_idx; Type: INDEX ATTACH; Schema: public; Owner: root
--

ALTER INDEX public.idx_transactions_account ATTACH PARTITION public.transactions_2017_account_id_idx;


--
-- Name: transactions_2017_category_id_idx; Type: INDEX ATTACH; Schema: public; Owner: root
--

ALTER INDEX public.idx_transactions_category ATTACH PARTITION public.transactions_2017_category_id_idx;


--
-- Name: transactions_2017_data_source_idx; Type: INDEX ATTACH; Schema: public; Owner: root
--

ALTER INDEX public.idx_transactions_data_source ATTACH PARTITION public.transactions_2017_data_source_idx;


--
-- Name: transactions_2017_merchant_id_idx; Type: INDEX ATTACH; Schema: public; Owner: root
--

ALTER INDEX public.idx_transactions_merchant ATTACH PARTITION public.transactions_2017_merchant_id_idx;


--
-- Name: transactions_2017_pkey; Type: INDEX ATTACH; Schema: public; Owner: root
--

ALTER INDEX public.transactions_pkey ATTACH PARTITION public.transactions_2017_pkey;


--
-- Name: transactions_2017_transaction_date_idx; Type: INDEX ATTACH; Schema: public; Owner: root
--

ALTER INDEX public.idx_transactions_date ATTACH PARTITION public.transactions_2017_transaction_date_idx;


--
-- Name: transactions_2017_type_idx; Type: INDEX ATTACH; Schema: public; Owner: root
--

ALTER INDEX public.idx_transactions_type ATTACH PARTITION public.transactions_2017_type_idx;


--
-- Name: transactions_2018_account_id_idx; Type: INDEX ATTACH; Schema: public; Owner: root
--

ALTER INDEX public.idx_transactions_account ATTACH PARTITION public.transactions_2018_account_id_idx;


--
-- Name: transactions_2018_category_id_idx; Type: INDEX ATTACH; Schema: public; Owner: root
--

ALTER INDEX public.idx_transactions_category ATTACH PARTITION public.transactions_2018_category_id_idx;


--
-- Name: transactions_2018_data_source_idx; Type: INDEX ATTACH; Schema: public; Owner: root
--

ALTER INDEX public.idx_transactions_data_source ATTACH PARTITION public.transactions_2018_data_source_idx;


--
-- Name: transactions_2018_merchant_id_idx; Type: INDEX ATTACH; Schema: public; Owner: root
--

ALTER INDEX public.idx_transactions_merchant ATTACH PARTITION public.transactions_2018_merchant_id_idx;


--
-- Name: transactions_2018_pkey; Type: INDEX ATTACH; Schema: public; Owner: root
--

ALTER INDEX public.transactions_pkey ATTACH PARTITION public.transactions_2018_pkey;


--
-- Name: transactions_2018_transaction_date_idx; Type: INDEX ATTACH; Schema: public; Owner: root
--

ALTER INDEX public.idx_transactions_date ATTACH PARTITION public.transactions_2018_transaction_date_idx;


--
-- Name: transactions_2018_type_idx; Type: INDEX ATTACH; Schema: public; Owner: root
--

ALTER INDEX public.idx_transactions_type ATTACH PARTITION public.transactions_2018_type_idx;


--
-- Name: transactions_2019_account_id_idx; Type: INDEX ATTACH; Schema: public; Owner: root
--

ALTER INDEX public.idx_transactions_account ATTACH PARTITION public.transactions_2019_account_id_idx;


--
-- Name: transactions_2019_category_id_idx; Type: INDEX ATTACH; Schema: public; Owner: root
--

ALTER INDEX public.idx_transactions_category ATTACH PARTITION public.transactions_2019_category_id_idx;


--
-- Name: transactions_2019_data_source_idx; Type: INDEX ATTACH; Schema: public; Owner: root
--

ALTER INDEX public.idx_transactions_data_source ATTACH PARTITION public.transactions_2019_data_source_idx;


--
-- Name: transactions_2019_merchant_id_idx; Type: INDEX ATTACH; Schema: public; Owner: root
--

ALTER INDEX public.idx_transactions_merchant ATTACH PARTITION public.transactions_2019_merchant_id_idx;


--
-- Name: transactions_2019_pkey; Type: INDEX ATTACH; Schema: public; Owner: root
--

ALTER INDEX public.transactions_pkey ATTACH PARTITION public.transactions_2019_pkey;


--
-- Name: transactions_2019_transaction_date_idx; Type: INDEX ATTACH; Schema: public; Owner: root
--

ALTER INDEX public.idx_transactions_date ATTACH PARTITION public.transactions_2019_transaction_date_idx;


--
-- Name: transactions_2019_type_idx; Type: INDEX ATTACH; Schema: public; Owner: root
--

ALTER INDEX public.idx_transactions_type ATTACH PARTITION public.transactions_2019_type_idx;


--
-- Name: transactions_2020_account_id_idx; Type: INDEX ATTACH; Schema: public; Owner: root
--

ALTER INDEX public.idx_transactions_account ATTACH PARTITION public.transactions_2020_account_id_idx;


--
-- Name: transactions_2020_category_id_idx; Type: INDEX ATTACH; Schema: public; Owner: root
--

ALTER INDEX public.idx_transactions_category ATTACH PARTITION public.transactions_2020_category_id_idx;


--
-- Name: transactions_2020_data_source_idx; Type: INDEX ATTACH; Schema: public; Owner: root
--

ALTER INDEX public.idx_transactions_data_source ATTACH PARTITION public.transactions_2020_data_source_idx;


--
-- Name: transactions_2020_merchant_id_idx; Type: INDEX ATTACH; Schema: public; Owner: root
--

ALTER INDEX public.idx_transactions_merchant ATTACH PARTITION public.transactions_2020_merchant_id_idx;


--
-- Name: transactions_2020_pkey; Type: INDEX ATTACH; Schema: public; Owner: root
--

ALTER INDEX public.transactions_pkey ATTACH PARTITION public.transactions_2020_pkey;


--
-- Name: transactions_2020_transaction_date_idx; Type: INDEX ATTACH; Schema: public; Owner: root
--

ALTER INDEX public.idx_transactions_date ATTACH PARTITION public.transactions_2020_transaction_date_idx;


--
-- Name: transactions_2020_type_idx; Type: INDEX ATTACH; Schema: public; Owner: root
--

ALTER INDEX public.idx_transactions_type ATTACH PARTITION public.transactions_2020_type_idx;


--
-- Name: transactions_2021_account_id_idx; Type: INDEX ATTACH; Schema: public; Owner: root
--

ALTER INDEX public.idx_transactions_account ATTACH PARTITION public.transactions_2021_account_id_idx;


--
-- Name: transactions_2021_category_id_idx; Type: INDEX ATTACH; Schema: public; Owner: root
--

ALTER INDEX public.idx_transactions_category ATTACH PARTITION public.transactions_2021_category_id_idx;


--
-- Name: transactions_2021_data_source_idx; Type: INDEX ATTACH; Schema: public; Owner: root
--

ALTER INDEX public.idx_transactions_data_source ATTACH PARTITION public.transactions_2021_data_source_idx;


--
-- Name: transactions_2021_merchant_id_idx; Type: INDEX ATTACH; Schema: public; Owner: root
--

ALTER INDEX public.idx_transactions_merchant ATTACH PARTITION public.transactions_2021_merchant_id_idx;


--
-- Name: transactions_2021_pkey; Type: INDEX ATTACH; Schema: public; Owner: root
--

ALTER INDEX public.transactions_pkey ATTACH PARTITION public.transactions_2021_pkey;


--
-- Name: transactions_2021_transaction_date_idx; Type: INDEX ATTACH; Schema: public; Owner: root
--

ALTER INDEX public.idx_transactions_date ATTACH PARTITION public.transactions_2021_transaction_date_idx;


--
-- Name: transactions_2021_type_idx; Type: INDEX ATTACH; Schema: public; Owner: root
--

ALTER INDEX public.idx_transactions_type ATTACH PARTITION public.transactions_2021_type_idx;


--
-- Name: transactions_2022_account_id_idx; Type: INDEX ATTACH; Schema: public; Owner: root
--

ALTER INDEX public.idx_transactions_account ATTACH PARTITION public.transactions_2022_account_id_idx;


--
-- Name: transactions_2022_category_id_idx; Type: INDEX ATTACH; Schema: public; Owner: root
--

ALTER INDEX public.idx_transactions_category ATTACH PARTITION public.transactions_2022_category_id_idx;


--
-- Name: transactions_2022_data_source_idx; Type: INDEX ATTACH; Schema: public; Owner: root
--

ALTER INDEX public.idx_transactions_data_source ATTACH PARTITION public.transactions_2022_data_source_idx;


--
-- Name: transactions_2022_merchant_id_idx; Type: INDEX ATTACH; Schema: public; Owner: root
--

ALTER INDEX public.idx_transactions_merchant ATTACH PARTITION public.transactions_2022_merchant_id_idx;


--
-- Name: transactions_2022_pkey; Type: INDEX ATTACH; Schema: public; Owner: root
--

ALTER INDEX public.transactions_pkey ATTACH PARTITION public.transactions_2022_pkey;


--
-- Name: transactions_2022_transaction_date_idx; Type: INDEX ATTACH; Schema: public; Owner: root
--

ALTER INDEX public.idx_transactions_date ATTACH PARTITION public.transactions_2022_transaction_date_idx;


--
-- Name: transactions_2022_type_idx; Type: INDEX ATTACH; Schema: public; Owner: root
--

ALTER INDEX public.idx_transactions_type ATTACH PARTITION public.transactions_2022_type_idx;


--
-- Name: transactions_2023_account_id_idx; Type: INDEX ATTACH; Schema: public; Owner: root
--

ALTER INDEX public.idx_transactions_account ATTACH PARTITION public.transactions_2023_account_id_idx;


--
-- Name: transactions_2023_category_id_idx; Type: INDEX ATTACH; Schema: public; Owner: root
--

ALTER INDEX public.idx_transactions_category ATTACH PARTITION public.transactions_2023_category_id_idx;


--
-- Name: transactions_2023_data_source_idx; Type: INDEX ATTACH; Schema: public; Owner: root
--

ALTER INDEX public.idx_transactions_data_source ATTACH PARTITION public.transactions_2023_data_source_idx;


--
-- Name: transactions_2023_merchant_id_idx; Type: INDEX ATTACH; Schema: public; Owner: root
--

ALTER INDEX public.idx_transactions_merchant ATTACH PARTITION public.transactions_2023_merchant_id_idx;


--
-- Name: transactions_2023_pkey; Type: INDEX ATTACH; Schema: public; Owner: root
--

ALTER INDEX public.transactions_pkey ATTACH PARTITION public.transactions_2023_pkey;


--
-- Name: transactions_2023_transaction_date_idx; Type: INDEX ATTACH; Schema: public; Owner: root
--

ALTER INDEX public.idx_transactions_date ATTACH PARTITION public.transactions_2023_transaction_date_idx;


--
-- Name: transactions_2023_type_idx; Type: INDEX ATTACH; Schema: public; Owner: root
--

ALTER INDEX public.idx_transactions_type ATTACH PARTITION public.transactions_2023_type_idx;


--
-- Name: transactions_2024_account_id_idx; Type: INDEX ATTACH; Schema: public; Owner: root
--

ALTER INDEX public.idx_transactions_account ATTACH PARTITION public.transactions_2024_account_id_idx;


--
-- Name: transactions_2024_category_id_idx; Type: INDEX ATTACH; Schema: public; Owner: root
--

ALTER INDEX public.idx_transactions_category ATTACH PARTITION public.transactions_2024_category_id_idx;


--
-- Name: transactions_2024_data_source_idx; Type: INDEX ATTACH; Schema: public; Owner: root
--

ALTER INDEX public.idx_transactions_data_source ATTACH PARTITION public.transactions_2024_data_source_idx;


--
-- Name: transactions_2024_merchant_id_idx; Type: INDEX ATTACH; Schema: public; Owner: root
--

ALTER INDEX public.idx_transactions_merchant ATTACH PARTITION public.transactions_2024_merchant_id_idx;


--
-- Name: transactions_2024_pkey; Type: INDEX ATTACH; Schema: public; Owner: root
--

ALTER INDEX public.transactions_pkey ATTACH PARTITION public.transactions_2024_pkey;


--
-- Name: transactions_2024_transaction_date_idx; Type: INDEX ATTACH; Schema: public; Owner: root
--

ALTER INDEX public.idx_transactions_date ATTACH PARTITION public.transactions_2024_transaction_date_idx;


--
-- Name: transactions_2024_type_idx; Type: INDEX ATTACH; Schema: public; Owner: root
--

ALTER INDEX public.idx_transactions_type ATTACH PARTITION public.transactions_2024_type_idx;


--
-- Name: transactions_2025_account_id_idx; Type: INDEX ATTACH; Schema: public; Owner: root
--

ALTER INDEX public.idx_transactions_account ATTACH PARTITION public.transactions_2025_account_id_idx;


--
-- Name: transactions_2025_category_id_idx; Type: INDEX ATTACH; Schema: public; Owner: root
--

ALTER INDEX public.idx_transactions_category ATTACH PARTITION public.transactions_2025_category_id_idx;


--
-- Name: transactions_2025_data_source_idx; Type: INDEX ATTACH; Schema: public; Owner: root
--

ALTER INDEX public.idx_transactions_data_source ATTACH PARTITION public.transactions_2025_data_source_idx;


--
-- Name: transactions_2025_merchant_id_idx; Type: INDEX ATTACH; Schema: public; Owner: root
--

ALTER INDEX public.idx_transactions_merchant ATTACH PARTITION public.transactions_2025_merchant_id_idx;


--
-- Name: transactions_2025_pkey; Type: INDEX ATTACH; Schema: public; Owner: root
--

ALTER INDEX public.transactions_pkey ATTACH PARTITION public.transactions_2025_pkey;


--
-- Name: transactions_2025_transaction_date_idx; Type: INDEX ATTACH; Schema: public; Owner: root
--

ALTER INDEX public.idx_transactions_date ATTACH PARTITION public.transactions_2025_transaction_date_idx;


--
-- Name: transactions_2025_type_idx; Type: INDEX ATTACH; Schema: public; Owner: root
--

ALTER INDEX public.idx_transactions_type ATTACH PARTITION public.transactions_2025_type_idx;


--
-- Name: transactions_2026_account_id_idx; Type: INDEX ATTACH; Schema: public; Owner: root
--

ALTER INDEX public.idx_transactions_account ATTACH PARTITION public.transactions_2026_account_id_idx;


--
-- Name: transactions_2026_category_id_idx; Type: INDEX ATTACH; Schema: public; Owner: root
--

ALTER INDEX public.idx_transactions_category ATTACH PARTITION public.transactions_2026_category_id_idx;


--
-- Name: transactions_2026_data_source_idx; Type: INDEX ATTACH; Schema: public; Owner: root
--

ALTER INDEX public.idx_transactions_data_source ATTACH PARTITION public.transactions_2026_data_source_idx;


--
-- Name: transactions_2026_merchant_id_idx; Type: INDEX ATTACH; Schema: public; Owner: root
--

ALTER INDEX public.idx_transactions_merchant ATTACH PARTITION public.transactions_2026_merchant_id_idx;


--
-- Name: transactions_2026_pkey; Type: INDEX ATTACH; Schema: public; Owner: root
--

ALTER INDEX public.transactions_pkey ATTACH PARTITION public.transactions_2026_pkey;


--
-- Name: transactions_2026_transaction_date_idx; Type: INDEX ATTACH; Schema: public; Owner: root
--

ALTER INDEX public.idx_transactions_date ATTACH PARTITION public.transactions_2026_transaction_date_idx;


--
-- Name: transactions_2026_type_idx; Type: INDEX ATTACH; Schema: public; Owner: root
--

ALTER INDEX public.idx_transactions_type ATTACH PARTITION public.transactions_2026_type_idx;


--
-- Name: transactions_2027_account_id_idx; Type: INDEX ATTACH; Schema: public; Owner: root
--

ALTER INDEX public.idx_transactions_account ATTACH PARTITION public.transactions_2027_account_id_idx;


--
-- Name: transactions_2027_category_id_idx; Type: INDEX ATTACH; Schema: public; Owner: root
--

ALTER INDEX public.idx_transactions_category ATTACH PARTITION public.transactions_2027_category_id_idx;


--
-- Name: transactions_2027_data_source_idx; Type: INDEX ATTACH; Schema: public; Owner: root
--

ALTER INDEX public.idx_transactions_data_source ATTACH PARTITION public.transactions_2027_data_source_idx;


--
-- Name: transactions_2027_merchant_id_idx; Type: INDEX ATTACH; Schema: public; Owner: root
--

ALTER INDEX public.idx_transactions_merchant ATTACH PARTITION public.transactions_2027_merchant_id_idx;


--
-- Name: transactions_2027_pkey; Type: INDEX ATTACH; Schema: public; Owner: root
--

ALTER INDEX public.transactions_pkey ATTACH PARTITION public.transactions_2027_pkey;


--
-- Name: transactions_2027_transaction_date_idx; Type: INDEX ATTACH; Schema: public; Owner: root
--

ALTER INDEX public.idx_transactions_date ATTACH PARTITION public.transactions_2027_transaction_date_idx;


--
-- Name: transactions_2027_type_idx; Type: INDEX ATTACH; Schema: public; Owner: root
--

ALTER INDEX public.idx_transactions_type ATTACH PARTITION public.transactions_2027_type_idx;


--
-- Name: transactions_default_account_id_idx; Type: INDEX ATTACH; Schema: public; Owner: root
--

ALTER INDEX public.idx_transactions_account ATTACH PARTITION public.transactions_default_account_id_idx;


--
-- Name: transactions_default_category_id_idx; Type: INDEX ATTACH; Schema: public; Owner: root
--

ALTER INDEX public.idx_transactions_category ATTACH PARTITION public.transactions_default_category_id_idx;


--
-- Name: transactions_default_data_source_idx; Type: INDEX ATTACH; Schema: public; Owner: root
--

ALTER INDEX public.idx_transactions_data_source ATTACH PARTITION public.transactions_default_data_source_idx;


--
-- Name: transactions_default_merchant_id_idx; Type: INDEX ATTACH; Schema: public; Owner: root
--

ALTER INDEX public.idx_transactions_merchant ATTACH PARTITION public.transactions_default_merchant_id_idx;


--
-- Name: transactions_default_pkey; Type: INDEX ATTACH; Schema: public; Owner: root
--

ALTER INDEX public.transactions_pkey ATTACH PARTITION public.transactions_default_pkey;


--
-- Name: transactions_default_transaction_date_idx; Type: INDEX ATTACH; Schema: public; Owner: root
--

ALTER INDEX public.idx_transactions_date ATTACH PARTITION public.transactions_default_transaction_date_idx;


--
-- Name: transactions_default_type_idx; Type: INDEX ATTACH; Schema: public; Owner: root
--

ALTER INDEX public.idx_transactions_type ATTACH PARTITION public.transactions_default_type_idx;


--
-- Name: budgets update_budgets_updated_at; Type: TRIGGER; Schema: public; Owner: root
--

CREATE TRIGGER update_budgets_updated_at BEFORE UPDATE ON public.budgets FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();


--
-- Name: transactions update_transactions_updated_at; Type: TRIGGER; Schema: public; Owner: root
--

CREATE TRIGGER update_transactions_updated_at BEFORE UPDATE ON public.transactions FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();


--
-- Name: budgets budgets_category_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: root
--

ALTER TABLE ONLY public.budgets
    ADD CONSTRAINT budgets_category_id_fkey FOREIGN KEY (category_id) REFERENCES public.categories(category_id);


--
-- Name: merchants merchants_default_category_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: root
--

ALTER TABLE ONLY public.merchants
    ADD CONSTRAINT merchants_default_category_id_fkey FOREIGN KEY (default_category_id) REFERENCES public.categories(category_id);


--
-- Name: transactions transactions_account_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: root
--

ALTER TABLE public.transactions
    ADD CONSTRAINT transactions_account_id_fkey FOREIGN KEY (account_id) REFERENCES public.accounts(account_id);


--
-- Name: transactions transactions_category_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: root
--

ALTER TABLE public.transactions
    ADD CONSTRAINT transactions_category_id_fkey FOREIGN KEY (category_id) REFERENCES public.categories(category_id);


--
-- Name: transactions transactions_merchant_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: root
--

ALTER TABLE public.transactions
    ADD CONSTRAINT transactions_merchant_id_fkey FOREIGN KEY (merchant_id) REFERENCES public.merchants(merchant_id);


--
-- PostgreSQL database dump complete
--

\unrestrict dLuQX4dxNb9c5DBHLYXPUlyC0GMUvxwCnGmBdj5TMuUVftp6bxLYd8cCLHkOFuw

