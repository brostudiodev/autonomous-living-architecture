---
title: "Automation Spec: G11 Strategic Auditor"
type: "automation_spec"
status: "active"
automation_id: "G11_strategic_auditor"
goal_id: "goal-g11"
systems: ["S01", "S11"]
owner: "Michał"
updated: "2026-04-13"
---

# 🤖 Automation Spec: G11 Strategic Auditor

## 🎯 Purpose
Provides a high-level comparison between **Intent** (Roadmap milestones) and **Reality** (Actual script execution and ROI). Ensures the system is working on what matters and quantifies the "Autonomy Dividend".

## 📝 Scope
- **In Scope:** Roadmap progress calculation; 7-day execution heartbeat; ROI aggregation by category; Biological readiness correlation.
- **Out of Scope:** Operational maintenance (handled by `autonomous_daily_manager.py`).

## 🔄 Inputs/Outputs
- **Inputs:** 
  - `digital_twin_michal.autonomy_roi` (Cumulative time saved)
  - `digital_twin_michal.system_activity_log` (Execution heartbeat)
  - Goal Roadmaps (Markdown parsing)
- **Outputs:**
  - JSON audit payload for n8n Strategic Review agent.

## 🛠️ Dependencies
- **Systems:** S01 Observability, S11 Meta-System
- **Scripts:** `G04_digital_twin_engine.py`

## ⚙️ Logic & Procedure
1. **Intent Sync:** Fetches roadmap completion percentages from the Digital Twin engine.
2. **Reality Check:** Queries the last 7 days of successful script executions to detect "Heartbeat" (active vs. stall).
3. **Value Aggregation:** Sums `minutes_saved` from the ROI table per category (e.g., Finance, Health).
4. **Context Synthesis:** Combines data into a unified JSON object for the "Chief Operating Officer" AI.

## ⚠️ Failure Modes
| Scenario | Detection | Response |
|---|---|---|
| Missing ROI Data | Aggregation returns 0 | Normal for new systems; ensure loggers are active |
| Roadmap Parse Fail | 0% progress reported | Check Roadmap.md syntax/Q2 markers |

## Changelog
| Date | Change |
|------|--------|
| 2026-03-13 | Initial strategic data provider |
| 2026-04-13 | Fully integrated with ROI engine and Roadmap Quarter-Detection. |
