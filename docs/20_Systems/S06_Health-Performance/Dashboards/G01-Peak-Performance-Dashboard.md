---
title: "Grafana Dashboard: G01 Peak Performance (15% Body Fat Target)"
type: "dashboard_spec"
status: "active"
dashboard_uid: "g01-performance-sql"
goal_id: "goal-g01"
system_id: "system-s05"
owner: "Michal"
updated: "2026-02-25"
review_cadence: "monthly"
---

# Grafana Dashboard: G01 Peak Performance (15% Body Fat Target)

## Purpose
Operationalize the `goal-g01` fitness/health objective by tracking body fat trend, readiness, and training progression in one place.

## Scope
### In Scope
- Visualization of training and body composition data sourced from PostgreSQL `autonomous_training`.
- Quick detection of stalled body fat progress and training readiness regressions.

### Out of Scope
- Writing to the database.
- ETL or view generation (handled by the data layer).

## Inputs / Outputs
### Inputs
- PostgreSQL database: `autonomous_training`
- Key tables/views used:
  - `measurements`
  - `v_hit_progression`
  - `v_recovery_analysis`

### Outputs
- Gauges, trend charts, and tables for decision support.

## Dashboard Details
- **Title:** G01: Peak Performance Dashboard (15% Target)
- **UID:** `g01-performance-sql`
- **Source JSON:** `/home/{{USER}}/grafana/dashboards/g01-target-body-fat.json`
- **Provisioning:** `/home/{{USER}}/grafana/provisioning/dashboards/dashboard.yml`
- **Default refresh:** `1m`
- **Default time range:** `now-6M → now`

## Data Source
- **Grafana datasource name:** `autonomous_training`
- **Grafana datasource UID:** `autonomous-training`
- **Type:** `grafana-postgresql-datasource`
- **Provisioning file:** `/home/{{USER}}/grafana/provisioning/datasources/datasources.yml`

Connection requirements:
- Must have a default database configured (provisioned as `database: autonomous_training` and `jsonData.database: autonomous_training`).
- DB user must have `SELECT` on required tables/views.

## Panels (What They Mean)
1. **Current Body Fat % (Target: 15%)**
- Shows latest `measurements.bodyfat_pct` and a static target line at 15.

2. **Body Fat Trend (Towards 15%)**
- Time series from `measurements` filtered by Grafana time range.

3. **HIT Strength Progression (AI Analyzed)**
- Pulls from `v_hit_progression` to show:
  - exercise, current weight, weight delta vs previous, TUT seconds, status, recommendation.

4. **Training Readiness (Recovery Trend)**
- Time series from `v_recovery_analysis.recovery_score`.

5. **Lean Muscle Mass Preservation**
- Derived metric from measurements:
  - `bodyweight_kg - (bodyweight_kg * (bodyfat_pct / 100))`.

## Variables
None.

## Dependencies
- Grafana service (container `grafana`).
- PostgreSQL service (container `local-ai-packaged-postgres-1`).
- Datasource provisioning must join Grafana to the `local-ai-packaged_demo` Docker network.

## Procedure
### Daily
- Check **Current Body Fat** (most recent reading present).
- Check **Training Readiness** for recent dips.

### Weekly
- Review **Body Fat Trend** and confirm direction towards 15%.
- Review **HIT Strength Progression** for stalled exercises.

### Monthly
- Audit view/table schema compatibility after DB migrations.

## Validation
### From Grafana API (host)
```bash
curl -fsS -u 'admin:autonomous2026' -H 'Content-Type: application/json' \
  http://localhost:3003/api/ds/query \
  -d '{"queries":[{"refId":"A","datasource":{"uid":"autonomous-training"},"rawSql":"SELECT COUNT(*) AS n FROM measurements;","format":"table"}],"from":"now-30d","to":"now"}'
```

## Failure Modes
| Scenario | Detection | Response |
|---|---|---|
| Datasource missing default DB | Grafana error: no default database configured | Ensure datasource has `database` and `jsonData.database` set to `autonomous_training` |
| View/table schema changed | Panel SQL errors | Update SQL to match current view columns |
| Data stale | Trend flat / no new measurement rows | Verify upstream ingestion of measurements |
| Network/DNS issue | Datasource connection errors | Confirm Grafana is attached to `local-ai-packaged_demo` and can resolve `local-ai-packaged-postgres-1` |

## Security Notes
- Health data is sensitive; restrict dashboard access.
- Keep DB password only in provisioning env (`AUTONOMOUS_POSTGRES_PASSWORD`).

## Owner + Review Cadence
- **Owner:** Michal
- **Review cadence:** Monthly
- **Last updated:** 2026-02-25
