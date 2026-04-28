---
title: "Automation Spec: G02 Content Generator"
type: "automation_spec"
status: "active"
automation_id: "G02_content_generator"
goal_id: "goal-g02"
systems: ["S02"]
owner: "Michał"
updated: "2026-04-13"
---

# 🤖 Automation Spec: G02 Content Generator

## 🎯 Purpose
Automates the drafting of high-impact content for LinkedIn and Substack by harvesting "Technical Wins" from the autonomous system's activity logs and git commits. Maintains the "Automationbro" persona and reduces creative friction.

## 📝 Scope
- **In Scope:** Git commit harvesting (feat, fix, refactor); `system_activity_log` success scanning; LLM-based draft generation; Obsidian Inbox delivery.
- **Out of Scope:** Automatic publishing (human-in-the-loop required); Graphics generation.

## 🔄 Inputs/Outputs
- **Inputs:** 
  - `digital_twin_michal.system_activity_log` (Success entries)
  - Local Git logs (7-day window)
  - Gemini 1.5 Pro API (Architecture-focused prompts)
- **Outputs:**
  - `Obsidian Vault/00_Inbox/Q2-Content-Ideas.md`

## 🛠️ Dependencies
- **Systems:** S02 Brand & Recognition
- **Services:** Digital Twin Engine (AgentZero bridge), Google Gemini API
- **Tools:** `git`, `psycopg2`

## ⚙️ Logic & Procedure
1. **Harvesting:** Scans for unique successful script runs and recent git commits.
2. **Context Synthesis:** Filters for high-value technical achievements (e.g., self-healing, architectural milestones).
3. **Drafting:** Passes context to Gemini via a sharpened "Automationbro" prompt focusing on:
   - Self-Healing Systems (G08/G11).
   - Infinite Throughput (G11).
   - Architectural Integrity (System-wide monitoring).
4. **Trigger:** Manual execution or weekly scheduled run.

## ⚠️ Failure Modes
| Scenario | Detection | Response |
|---|---|---|
| No Wins Found | Logs "No recent wins found" | Skip generation to maintain high signal |
| Gemini API Fail | Traceback in console | Fallback to raw win-list output |
| Git Access Denied | Subprocess error | Log warning, proceed with DB-only wins |

## Changelog
| Date | Change |
|------|--------|
| 2026-03-18 | Initial content idea extractor |
| 2026-04-13 | Sharpened prompt for 'Architecture-First' and 'Self-Healing' themes. |
