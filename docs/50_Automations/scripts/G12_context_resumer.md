---
title: "G12: Context Resumer"
type: "automation_spec"
status: "active"
automation_id: "G12_context_resumer"
goal_id: "goal-g12"
systems: ["S04"]
owner: "Michal"
updated: "2026-04-18"
---

# G12: Context Resumer

## Purpose
Synthesizes the entire system state (readiness, finances, recent activity, system health) into a concise "Morning Mission Directive" to ensure rapid context resumption each day.

## Triggers
- Scheduled execution at 06:00 via `autonomous_daily_manager.py`.
- Manual execution via `fill-daily.sh`.

## Inputs
- **System State**: Readiness, Sleep, ROI, and Project data from `DigitalTwinEngine`.
- **Technical Context**: Recently modified files in `scripts/`, pending `TODO` counts.
- **System Health**: Error counts and failures in `system_activity_log`.
- **Career Intelligence**: Most recent technical win from `Technical_Wins_Log.md`.

## Processing Logic
1.  **Context Aggregation**: Collects health scores, financial alerts, technical activity, and recent wins.
2.  **Synthesis (AI or Rule-Based)**:
    *   **AI (Gemini)**: If `GEMINI_API_KEY` exists, generates a 3-sentence high-level directive.
    *   **Rule-Based (Fallback)**: Uses deterministic logic based on readiness thresholds and system status.
3.  **Rich Goal Block Generation**: Iterates through goals (G04, G05, G10) to generate navigation links and context.
4.  **Terminal Command Injection**: Dynamically generates `python3 scripts/GXX_*.py` commands for immediate resumption of active missions.
5.  **Output Segmentation**: Uses internal markers (`[RICH_MISSION_BLOCK_START]`) to allow the `autonomous_daily_manager.py` to surgically split the directive from the detailed context.

## Outputs
- **Structured String**: Segments the Directive from the Rich Mission context.
- **Temporary Cache**: Writes to `scripts/morning_mission.txt`.

## Dependencies
### Systems
- [S04 Digital Twin](../../20_Systems/S04_Digital-Twin/README.md)
- [S11 Meta-System Integration](../../20_Systems/S11_Meta-System-Integration/README.md)

### External Services
- Google Gemini API (optional but recommended).

## Error Handling
| Failure Scenario | Detection | Response | Alert |
|---|---|---|---|
| API Key Missing | Environment check | Switch to deterministic logic | Console log |
| DB Error | Exception in query | Use default maintenance directive | Console log |
| Gemini Timeout | Request timeout (20s) | Fallback to rule-based generation | Console log |

## Monitoring
- **Success metric**: Presence of `🎯 MORNING MISSION` in today's daily note.

## Manual Fallback
If the generator fails, the system provides a generic maintenance directive.
