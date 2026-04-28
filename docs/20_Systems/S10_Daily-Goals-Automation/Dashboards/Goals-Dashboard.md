---
title: "Grafana Dashboard: Goals Dashboard"
type: "dashboard_spec"
status: "active"
dashboard_uid: "goals-dashboard"
system_id: "system-s05"
owner: "Michał"
updated: "2026-02-25"
review_cadence: "monthly"
---

# Grafana Dashboard: Goals Dashboard

## Purpose
Provide a real-time operational view of autonomous goals and tasks (totals, completion rate, per-goal progress, and incomplete task detail) sourced from Prometheus metrics.

## Scope
### In Scope
- Visualization of goal/task KPIs using Prometheus metrics.
- Per-goal filtering via a Grafana template variable.
- Debugging/validation of the Prometheus queries used by the dashboard.

### Out of Scope
- Authoring or editing goal data (handled by the exporter and upstream YAML/JSON files).
- Defining goal taxonomy or priorities.

## Inputs / Outputs
### Inputs
- Prometheus time series scraped from `goals-exporter`.

Key metrics used:
- `autonomous_goals_total`
- `autonomous_tasks_total`
- `autonomous_tasks_completed`
- `autonomous_tasks_priority{priority="p1"|"p2"|"p3"}`
- `autonomous_goal_progress{goal="Gxx", ...}`
- `autonomous_goal_completion_rate{goal="Gxx", ...}`
- `autonomous_goal_tasks{goal="Gxx", status="total"|"completed"|"blocked"}`
- `autonomous_goal_incomplete_task{goal="Gxx", task_name="…", priority="…", minutes="…"}`

### Outputs
- Grafana panels showing totals, rates, distributions, and a per-goal incomplete task table.

## Dashboard Details
- **Title:** Goals Dashboard
- **UID:** `goals-dashboard`
- **Source JSON:** `/home/{{USER}}/grafana/dashboards/goals-dashboard.json`
- **Provisioning:** `/home/{{USER}}/grafana/provisioning/dashboards/dashboard.yml` (file provider path `/var/lib/grafana/dashboards`)
- **Default refresh:** `30s`
- **Default time range:** `now-6h → now`

## Data Source
- **Grafana datasource UID:** `prometheus`
- **Type:** Prometheus
- **Provisioning file:** `/home/{{USER}}/grafana/provisioning/datasources/datasources.yml`

## Panels (What They Mean)
1. **Total Goals**
- PromQL: `autonomous_goals_total`

2. **Total Tasks**
- PromQL: `autonomous_tasks_total`

3. **Completed Tasks**
- PromQL: `autonomous_tasks_completed`

4. **Overall Completion Rate**
- PromQL: `autonomous_tasks_completed / autonomous_tasks_total * 100`

5. **Tasks by Priority**
- PromQL: `autonomous_tasks_priority`

6. **Goal Progress - $goal**
- PromQL: `autonomous_goal_progress{goal="$goal"}`

7. **Goal Completion Rate - $goal**
- PromQL: `autonomous_goal_completion_rate{goal="$goal"}`

8. **Task Status - $goal**
- PromQL: `autonomous_goal_tasks{goal="$goal"}`

9. **Incomplete Tasks - $goal**
- PromQL: `autonomous_goal_incomplete_task{goal="$goal"}`

## Variables
- `goal` (Prometheus query variable)
- Query: `label_values(autonomous_goal_progress, goal)`

## Dependencies
- Grafana service (container `grafana`).
- Prometheus service (container `prometheus`).
- goals exporter service (container `goals-exporter`).
- Network connectivity: Grafana → Prometheus (`http://prometheus:9090`).

## Procedure
### Daily
- Verify the dashboard loads without errors.
- Spot-check that `Total Tasks` changes when TODO/goals data changes.

### Weekly
- Confirm `goal` variable options match the active goal IDs.
- Review the **Incomplete Tasks** table for obviously stale tasks.

### Monthly
- Validate exporter and scrape health:
  - Prometheus target `goals-tracker` should be `UP`.

## Validation
Run in host shell:
```bash
curl -fsS http://localhost:9090/api/v1/query?query=autonomous_goals_total | jq '.data.result'
```

## Failure Modes
| Scenario | Detection | Response |
|---|---|---|
| Prometheus datasource broken | Grafana panels show datasource/query errors | Check `prometheus` container status and Grafana datasource UID `prometheus` |
| Exporter down | Prometheus target `goals-tracker` down, dashboard shows N/A | Restart `goals-exporter`, verify `/metrics` responds |
| Variable `goal` empty | Dropdown has no options | Ensure `autonomous_goal_progress` metric exists and includes `goal` label |
| Completion rate divide-by-zero | Gauge shows NaN/Inf | Ensure `autonomous_tasks_total` is non-zero; consider clamping if needed |

## Security Notes
- Dashboard is read-only visualization; data is pulled via Grafana backend from Prometheus.
- Protect Grafana admin credentials and restrict dashboard access appropriately.

## Owner + Review Cadence
- **Owner:** Michał
- **Review cadence:** Monthly
- **Last updated:** 2026-02-25
