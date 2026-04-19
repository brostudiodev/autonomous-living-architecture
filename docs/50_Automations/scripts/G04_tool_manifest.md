---
title: "Automation Spec: G04 Tool Manifest"
type: "automation_spec"
status: "active"
automation_id: "G04_tool_manifest"
goal_id: "goal-g04"
systems: ["S04"]
owner: "Michal"
updated: "2026-04-01"
---

# 🤖 Automation Spec: G04 Tool Manifest

## Purpose
The `G04_tool_manifest.json` file acts as the primary registry for mapping G-series scripts to agent-executable tools. It allows the Digital Twin API to expose a dynamic set of capabilities to n8n and other client systems without manual code changes.

## Inputs
- **File:** `scripts/_meta/G04_tool_manifest.json`.
- **Schema:** JSON array of tool objects.

## Tool Metadata Format
```json
{
  "id": "unique_tool_id",
  "domain": "goal_domain (e.g., finance)",
  "script": "script_filename.py",
  "description": "Functional description for the AI Agent",
  "parameters": {}
}
```

## Processing Logic
1.  **Discovery:** 
    - `GET /tools`: Returns metadata for tools, supporting domain filtering (e.g., `?domain=finance`).
    - `GET /tool/list`: Returns the complete definitive list of all registered tools.
    - `GET /tool/help`: Returns a human-readable and AI-optimized guide for using the tool framework.
2.  **Validation:** When `POST /execute_tool` is called, the API verifies the `tool_id` exists in this manifest before execution.

## Dependencies
### Systems
- [S04 Digital Twin Registry](../../20_Systems/S04_Digital-Twin/Tool-Registry.md)

## Failure Modes
| Failure Scenario | Detection | Response |
|---|---|---|
| Invalid JSON | API logs error on startup/reload | Validate JSON syntax. |
| Missing Script | `execute_tool` returns 400 | Verify the `script` path in the manifest. |

## Manual Fallback
Tools can still be executed manually via the command line:
`python3 scripts/[script_name].py`
