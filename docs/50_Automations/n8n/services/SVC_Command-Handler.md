---
title: "SVC: Command Handler"
type: "service_spec"
status: "active"
service_id: "SVC_Command-Handler"
goal_id: "goal-g04"
systems: ["S04", "S08"]
owner: "Michal"
updated: "2026-04-07"
---

# SVC: Command Handler

## Purpose
Acts as the central router for all text-based commands entering the system. It normalizes inputs, validates permissions, and dispatches requests to the appropriate domain service or the Digital Twin Central API.

## Triggers
- **Workflow Call:** Triggered by `ROUTER_Intelligent_Hub` after input normalization.
- **Direct Webhook:** Can be called via internal HTTP requests for system actions.

## Processing Logic
1. **Extraction:** Parses the primary command and associated arguments from the intent metadata.
2. **Deep-Link Translation (NEW Apr 07):** Intercepts `/start` commands containing underscores (e.g., `approve_123`). It automatically maps these to their primary command counterparts (e.g., `/approve 123`) to support one-tap mobile workflows.
3. **Layered Registry Lookup:**
    - **Inline:** Handled directly in the workflow (e.g., `/help`, `/start`).
    - **Standard:** Direct mapping to `/status`, `/today`, `/sync`, etc.
    - **Complex:** Routed to specialized domain workflows (e.g., `/inventory`, `/finance`).
    - **Passthrough:** Direct forwarding to the Digital Twin API for unknown but valid endpoints.
4. **API Forwarding:** Commands requiring parameters or specialized parsing are routed through the `/ask` endpoint of the Central API.

## Inputs
- **JSON Metadata:** Contains `_router` context and `intent` entities (command + args).

## Outputs
- **Standardized Response:** A JSON object ready for `SVC_Response-Dispatcher`, containing `response_text` and execution metrics.

## Dependencies
- **System:** `S04 Digital Twin Central API` (G04)
- **Workflow:** `SVC_Response-Dispatcher`
- **Workflow:** `SVC_Input-Normalizer`

## Failure Modes
| Scenario | Detection | Response |
|----------|-----------|----------|
| Unknown Command | Registry Miss | Return "Unknown command" message with /help hint |
| Missing Metadata | Node validation | Throw error, captured by error handler |
| API Timeout | HTTP Request exception | Return "System busy" or "Unreachable" message |

---
*Documentation synchronized with Command Translation Milestone (v3.8) 2026-04-07.*
