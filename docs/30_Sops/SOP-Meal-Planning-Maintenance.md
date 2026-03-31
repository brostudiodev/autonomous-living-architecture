---
title: "SOP: Meal Planning Maintenance"
type: "sop"
status: "active"
owner: "Michal"
updated: "2026-03-02"
---

# SOP: Meal Planning Maintenance

## 📝 Purpose
Standard procedure for maintaining the deterministic meal planning matrix and ensuring the system remains aligned with your pantry preferences.

## 🛠️ Prerequisites
- Basic Python knowledge (editing lists in `G03_meal_planner.py`).
- PostgreSQL access to `autonomous_pantry`.

## 🚀 Procedure

### 1. Updating the Recipe Matrix
When you want to add a new standard meal:
1.  Open `scripts/G03_meal_planner.py`.
2.  Locate the `RECIPES` list.
3.  Add a new dictionary entry:
    ```python
    {
        "name": "Meal Name",
        "requires": ["Ingredient A", "Ingredient B"],
        "optional": ["Garnish C"]
    }
    ```
    *Ensure ingredient names match the `category` column in the `pantry_inventory` table exactly.*

### 2. Monitoring Expiry Accuracy
1.  Check the `Meal-Suggestions.md` file in your Obsidian Inbox.
2.  Verify that recipes marked with ⭐ actually contain expiring items.
3.  If an expiring item is not being suggested, add a recipe that requires it to the matrix.

### 3. Verification
Run the planner manually to test the new matrix:
```bash
python3 scripts/G03_meal_planner.py
```

## ⚠️ Troubleshooting
| Issue | Cause | Resolution |
|---|---|---|
| No recipes suggested | Strict requirements | Check if common staples (Rice, Pasta) are in inventory. |
| Misspelled Ingredient | Case sensitivity | Script uses `.lower()` but the matrix string must exist in DB. |
