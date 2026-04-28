---
title: "Automation Spec: G10 Micro-Slot Triage"
type: "automation_spec"
status: "active"
system_id: "S10"
goal_id: "goal-g10"
owner: "Michał"
updated: "2026-04-01"
review_cadence: "monthly"
---

# 🤖 Automation Spec: G10 Micro-Slot Triage

## 🎯 Purpose
Maximize productivity by identifying 15-45 minute gaps in the Google Calendar and suggesting "Quick Win" or "Admin" tasks via Telegram. Reduces decision fatigue during transitions.

## 📝 Scope
- **In Scope:** Calendar gap identification; Google Task list filtering; Telegram suggestions.
- **Out of Scope:** Automated scheduling of tasks into calendar; Deletion of tasks.

## 🔄 Inputs/Outputs
- **Inputs:** 
  - Google Calendar (via `G10_calendar_client.py`)
  - Google Tasks (via `G10_google_tasks_sync.py`)
- **Outputs:**
  - Proactive Telegram alert
  - Activity log in `G11_log_system`

## 🛠️ Dependencies
- **Systems:** S09 Productivity & Time, S10 Daily Goals Automation
- **Services:** Google Calendar API, Google Tasks API, Telegram Bot API
- **Credentials:** `TELEGRAM_BOT_TOKEN`, `CLIENT_SECRET_FILE`, `TOKEN_FILE`

## ⚙️ Logic & Procedure
1. **Gap Detection:** Calculates intervals between today's timed calendar events.
2. **Task Prioritization:** 
   - Searches the "Suggestions" task list first.
   - Fallback to "My Tasks" filtering for "ADMIN" or "REVIEW" keywords.
3. **Trigger:** Automated via `G11_global_sync.py` every 15-30 mins.

## ⚠️ Failure Modes
| Scenario | Detection | Response |
|---|---|---|
| Google Auth Error | "Permission error" in logs | Run `G10_google_tasks_sync.py --reauth` |
| No Gaps Found | Silent log entry "No suitable gaps" | Expected behavior for busy days |
| No Tasks | "Found gap, no tasks" in log | Verify tasks exist in "Suggestions" or "Admin" lists |

## 🔒 Security Notes
- **Access Control:** Uses OAuth 2.0 with restricted scopes for Google APIs.
- **Secrets:** All tokens/secrets stored in `.env` or encrypted pickle files.

---
*System Hardening v5.4 - April 2026*
