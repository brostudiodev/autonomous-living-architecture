---
title: "Workflow Spec: WF115 Autonomous Schedule Negotiator"
type: "n8n_workflow"
status: "active"
owner: "Michal"
updated: "2026-04-10"
---

# 🤖 Workflow Spec: WF115 Autonomous Schedule Negotiator

## 📝 Overview
**Purpose:** Dynamically optimizes the daily schedule by negotiating between calendar events, tasks, and real-time biological readiness.
**Goal Alignment:** G10 Intelligent Productivity & G11 Meta-System Integration.

## 🏗️ Workflow Architecture
1. **Cron Trigger:** Runs hourly (during active windows).
2. **Context Ingestion (Digital Twin API):**
    - Calls `GET /all` for context on:
        - `readiness_score`, `hrv_ms`, `sleep_score` (G07 Biometrics).
        - `upcoming_tasks` (Google Tasks).
        - `today_events` (Google Calendar).
3. **AI Logic (Gemini 1.5 Flash):**
    - **Prompt:** "Optimize today's schedule. Energy: [READINESS] HRV: [HRV]. Priority tasks: [TASKS]. Calendar events: [EVENTS]. Protect Deep Work if energy is high, or propose recovery if energy is low."
    - **Negotiation Policy:** Always prioritize health (biological state) over secondary tasks.
4. **Action Generation:**
    - Generates an updated Markdown schedule for the remaining hours of the day.
5. **Notification:** Updates the user via Telegram with the "Negotiated Schedule".

## ⚡ Technical Details
- **Trigger:** Schedule Trigger (1 hour)
- **Primary Source:** `http://digital-twin-api:5677/all`
- **AI Model:** Gemini 1.5 Flash
- **Integrations:** Telegram, Google Calendar, Digital Twin API.
- **Template:** `docs/50_Automations/n8n/templates/WF_Schedule_Negotiator.json`

## 📤 Outputs
- **Telegram Update:** 🤝 **Negotiated Schedule Update**: [Markdown Schedule]
- **Activity Log:** Logs the negotiation event to `system_activity_log`.

## ⚠️ Known Issues / Maintenance
- **Conflict Handling:** Does not yet push changes back to Google Calendar; only proposes and provides an updated view in Obsidian/Telegram.
- **Biological Lag:** If `G07_zepp_sync.py` fails, the negotiator will use stale or fallback readiness data.

---
*Introduced 2026-04-10 to centralize time architecture in n8n.*
