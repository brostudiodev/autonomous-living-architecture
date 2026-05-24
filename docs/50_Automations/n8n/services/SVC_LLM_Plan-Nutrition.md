---
title: "SVC: LLM Plan Nutrition"
type: "automation_spec"
status: "active"
owner: "Michał"
updated: "2026-05-04"
---

# SVC_LLM_Plan-Nutrition

## Purpose
The Nutrition Intelligence Engine. It designs precise, multi-day nutrition plans optimized for body composition goals and high-intensity training recovery (HIT/Mentzer). It accounts for real-world constraints like prep time and budget.

## Scope
- **In Scope:** Macro calculation, meal scheduling, shopping list generation, training/rest day differentiation.
- **Out Scope:** Primary inventory tracking.

## Data Flow (Inputs/Outputs)

### Input (JSON via Webhook)
```json
{
  "goal": "lean_bulk",
  "days": 3,
  "profile": { "weight_kg": 85, "activity_level": "moderate" },
  "preferences": { "prep_time_max_minutes": 30, "budget": "medium" }
}
```

### Output (JSON)
```json
{
  "success": true,
  "data": {
    "calculated_targets": { "daily_calories": 2800, "protein_g": 180 },
    "days": [
      { "day_type": "training", "meals": [...] }
    ],
    "shopping_list": [...],
    "total_estimated_cost_pln": 350
  }
}
```

## Dependencies
- **Service:** Google Gemini API
- **Source:** `G03_meal_planner.py`
- **Trigger:** Webhook at `/webhook/llm/plan-nutrition`

## Failure Modes
| Scenario | Detection | Response |
|----------|-----------|----------|
| Unsafe Targets | Safeguard node | Flags plan for review if calories <800 or >6000. |
| Incomplete Plan | Integrity check | Error if meals sum deviates from daily total >100kcal. |

## Security Notes
- No sensitive user data outside of basic biometric profile.

## Owner + Review Cadence
- **Owner:** Michał
- **Review:** Monthly (Review recipe variety and macro adherence)
