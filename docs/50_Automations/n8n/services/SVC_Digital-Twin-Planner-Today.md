---
title: "service: SVC_Digital-Twin-Planner-Today"
type: "automation_spec"
status: "active"
automation_id: "SVC_Digital-Twin-Planner-Today"
goal_id: "goal-g10"
systems: ["S04", "S09"]
owner: "Michal"
updated: "2026-02-23"
---

# service: SVC_Digital-Twin-Planner-Today

## Purpose
A production-ready n8n sub-workflow that connects the Intelligent-Hub to the Digital Twin API's `/today` endpoint. It parses the current Obsidian Daily Note to deliver a live "Mobile Dashboard" of vitals, goal progress, and manual tasks to Telegram.

## Triggers
- **Sub-workflow:** Called by `ROUTER_Intelligent_Hub` (typically via `/today` or `/vitals` commands).

## Inputs
- **Router Data:** Raw text query, chat ID, and user metadata.

## Processing Logic
1. **Normalize Router Input:**
   - Detects language (Polish/English).
   - Normalizes metadata for routing.
2. **Fetch Twin Dashboard:**
   - Calls `GET http://[INTERNAL_IP]:5677/today?format=text`.
3. **Format for Dispatcher:**
   - Extracts the pre-formatted `response_text` from the API.
   - Maps metadata to the `SVC_Response-Dispatcher` format.

## Outputs
- **Formatted Response:** `{"response_text": "📱 Today's Dashboard...", "chat_id": "...", "metadata": {...}}`

## Dependencies
### Systems
- [Digital Twin System](../../20_Systems/S04_Digital-Twin/README.md)
- [Productivity & Time](../../20_Systems/S09_Productivity-Time/README.md)

### External Services
- **Digital Twin API:** Running on `[INTERNAL_IP]:5677`.

## Manual Fallback
Verify the API is reachable: `curl http://[INTERNAL_IP]:5677/today?format=text`.
