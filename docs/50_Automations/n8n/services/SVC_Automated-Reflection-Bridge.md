---
title: "Service: Automated Reflection Bridge"
type: "automation"
status: "active"
owner: "Michał"
updated: "2026-04-10"
---

# SVC_Automated-Reflection-Bridge

## Purpose
The Automated Reflection Bridge is an "Evening Synthesis" engine that summarizes the entire day's activities, biological states, and system-generated insights into a structured Polish reflection. It serves as the final daily audit, connecting patterns between health, finance, and productivity before Michał winds down for sleep.

## Scope
- **In Scope:** Daily biometric analysis (HRV, Sleep, Readiness), hydration tracking, budget breach summaries, task completion status, and cross-domain pattern recognition.
- **Out Scope:** Long-term historical trend analysis (handled by G04_trend_forecaster).

## Logic (Managed by n8n)
> ⚠️ **Note:** The core logic of this service is managed within **n8n**.

1.  **Context Gathering:** Calls `GET /all` on the Digital Twin API for real-time telemetry.
2.  **Intelligence Retrieval:** Fetches daily-generated data from PostgreSQL (Friction Analysis, Task Triage, Schedule Negotiation).
3.  **LLM Synthesis:** Uses **Gemini 2.5 Flash** to draft a structured reflection in Polish, including a specific sleep preparation recommendation.
4.  **Persistence:** Upserts the final reflection into the `daily_intelligence` table (`evening_reflection` column).

## Inputs/Outputs
- **Inputs:**
  - Digital Twin API: `http://{{INTERNAL_IP}}:5677/all`
  - Database: `daily_intelligence` (read `reflection_draft`, `task_triage`, `content_drafts`, `friction_analysis`, `schedule_negotiation`)
- **Outputs:**
  - Database: `digital_twin_michal.daily_intelligence` (column: `evening_reflection`)
  - Notifications: Email alerts on failure.

## Dependencies
- **Systems:** Digital Twin API (G04), PostgreSQL (S03).
- **Services:** n8n, Google Gemini API.
- **Credentials:** `Postgres account digital_twin_michal docker`, `Google Gemini(PaLM) Api account 2`.

## Procedure (Execution)
- **Schedule:** Runs daily at 21:00 via Cron (`0 21 * * *`).
- **Manual Trigger:** Can be executed via the n8n UI.

## Failure Modes
| Scenario | Detection | Response |
|----------|-----------|----------|
| API Data Fetch Failed | HTTP Request node failure | Notify via Gmail; Check API container status |
| LLM Generation Failed | LLM Chain node failure | Notify via Gmail; Check Gemini API quota |
| DB Upsert Failed | Postgres node failure | Notify via Gmail; Ensure `evening_reflection` column exists |

## Security Notes
- Processes sensitive biological and financial data within the local n8n instance.
- Database credentials are encrypted within n8n.
