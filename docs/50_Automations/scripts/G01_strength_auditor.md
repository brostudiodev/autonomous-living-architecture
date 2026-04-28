---
title: "Strength & TUT Auditor (G01)"
type: "automation_spec"
status: "active"
owner: "Michał"
updated: "2026-04-02"
---

# Purpose
The **Strength & TUT Auditor** (`G01_strength_auditor.py`) provides autonomous feedback on HIT (High-Intensity Training) progression. It specifically focuses on **Time Under Tension (TUT)** as the primary driver for hypertrophy and strength, rather than just weight.

# Scope
- **In Scope:** `workout_sets` analysis, TUT comparison with previous sessions, PR detection, load adjustment recommendations.
- **Out Scope:** Cardiorespiratory tracking, non-HIT training styles.

# Progression Logic
- **TUT Threshold:** If TUT for an exercise reaches or exceeds **90 seconds**, the auditor recommends increasing the weight or increasing focus (slower/deeper reps) for the next session.
- **PR Detection:** A Personal Record (PR) is flagged if current TUT exceeds previous TUT for the same weight, or if weight increases while maintaining TUT.

# Inputs/Outputs
- **Inputs:** `autonomous_training` PostgreSQL database (`workout_sets` and `exercises` tables).
- **Outputs:** Markdown formatted report for the Obsidian Daily Note.

# Dependencies
- **Systems:** S07 (Health & Bio-Optimization), G01 (Target Body Fat)
- **Database:** `autonomous_training`

# Procedure
- Automatically executed by `autonomous_daily_manager.py` during the daily sync.
- Reports are combined into the `TRAINING_DETAILS` collapsible section.

# Failure Modes
| Scenario | Detection | Response |
|----------|-----------|----------|
| No Previous Data | Query returns NULL | Marks session as "Baseline Set". |
| DB Connection Fail | Script logs error | Skips audit; Daily Note shows "No training data". |

# Security Notes
- Read-only database access.
- Credentials managed via `.env`.

# Owner + Review Cadence
- **Owner:** Michał
- **Review:** Monthly (Check progression logic alignment with physical results)
