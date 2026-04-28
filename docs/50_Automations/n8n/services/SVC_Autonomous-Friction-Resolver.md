---
title: "Service: Autonomous Friction Resolver"
type: "automation"
status: "active"
owner: "Michał"
updated: "2026-04-10"
---

# SVC_Autonomous-Friction-Resolver

## Purpose
The Autonomous Friction Resolver is a "Self-Correction" engine that scans Michał's entire Digital Twin ecosystem for inefficiencies, risks, or wasted effort. It identifies "friction" across domains (Finance, Health, Smart Home, Pantry, Logistics) and proposes concrete, actionable **Quick Wins** to resolve them.

## Scope
- **In Scope:** Analyzing budget breaches, hydration deficits, smart home sensor failures, pantry low stock, task overloads, and cross-domain correlations.
- **Out Scope:** Direct execution of complex repairs (handled by G11_decision_handler).

## Logic (Managed by n8n)
> ⚠️ **Note:** The core logic of this service is managed within **n8n**.

1.  **Context Gathering:** Calls `GET /all` on the Digital Twin API to fetch a holistic system state.
2.  **Data Extraction:** Categorizes friction data from Health, Finance, Pantry, and Smart Home modules.
3.  **LLM Analysis:** Uses **Gemini 2.5 Flash** to identify the top 1-3 friction points with the highest impact and propose specific solutions.
4.  **Persistence:** Upserts the analysis into the `daily_intelligence` table (`friction_analysis` column).

## Inputs/Outputs
- **Inputs:**
  - Digital Twin API: `http://{{INTERNAL_IP}}:5677/all`
- **Outputs:**
  - Database: `digital_twin_michal.daily_intelligence` (column: `friction_analysis`)
  - Notifications: Email alerts on failure.

## Dependencies
- **Systems:** Digital Twin API (G04), PostgreSQL (S03).
- **Services:** n8n, Google Gemini API.
- **Credentials:** `Postgres account digital_twin_michal docker`, `Google Gemini(PaLM) Api account 2`.

## Procedure (Execution)
- **Schedule:** Runs 4x daily via Cron (`0 8,12,16,20 * * *`).
- **Manual Trigger:** Can be executed via the n8n UI.

## Failure Modes
| Scenario | Detection | Response |
|----------|-----------|----------|
| API Timeout | HTTP Request node failure | Notify via Gmail; Check API status |
| LLM Hallucination | Validation Code node failure | Notify via Gmail; Review prompt |
| DB Schema Mismatch | Postgres node failure | Notify via Gmail; Ensure `friction_analysis` column exists |

## Security Notes
- API token management is handled by n8n credentials.
- Database access is restricted to the internal network.
