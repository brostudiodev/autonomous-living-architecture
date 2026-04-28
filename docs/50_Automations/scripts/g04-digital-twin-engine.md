---
title: "G04_digital_twin_engine.py: Autonomous Intelligence Orchestrator"
type: "automation_spec"
status: "active"
automation_id: "g04-digital-twin-engine"
goal_id: "goal-g04"
systems: ["S04"]
owner: "Michał"
updated: "2026-03-10"
review_cadence: "Monthly"
---

# G04_digital_twin_engine.py

## Purpose
The core reasoning engine of the Digital Twin Ecosystem. It aggregates real-time data from all integrated domains (Health, Finance, Pantry, Home, Career) to generate proactive insights, dynamic schedules, and strategic alerts. It implements "Predictive Focus Switching" and longitudinal trend analysis to align daily activities with biological readiness and objective priorities.

## Scope
### In Scope
- Multi-domain state aggregation from PostgreSQL databases.
- **Cross-Domain Correlation Engine:** Identifies inter-system risks (e.g., Low activity + Weight gain).
- **Historical Trend Analysis:** **[UPDATED]** Calculates biological velocity (Sleep/Readiness/Steps) and financial velocity (Daily Spend) across 7-day and 30-day windows.
- **Autonomy ROI Tracking:** **[NEW]** Programmatically calculates and logs time saved by autonomous scripts in the `autonomy_roi` table.
- **Contextual Memory:** Persistent storage of strategic advice in `digital_twin_michal.strategic_memory`.
- **Project Watcher:** **[NEW]** Autonomous regex-parsing of Obsidian project notes to extract real-time status and next steps.
- **Vault Intelligence:** **[NEW]** Tracks knowledge graph telemetry (total notes, orphans, tag distribution).
- **Contextual Continuity:** Ability to reference and build upon previous guidance.
- Integration with Home Assistant for environmental state.
- Generation of "Director's Insights" based on cross-domain logic.
- Dynamic task suggestion based on roadmap progress and readiness.

### Out of Scope
- Direct device control (handled by G08 Home Orchestrator).
- Multi-user support (hardcoded for Person UUID 001).

## Triggers
- **API Call:** Via `/suggested`, `/all`, or `/summary` endpoints in `G04_digital_twin_api.py`.
- **Manual:** `python3 scripts/G04_digital_twin_engine.py`

## Inputs
- **Biometrics (G07):** Sleep, HRV, and Readiness scores from `autonomous_health`.
- **Financials (G05):** Budget alerts and spending velocity from `autonomous_finance`.
- **Logistics (G03):** Inventory and expiry dates from `autonomous_pantry`.
- **Smart Home (G08):** Temperature and security status via Home Assistant.
- **Career (G09):** Skill gaps and brand impact from `autonomous_career`.
- **Obsidian Vault:** Project notes and knowledge graph state.
- **Strategic Memory:** Previous insights and decisions from `digital_twin_michal`.
- **Roadmaps:** Q1 goal progress from Markdown documentation.

## Processing Logic
1.  **State Initialization:** Connects to all domain-specific databases and fetches current snapshots.
2.  **Cross-Domain Correlation:**
    - Analyzes biological readiness (Sleep/HRV) to set the "Cognitive Budget".
    - Maps roadmap tasks against current availability.
3.  **Insight Generation:**
    - **Tier 1 (Critical):** Immediate budget breaches or home security alerts.
    - **Tier 2 (Heuristic):** Cross-domain correlations (e.g., Financial pressure vs. Pantry shopping).
    - **Tier 3 (Strategic):** Predictive focus suggestions based on readiness.
    - **Tier 4 (Logistics):** Low stock or expiring pantry items.
4.  **Trend Calculation:** **[UPDATED]** Performs longitudinal analysis on biometrics and finance to detect "Improving" or "Declining" states over 7d and 30d periods.
5.  **ROI Synthesis:** Aggregates cumulative "Minutes Saved" for the current day.

## Outputs
- **Structured JSON:** The complete `twin_state` for API consumption (now including `trends` and `roi`).
- **Markdown Reports:** Natural language briefings for Telegram and Obsidian.

## Dependencies
### Systems
- [S04 Digital Twin](../../20_Systems/S04_Digital-Twin/README.md) - Parent system.
- [S03 Data Layer](../../20_Systems/S03_Data-Layer/README.md) - Data source.

### External Services
- **Home Assistant REST API:** For real-time sensor data.

## Error Handling
| Failure Scenario | Detection | Response | Alert |
|---|---|---|---|
| DB Offline | `psycopg2` Error | Mark domain as "Offline" in state | Report UI |
| HA Unreachable | Timeout | Use last cached home state | Report UI |
| Roadmap Missing | `os.path.exists()` | Skip goal progress calculation | Console |

## Security Notes
- **Privacy:** 100% Local processing of all biometrics and financials.
- **Data Integrity:** Read-only access to most databases; strictly controlled state aggregation.

## Related Documentation
- [Goal: G04 Digital Twin Ecosystem](../../10_Goals/G04_Digital-Twin-Ecosystem/README.md)
- [System: S04 Digital Twin](../../20_Systems/S04_Digital-Twin/README.md)

---
*Updated: 2026-03-10 by Digital Twin Assistant*
