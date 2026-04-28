---
title: "G09: Professional Impact Synthesis"
type: "automation_spec"
status: "active"
automation_id: "G09_career_growth_reporter.py"
goal_id: "goal-g09"
systems: ["S04", "S09"]
owner: "Michał"
updated: "2026-03-11"
---

# G09: Professional Impact Synthesis

## Purpose
Autonomously synthesizes technical achievements, "Million Dollar Ideas", and project wins from the Digital Twin's strategic memory into a concise, professional impact summary. This maintains a live career portfolio with zero manual effort.

## Triggers
- **Automated:** Executed weekly or as part of the `G11_global_sync.py` registry.
- **Manual:** `python3 scripts/G09_career_growth_reporter.py`
- **Dashboard:** Injected into the "Director's Insights" section of the Daily Note.

## Inputs
- PostgreSQL Database: `digital_twin_michal`
- Table: `strategic_memory` (filtered for last 7 days).
- LLM Engine: Gemini 1.5 Flash.

## Processing Logic
1.  **Achievement Harvesting:** Collects all memory entries of type 'achievement', 'insight', or 'million_dollar_idea' from the past week.
2.  **AI Synthesis:** Sends the raw data to Gemini with a "Professional Brand Strategist" prompt.
3.  **Refinement:** Structures the output into exactly 3 bold, high-impact bullet points focused on technical leadership and architectural wins.

## Outputs
- **Markdown Report:** 3-bullet summary injected into Obsidian.
- **Centralized Logging:** Reports `SUCCESS` or `FAILURE` to `system_activity_log`.

## Dependencies
### Systems
- [S04 Digital Twin](../../20_Systems/S04_Digital-Twin/README.md)
- [S09 Automated Career Intelligence](../../10_Goals/G09_Automated-Career-Intelligence/README.md)

### External Services
- Google Gemini API

## Error Handling
| Failure Scenario | Detection | Response | Alert |
|---|---|---|---|
| No Memories Found | SQL query returns empty | Skip report, return "No new wins" | System Activity Log |
| API Error | `requests` timeout | Log failure | System Activity Log |

## Manual Fallback
If career synthesis is unavailable:
1.  Manually review the `strategic_memory` table.
2.  Review Git commit history for technical wins.
3.  Copy wins into the Digital Twin UI: "/career/generate_growth_report".
