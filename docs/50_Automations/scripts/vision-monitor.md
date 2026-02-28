---
title: "script: vision-monitor"
type: "automation_spec"
status: "active"
automation_id: "vision-monitor"
goal_id: "goal-g11"
systems: ["S11"]
owner: "Michal"
updated: "2026-02-23"
---

# script: vision-monitor

## Purpose
Aggregates the 2026 North Star vision and active Power Goal intents into a single strategic view. This ensures the North Star remains visible during daily execution.

## Triggers
- **API Call:** Triggered via the `/vision` endpoint of the Digital Twin API.

## Inputs
- **Documentation:** `docs/00_Start-here/North-Star.md` and `docs/10_Goals/*/README.md`.

## Processing Logic
1. **Vision Extraction:** Regex-parses the North Star definition from the root strategy files.
2. **Goal Enumeration:** Iterates through goal directories to extract IDs, names, and "Intent" sections.
3. **Intent Normalization:** Cleans up Markdown formatting for consistent API delivery.

## Outputs
- **JSON Object:** Strategic hierarchy of North Star and Goals.
- **Markdown Text:** Formatted list for Telegram strategic reviews.

## Dependencies
### Systems
- [Meta-System Integration (S11)](../../../20_Systems/S11_Intelligence_Router/README.md)

## Error Handling
| Failure Scenario | Detection | Response |
|---|---|---|
| Folder missing | `os.path.exists` fails | Return "Unknown" for vision |
| Format mismatch | Regex fail | Provide "TBD" for goal intent |

## Manual Fallback
Review the base documentation files in `docs/` directly.
