---
title: "SOP: Unified Triage"
type: "sop"
status: "active"
owner: "Michał"
updated: "2026-04-03"
---

# SOP: Unified Triage (The Digital Twin Command Center)

## Purpose
Provides a single, frictionless interface for managing all system-generated actions, anomalies, and logistics. Instead of checking multiple databases and notes, the user performs a single "Triage" session daily.

## Scope
- **In Scope:** Pending decision requests (G11), financial spending anomalies (G05), and low-stock pantry alerts (G03).
- **Out Scope:** Direct execution of complex coding tasks or physical world actions.

## Inputs/Outputs
- **Inputs:** `digital_twin_michal.decision_requests`, `autonomous_finance.v_budget_performance`, `autonomous_pantry.pantry_inventory`.
- **Outputs:** Unified report via Telegram (`/triage`) and REST API (`GET /triage`).

## Dependencies
- **Systems:** PostgreSQL (multiple DBs), FastAPI (Digital Twin API).
- **Scripts:** `G04_digital_twin_engine.py`, `G05_finance_anomaly_detector.py`.

## Procedure

### Daily Triage Flow
1. **Trigger:** Send `/triage` to the Telegram Bot.
2. **Review:** Scan the list for critical items (marked with 🚩 or 🔴).
3. **Action:**
   - For **Decisions**: Copy the `<code>/approve [ID]</code>` command and send it back to the bot.
   - For **Anomalies**: Review the "Top TX" provided in the details. If it's a miscategorization, fix it in the Finance Sheet.
   - For **Low Stock**: The system automatically adds these to the Google Shopping list once a decision is approved.

### Adding New Triage Sources
To add a new domain to the triage:
1. Update `DigitalTwinEngine.get_unified_triage()` in `G04_digital_twin_engine.py`.
2. Ensure the new source has a unique `ref_id` prefix (e.g., `HEAL-`, `WORK-`).

## Failure Modes
| Scenario | Detection | Response |
|----------|-----------|----------|
| API Timeout | Bot returns "Error" | Check `pm2 status digital-twin-api` |
| DB Connectivity | Log shows "psycopg2.OperationalError" | Verify PostgreSQL service is running |
| Duplicate Alerts | Same item appears twice | Check `G11_decision_proposer.py` deduplication logic |

## Security Notes
- Triage data contains financial summaries. Access is restricted to the owner's Telegram ID.
- Database credentials are managed via `.env`.

## Owner + Review Cadence
- **Owner:** Michał
- **Review:** Monthly (during G12 Documentation Audit).
