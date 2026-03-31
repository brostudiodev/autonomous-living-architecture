---
title: "Automation Spec: G03 Pantry Suggestion Engine"
type: "automation_spec"
status: "active"
automation_id: "G03_pantry_suggestor.py"
goal_id: "goal-g03"
systems: ["S03", "S05"]
owner: "Michal"
updated: "2026-03-23"
---

# G03: Pantry Suggestion Engine

## Purpose
Generates intelligent restocking recommendations based on real-time inventory levels, physical locations, consumption burn rates, and financial constraints.

## Key Features
- **Predictive Analytics:** Uses historical burn rates from `v_pantry_predictions` to forecast stockout dates and trigger alerts 7 days in advance.
- **Location Awareness:** Supports multiple physical locations (e.g., `Spizarka`, `Gabinet`) to provide context-specific restocking advice.
- **Threshold Integrity:** Distinguishes between `NULL` (untracked) and `0` (essential but lean) critical thresholds.
- **Price Intelligence:** Cross-references needs with the `pantry_prices` table to suggest the cheapest store and highlight active promotions (🔥).
- **Financial Awareness:** Connects to the `autonomous_finance` database to compare estimated restock costs against the remaining 'Lifestyle' budget.

## Triggers
- **Automated:** Part of the `autonomous_daily_manager.py` dashboard generation.
- **Manual:** `python3 scripts/G03_pantry_suggestor.py`

## Inputs
- **Databases:** `autonomous_pantry` (Inventory, Prices, Predictions) and `autonomous_finance` (Budget Performance).
- **Configuration:** `.env` for database connectivity.

## Processing Logic
1.  **Requirement Extraction:** Queries `v_pantry_predictions` for items that are below threshold or predicted to run out within 7 days.
2.  **Location Tagging:** Retrieves the `location` for each item to group suggestions logically.
3.  **Price Scouting:** Performs a `LEFT JOIN` with `pantry_prices` to find the lowest available price.
4.  **Autonomy Evaluation:** For critical items (below threshold and < 3 days remaining), it calls the `G11_rules_engine` to evaluate `auto_procurement`.
5.  **Agentic Workflow:** If the engine returns `ASK_HUMAN`, it creates a pending decision request for Telegram approval.
6.  **Budget Validation:** Retrieves the current remaining 'Lifestyle' budget.
7.  **Reporting:** Formats a Markdown table with Location context and status icons (🚨, ⚠️, 🔮).

## Outputs
- **Obsidian Inbox:** Updates `Obsidian Vault/00_Inbox/Pantry-Suggestions.md`.
- **System Activity Log:** Records a `SUCCESS` entry with total suggestions and estimated cost.

## Dependencies
### Systems
- [S03 Data Layer](../../20_Systems/S03_Data-Layer/README.md)
- [S05 Finance System](../../10_Goals/G05_Autonomous-Financial-Command-Center/README.md)

---
*Updated: 2026-03-23*
