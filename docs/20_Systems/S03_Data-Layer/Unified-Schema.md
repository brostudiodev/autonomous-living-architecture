---
title: "S03: High-Level Unified Data Schema"
type: "system_spec"
status: "active"
system_id: "S03"
goal_id: "goal-g11"
owner: "Michał"
updated: "2026-02-27"
---

# S03: Unified Data Schema (The Life Lake)

## Overview
To achieve Tier 4 Autonomy, the system must correlate data across 12 diverse life domains. This schema defines the high-level architecture for aggregating siloed data into a unified intelligence layer.

## Core Architectural Pattern: The Hybrid Lake
I use a **Hybrid Schema** approach:
1. **Siloed Production DBs:** Strong relational schemas for domain operations (Finance, Health, etc.).
2. **Unified Intelligence Layer:** Flattened views and temporal tables for cross-domain correlation.

## 1. The Event Stream (Existing)
Table: `digital_twin_updates`
- **Purpose:** Immutable log of all system signals.
- **Format:** `JSONB` update_data for maximum flexibility.

## 2. The Flattened Temporal Table (Q2 Target)
Table: `v_unified_daily_intelligence` (Materialized View)
Flattens domain data into a single row per day:
- `measurement_date` (PK)
- `health_readiness_score`
- `health_sleep_score`
- `finance_budget_breaches`
- `pantry_low_stock_count`
- `productivity_task_completion_pct`
- `brand_subscriber_growth`

## 3. The Predictive "Ghost" Schema
Table: `predictions`
- **Purpose:** Stores system forecasts to measure accuracy.
- **Fields:** `target_date`, `metric_name`, `predicted_value`, `actual_value`, `confidence_interval`.

## Integration Standards
- **Global Link:** All records MUST link to a `measurement_date`.
- **Unit Standard:** Metric values are stored as floats; units are managed in `pantry_dictionary` or `meta_mapper`.
- **Traceability:** Every unified record must point back to its `source_system` (G01-G12).
