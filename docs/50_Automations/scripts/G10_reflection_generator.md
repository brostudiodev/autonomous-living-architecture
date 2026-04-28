---
title: "G10_reflection_generator.py: AI Feedback Loop"
type: "automation_spec"
status: "active"
automation_id: "g10-reflection-generator"
goal_id: "goal-g10"
systems: ["S04", "S10"]
owner: "Michał"
updated: "2026-03-10"
review_cadence: "Monthly"
---

# G10_reflection_generator.py

## Purpose
Closes the daily feedback loop by generating a personalized, data-driven evening reflection. It synthesizes biological readiness, checked goals, and technical wins into a philosophical "Stoic Coach" briefing, which is then injected directly into the Obsidian Daily Note.

## Scope
### In Scope
- Fetching today's biometrics from `autonomous_health`.
- Extracting "Checked" Power Goals and "Did" statements from the Daily Note.
- Identifying the daily "Automation Win" from frontmatter.
- **Resilient Reporting:** Uses Gemini 1.5 for philosophical synthesis (if API key available) or a logic-based data summary (fallback).
- Precise injection into the `## 🧠 Reflection` section using regex.

### Out of Scope
- Modifying biometrics data (read-only).
- Managing tomorrow's schedule (delegated to G10_tomorrow_planner).

## Triggers
- **API Call:** Via `/log_reflection` endpoint.
- **Manual:** `python3 scripts/G10_reflection_generator.py`

## Inputs
- **Obsidian Daily Note:** Source for checked tasks and goal descriptions.
- **PostgreSQL (`autonomous_health`):** Source for sleep, readiness, and steps.
- **Gemini 1.5 API:** For "Stoic Coach" persona synthesis.

## Processing Logic
1.  **Context Scrape:** Reads the current Daily Note and the last 24 hours of biometric data.
2.  **Logic-Based Analysis:** 
    - Identifies if output was high despite low readiness (Grit detection).
    - Checks if North Star goals (G04, G10, G11) were touched.
3.  **Synthesis:**
    - **AI Mode:** Feeds context to Gemini with a prompt focusing on "Reality", "Strategic Win", and "Stoic Pivot".
    - **Fallback Mode:** Generates a structured list of metrics vs. achievements.
4.  **Injection:** Uses `re.sub` to replace or insert the reflection block under the correct header in the note.

## Outputs
- **Note Update:** Injects `> [!brain] **AI Evening Reflection**` block into today's note.

## Dependencies
### Systems
- [S04 Digital Twin](../../20_Systems/S04_Digital-Twin/README.md) - API exposure.
- [S10 Productivity](../../10_Goals/G{{LONG_IDENTIFIER}}/README.md) - Reflection methodology.

## Error Handling
| Failure Scenario | Detection | Response | Alert |
|---|---|---|---|
| Note Missing | `os.path.exists` | Log error, abort | API 200 (with warning) |
| API Key Missing | `os.getenv` | Trigger logic-based summary | Inline Note tag |
| Header Missing | `string in content` | Log warning, abort injection | Console |

## Related Documentation
- [Goal: G10 Productivity Architecture](../../10_Goals/G{{LONG_IDENTIFIER}}/README.md)
- [Script: G04 Digital Twin API](./G04_digital_twin_api.md)

---
*Created: 2026-03-10 by Digital Twin Assistant*
