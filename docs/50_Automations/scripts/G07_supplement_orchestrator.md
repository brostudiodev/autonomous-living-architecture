---
title: "G07: Supplement Orchestrator"
type: "automation_spec"
status: "active"
owner: "Michał"
goal_id: "goal-g07"
updated: "2026-04-28"
---

# G07: Supplement Orchestrator

## Purpose
Transforms bio-nutrition advisories into actionable Google Tasks. It closes the loop between health analysis (readiness/training load) and physical execution.

## Scope
### In Scope
- Consuming advice from `G07_bio_nutrition_agent.py`.
- Filtering for specific supplement icons (💊, ⚠️).
- Creating tasks in the "Pantry" Google Task list.
- Setting due dates to TODAY for immediate action.

### Out of Scope
- Nutritional analysis (handled by `G07_bio_nutrition_agent.py`).
- Tracking supplement stock levels (handled by G03).

## Inputs/Outputs
### Input
- **Source:** Python logic from `G07_bio_nutrition_agent.py`.

### Output
- **Target:** Google Tasks API (list: "Pantry").
- **Audit:** `system_activity_log`.

## Procedure
### Manual Execution
```bash
python3 G07_supplement_orchestrator.py
```

## Logic
1. Generate the Bio-Nutrition Advisory report.
2. Scan for lines containing recovery or warning emojis.
3. Clean the text and push to Google Tasks to ensure the user sees it in their primary task interface.

## Integration
- **Orchestrator:** `autonomous_daily_manager.py` (runs in parallel).
- **Domain:** Predictive Health Management.

## Owner + Review Cadence
- **Owner:** Michał
- **Review:** Monthly.
---
