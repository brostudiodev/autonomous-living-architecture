---
title: "SVC: Reflection Provider"
type: "automation_spec"
status: "active"
automation_id: "SVC_Reflection-Provider"
goal_id: "goal-g10"
systems: ["S08"]
owner: "Michal"
updated: "2026-04-10"
---

# SVC_Reflection-Provider

## Purpose
Automated evening workflow that provides AI-generated reflection prompts based on daily data. Runs daily to support journaling and self-reflection.

## Triggers
- **Schedule:** Daily evening (time TBD).

## Inputs
- **PostgreSQL:** Reads daily data from multiple databases (health, finance, productivity).
- **Digital Twin API:** Fetches system state.

## Processing Logic
1. **Fetch Daily Context** (HTTP Request node): Gets today's data from Digital Twin API.
2. **Generate Reflection Prompts** (Code node): Creates contextual questions based on day's data.
3. **Format Message** (Code node): Formats prompts for Telegram delivery.
4. **Send to Telegram** (Telegram node): Delivers reflection prompts.

## Outputs
- **Telegram:** Evening reflection prompts.

## Dependencies
### Systems
- [S08 Automation Orchestrator](../../../20_Systems/S08_Automation-Orchestrator/README.md)
- [S04 Digital Twin](../../../20_Systems/S04_Digital-Twin/README.md)

### External Services
- Telegram Bot.
- Google Gemini API (for prompt generation).

## Manual Fallback
Check daily note in Obsidian for context.