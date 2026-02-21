---
title: "G01: Monthly Health Reporter"
type: "automation_spec"
status: "active"
automation_id: "g01-monthly-reporter"
goal_id: "goal-g01"
systems: ["S06"]
owner: "{{OWNER_NAME}}"
updated: "2026-02-21"
---

# G01: Monthly Health Reporter

## Purpose
Aggregates monthly health and training data from the `autonomous_training` database and generates a Markdown report.

## Triggers
- Manual execution
- Planned: Monthly cron job

## Inputs
- `autonomous_training` database (workouts, body composition)

## Outputs
- Markdown report in `docs/10_Goals/G01_Target-Body-Fat/artifacts/reports/`

## Dependencies
- [S03 Data Layer](../../20_Systems/S03_Data-Layer/README.md)
- [S06 Health Performance](../../20_Systems/S06_Health-Performance/README.md)
