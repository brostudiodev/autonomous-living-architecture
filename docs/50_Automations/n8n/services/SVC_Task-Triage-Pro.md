---
title: "SVC: Task Triage Pro"
type: "automation_spec"
status: "active"
automation_id: "SVC_Task-Triage"
goal_id: "goal-g11"
systems: ["S08", "S11"]
owner: "Michał"
updated: "2026-04-23"
---

# SVC: Task-Triage-Pro

## Purpose
The **Task Triage Pro** workflow autonomously prioritizes and categorizes Google Tasks based on Michał's daily biometric readiness and system-wide state. It ensures that high-energy tasks are scheduled for high-readiness days and provides a structured daily agenda.

## Triggers
- **Schedule Trigger:** Runs daily at 07:00 AM.
- **Manual Trigger:** Can be executed manually via n8n UI.

## Inputs
- **Biometric Readiness:** Fetched from `/health/readiness` (Digital Twin API).
- **Google Tasks:** Fetched from `/todos` (Digital Twin API).

## Processing Logic
1. **Data Fetching:** Retrieves readiness score and current task list from the Digital Twin API.
   - **Timeout (Updated Apr 23):** 60s (Increased from 15s to accommodate agentic `/todos` processing).
2. **Data Validation:** Ensures both biometrics and tasks are available before proceeding.
3. **LLM Triage (Gemini 2.5 Flash):**
   - Categorizes tasks into: `URGENT_TODAY`, `BACKLOG`, `RECOVERY`, `NOTE_TO_OBSIDIAN`, `HABIT`.
   - Assigns estimated duration and provides context-aware reasoning.
   - Limits `URGENT_TODAY` based on readiness score (max 5 items).
4. **Persistence:** Upserts the triaged JSON to the `daily_intelligence` table in PostgreSQL.

## Outputs
- **PostgreSQL:** Updated `task_triage` column in `daily_intelligence`.
- **Alerts:** Gmail notifications on fetch, triage, or DB write failures.

## Dependencies
### Systems
- [Digital Twin API (S04)](../../../20_Systems/S00_Homelab-Platform/Architecture.md)
- [n8n Automation Hub (S08)](../README.md)
- [PostgreSQL (S03)](../../../20_Systems/S03_Data-Layer/README.md)

## Error Handling
| Failure Scenario | Detection | Response | Alert |
|---|---|---|---|
| API Timeout | Node Error | Increased timeout to 60s | Gmail Alert |
| LLM Invalid JSON | Parse Error | Workflow fallback/retry | Gmail Alert |
| DB Write Fail | Postgres Node | Log failure and details | Gmail Alert |

---
*Updated: 2026-04-23 | Increased API timeouts to 60s to resolve fetch failures.*
