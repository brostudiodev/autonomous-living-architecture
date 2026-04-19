---
title: "Service: Autonomous Schedule Negotiator"
type: "automation"
status: "active"
owner: "Michal"
updated: "2026-04-10"
---

# SVC_Autonomous-Schedule-Negotiator

## Purpose
The Autonomous Schedule Negotiator is a real-time "Time Optimization" engine that balances Michal's current biological readiness (energy levels) with his task demands. It dynamically reshuffles the daily schedule to ensure high-stakes work is performed during peak energy windows, while protecting recovery and sleep preparation.

## Scope
- **In Scope:** Biological readiness constraints, hydration tracking, task categorization (High/Medium/Other), roadmap mission integration, and focus block optimization.
- **Out Scope:** Direct modification of external calendars (handled by G10_calendar_enforcer).

## Logic (Managed by n8n)
> ⚠️ **Note:** The core logic of this service is managed within **n8n**.

1.  **Context Gathering:** Calls `GET /all` on the Digital Twin API to fetch biometrics, hydration, tasks, and project states.
2.  **Biological Constraints:** Treats readiness data as the primary constraint (biology overrides ambition).
3.  **LLM Negotiation:** Uses **Gemini 2.5 Flash** to create optimized time blocks: Deep Work (90min), Focused Work (45min), Admin (30min), Break (15min), Recovery (variable).
4.  **Persistence:** Upserts the negotiated schedule into the `daily_intelligence` table (`schedule_negotiation` column).

## Inputs/Outputs
- **Inputs:**
  - Digital Twin API: `http://{{INTERNAL_IP}}:5677/all`
- **Outputs:**
  - Database: `digital_twin_michal.daily_intelligence` (column: `schedule_negotiation`)
  - Notifications: Email alerts on failure.

## Dependencies
- **Systems:** Digital Twin API (G04), Google Tasks (S09), PostgreSQL (S03).
- **Services:** n8n, Google Gemini API.
- **Credentials:** `Postgres account digital_twin_michal docker`, `Google Gemini(PaLM) Api account 2`.

## Procedure (Execution)
- **Schedule:** Runs 5x daily via Cron (`0 7,10,13,16,19 * * *`).
- **Manual Trigger:** Can be executed via the n8n UI.

## Failure Modes
| Scenario | Detection | Response |
|----------|-----------|----------|
| API Timeout | HTTP Request node failure | Notify via Gmail; Check API status |
| LLM Validation Failure | Validation Code node failure | Notify via Gmail; Review prompt |
| DB Schema Mismatch | Postgres node failure | Notify via Gmail; Ensure `schedule_negotiation` column exists |

## Security Notes
- API token management is handled by n8n credentials.
- Biological data (HRV, Sleep) is processed within the internal environment.
