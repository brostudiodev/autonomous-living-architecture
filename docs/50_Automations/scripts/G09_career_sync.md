---
title: "G09_career_sync.py: Career Intelligence Data Ingestion"
type: "automation_spec"
status: "active"
automation_id: "g09-career-sync"
goal_id: "goal-g09"
systems: ["S03", "S04"]
owner: "Michał"
updated: "2026-03-02"
review_cadence: "Quarterly"
---

# G09_career_sync.py

## Purpose
Initializes and maintains the Career Intelligence database (`autonomous_career`). It tracks professional development metrics including skill proficiency levels and brand impact (LinkedIn/Public recognition) to provide data-driven insights for career growth.

## Scope
### In Scope
- Database schema management for career metrics.
- Tracking of skill proficiency (0-100%).
- Tracking of brand impact metrics (platform, metric name, value).
- Integration with G04 Digital Twin for insight generation.

### Out of Scope
- Automatic scraping of LinkedIn (requires manual data provision or specific API integration).
- Resume generation (handled by separate G09 tools).

## Triggers
- **Manual:** `python3 scripts/G09_career_sync.py`
- **Scheduled:** Intended for weekly execution (TBD).

## Inputs
- **Environment Variables:** DB credentials via `.env`.
- **Manual Data:** Proficiency levels and metrics provided via DB upserts or helper files.

## Processing Logic
1.  **DB Initialization:** Ensures the `autonomous_career` database exists.
2.  **Schema Enforcement:** Creates `skill_metrics` and `brand_impact` tables if they do not exist.
3.  **Data Synchronization:** (Currently a placeholder) Designed to pull metrics from external professional platforms.

## Outputs
- **PostgreSQL Tables:** Populated `skill_metrics` and `brand_impact` tables.
- **Console Logs:** Confirmation of database readiness.

## Dependencies
### Systems
- [S03 Data Layer](../../20_Systems/S03_Data-Layer/README.md) - PostgreSQL persistence.
- [S04 Digital Twin](../../20_Systems/S04_Digital-Twin/README.md) - Consumes career data for insights.

### External Services
- None (currently local DB only).

## Error Handling
| Failure Scenario | Detection | Response | Alert |
|---|---|---|---|
| DB Connection Fail | `psycopg2.connect()` | Exit with error | Console |
| Permission Denied | SQL execution | Log error and exit | Console |

## Security Notes
- **Privacy:** 100% Local. Professional metrics are stored in the local PostgreSQL instance.
- **Credentials:** Uses standard `.env` configuration.

## Manual Fallback
Skills and brand metrics can be updated manually via SQL:
```sql
INSERT INTO skill_metrics (skill_name, proficiency_level) VALUES ('Python', 85);
```

## Related Documentation
- [Goal: G09 Automated Career Intelligence](../../10_Goals/G09_Automated-Career-Intelligence/README.md)
- [System: S03 Data Layer](../../20_Systems/S03_Data-Layer/README.md)
