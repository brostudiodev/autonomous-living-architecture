---
title: "Automation Spec: G10_calendar_client.py"
type: "automation_spec"
status: "active"
automation_id: "G10_calendar_client.py"
goal_id: "goal-g10"
systems: ["S10"]
owner: "Michał"
updated: "2026-04-04"
---

# 🤖 Automation Spec: G10_calendar_client.py

## 📝 Overview
**Purpose:** Provides a low-level interface for Google Calendar API operations, including event creation (time-blocking), fetching daily/tomorrow's schedules, and managing recurring focus blocks.
**Goal Alignment:** G10 Intelligent Productivity (Calendar Enforcer)

## ⚡ Technical Details
- **Language:** Python
- **Triggers:** Called by `G10_calendar_enforcer.py`, `autonomous_evening_manager.py`, and `G10_tomorrow_planner.py`.
- **Databases:** None (Direct Google Calendar API integration)
- **Dependencies:** `google.oauth2`, `googleapiclient.discovery`, `datetime`, `os`

## 🛠️ Logic Flow
1. **Authentication:** Uses a Service Account JSON key (`google_credentials_digital-twin-michal.json`).
2. **Operations:**
   - `get_today_events()` / `get_tomorrow_events()`: Fetches a list of events for a specific day.
   - `upsert_block()`: Ensures a named event (e.g., "Deep Work") exists for a specific time window.
   - `create_recurring_event()`: Handles complex RRULE-based recurring events.

## 📤 Outputs
- **Events List:** List of dictionaries containing time strings and summaries.
- **Success/Failure:** Booleans for creation/modification tasks.

## ⚠️ Known Issues / Maintenance
- **Timezone:** Uses centralized `db_config.TIMEZONE` (default: `Europe/Warsaw`).
- **API Quotas:** Standard Google Calendar API limits apply.

---
*System Hardening - April 2026*
