---
title: "G12: Dynamic Connectivity Mapper"
type: "automation_spec"
status: "active"
automation_id: "G12_connectivity_mapper"
goal_id: "goal-g12"
systems: ["S04", "S11"]
owner: "Michał"
updated: "2026-03-28"
---

# G12: Dynamic Connectivity Mapper

## Purpose
Generates a real-time architectural visualization of the autonomous system by crawling `Systems.md` files and correlating them with live activity logs. This provides 100% visibility into system health and goal-to-automation traceability.

## Triggers
- **Manual:** `python scripts/G12_connectivity_mapper.py`
- **Web UI:** Triggered when visiting `GET /map` on the Digital Twin API.

## Inputs
- **Documentation:** `docs/10_Goals/*/Systems.md` (Traceability tables).
- **Database:** `digital_twin_michal.system_activity_log` (Latest status per script).

## Processing Logic
1. **Directory Crawl:** Iterates through all goal directories in `docs/10_Goals/`.
2. **Table Parsing:** Uses regex to extract `Goal -> System` and `System -> Automation` relationships from Markdown tables.
3. **Health Correlation:** Queries the database for the latest status (`SUCCESS`, `FAILURE`, or `UNKNOWN`) of each identified automation.
4. **Graph Synthesis:** Generates a Mermaid.js string with custom styling classes for health-based color coding.

## Outputs
- **Mermaid String:** Served via `GET /map/data`.
- **Interactive UI:** Rendered HTML at `GET /map`.

## Dependencies
### Systems
- [S04 Digital Twin Hub](../../20_Systems/S04_Digital-Twin/README.md)
- [S11 Meta-System Integration](../../20_Systems/S11_Meta-System-Integration/README.md)

## Error Handling
| Scenario | Detection | Response |
|----------|-----------|----------|
| Broken Table | Regex fail | Skip row, log warning |
| DB Error | psycopg2 exception | Set status to `UNKNOWN` |
| Path Missing | `os.path.exists` | Show error node in Mermaid |

## Monitoring
- **Success metric:** 100% coverage of documented goal-to-automation links.
- **Visual Validation:** All nodes in `/map` correctly reflect statuses from `system_activity_log`.

## Manual Fallback
If the dynamic map fails, refer to the static version in [Obsidian Vault/G11_System_Connectivity_Map.md](../../../../Obsidian Vault/G11_System_Connectivity_Map.md).
