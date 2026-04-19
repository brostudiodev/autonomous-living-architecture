---
title: "PROJ: Personal Agent (G10)"
type: "automation_spec"
status: "active"
automation_id: "PROJ_Personal-Agent"
goal_id: "goal-g10"
systems: ["S04", "S10"]
owner: "Michal"
updated: "2026-04-15"
---

# PROJ_Personal-Agent

## Purpose
The **Personal Agent** is a decisive and proactive AI assistant specialized in managing Michal's time and tasks. It operates on a **"Assume & Act"** philosophy, immediately executing requests related to Google Calendar and Google Tasks by making intelligent assumptions when inputs are incomplete.

## Key Features
- **Decisive Task & Calendar Execution:** Automatically adds, lists, and completes tasks and events without asking for clarification.
- **Natural Language in Polish:** Operates natively in Polish to reduce mental friction.
- **Intelligent Assumption Engine:** 
  - If no time is specified: Assumes 1 hour.
  - If no date for task: Assumes Tomorrow.
  - If date for event: Assumes Today.
- **Unified Interface:** Acts as a specialized sub-agent for the `AI-Agent-Interactive` (Telegram) hub.

## Triggers
- **Sub-workflow:** Triggered by `ROUTER_Intelligent_Hub` for keywords: `kalendarz`, `zadania`, `spotkanie`, `tasks`, `calendar`, `todo`.
- **Direct Interaction:** Accessible via Telegram bot for immediate time management.

## Inputs
- **query:** User message in Polish or English.
- **user_name / user_id:** User identification for context.
- **chat_id:** Session identifier for conversational memory.

## Processing Logic
1. **Normalization:** Standardizes input formats (supports both direct and tool-mediated calls). Extracts chat and user metadata.
2. **Context Enrichment:** Injects current Date/Time in Warsaw timezone and the user's name.
3. **AI Reasoning (Personal Agent):**
   - Uses `gemini-flash-lite-latest` (Temp 0.2) for fast, decisive action.
   - **Role:** Strict calendar/task assistant.
   - **Protocol:** "Never ask for clarification. Assume and EXECUTE."
4. **Tool Interaction:**
   - **Calendar:** Fetches events (`Get Events`), creates new ones (`Create Event`), or manages invitations (`Create Event with Attendee`).
   - **Tasks:** Lists pending items (`Get Tasks`), creates new tasks (`Create Task`), or marks items as done (`Complete Task`).
5. **Output Formatting:** Returns a conversational confirmation in Polish, explaining any assumptions made.

## AI Agent Configuration
- **Model:** Google Gemini Flash Lite (Temp 0.2).
- **Language:** Polish (Mandatory output).
- **Tools:**
  - Google Calendar (Get/Create/Update)
  - Google Tasks (Get/Create/Update)
  - Calculator

## Dependencies
### Systems
- [Intelligent Productivity (G10)](../../../10_Goals/G{{LONG_IDENTIFIER}}/README.md)
- [Digital Twin Ecosystem (G04)](../../../10_Goals/G04_Digital-Twin-Ecosystem/README.md)
- [External APIs]: Google Calendar, Google Tasks.

## Error Handling
| Failure Scenario | Detection | Response |
|----------|-----------|----------|
| Ambiguous Time | AI Step | Agent chooses a logical time slot and informs the user. |
| API Error (Auth) | Node Failure | Returns a "Przepraszam, nie udało się..." message with technical context. |
| No Query | `Normalize Input` | Prompts user with a list of its capabilities. |

## Security Notes
- **OAuth2:** Uses dedicated Google Cloud service credentials for Calendar and Tasks.
- **Timezone:** Hardcoded to `Europe/Warsaw` to prevent scheduling errors.

---

*Documentation created for PROJ_Personal-Agent.json v1.0 (2026-04-15)*
