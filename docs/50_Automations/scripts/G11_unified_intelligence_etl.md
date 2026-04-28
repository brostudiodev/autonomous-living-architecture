---
title: "G11_unified_intelligence_etl.py: Multi-Domain Data Warehouse"
type: "automation_spec"
status: "active"
automation_id: "g11-unified-intelligence-etl"
goal_id: "goal-g11"
systems: ["S03", "S04", "S11"]
owner: "Michał"
updated: "2026-03-10"
review_cadence: "Quarterly"
---

# G11_unified_intelligence_etl.py

## Purpose
The primary ETL (Extract, Transform, Load) engine for the system's "Life Data Warehouse". It consolidates fragmented data from domain-specific databases (Health, Finance, Pantry, Training) into a single, unified `daily_intelligence` table. This enables high-fidelity cross-domain analysis and long-term performance modeling.

## Scope
### In Scope
- Extracting daily metrics from 4+ independent PostgreSQL databases.
- Normalizing currency (PLN), time (minutes), and biological scores.
- Performing UPSERT operations to maintain daily data integrity.
- Supporting historical backfills via `G11_intelligence_backfill.py`.

### Out of Scope
- Real-time event streaming (strictly daily batches).
- Multi-user data isolation (Person 001 only).

## Triggers
- **Scheduled:** Daily via `autonomous_daily_manager.py`.
- **Manual:** `python3 scripts/G11_unified_intelligence_etl.py`
- **Backfill:** `python3 scripts/G11_intelligence_backfill.py` (30-day window).

## Inputs
- **Database: autonomous_health:** Sleep Score, Readiness, HRV, Steps, Calories.
- **Database: autonomous_finance:** Daily Spend (PLN), Budget alerts.
- **Database: autonomous_pantry:** Low stock count.
- **Database: autonomous_training:** Workout presence, Recovery score.
- **Database: digital_twin_michal:** Autonomy ROI (Minutes saved).

## Processing Logic
1.  **Extract:** Sequential connections to domain databases to fetch current day aggregates.
2.  **Transform:**
    - Coalescing NULL values to 0.
    - Consolidating budget alerts from `v_budget_performance`.
    - Calculating workout status from binary presence in `workouts` table.
3.  **Load:** UPSERT (Insert on conflict update) into `digital_twin_michal.daily_intelligence`.

## Outputs
- **Unified Table:** `daily_intelligence` (Master record for analytical queries).

## Dependencies
### Systems
- [S03 Data Layer](../../20_Systems/S03_Data-Layer/README.md) - Host for consolidated table.
- [S11 Meta-System](../../20_Systems/S11_Meta-System-Integration/README.md) - Logic owner.

## Error Handling
| Failure Scenario | Detection | Response | Alert |
|---|---|---|---|
| Domain DB Offline | `psycopg2` error | Log specific domain fail, proceed with others | ETL Warning |
| UPSERT Conflict | Primary Key Error | Abort specific date, continue | Critical Error |

## Related Documentation
- [Goal: G11 Meta-System Integration](../../10_Goals/G11_Meta-System-Integration-Optimization/README.md)
- [API: /intelligence/best_day](./G04_digital_twin_api.md)

---
*Created: 2026-03-10 by Digital Twin Assistant*
