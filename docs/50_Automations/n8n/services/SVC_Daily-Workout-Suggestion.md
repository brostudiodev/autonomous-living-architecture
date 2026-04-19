---
title: "SVC: Daily Workout Suggestion"
type: "automation_spec"
status: "inactive"
automation_id: "SVC_Daily-Workout-Suggestion"
goal_id: "goal-g01"
systems: ["S08", "S07"]
owner: "Michal"
updated: "2026-04-10"
---

# SVC: Daily-Workout-Suggestion

## Purpose
Automated morning briefing that queries the workout database to determine the optimal workout suggestion based on recovery time (HIT protocol: train every 3-5 days). Delivers workout recommendation to Telegram. Runs daily at 6:49 AM.

**Status:** Currently inactive (active=false in n8n).

## Triggers
- **Schedule Trigger:** Daily at 6:49 AM (Schedule: Daily 6:49 AM node, lines 6-19).

## Inputs
- **PostgreSQL Query:** `SELECT workout_date, template_id, duration_min, days_since_last_workout, recovery_score, mood_score FROM workouts ORDER BY workout_date DESC LIMIT 1`

## Processing Logic
1. **PostgreSQL: Get Last Workout** (PostgreSQL node, lines 22-36): Queries `workouts` table for most recent workout record.
2. **Code: Determine Suggestion** (Code node, lines 39-46): Calculates days since last workout. Logic:
   - 0 days: "Workout done today!" (rest day tomorrow)
   - 1-2 days: Rest day (CNS recovery)
   - 3-5 days: TRAINING DAY (optimal)
   - 5+ days: GET TO THE GYM (streak alert)
   - No record: Log First Workout
3. **Telegram: Send Suggestion** (Telegram node, lines 49-67): Sends formatted message to chat ID `{{TELEGRAM_CHAT_ID}}`.

## Outputs
- **Telegram Message:** Formatted workout suggestion.
- **Example Output:** `🏋️ **Workout Suggestion**\n\n💪 TRAINING DAY\n\n📅 Last: 2026-04-08 (3 days ago)\n⏱️ Duration: 45 min\n\nPerfect timing! 3 days since last workout.`

## Dependencies
### Systems
- [S08 Automation Orchestrator](../../../20_Systems/S08_Automation-Orchestrator/README.md) - n8n Execution engine.
- [S07 Predictive Health Management](../../../20_Systems/S06_Health-Performance/README.md) - Health database.

### External Services
- PostgreSQL database (`autonomous_training`).
- Telegram Bot (AndrzejSmartBot credentials).

## Error Handling
| Failure Scenario | Detection | Response | Alert |
|---|---|---|---|
| No workout record | Query returns empty | Returns "Log First Workout" suggestion | n8n Execution log |
| PostgreSQL failure | PostgreSQL node error | Workflow error logged | n8n Execution log |

## Security Notes
- Hardcoded Telegram chat_id (`{{TELEGRAM_CHAT_ID}}`) - should use environment variable.
- PostgreSQL credentials stored in n8n credential store.
- Telegram credentials stored in n8n credential store.

## Manual Fallback
```bash
# Manually check last workout
psql -U michal -d autonomous_training -c "SELECT * FROM workouts ORDER BY workout_date DESC LIMIT 1;"
```