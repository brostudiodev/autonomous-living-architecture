---
title: "script: G11 Meta-Rules Engine"
type: "automation_spec"
status: "active"
automation_id: "G11_rules_engine"
goal_id: "goal-g11"
systems: ["S11", "S04"]
owner: "Michal"
updated: "2026-02-25"
---

# script: G11_rules_engine.py

## Purpose
The intelligence core of the Personal OS. It evaluates the consolidated state of the Digital Twin across multiple domains (Finance, Health, Learning, Logistics) to identify cross-system correlations and generate strategic "Director's Advice."

## Triggers
- **API Call:** Executed whenever the `/os` endpoint of the Digital Twin API is polled.
- **Manual:** `python3 scripts/G11_rules_engine.py` for a CLI report.

## Inputs
- **Databases:**
  - `autonomous_finance`: Budget alerts and spend patterns.
  - `autonomous_training`: Workout frequency and body fat trends.
  - `autonomous_learning`: Study progress.
  - `autonomous_pantry`: Inventory status.

## Processing Logic
1. **Data Aggregation:** Queries all core databases to form a snapshot of the ecosystem.
2. **Correlation Rules:**
   - **Health/Activity:** Flags risks if body fat is up while HIT frequency is down.
   - **Learning/Productivity:** Flags G06 risk if study hours are stagnating.
   - **Finance/Pantry:** Recommends shopping restrictions if budget breaches are high.
   - **Readiness:** Identifies "Growth Windows" when recovery scores and rest days are optimal.
3. **Categorization:** Sorts findings into `Warnings`, `Insights`, and `Recommendations`.

## Outputs
- **JSON Object:** For consumption by the Digital Twin API.
- **Markdown Text:** For direct viewing in the terminal or Obsidian.

## Dependencies
### Systems
- [S03 Data Layer](../../../20_Systems/S03_Data-Layer/README.md)
- [S04 Digital Twin](../../../20_Systems/S04_Digital-Twin/README.md)

### External Services
- PostgreSQL (Local Docker)

## Credentials
- DB Access: `{{DB_USER}}:{{DB_PASSWORD}}@{{DB_HOST}}:{{DB_PORT}}`

---
*Command Center Integration:*
The output of this engine is the primary content for the [Personal OS Dashboard](../../10_Goals/G11_Meta-System-Integration-Optimization/Personal-OS-Dashboard.md).
