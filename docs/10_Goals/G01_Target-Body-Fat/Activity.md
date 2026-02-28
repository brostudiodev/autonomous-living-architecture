---
title: "G01: Detailed Activity Log"
type: "activity_log"
status: "active"
goal_id: "goal-g01"
owner: "Michal"
updated: "2026-02-07"
---

## 2026-W02: Weekly Progress

**Target Body Fat**

Major achievements this week:
- Logged 5 training/health activity(ies)

**Activities Summary:**
- **2026-02-08**: Maintaining diet, measuring
- **2026-02-09**: Keeping goal on track
- **2026-02-10**: High-Intensity Training (HIT) today
- **2026-02-11**: Training Journal in database
- **2026-02-13**: HIT Training

*Generated automatically on 2026-02-15*

---

## 2026-W01: Weekly Progress

**Target Body Fat**

Continued development and maintenance activities.

Additional activities: 6 task(s) completed.

**Activities Summary:**
- **2026-02-03**: - **Next:**
- **2026-02-04**: Healing before next workout
- **2026-02-06**: Weight measurement with Withings Body Smart
- **2026-02-07**: Weight measurement taken
- **2026-02-08**: Maintaining diet, measuring
- **2026-02-09**: Keeping goal on track.

*Generated automatically on 2026-02-10*

---

## 2026-02-25 | Training Journal System v2.0 (PostgreSQL Migration)

### Implementation Summary
**What:** Migrated Training Journal from local CSV storage to PostgreSQL `autonomous_training` database with n8n bidirectional sync.

**Why:** Establish a single source of truth (SSOT) for the Digital Twin, enable real-time progression tracking, and eliminate Git-based sync latency.

**How:**
- Replaced GitHub Actions CSV sync with n8n workflow `WF003__training-data-sync`.
- Mapped Google Sheets schema to PostgreSQL relational tables (`workouts`, `workout_sets`).
- Updated `smart_log_workout.py` and `g01-exporter.py` to use direct SQL queries.
- Established Google Sheets as the human-friendly entry point (UI) while treating the DB as the canonical source.

**Result:**
- Training metrics (Progression, TUT compliance) now available in real-time via SQL.
- Digital Twin briefings accurately reflect the latest training status.
- Eliminated file-system dependencies for core analytics.

### Technical Specifications
- **Trigger:** n8n Schedule (6h) + manual webhook trigger.
- **Sync Engine:** n8n `Postgres` and `Google Sheets` nodes.
- **SSOT Database:** PostgreSQL `autonomous_training` on Homelab.
- **Metrics Engine:** Prometheus exporter pulling from SQL views.

### Next Milestone
- [ ] Implement monthly automated progress report using PostgreSQL views.
- [ ] Develop dynamic training planner based on historical SQL data.

---

## 2026-01-23 | Training Journal System v1.0 Complete (Legacy)

### Implementation Summary
**What:** Mobile-first training journal with Google Sheets capture, GitHub Actions sync, and CSV schema validation. (Deprecated in favor of v2.0 PostgreSQL SSOT).

### Technical Specifications
- **Trigger:** Cron schedule `0 */6 * * *` (every 6 hours) + manual dispatch
- **Validation:** Bash header check with exact string match + carriage return stripping
- **Commit policy:** Only commit if `git diff --cached` detects changes
- **CSV paths:**
  - `docs/10_Goals/G01_Target-Body-Fat/Training/data/sets.csv`
  - `docs/10_Goals/G01_Target-Body-Fat/Training/data/workouts.csv`
  - `docs/10_Goals/G01_Target-Body-Fat/Training/data/measurements.csv`

### Performance Results
- **Sync latency:** <30 seconds per run (download + validate + commit)
- **False positive rate:** 0 (validation caught intentional header break in testing)
- **Logging UX:** Confirmed <60s on mobile (Google Sheets app)

### Time Investment Breakdown
- Google Sheets setup: 20 min
- GitHub Actions workflow + debugging: 90 min
- CSV schema design: 30 min
- Documentation (config YAMLs, README): 45 min
- **Total:** ~3 hours (one-time setup)

### Documentation Artifacts
- [x] `Training/README.md` (operating manual)
- [x] `Training/config/exercises.yml` (exercise ID registry)
- [x] `Training/config/workout_hit_*.yml` (workout definitions for upper/lower/fullbody)
- [x] `.github/workflows/g01_training_sync.yml` (automation code + docs inline)
- [x] Goal docs (README, Outcomes, Metrics, Systems, Roadmap, ACTIVITY_LOG)

### Lessons Learned
**What worked well:**
- "Publish to web" CSV export is simplest auth model (no service account complexity)
- Header validation catches 80% of corruption with 15 lines of bash
- `env:` on download step (not commit step) prevents empty URL variables

**What to improve next time:**
- Add Google Sheets dropdowns sooner (prevent typos at source)
- Consider service account for private sheets if privacy becomes concern
- Build monthly review automation before data piles up

### Next Milestone
- [ ] Add monthly review script (`scripts/g01_monthly_review.py`) — auto-generate progress summary
- [ ] Add Google Sheets data validation (dropdowns for `workout_id`, `exercise_id`, booleans)
- [ ] Create first monthly review manually (template for automation)

**Target:** End of Q1 2026