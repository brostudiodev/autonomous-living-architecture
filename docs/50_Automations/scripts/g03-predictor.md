---
title: "G03: Pantry Predictor"
type: "automation_spec"
status: "active"
automation_id: "g03-predictor"
goal_id: "goal-g03"
systems: ["S04"]
owner: "Michal"
updated: "2026-02-21"
---

# G03: Predictive Pantry Analysis

## Purpose
Analyzes real-time pantry inventory from PostgreSQL to predict restocking needs based on estimated consumption rates.

## Triggers
- Manual execution: `{{ROOT_LOCATION}}/autonomous-living/.venv/bin/python3 scripts/g03_predictive_pantry_simple.py`
- Planned: Integration into `fill-daily.sh` for morning briefing generation.

## Inputs
- PostgreSQL database: `autonomous_pantry`
  - `pantry_inventory`: Current stock levels
  - `pantry_dictionary`: Critical thresholds per category

## Processing Logic
1. Connects to `autonomous_pantry` database.
2. Joins inventory and dictionary tables to get current stock and thresholds.
3. Applies weekly consumption rates (configurable in script).
4. Calculates `Days_Until_Critical` for each item.
5. Assigns priority (URGENT/HIGH/LOW) based on lead time.
6. Outputs a list of items requiring attention.

## Outputs
- Console summary of items requiring restock.
- Analysis JSON: `docs/10_Goals/G03_Autonomous-Household-Operations/Analysis/predictive-pantry-analysis.json`

## Dependencies
- [S03 Data Layer](../../20_Systems/S03_Data-Layer/README.md)
- [S04 Digital Twin](../../20_Systems/S04_Digital-Twin/README.md)

## Failure Modes
| Failure Scenario | Detection | Response |
|---|---|---|
| DB Connection Fail | Script Error | Check PostgreSQL status |
| Insufficient Data | Low accuracy | Continue manual tracking |
