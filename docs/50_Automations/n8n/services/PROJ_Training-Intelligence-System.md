---
title: "PROJ: Training Intelligence System"
type: "automation_spec"
status: "active"
automation_id: "PROJ_Training-Intelligence-System"
goal_id: "goal-g01"
systems: ["S08", "S07"]
owner: "Michal"
updated: "2026-04-10"
---

# PROJ_Training-Intelligence-System

## Purpose
AI-powered training intelligence system that provides workout summaries, exercise tracking, and fitness insights using natural language. Queries PostgreSQL for workouts, workout_sets, and measurements, then uses Gemini AI to generate intelligent responses.

## Triggers
- **Workflow Trigger:** Executed by another workflow (e.g., `ROUTER_Intelligent_Hub`) via `When Executed by Router` (lines 6-16).
- **Manual Trigger:** For testing via `Manual Trigger (Testing)` (lines 18-27).
- **Command:** Triggered via `/training` in Telegram.

## Inputs
- **Query:** Natural language string (e.g., "Show me my training summary", "Jaki był mój ostatni trening?").
- **Metadata:** Chat ID, source type, username.
- **Days Lookback:** Default 60 days (configurable).

## Processing Logic
1. **Normalize Router Input** (Code node, lines 29-40): Extracts query, detects language (Polish/English), sets metadata. Uses keyword matching for language detection (Polish: jaki, kiedy, ile, trening, ćwiczenie vs English: what, when, how, workout, exercise).
2. **PostgreSQL: Get Workouts** (PostgreSQL node, lines 42-61): Queries `workouts` table for specified days (default 60).
3. **PostgreSQL: Get Sets** (PostgreSQL node, lines 63-82): Queries `workout_sets` table with exercise details (weight, TUT, failure, form).
4. **PostgreSQL: Get Measurements** (PostgreSQL node, lines 84-103): Queries `measurements` table (bodyweight, bodyfat).
5. **Merge: All Training Data** (Merge node, lines 105-116): Combines all three data sources.
6. **IF: Has Training Data?** (IF node, lines 118-149): Branches based on data availability.

## AI Agent Configuration
- **Role:** Training Intelligence Assistant.
- **Language:** Auto-detected (Polish/English).
- **Model:** Google Gemini.
- **Memory:** Windowed buffer for session context.

## Outputs
- **Response Text:** Human-readable training summary or answer.
- **Data:** Workout history, sets, measurements.
- **Summary:** Total workouts, rest days, recovery scores.

## Dependencies
### Systems
- [S08 Automation Orchestrator](../../../20_Systems/S08_Automation-Orchestrator/README.md) - n8n Execution engine.
- [S07 Predictive Health Management](../../../20_Systems/S06_Health-Performance/README.md) - Training database.

### External Services
- PostgreSQL (`autonomous_training` docker).
- Google Gemini API.

## Error Handling
| Failure Scenario | Detection | Response | Alert |
|---|---|---|---|
| No training data | IF node (count = 0) | Returns empty state message | None |
| Database error | PostgreSQL node error | Workflow error logged | n8n Execution log |
| Gemini API timeout | LangChain node timeout | Return "Could not process request" | n8n Execution log |

## Security Notes
- PostgreSQL credentials stored in n8n credential store.
- Google Gemini credentials stored in n8n credential store.

## Manual Fallback
```bash
# Check workouts manually
psql -U michal -d autonomous_training -c "SELECT * FROM workouts ORDER BY workout_date DESC LIMIT 10;"
```