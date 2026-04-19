---
title: "G10: Schedule Negotiator"
type: "automation"
status: "deprecated"
owner: "Michal"
updated: "2026-04-16"
goal_id: "goal-g10"
---

# G10: Schedule Negotiator (n8n Migrated)

> [!danger] **DEPRECATED**
> The standalone Python script `G10_schedule_negotiator.py` has been archived. This automation is now entirely managed by **n8n** to ensure reliability and better LLM orchestration.

## Purpose
The schedule negotiation process gathers biological context (Readiness, HRV) and task context (Google Tasks) to optimize the day's plan.

## Orchestration (n8n)
- **Trigger:** Scheduled daily at 06:05 (CET) or triggered via Telegram `/negotiate`.
- **Workflow:** `WF010_Schedule-Negotiator`
- **Actions:**
    1. Fetch biometrics via `Digital Twin API`.
    2. Fetch tasks via `Google Tasks API`.
    3. LLM-based reasoning for schedule optimization.
    4. Update Google Calendar via `G10_calendar_enforcer.py`.

## Procedure
This automation no longer runs as a local Python script. It is triggered by the n8n orchestrator.
To manually trigger:
- Use Telegram command: `/negotiate`
- Or manually start the n8n workflow `WF010_Schedule-Negotiator`.

## Archive Status
The original script is located in `scripts/archive/G10_schedule_negotiator.py` for reference.

## Failure Modes
| Scenario | Detection | Response |
|---|---|---|
| n8n Webhook Offline | Connection Error | Fallback to local rule-based `G10_schedule_optimizer.py`. |
| Biometric Data Stale | Warning in log | Use 70% readiness as conservative default. |

## Owner + Review Cadence
- **Owner:** Michal
- **Review Cadence:** Monthly audit of schedule accuracy and "Assumed & Acted" success rate.
