---
title: "Grafana Dashboard: Static Goals Dashboard"
type: "dashboard_spec"
status: "active"
dashboard_uid: "static-goals-dashboard"
system_id: "system-s05"
owner: "Michal"
updated: "2026-02-25"
review_cadence: "monthly"
---

# Grafana Dashboard: Static Goals Dashboard

## Purpose
Provide a lightweight table view of *flattened incomplete tasks* coming from a static JSON endpoint, primarily for debugging/verification of the goals JSON feed and quick operational review.

## Scope
### In Scope
- Displaying incomplete tasks via JSON API datasource.
- Validating the `/static_goals` endpoint output shape.

### Out of Scope
- Prometheus-based KPIs (covered by the Goals Dashboard).
- Editing goal/task definitions.

## Inputs / Outputs
### Inputs
- HTTP JSON endpoint served by `goals-exporter`:
  - Container path: `http://goals-exporter:8080/static_goals`
  - Host access (port mapping): `http://localhost:8082/static_goals`

Expected JSON shape:
```json
{ "data": [ {"goal_id": "G01", "goal_name": "…", "task_name": "…", "priority": "p1", "minutes": 30}, ... ] }
```

### Outputs
- Table panel listing goal/task rows (one row per incomplete task).

## Dashboard Details
- **Title:** Static Goals Dashboard
- **UID:** `static-goals-dashboard`
- **Source JSON:** `/home/{{USER}}/grafana/dashboards/static-goals-dashboard.json`
- **Provisioning:** `/home/{{USER}}/grafana/provisioning/dashboards/dashboard.yml`
- **Default refresh:** off (`refresh=false` in dashboard)
- **Default time range:** `now-6h → now` (not materially used by static JSON)

## Data Source
- **Grafana datasource name:** `Static Goals JSON`
- **Grafana datasource UID:** `static-goals-json`
- **Type:** `marcusolsson-json-datasource` (JSON API)
- **Provisioning file:** `/home/{{USER}}/grafana/provisioning/datasources/datasources.yml`

## Panel
### Incomplete Tasks (Static)
- **Type:** Table
- **Fields extracted** via JSONPath:
  - `$.data[*].goal_id`
  - `$.data[*].goal_name`
  - `$.data[*].task_name`
  - `$.data[*].priority`
  - `$.data[*].minutes`

## Dependencies
- Grafana service (container `grafana`).
- goals exporter service (container `goals-exporter`).
- JSON API datasource plugin must be installed (no changes required if already present).

## Procedure
### Daily
- Open the dashboard and confirm the table populates.

### Weekly
- Validate endpoint shape hasn’t changed:
```bash
curl -fsS http://localhost:8082/static_goals | jq '.data | type, length'
```

### Monthly
- If table is empty unexpectedly, validate `goals.json` generation and exporter logs.

## Failure Modes
| Scenario | Detection | Response |
|---|---|---|
| JSON endpoint down | Table shows datasource/network error | Check `goals-exporter` container status and logs |
| JSON shape changed | Table shows missing fields / empty columns | Ensure endpoint returns `{data: [...]}` and paths still match |
| Auth/CORS issues | Requests failing in Grafana | Prefer proxy access mode; check datasource config |

## Security Notes
- Endpoint may expose task titles; treat as personal data.
- Restrict Grafana access; avoid exposing dashboards publicly.

## Owner + Review Cadence
- **Owner:** Michal
- **Review cadence:** Monthly
- **Last updated:** 2026-02-25
