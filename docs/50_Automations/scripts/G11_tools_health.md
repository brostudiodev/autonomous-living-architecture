---
title: "G11_tools_health.py: Tool Discovery & Health API"
type: "automation_spec"
status: "active"
automation_id: "G11_tools_health"
goal_id: "goal-g11"
systems: ["S11", "S04"]
owner: "Michal"
updated: "2026-04-18"
---

# G11: Tools Health and Validation API

## Purpose
Provides a discovery and health validation layer for all G11 Meta-System tools. It ensures that all scripts in the `scripts/` folder are correctly registered in the system manifest and tracks their operational health.

## Endpoints
- **GET `/tools/health`**: Returns a comprehensive health report of all G11 tools, including registration status and recent execution history.

## Logic
1. **Manifest Validation**: Cross-references scripts in the folder with the `G04_tool_manifest.json`.
2. **Orphan Detection**: Identifies "orphaned" scripts that exist in the filesystem but are not registered in the manifest.
3. **Health Integration**: Pulls historical success/failure data for each tool via `G11_script_health.py`.

## Implementation Details
- **Framework**: FastAPI / Uvicorn.
- **Port**: 5680.
- **Manifest Path**: `scripts/_meta/G04_tool_manifest.json`.

---
*Related Documentation:*
- [G04_tool_manifest.md](../S04_Digital-Twin/G04_tool_manifest.md)
- [G11_script_health.md](G11_script_health.md)
