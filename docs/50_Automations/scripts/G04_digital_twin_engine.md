---
title: "G04: Digital Twin Core Engine"
type: "automation_spec"
status: "active"
automation_id: "G04_digital_twin_engine.py"
goal_id: "goal-g04"
systems: ["S04"]
owner: "Michal"
updated: "2026-04-19"
---

# G04: Digital Twin Core Engine

## Purpose
The primary "brain" of the Autonomous Living ecosystem. This script aggregates data from all subsystems (Finance, Health, Logistics, Pantry, etc.) to provide holistic insights, generate strategic directives, and maintain the cross-domain correlation engine.

## Key Features
- **State Aggregation:** Pulls current reality from 7+ PostgreSQL databases.
- **Time-Aware Historical Queries (NEW Apr 14):** Support for `target_date` in all major state methods (`get_health_status`, `generate_summary`, `get_full_context`). Allows the system to reconstruct historical system states for any given day.
- **Personal Anniversary Engine (NEW Apr 14):** Specialized logic to track yearly recurring events (Birthdays, Weddings) via the `anniversaries` table.
- **Strategic Memory:** Records and retrieves up to 20 "strategic_memory" items to maintain contextual continuity across days.
- **Best Day Insight:** Identifies peak performance days by correlating sleep, readiness, and step data.
- **Director's Insights (Fix Apr 01):** Specifically logic-checked to ensure "Previous Guidance" is fetched before the current state is saved to memory, preventing duplication of insights.
- **Correlation Engine:** Detects patterns between domains (e.g., Caffeine vs. REM Sleep, Budget vs. Pantry).
- **Primary Directive (Updated Apr 04):** Dynamically extracts the "Morning Mission" from `morning_mission.txt` for use by the G11 Mission Aggregator.
- **Quarter-Aware Roadmap (Updated Apr 04):** `get_roadmap_mins()` now automatically detects the current quarter (e.g., Q2) and filters tasks accordingly.
- **Autonomy ROI:** Calculates time saved via automated systems.
- **Proactive State Updates (Added Apr 13):** `update_entity_state()` allows external agents to push real-time snapshots to the `digital_twin_updates` table, enabling high-frequency telemetry without polling bottlenecks.
- **Sanity Audit Support (Added Apr 15):** Implemented `AUDIT_MODE=1` protocol for non-destructive system health verification (G11 compliance).
- **Centralized Timezone (Added Apr 15):** Migrated hardcoded timezone logic to use `db_config.TIMEZONE` for consistent display of biometric events (Sleep start/end).
- **Unified Hydration Target (NEW Apr 18):** Standardized the system-wide hydration goal to **2000ml** (Water + Coffee contribution). This target is now enforced across the engine (`get_hydration_status`), the task prompter (`get_task_recommendations`), and Agent Zero reports, eliminating conflicting "1750ml" or "2500ml" alerts.
- **System-Wide DB Normalization (NEW Apr 18):** Completed a comprehensive normalization of database connection variables across the entire ecosystem. Migrated all G-series scripts to use centralized constants from `db_config.py` (e.g., `DB_FINANCE`, `DB_HEALTH`), resolving widespread typos (e.g., `DB_TRAININGG`) and variable truncation (`db_confi` -> `db_config`) that previously caused intermittent connectivity gaps.
- **Unlocked Historical Data (NEW Apr 19):** Removed all history-based limitations (30/90 days). Default lookback and forecasting windows standardized to **3650 days (10 years)** across all analytical methods (`get_sleep_trend`, `get_workout_stats`, `generate_finance_forecast`, etc.). This enables seamless multi-year trend analysis and prevents data gaps in historical reporting.
- **Circuit Breaker Integration (Added Apr 17):** Formalized the use of `@domain_circuit_breaker` in the core engine. All database queries are now protected by the `G04_domain_isolator`, enabling fast-failing for unstable domains and preventing system-wide hangs.

## Triggers
- **Internal:** Called by `G04_digital_twin_api.py`, `autonomous_daily_manager.py`, and `G11_mission_aggregator.py`.
- **Manual:** `python3 scripts/G04_digital_twin_engine.py` (prints suggested report) or `AUDIT_MODE=1 python3 scripts/G04_digital_twin_engine.py` for health check.

## Inputs
- **Databases:** `digital_twin_michal`, `autonomous_finance`, `autonomous_health`, `autonomous_pantry`, `autonomous_training`, `autonomous_learning`, `autonomous_life_logistics`.
- **Obsidian:** Scans `02_Projects/` for active roadmap statuses.
- **Local Files:** `morning_mission.txt` for primary directives.

## Outputs
- **Twin State:** A unified JSON state object used by the API and Bot.
- **Director's Insights:** Markdown formatted insights for the Daily Note.
- **Snapshots:** Persists daily system state to `twin_state_snapshots`.

## Dependencies
### Systems
- [S04 Digital Twin Hub](../../20_Systems/S04_Digital-Twin/README.md)
- [S03 Data Layer](../../20_Systems/S03_Data-Layer/README.md)

## Error Handling
| Failure Scenario | Detection | Response | Alert |
|---|---|---|---|
| Sub-DB Offline | `psycopg2` error | Skips that domain, populates error msg | Log Info |
| Memory Full | Disk space check | Rotates older logs | Log Warning |
| Missing morning_mission.txt | FileNotFoundError | Fallback to "Execute 2026 Power Goals" | Log Info |

## Manual Fallback
If the engine is failing:
1. Check connectivity to all Postgres databases.
2. Run `python3 scripts/G04_digital_twin_engine.py` to see domain-specific error messages.
