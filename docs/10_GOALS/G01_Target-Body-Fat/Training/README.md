# G01 Training Journal (Low-Volume HIT)

This is the canonical workout journal for Goal 01 (Target Body Fat).

Principle: log the *minimum* data that drives decisions.
- Load is always in kg.
- Tempo is ignored.
- Progression is guided by TUT (time under tension) and form quality.
- Training frequency is "when recovered", typically 2–6 days. If I don't feel it, I postpone to next day.

---

## Source of truth
- Workout definition: `config/workout.yml`
- Exercise IDs: `config/exercises.yml`
- Per-exercise HIT sets (core log): `data/sets.csv`
- Session metadata: `data/workouts.csv`
- Smart-scale measurements: `data/measurements.csv`
- Optional context (only when needed): `sessions/YYYY/*.md`

---

## What gets logged (non-negotiable)
For each exercise (HIT = 1 working set):
- `weight_kg`
- `tut_s`
- `max_effort` (did I truly push?)
- `form_ok` (was it clean enough to count?)

Notes are allowed but optional.

---

## Decision rules (simple and practical)
These rules are **guidance**, not religion. I can override them with judgment.

- If `tut_s > 90` and `form_ok=true`: I *should consider* increasing weight next time.
- If `tut_s` is around 60–90 and `form_ok=true`: hold weight, aim to extend TUT.
- If `form_ok=false`: do NOT increase weight (even if TUT is high). Fix execution first.
- If `max_effort=false`: treat the set as a non-test day; do not auto-progress.

---

## Logging workflow (fast)
1) After training: append rows to `data/sets.csv` (one row per exercise).
2) Append one row to `data/workouts.csv`.
3) Optional: if something unusual happened, add a short note in `sessions/YYYY-MM-DD__hit-fullbody-a.md`.
4) Next morning: append smart scale result to `data/measurements.csv` (if not already logged).

That's it.
