---
title: "G01: Training Journal (Low-Volume HIT)"
type: "training_guide"
status: "active"
goal_id: "goal-g01"
owner: "Michał"
updated: "2026-04-08"
---

# G01 Training Journal (Low-Volume HIT)

This is the canonical workout journal for Goal 01 (Target Body Fat).

Principle: log the *minimum* data that drives decisions.
- Load is always in kg.
- Tempo is ignored.
- Progression is guided by TUT (time under tension) and form quality.
- Training frequency is "when recovered", typically 2–6 days. If I don't feel it, I postpone to next day.

---

## Source of truth
- **Canonical Store (SSOT):** PostgreSQL `autonomous_training` database.
- **User Interface:** Google Sheets (`training_journal`) for mobile/manual logging (synced to DB).
- **CLI Interface:** `smart_log_workout.py` for direct database entry.
- **Secondary Backups:** Local SQL dumps and transient data files (staging).

---

## What gets logged (non-negotiable)
For each exercise (HIT = 1 working set):
- `weight_kg`
- `tut_s`
- `is_max_effort` (boolean)
- `form_quality_score` (1-5 scale)

---

## Decision rules (simple and practical)
These rules are **guidance**, not religion. I can override them with judgment.

- If `tut_s > 90` and `form_quality >= 4`: I *should consider* increasing weight next time.
- If `tut_s` is around 60–90 and `form_quality >= 4`: hold weight, aim to extend TUT.
- If `form_quality < 4`: do NOT increase weight (even if TUT is high). Fix execution first.
- If `is_max_effort=false`: treat the set as a non-test day; do not auto-progress.

---

## Logging workflow (fast)
1) **Mobile:** Log session in the `training_journal` Google Sheet. n8n will sync to PostgreSQL automatically.
2) **Desktop:** Run `python smart_log_workout.py` to log directly to the database.
3) **Next Morning:** Fasted smart scale measurement is auto-synced to `v_body_composition` in PostgreSQL.

That's it. No manual Git operations or CSV editing required.

---

## ☕ Fuel the Architecture

Building and maintaining this level of technical rigor is a massive investment. If this blueprint helps your own engineering journey, I would be grateful for your support.

<a href='https://ko-fi.com/michalnowakowski' target='_blank'><img height='60' style='border:0px;height:60px;' src='https://storage.ko-fi.com/cdn/kofi3.png?v=3' border='0' alt='Buy Me a Coffee at ko-fi.com' /></a>

**Support my hard work in engineering a fully autonomous life.** Every coffee fuels another line of code, another automated insight, and another step toward the 2026 North Star. Your contributions help maintain the infrastructure and research shared in this open-source blueprint.
