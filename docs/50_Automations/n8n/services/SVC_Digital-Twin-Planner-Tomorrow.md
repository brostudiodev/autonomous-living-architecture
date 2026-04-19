---
title: "service: SVC_Digital-Twin-Planner-Tomorrow"
type: "automation_spec"
status: "active"
automation_id: "SVC_Digital-Twin-Planner-Tomorrow"
goal_id: "goal-g10"
systems: ["S04", "S09"]
owner: "Michal"
updated: "2026-04-10"
---

# service: SVC_Digital-Twin-Planner-Tomorrow

## Purpose
A production-ready n8n sub-workflow that orchestrates the "Tomorrow's Mission Briefing" (Daily Planner). It fetches aggregated data from the Digital Twin API, including today's wins, tomorrow's calendar, and strategic intelligence, then formats it for Telegram delivery.

## Triggers
- **Sub-workflow:** Called by `ROUTER_Intelligent_Hub` (typically via `/tomorrow` or `/briefing` commands).

## Inputs
- **Router Data:** Raw text query, chat ID, and user metadata.

## Processing Logic
1. **Normalize Router Input** (Code node, lines 19-29): Extracts command, cleans `/training` prefix, detects language from keywords (Polish: jaki, kiedy, ile, trening vs English: what, when, how, workout), extracts `chat_id`, `source_type`, and `username`.
2. **Fetch Twin Planner Tomorrow** (HTTP Request node, line 32): GET request to `http://{{INTERNAL_IP}}:5677/tomorrow` - fetches tomorrow's planner data from Digital Twin API.
3. **Format for Dispatcher** (Code node, lines 52-62): Parses JSON response, extracts `today_summary` (wins), `tomorrow_preview` (calendar, missions), `strategic_advice`. Sanitizes text for Telegram (strips Wiki-links `[[]]`, converts `[]` to `()`, replaces underscores with dashes). Constructs structured briefing message.

## Outputs
- **Formatted Response:** `{"response_text": "🌙 Mission Briefing...", "chat_id": "...", "metadata": {...}}`

## Dependencies
### Systems
- [Digital Twin System](../../../20_Systems/S04_Digital-Twin/README.md)
- [Productivity & Time](../../../20_Systems/S09_Productivity-Time/README.md)

### External Services
- **Digital Twin API:** Running on `{{INTERNAL_IP}}:5677` (with `/tomorrow` endpoint).
- **Google Calendar API:** Accessed via the backend G10 client.

## Manual Fallback
Verify API health: `curl http://{{INTERNAL_IP}}:5677/tomorrow`. The sub-workflow includes error handling to return "Digital Twin context unavailable" if the API is down.
