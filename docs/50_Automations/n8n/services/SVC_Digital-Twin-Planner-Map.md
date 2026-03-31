---
title: "service: SVC_Digital-Twin-Planner-Map"
type: "automation_spec"
status: "active"
automation_id: "SVC_Digital-Twin-Planner-Map"
goal_id: "goal-g11"
systems: ["S04", "S11"]
owner: "Michal"
updated: "2026-02-23"
---

# service: SVC_Digital-Twin-Planner-Map

## Purpose
An n8n sub-workflow that connects the Intelligent-Hub to the Digital Twin API's `/map` endpoint. It generates and retrieves the G11 system connectivity matrix, providing a real-time audit of how well all 12 goals are integrated with the data layer.

## Triggers
- **Sub-workflow:** Called by `ROUTER_Intelligent_Hub` (typically via the `/map` command).

## Inputs
- **Router Data:** Raw text query, chat ID, and user metadata.

## Processing Logic
1. **Normalize Router Input:**
   - Cleans the `/map` command prefix.
   - Detects language (Polish/English).
2. **Fetch Twin Connectivity Map:**
   - Calls `GET http://[INTERNAL_IP]:5677/map?format=text`.
3. **Format for Dispatcher:**
   - Extracts the pre-formatted `response_text` from the API.
   - Maps metadata to the standard `SVC_Response-Dispatcher` format.

## Outputs
- **Formatted Response:** `{"response_text": "G11 Connectivity Matrix...", "chat_id": "...", "metadata": {...}}`

## Dependencies
### Systems
- [Digital Twin System](../../20_Systems/S04_Digital-Twin/README.md)
- [Meta-System Integration (S11)](../../20_Systems/S11_Meta-System-Integration/README.md)

### External Services
- **Digital Twin API:** Running on `[INTERNAL_IP]:5677`.

## Manual Fallback
Verify the API is reachable: `curl http://[INTERNAL_IP]:5677/map?format=text`.
