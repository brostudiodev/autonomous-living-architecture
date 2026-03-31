---
title: "Automation Spec: G10_meeting_briefing.py"
type: "automation_spec"
status: "active"
created: "2026-03-13"
updated: "2026-03-29"
---

# 🤖 Automation Spec: G10_meeting_briefing.py

## 📝 Overview
**Purpose:** Provides context-aware briefings for upcoming calendar events. It bridges the gap between structured schedule data and unstructured historical notes in the Obsidian Vault. To maintain a high signal-to-noise ratio, Telegram notifications for successful briefings are disabled, while internal ROI logging and error alerting remain active.
**Goal Alignment:** G10 (Intelligent Productivity) & G04 (Digital Twin Intelligence)

## ⚡ Technical Details
- **Language:** Python
- **Triggers:** Cron (morning run before 09:00) or real-time (within 120 mins of event).
- **Databases:** `autonomous_training` (for workout intelligence).
- **Dependencies:** `G04_digital_twin_engine`, `G04_digital_twin_notifier`, `G10_calendar_client`, `G05_ollama_wrapper`.

## 🛠️ Logic Flow
1. **Event Retrieval:** Fetches today's events from Google Calendar via `G10_calendar_client`.
2. **Context Discovery:**
    - Cleans meeting titles from common prefixes/emojis.
    - Performs a weighted keyword search across the Obsidian Vault.
    - **Noise Filter:** Strictly ignores non-Markdown files, templates, retrospectives, and monthly summaries.
    - **Prioritization:** Weighs results from `02_Projects` and `01_Daily_Notes` higher.
3. **Domain Intelligence:**
    - Detects "Training" or "Workout" events.
    - Queries the training database for last session results and current HIT progression targets (Overload targets).
4. **AI Summarization:** Uses `G05_ollama_wrapper` (Gemini Flash or Ollama) to generate a 2-3 bullet point summary of the found context.
5. **Formatting:** Strips Obsidian-style internal links and formats the payload for Telegram readability.

## 📤 Outputs
- **Internal State:** Context is processed and prepared for the system.
- **ROI Logging:** Automatically logs "Professional Productivity" time saved (5 mins/event).
- **Error Alerting:** Sends a Telegram notification only if the briefing process encounters a critical failure.

## ⚠️ Known Issues / Maintenance
- **LLM Dependency:** AI summaries require a configured `GEMINI_API_KEY` or local Ollama instance.
- **Search Latency:** Large vault searches can take 2-5 seconds depending on keyword complexity.

---
*Updated: 2026-03-29 by Digital Twin Assistant*
