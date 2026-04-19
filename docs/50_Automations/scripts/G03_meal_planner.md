---
title: "G03_meal_planner: Intelligent Meal Selection"
type: "automation_spec"
status: "active"
automation_id: "G03_meal_planner"
goal_id: "goal-g03"
systems: ["S03", "S06"]
owner: "Michal"
updated: "2026-03-28"
---

# G03_meal_planner: Intelligent Meal Selection

## Purpose
Generates high-protein meal suggestions based on current pantry inventory and upcoming nutritional needs. Minimizes food waste by prioritizing expiring items and ensures recovery nutrition for training days.

## Triggers
- **Scheduled:** Part of the daily global sync.
- **Manual:** `python scripts/G03_meal_planner.py`

## Inputs
- **Inventory:** `pantry_inventory` table (Items > 0 qty).
- **Expiring:** `pantry_inventory` table (Items expiring within 7 days).
- **Nutrition Goals:** High-protein priority (Power Goal G01).

## Processing Logic
1. **Pantry Analysis:** Fetches all available items and identifies those near expiration.
2. **AI Suggestion Engine (Gemini 1.5 Flash):**
    - Sends inventory and expiring list to Gemini.
    - Requests 3 meal options (Breakfast, Lunch, Dinner).
    - **NEW (Mar 28):** Allows suggestions with 1-2 missing essential ingredients.
    - Gemini returns JSON with `ingredients_used` and `ingredients_missing`.
3. **Deterministic Fallback:** If AI fails, matches inventory against a hardcoded recipe matrix (e.g., Omelette, Spaghetti).
4. **Chef's Choice:** Selects the first suggestion as the primary recommendation for the day.
5. **State Persistence:** Saves the choice to `selected_meal.json` for the `G03_cart_aggregator`.

## Outputs
- **JSON:** `selected_meal.json` (Includes `missing_ingredients` for auto-procurement).
- **Markdown:** [Obsidian Meal Suggestions](../../../../Obsidian Vault/00_Inbox/Meal-Suggestions.md).
- **Telegram:** Sends "Chef's Choice" briefing with nutrition info and ingredient status.
- **System Integration:** Missing ingredients are automatically picked up by `G03_cart_aggregator.py` for the shopping list.

## Dependencies
### Systems
- [S03 Data Layer](../../20_Systems/S03_Data-Layer/README.md)
- [S06 Health Performance](../../20_Systems/S06_Health-Performance/README.md)

### External Services
- Google Gemini API

## Error Handling
| Scenario | Detection | Response |
|----------|-----------|----------|
| Gemini API Timeout | Exception caught | Fallback to deterministic recipe matrix |
| DB Connection Fail | Exception caught | Log error, skip execution |
| Empty Pantry | Inventory count = 0 | Skip suggestions, notify user |

## Monitoring
- **Success metric:** 100% of "Chef's Choice" ingredients (used + missing) accounted for in shopping list.
- **ROI:** Logged as "Meal Planning" cognitive load saved.

## Changelog
| Date | Change |
|------|--------|
| 2026-03-03 | Initial meal planning logic |
| 2026-03-28 | Integrated missing ingredients logic for autonomous procurement |
