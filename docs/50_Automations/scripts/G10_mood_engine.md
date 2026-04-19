---
title: "G10: Mood & Energy Engine"
type: "automation_spec"
status: "active"
automation_id: "G10_mood_engine"
goal_id: "goal-g10"
systems: ["S09"]
owner: "Michal"
updated: "2026-03-31"
---

# G10: Mood & Energy Engine

## Purpose
Autonomously suggests `mood`, `energy`, and a `reflection_draft` for the Obsidian Daily Note by correlating biometric, financial, and logistical data using LLM intelligence. This removes the friction of manual qualitative state logging.

## Triggers
- **Scheduled:** Part of `G11_global_sync.py` (triggers at 06:00).
- **Manual:** `python3 scripts/G10_mood_engine.py`.

## Inputs
- **Health:** Biometric Readiness and Sleep scores (G07).
- **Finance:** Count of active budget alerts (G05).
- **Logistics:** Count of urgent pantry stockouts (G03).
- **LLM:** Gemini 1.5 Flash (via `G05_ollama_wrapper.py`).

## Logic Flow
1.  **Context Preparation:** Gathers current metrics for Readiness, Sleep, Finance alerts, and Pantry status.
2.  **Intelligence (n8n - SVC_Proactive-Daily-Reflection-Drafter):** 
    *   Triggers at 18:30 daily.
    *   Fetches 360° context from `/all`.
    *   **LLM Chain (Gemini 1.5 Flash):** Uses a sophisticated prompt to correlate biometrics, finance, and goals into a single Polish reflection sentence.
    *   **Validation:** Multi-stage validation ensures API data is valid and LLM output is non-empty before proceeding.
    *   **Persistence:** Uses **Option A (Query Parameters)** to safely upsert the reflection into `daily_intelligence` via PostgreSQL.
3.  **Fallback (Rule-based):** If the n8n layer fails, the Python script provides basic energy/mood foundation.

## Notifications
- **Gmail Integration:** The workflow sends immediate failure alerts to `{{EMAIL}}` if the Context API, LLM, or DB Write stages fail.

## Outputs
- **Database:** `digital_twin_michal.daily_intelligence` (energy, mood, reflection_draft, is_automated).
- **Obsidian:** `%%JOURNAL%%` and `%%TAGS%%` markers updated via `autonomous_daily_manager.py`.

## Failure Modes
- **LLM Timeout:** Reverts to rule-based fallback logic.
- **Stale Data:** Defaults to "normal" (3) and "ok".
- **Override:** Manual entries in the Daily Note or DB take precedence.

---
*Updated: 2026-04-06 | Added LLM-driven reflection drafting and improved JSON parsing.*
