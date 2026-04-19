---
title: "SVC_Digital-Twin-Sync: Global System Orchestrator"
type: "automation_spec"
status: "active"
automation_id: "SVC_Digital-Twin-Sync"
goal_id: "goal-g11"
systems: ["S04", "S11"]
owner: "Michal"
updated: "2026-02-24"
---

# SVC_Digital-Twin-Sync: Global System Orchestrator

## Purpose
An n8n service workflow that triggers the global synchronization process across all subsystems (Pantry, Finance, Substack, Tasks, Daily Notes) via the Digital Twin API.

## Triggers
- **Execute Workflow Trigger:** Called by the Master Router (e.g., user says "sync all") or a scheduled maintenance workflow.

## Inputs
- **API Endpoint:** `http://{{INTERNAL_IP}}:5677/sync?format=text`

## Processing Logic
1. **Normalize Input:** Standardizes the request context.
2. **Trigger Global Sync:** Calls the Twin API `/sync` endpoint, which executes `G11_global_sync.py` on the host.
3. **Format for Dispatcher:** Returns a success/fail report for each subsystem.

## Outputs
- **Sync Report:** A Markdown list of subsystem statuses (✅ Success / ❌ Failed).

## Dependencies
### Systems
- [S11 Meta-System Integration](../../../20_Systems/S11_Meta-System-Integration/README.md)
- [Digital Twin API](../../../scripts/G04_digital_twin_api.py)

## Error Handling
| Failure Scenario | Detection | Response | Alert |
|---|---|---|---|
| Script Timeout | 120s limit in API | Reports specific script failure in list | n8n Error Workflow |
| API Unreachable | Connect Timeout | Reports global service failure | n8n Error Workflow |
