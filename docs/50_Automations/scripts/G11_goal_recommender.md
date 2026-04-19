---
title: "Autonomous Goal Recommender (G11)"
type: "automation_spec"
status: "active"
owner: "Michal"
updated: "2026-04-02"
---

# Purpose
The **Goal Recommender** (`G11_goal_recommender.py`) autonomously selects three Power Goals for the day. This eliminates manual decision-making by analyzing real-time data from health, finance, and system operations.

# Scope
- **In Scope:** Readiness Score (G07), Financial Anomalies (G05), System Failures (G11), Roadmap Gaps (G12).
- **Out Scope:** Manual commitment overrides (Obsidian manual selection).

# Inputs/Outputs
- **Inputs:** 
  - `biometrics` table (Readiness)
  - `autonomous_decisions` table (Finance)
  - `system_activity_log` (Failures)
- **Outputs:** Recommended Goal IDs and justification report for the Daily Note.

# Dependencies
- **Systems:** S04 (Digital Twin), G11 (Meta-System), G07 (Predictive Health), G05 (Autonomous Finance)
- **Database:** `digital_twin_michal` (unified state)

# Procedure
- Automated by `autonomous_daily_manager.py` during the morning sync.
- Can be run manually: `python3 scripts/G11_goal_recommender.py`.

# Failure Modes
| Scenario | Detection | Response |
|----------|-----------|----------|
| No Biometrics | Query returns empty | Fallback to default readiness (75) |
| Multi-Goal Tie | Logic conflict | Use Meta (G11) and Docs (G12) as defaults |
| Logic Error | script_activity_log failure | User must manually select goals in Obsidian |

# Security Notes
- Read-only database access.
- Credentials managed via `.env`.

# Owner + Review Cadence
- **Owner:** Michal
- **Review:** Monthly (Goal G11 audit)
