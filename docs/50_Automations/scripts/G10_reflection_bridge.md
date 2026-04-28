---
title: "G10: Automated Daily Reflection (The Reflection Bridge)"
type: "automation_spec"
status: "active"
automation_id: "G10_reflection_bridge"
goal_id: "goal-g10"
systems: ["S04", "S10", "S11"]
owner: "Michał"
updated: "2026-03-26"
---

# G10: Automated Daily Reflection (The Reflection Bridge)

## Purpose
Closes the loop between biometric/objective data and human subjective feeling. Automates the evening journaling process by generating data-driven prompts and injecting human responses directly into Obsidian.

## Triggers
1.  **Generation:** Scheduled daily at 21:00 via `G11_global_sync.py` or n8n cron.
2.  **Interaction:** n8n fetches prompts via API and sends to Telegram.
3.  **Submission:** n8n sends summarized response back to the Digital Twin API.

## Inputs
- **Digital Twin Engine:** For context-aware question generation (Readiness, Focus, Finance).
- **PostgreSQL:** `reflection_prompts` and `reflection_answers` tables.
- **Human Input:** Telegram voice or text response (processed by n8n).

## Processing Logic
1.  **Generate:** `G10_reflection_generator.py` analyzes the day and creates 3 logic-based questions.
2.  **Prompt:** n8n calls `GET /reflection/prompts` and interacts with Michał.
3.  **Submit:** n8n calls `POST /reflection/submit` with the raw input and AI summary.
4.  **Inject:** `G10_evening_summarizer.py` surgically updates the Daily Note using `%%REFLECTION%%` and `%%JOURNAL%%` markers.

## Outputs
- **Database:** Rows in `reflection_prompts` and `reflection_answers`.
- **Obsidian:** Updated sections in the current Daily Note.

## Dependencies
### Systems
- [S04 Digital Twin](../../20_Systems/S04_Digital-Twin/README.md)
- [S10 Intelligent Productivity](../../10_Goals/G{{LONG_IDENTIFIER}}/README.md)

### External Services
- **n8n:** Required for Telegram interaction and LLM summarization.
- **Google Gemini API:** (via n8n) for transcription/summary.

## Error Handling
| Failure Scenario | Detection | Response | Alert |
|---|---|---|---|
| API Offline | n8n request fails | Log to n8n | Telegram notification |
| File Locked | script fails to write | Retry after 5 mins | System Activity Log |
| Missing Markers | script log | Log warning | System Activity Log |

## Monitoring
- Success metric: Reflection injected into Obsidian daily note before 22:00.
- Dashboard: Digital Twin API `/status`.

## Manual Fallback
If the bridge fails:
1.  Open Obsidian.
2.  Locate `%%REFLECTION_START%%` in the Daily Note.
3.  Manually type your evening summary.
