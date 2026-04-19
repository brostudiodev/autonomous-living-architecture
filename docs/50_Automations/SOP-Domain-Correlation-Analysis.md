---
title: "SOP: Domain Correlation Analysis"
type: "sop"
status: "active"
owner: "Michal"
updated: "2026-04-03"
---

# SOP: Domain Correlation Analysis

## Purpose
Enables the system to identify relationships and patterns between isolated life domains (e.g., how spending habits affect mood or how sleep quality impacts workout performance).

## Scope
- **In Scope:** Cross-database joining of `autonomous_finance` (transactions), `digital_twin_michal` (mood/energy), and `autonomous_health` (biometrics).
- **Out Scope:** Real-time medical diagnosis or automated financial trading.

## Inputs/Outputs
- **Inputs:** Month/Year parameters, Domain A, Domain B.
- **Outputs:** AI-generated analytical report via Telegram or API.

## Dependencies
- **Systems:** PostgreSQL (multiple databases), Gemini Flash (via `G05_ollama_wrapper.py`).
- **Endpoints:** `/correlation` (REST), `/correlation` (AgentZero natural language).

## Procedure

### Running an Analysis
1. **Natural Language:** Ask the bot: *"How did my spending affect my mood in March?"*
2. **Explicit Command:** Use `/correlation finance mood 3 2026`.
3. **Review:** The system will aggregate daily sums/scores, join them by date, and send the dataset to the LLM for pattern recognition.

### Data Precision Rules
- **Finance:** Only `type = 'Expense'` items are summed to avoid income skewing the "spending" metric.
- **Mood/Energy:** Uses the 1-10 integer scales from `daily_intelligence`.

## Failure Modes
| Scenario | Detection | Response |
|----------|-----------|----------|
| 404 Error | Log shows "Route not found" | Ensure API is restarted and route is registered in `G04_digital_twin_api.py`. |
| Insufficient Data | Bot says "Insufficient data" | Ensure daily logs and finance syncs have been run for that month. |
| Schema Error | "Unknown column" in logs | Verify table structures in `G04_digital_twin_engine.py`. |

## Owner + Review Cadence
- **Owner:** Michal
- **Review:** Quarterly or when adding new telemetry sources (e.g., environment sensors).
