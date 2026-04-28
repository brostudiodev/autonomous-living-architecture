---
title: "S04: Tool Registry & Agent Execution"
type: "system_spec"
status: "active"
owner: "Michał"
updated: "2026-04-01"
---

# S04: Tool Registry & Agent Execution

## Purpose
The Tool Registry provides a unified, domain-driven interface for Agent Zero and other sub-agents to discover and execute G-series scripts. It transitions the system from a collection of isolated scripts into an "Agentic Framework" where capabilities are dynamically exposed to AI.

## Scope
- **In Scope:** Tool discovery via `/tools` and `/tool/list`, tool execution via `/execute_tool`, tool documentation via `/tool/help`, tool metadata management in `G04_tool_manifest.json`.
- **Out Scope:** Script logic itself, direct SSH execution of scripts from n8n.

## Inputs/Outputs
- **Discovery:** 
    - `GET /tool/list`: Returns a JSON list of all available tools.
    - `GET /tool/help`: Returns a formatted guide and tool descriptions for human/AI reference.
- **Execution:** 
    - `POST /execute_tool`: Takes a JSON `tool_id` and optional parameters.
    - **Output:** Execution status (SUCCESS/FAILURE), raw script output, exit code.

## Dependencies
- **Systems:** [S04 Digital Twin Engine](../../20_Systems/S04_Digital-Twin/README.md), [G11 Centralized Logger](../../50_Automations/scripts/G11_log_system.md).
- **Files:** `scripts/_meta/G04_tool_manifest.json`.

## Procedure
### Adding a New Tool
1.  Develop and test the G-series script in `scripts/`.
2.  Open `scripts/_meta/G04_tool_manifest.json`.
3.  Add a new entry with `id`, `domain`, `script` path, and `description`.
4.  The tool is now immediately discoverable by n8n agents via the `/tools` endpoint.

## Failure Modes
| Scenario | Detection | Response |
|----------|-----------|----------|
| Script not found | API returns 400 | Verify `script` path in manifest. |
| Execution Timeout | 60s timeout in `execute_tool` | Check for blocking calls or heavy DB queries. |
| Manifest Corrupted | `ToolRegistry` logs error | Validate JSON syntax in `G04_tool_manifest.json`. |

## Security Notes
- **Execution Guard:** Only scripts registered in the manifest can be executed.
- **Parameters:** Parameters are currently passed as env-aware variables to ensure safe execution (Future G11-FH expansion).

## Owner + Review Cadence
- **Owner:** Michał
- **Review Cadence:** Monthly audit of tool performance and accuracy.
