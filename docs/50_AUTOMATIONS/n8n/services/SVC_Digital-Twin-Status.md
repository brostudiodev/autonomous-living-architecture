---
title: "service: SVC_Digital-Twin-Status"
type: "automation_spec"
status: "active"
automation_id: "SVC_Digital-Twin-Status"
goal_id: "goal-g04"
systems: ["S04", "S05"]
owner: "{{OWNER_NAME}}"
updated: "2026-02-19"
---

# service: SVC_Digital-Twin-Status

## Purpose
A production-ready n8n sub-workflow that connects the Intelligent-Hub to the Digital Twin API. It handles input normalization (including language detection) and formats the life status summary for the Telegram response dispatcher.

## Triggers
- **Sub-workflow:** Called by `ROUTER_Intelligent_Hub` (typically via `/status` or `/training` commands).

## Inputs
- **Router Data:** Raw text query, chat ID, and user metadata.

## Processing Logic
1. **Normalize Router Input:**
   - Cleans command prefixes (e.g., removes `/training`).
   - Detects language (Polish/English) based on keyword matching.
   - Normalizes metadata (`chat_id`, `source_type`, `user_id`).
2. **Fetch Twin Status:**
   - Calls `GET http://{{INTERNAL_IP}}:5677/status`.
3. **Format for Dispatcher:**
   - Extracts the human-readable summary.
   - Maps metadata to the required `SVC_Response-Dispatcher` format.
   - Preserves trace information and success flags.

## Outputs
- **Formatted Response:** `{"response_text": "...", "chat_id": "...", "metadata": {...}}`

## Dependencies
### Systems
- [Digital Twin System](../../20_SYSTEMS/S04_Digital-Twin/README.md)
- [Telegram Integration](../../20_SYSTEMS/S05_Telegram-Integration/README.md)

### External Services
- **Digital Twin API:** Running on `{{INTERNAL_IP}}:5677`.

## Manual Fallback
Verify the API is reachable: `curl http://{{INTERNAL_IP}}:5677/status`. If down, the dispatcher will receive a failure or the router will hit its fallback.
