---
title: "Automation Spec: Autonomous Evening Manager"
type: "automation_spec"
status: "active"
system_id: "S10"
goal_id: "goal-g10"
owner: "Michal"
updated: "2026-04-04"
review_cadence: "monthly"
---

# 🤖 Automation Spec: Autonomous Evening Manager

## 🎯 Purpose
Automate the transition from high-velocity execution to deep recovery (The "Cognitive Shutdown"). Orchestrates a multi-stage process for data reflection, tomorrow's planning, and content creation to ensure optimal sleep quality and a Frictionless Morning.

## 📝 Scope
- **In Scope:** 
  - Unified orchestration of G10 (Journal/Memory/Foundation/Patterns).
  - Autonomous content draft generation (G13).
  - Tomorrow's strategic mission briefing (G10).
  - Bedroom environment checks (G08).
  - Unified Telegram briefing.
- **Out of Scope:** Automatic device control (handled by Home Assistant).

## 🔄 Inputs/Outputs
- **Inputs:** 
  - Today's Technical Wins (G09)
  - Tomorrow's Mission Context (G10)
  - Bedroom Environment (G08)
- **Outputs:**
  - Content Drafts in Obsidian Inbox (G13)
  - Daily Pattern Analysis in Daily Note (G10)
  - Unified Telegram Briefing

## 🛠️ Logic & Procedure (Updated Apr 07)
1. **Trigger:** Global Sync running after 18:00 (or manual with `--force`).
2. **Phase 1: Foundation:** Runs Journal Collector, AI Memory Generator, Foundation Checker (now with Weather), and Pattern Analyzer.
3. **Phase 2: Content:** Triggers G13 Content Draft Agent to generate LinkedIn/Substack drafts.
4. **90-Minute Shutdown Optimizer (NEW Apr 07):**
    - Calculates dynamic **Target Sleep** and **Light-Dimming (Cutoff)** times.
    - If tomorrow has a meeting before 08:30 → Shifts sleep 45 mins earlier.
    - If Biological Readiness is < 65 → Shifts sleep 30 mins earlier (Recovery Mode).
5. **Phase 3: Planning:** Fetches tomorrow's roadmap missions and calendar events.
6. **Phase 4: Environment:** Checks bedroom readiness (Temp/CO2).
7. **Phase 5: Notification:** Sends the final "Cognitive Shutdown" briefing to Telegram, including personalized sleep/cutoff recommendations and reasoning.


## ⚠️ Failure Modes
| Scenario | Detection | Response |
|---|---|---|
| Script Failures | Traceback/Log | Orchestrator skips failed phase, continues to others. |
| Missing Wins | G13 check | Skips content generation for the day. |
| Planner Error | "Maintain focus" fallback | Verify `G10_tomorrow_planner` health. |

## 🔒 Security Notes
- **Secrets:** Uses standard environment variables for tokens. No sensitive mission data is exported beyond Telegram.

---
*Unified Shutdown v6.0 - April 2026*
