---
title: "G04: Context Cache Manager"
type: "automation_spec"
status: "active"
automation_id: "G04_context_cache_manager"
goal_id: "goal-g04"
systems: ["S04"]
owner: "Michał"
updated: "2026-04-28"
---

# G04: Context Cache Manager

## Purpose
The **Context Cache Manager** (`G04_context_cache_manager.py`) is a high-performance utility designed to solve timeout issues in the Digital Twin Uber-Context endpoint (`/all`). It pre-calculates the entire system state (aggregating from 7+ databases) and stores it as a ready-to-serve JSON blob.

## Triggers
- **Scheduled:** Runs every 10 minutes (`*/10 * * * *`) via crontab.
- **On-Demand:** Can be triggered manually to force a cache refresh.

## Inputs
- **Databases:** `autonomous_finance`, `autonomous_health`, `autonomous_training`, `digital_twin_michal`.
- **API Internal Calls:** `engine.get_full_context()`, `format_dashboard()`, `generate_report()`.

## Processing Logic
1. **Data Aggregation:** Executes all "heavy" data gathering logic (readiness, finance alerts, health trends, reliability logs).
2. **Snapshot Construction:** Builds a unified `uber_context` JSON object.
3. **Formatted Report:** Pre-renders the Markdown version of the dashboard.
4. **PostgreSQL Persistence:** Performs an `UPSERT` on the `digital_twin_updates` table with `entity_type='uber_context'`.
5. **Redis Persistence (v7.1 Migration):** Pushes the aggregated `uber_context` JSON directly to Redis under the key `twin:context:all` with a 1-hour TTL.
6. **Logging:** Records success/failure in `system_activity_log`.

## Outputs
- **Redis (Fast):** Shared state in `twin:context:all`.
- **PostgreSQL (Persistent):** Updated `state_data` in `digital_twin_updates`.
- **System Log:** `SUCCESS` entry in `system_activity_log`.

## Performance Impact
- **Before Caching:** `/all` response time ~5-15 seconds (frequent timeouts in n8n).
- **After Caching:** `/all` response time < 50 milliseconds.

## Dependencies
- **Engine:** `G04_digital_twin_engine.py`.
- **Dashboards:** `G11_unified_health_dashboard.py`, `G11_system_reliability_auditor.py`.

---
*Updated: 2026-04-23 | Initial implementation of high-frequency system state caching.*
