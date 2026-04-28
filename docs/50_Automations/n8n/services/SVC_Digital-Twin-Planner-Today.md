---
title: "service: SVC_Digital-Twin-Planner-Today"
type: "automation_spec"
status: "active"
automation_id: "SVC_Digital-Twin-Planner-Today"
goal_id: "goal-g10"
systems: ["S04", "S09"]
owner: "Michał"
updated: "2026-04-10"
---

# service: SVC_Digital-Twin-Planner-Today

## Purpose
A production-ready n8n sub-workflow that connects the Intelligent-Hub to the Digital Twin API's `/today` endpoint. It parses the current Obsidian Daily Note to deliver a live "Mobile Dashboard" of vitals, goal progress, and manual tasks to Telegram.

## Triggers
- **Sub-workflow:** Called by `ROUTER_Intelligent_Hub` (typically via `/today` or `/vitals` commands).

## Inputs
- **Router Data:** Raw text query, chat ID, and user metadata.

## Processing Logic
1. **Normalize Router Input** (Code node, lines 19-29): Extracts `query`, `language` (auto-detected from Polish/English keywords: dzisiaj, dziś, vitals, cele, biometria, zadania, dashboard vs today, vitals, goals, biometric, tasks), `chat_id`, `source_type`, and `username`.
2. **Fetch Twin Dashboard Today** (HTTP Request node, line 32): GET request to `http://{{INTERNAL_IP}}:5677/today?format=text` - fetches today's dashboard from Digital Twin API.
3. **Format for Dispatcher** (Code node, lines 52-62): Extracts `response_text` from API body, adds metadata, language, timestamp, and formats JSON for dispatcher.

## Outputs
- **Formatted Response:** `{"response_text": "📱 Today's Dashboard...", "chat_id": "...", "metadata": {...}}`

## Dependencies
### Systems
- [Digital Twin System](../../../20_Systems/S04_Digital-Twin/README.md)
- [Productivity & Time](../../../20_Systems/S09_Productivity-Time/README.md)

### External Services
- **Digital Twin API:** Running on `{{INTERNAL_IP}}:5677`.

## Manual Fallback
Verify the API is reachable: `curl http://{{INTERNAL_IP}}:5677/today?format=text`.
