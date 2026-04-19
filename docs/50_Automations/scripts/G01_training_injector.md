---
title: "Automation Spec: G01 Training Injector"
type: "automation_spec"
status: "active"
system_id: "S10"
goal_id: "goal-g01"
owner: "Michal"
updated: "2026-04-01"
review_cadence: "monthly"
---

# 🤖 Automation Spec: G01 Training Injector

## 🎯 Purpose
Frictionless HIT workout execution by pre-populating target weights and TUT (Time Under Tension) from historical data directly into the Obsidian Daily Note when biological readiness is sufficient.

## 📝 Scope
- **In Scope:** Reading historical workout data from PostgreSQL; Checking biometric readiness; Injecting Markdown tables into Daily Notes.
- **Out of Scope:** Manual workout logging (handled by `smart_log_workout.py`); Long-term trend analysis (handled by `G01_progress_analyzer.py`).

## 🔄 Inputs/Outputs
- **Inputs:** 
  - `autonomous_training.workout_sets` (Historical targets)
  - Biometric Readiness Score (via Digital Twin Engine)
- **Outputs:**
  - Markdown block injected into the current Daily Note under `## 🏋️ Training`.
  - Activity log in `G11_log_system`.

## 🛠️ Dependencies
- **Systems:** S10 Daily Goals Automation, S03 Data Layer (PostgreSQL)
- **Services:** Digital Twin Engine (for health state)
- **Credentials:** PostgreSQL credentials (via db_config)

## ⚙️ Logic & Procedure
1. **Readiness Check:** If `readiness_score < 65`, the script skips injection to encourage recovery.
2. **Target Retrieval:** Identifies the most recent workout template used from PostgreSQL and fetches the last recorded weights and TUT for those exercises.
3. **Injection:** Searches the current Daily Note for `## 🏋️ Training` and injects a formatted status table.
4. **Trigger:** Automated via `G11_global_sync.py`.

## 📜 Changelog
| Date | Change |
|------|--------|
| 2026-04-01 | Initial spec created |
| 2026-04-16 | Bugfix: Migrated from CSV to PostgreSQL; Fixed target_date initialization in Engine |

## ⚠️ Failure Modes
| Scenario | Detection | Response |
|---|---|---|
| CSV Missing | FileNotFoundError in logs | Check `{{ROOT_LOCATION}}/Training/` path |
| No Daily Note | "Daily Note not found" in log | Ensure `autonomous_daily_manager.py` ran first |
| Readiness Unknown| Defaults to skip | Verify Zepp/Withings sync health |

## 🔒 Security Notes
- **Secrets:** No sensitive data involved in this automation.

---
*System Hardening v5.4 - April 2026*
