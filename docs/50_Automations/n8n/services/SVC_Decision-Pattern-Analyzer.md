---
title: "Service: Decision Pattern Analyzer"
type: "automation"
status: "active"
owner: "Michał"
updated: "2026-04-10"
---

# SVC_Decision-Pattern-Analyzer

## Purpose
The Decision Pattern Analyzer is a "Metacognitive" engine that performs a weekly audit of the system's decisions, triages, and human interactions. It identifies recurring themes, cognitive biases, and discrepancies between intentions and actual outcomes across all life domains (Health, Finance, Productivity).

## Scope
- **In Scope:** Weekly aggregation of daily intelligence, task triage history, friction reports, and readiness trends.
- **Out Scope:** Real-time decision making (handled by Agent Zero/n8n routers).

## Logic (Managed by n8n)
> ⚠️ **Note:** The core logic of this service is managed within **n8n**.

1.  **Data Harvesting:** Aggregates the last 7 days of `daily_intelligence` and `system_activity_log`.
2.  **Pattern Recognition:** Identifies recurring themes (e.g., "Financial stress," "Maintenance mode vs. Growth").
3.  **Bias Detection:** Highlights potential cognitive biases (e.g., deferring strategic tasks despite high readiness).
4.  **Actionable Recommendations:** Generates top 3 concrete changes and one system improvement for the next week.
5.  **Scoring:** Assigns a 1-10 score to each domain and an overall weekly score.
6.  **Persistence:** Upserts the analysis into the `weekly_intelligence` table (`decision_pattern_analysis` column).

## Inputs/Outputs
- **Inputs:**
  - Database: `daily_intelligence` (7-day window)
- **Outputs:**
  - Database: `digital_twin_michal.weekly_intelligence` (column: `decision_pattern_analysis`)
  - Notifications: Failure alerts via Gmail.

## Dependencies
- **Systems:** Digital Twin Engine (G04), PostgreSQL (S03).
- **Services:** n8n, Google Gemini API.
- **Credentials:** `Postgres account digital_twin_michal docker`, `Google Gemini(PaLM) Api account 2`.

## Procedure (Execution)
- **Schedule:** Weekly (typically Friday/Sunday evening).
- **Manual Trigger:** Can be executed via n8n UI for custom reporting periods.

## Failure Modes
| Scenario | Detection | Response |
|----------|-----------|----------|
| Missing Table | Postgres node error | Run `scripts/setup_intelligence_db.py` to create `weekly_intelligence` |
| Insufficient Data | Code node validation | Ensure at least 3-4 days of daily logs exist |
| LLM Analysis Timeout | LLM Chain node failure | Check API status or simplify prompt |

## Security Notes
- Processes sensitive historical data across all domains.
- Access restricted to internal network and authenticated n8n instance.
