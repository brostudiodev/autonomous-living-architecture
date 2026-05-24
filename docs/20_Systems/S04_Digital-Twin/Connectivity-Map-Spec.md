---
title: "REST API: Connectivity Map"
type: "technical_specification"
status: "active"
owner: "Michał"
updated: "2026-05-20"
---

# REST API: Connectivity Map

## Purpose
Provides a dynamic, interactive visualization of the system's goals, core systems, and automations. It serves as the primary tool for architectural traceability and operational visibility.

## Scope
- **In Scope:** Mermaid.js graph generation, filtering by G-series and S-series, interactive panning/zooming, and status color-coding.
- **Out Scope:** Direct system control or configuration via the map.

## Inputs/Outputs
- **Inputs:** 
  - Traceability tables in `docs/10_Goals/*/Systems.md`.
  - Latest script status from `system_activity_log` (PostgreSQL).
  - Query Parameter: `filters` (comma-separated list of Gxx or Sxx IDs).
- **Outputs:**
  - `GET /map`: Interactive HTML UI.
  - `GET /map/data`: JSON object containing the Mermaid.js definition string.

## Architecture
The system uses a **Backend-Driven Visualization** pattern:
1. **Collector:** `modules/docs/scripts/G12_connectivity_mapper.py` scans documentation and logs.
2. **API:** `core/api.py` exposes the data with filtering support.
3. **Frontend:** `autonomous_sdk/static/map.html` renders the graph using `mermaid.js` and `svg-pan-zoom`.

## Procedure

### Filtering the View
1. Open the sidebar using the **▶** toggle button on the left.
2. Select specific **Goals** or **Systems** to isolate their connectivity chains.
3. Click **🔄 Update View** to re-render.

### Navigation
- **Zoom:** Use the mouse wheel or the **➕/➖** buttons in the header. (Max zoom: 50x)
- **Pan:** Click and drag the map background.
- **Reset:** Click the **🏠** button to return to the initial view (maintains current zoom level if toggling sidebar).

## Failure Modes
| Scenario | Detection | Response |
|----------|-----------|----------|
| Graph fails to render | "Mermaid Syntax Error" message | Check `G12_connectivity_mapper.py` for ID sanitization issues. |
| "No Log" status for active scripts | Nodes appear gray/dashed | Ensure script calls `log_activity` from `G11_log_system`. |
| Empty graph | "No nodes found matching filters" | Verify filter IDs (G01, S03, etc.) are correct. |

## Security Notes
- Access requires a valid `X-API-KEY`.
- No sensitive paths or credentials are exposed in the node labels.

## Owner + Review Cadence
- **Owner:** Michał (Architect)
- **Review:** Monthly during Documentation Audit (G12).
