---
title: "G09_ai_skill_analyzer.py: Learning Strategy"
type: "automation_spec"
status: "active"
automation_id: "G09_ai_skill_analyzer"
goal_id: "goal-g09"
systems: ["S09", "S04", "S10"]
owner: "Michał"
updated: "2026-03-09"
---

# G09: AI Skill Analyzer

## Purpose
Uses LLM reasoning to analyze study history (G06) and suggest the "Next 3 Best Actions" for learning, ensuring that study time is focused on the highest-priority certification gaps.

## Triggers
- **When:** Scheduled via `G11_global_sync.py` (runs periodically).
- **Manual:** `python3 G09_ai_skill_analyzer.py`
- **Internal:** Called by `autonomous_daily_manager.py` during dashboard generation.

## Inputs
- **Career Context:** Active goals, required hours, and recent study history from `G09_career_data_provider`.
- **Environment Variables:** `GOOGLE_GEMINI_API_KEY`.

## Processing Logic
1. **Fetch Context:** Gathers detailed study metrics and goal gaps from the `autonomous_learning` database.
2. **AI Analysis:** 
    - Sends the context to Gemini 1.5 Flash.
    - Requests specific, actionable next steps (not generic topics).
    - Prioritizes goals with the largest "hour gap" and highest priority.
3. **Persist Recommendations:** Saves the JSON output to `learning_recommendations.json`.

## Outputs
- **JSON Registry:** `learning_recommendations.json` containing 3 specific actions.
- **Console Log:** Displays the recommendations.

## Dependencies
### Systems
- [S09 Career Intelligence](../../10_Goals/G09_Automated-Career-Intelligence/README.md)
- [S04 Digital Twin Hub](../../20_Systems/S04_Digital-Twin/README.md)

### External Services
- Google Gemini API

### Credentials
- `GOOGLE_GEMINI_API_KEY` (stored in `.env`)

## Error Handling
| Failure Scenario | Detection | Response | Alert |
|---|---|---|---|
| API Timeout | Exception in request | Use fallback generic tasks | Console |
| DB Offline | Connection error in provider | Log error, return empty list | None |
| Invalid JSON | JSON parse error from LLM | Attempt regex cleanup, then fallback | None |

## Monitoring
- **Success metric:** Specific learning recommendations appear in the Obsidian Daily Note and Google Calendar.
- **ROI Tracking:** Included in the G10 Planning ROI.

## Manual Fallback
Michał can manually review the `v_learning_progress` view in the database or the `Roadmap.md` in G06 to determine next steps.

---
*Related Documentation:*
- [G06_learning_sync.md](G06_learning_sync.md)
- [G09_career_data_provider.md](G09_career_data_provider.md)
- [autonomous_daily_manager.md](autonomous_daily_manager.md)
