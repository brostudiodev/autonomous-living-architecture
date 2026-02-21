--
-- PostgreSQL database dump
--

\restrict z8JHVvKmJVH80snWZwfxXBveGeatJIjXNBNsluDUk5nuwUajAJadAcWhIYlh37H

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
-- Name: upsert_pantry_item(character varying, numeric, character varying, date, date, character varying, numeric, text); Type: FUNCTION; Schema: public; Owner: root
--

CREATE FUNCTION public.upsert_pantry_item(_category character varying, _qty numeric, _unit character varying, _expiry date, _updated date, _status character varying, _threshold numeric, _notes text) RETURNS void
    LANGUAGE plpgsql
    AS $$
BEGIN
    INSERT INTO pantry_inventory (category, current_quantity, unit, next_expiry, last_updated, status, critical_threshold, notes, updated_at)
    VALUES (_category, _qty, _unit, _expiry, _updated, _status, _threshold, _notes, NOW())
    ON CONFLICT (category) 
    DO UPDATE SET 
        current_quantity = EXCLUDED.current_quantity,
        unit = EXCLUDED.unit,
        next_expiry = EXCLUDED.next_expiry,
        last_updated = EXCLUDED.last_updated,
        status = EXCLUDED.status,
        critical_threshold = EXCLUDED.critical_threshold,
        notes = EXCLUDED.notes,
        updated_at = NOW();
END;
$$;


ALTER FUNCTION public.upsert_pantry_item(_category character varying, _qty numeric, _unit character varying, _expiry date, _updated date, _status character varying, _threshold numeric, _notes text) OWNER TO root;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: pantry_dictionary; Type: TABLE; Schema: public; Owner: root
--

CREATE TABLE public.pantry_dictionary (
    category character varying(255) NOT NULL,
    ai_synonyms text,
    default_unit character varying(50),
    critical_threshold numeric(10,2),
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now()
);


ALTER TABLE public.pantry_dictionary OWNER TO root;

--
-- Name: pantry_inventory; Type: TABLE; Schema: public; Owner: root
--

CREATE TABLE public.pantry_inventory (
    category character varying(255) NOT NULL,
    current_quantity numeric(10,2) DEFAULT 0,
    unit character varying(50),
    next_expiry date,
    last_updated date,
    status character varying(50),
    critical_threshold numeric(10,2),
    notes text,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now()
);


ALTER TABLE public.pantry_inventory OWNER TO root;

--
-- Name: pantry_dictionary pantry_dictionary_pkey; Type: CONSTRAINT; Schema: public; Owner: root
--

ALTER TABLE ONLY public.pantry_dictionary
    ADD CONSTRAINT pantry_dictionary_pkey PRIMARY KEY (category);


--
-- Name: pantry_inventory pantry_inventory_pkey; Type: CONSTRAINT; Schema: public; Owner: root
--

ALTER TABLE ONLY public.pantry_inventory
    ADD CONSTRAINT pantry_inventory_pkey PRIMARY KEY (category);


--
-- PostgreSQL database dump complete
--

\unrestrict z8JHVvKmJVH80snWZwfxXBveGeatJIjXNBNsluDUk5nuwUajAJadAcWhIYlh37H

