---
title: "G01: Roadmap"
type: "goal_roadmap"
status: "active"
goal_id: "goal-g01"
updated: "2026-01-23"
---

# Roadmap (2026)

## Q1 (Jan–Mar)
- [x] Google Sheets capture UI setup (Jan 22)
- [x] GitHub Actions sync automation (Jan 23)
- [x] CSV schema validation (Jan 23)
- [ ] Monthly review script (auto-generate progress summary)
- [x] Add Google Sheets dropdowns (exercise_id, workout_id validation at source)
- [ ] First DEXA scan or waist measurement baseline (end of Q1)

## Q2 (Apr–Jun)
- [ ] Next session planner script (auto-generate "increase/hold" recommendations)
- [ ] Obsidian dashboard with Dataview queries (visual progress tracking)
- [ ] Evaluate: is smart scale BF% signal valid, or switch to waist-only tracking?
- [ ] Mid-year review: BF% trend analysis, decide if nutrition tracking needed

## Q3 (Jul–Sep)
- [ ] n8n reminder integration (alert if no workout logged in 7+ days)
- [ ] Add conditional formatting to Google Sheets (highlight TUT>90s, form_ok=false)
- [ ] Experiment: connect nutrition data if BF% progress stalled

## Q4 (Oct–Dec)
- [ ] Year-end review: compare Jan baseline vs Dec results
- [ ] Document lessons learned for 2027 planning
- [ ] Decide: continue HIT, or pivot to different training style based on results

## Dependencies
- **Systems:** S03 (data layer must be stable), S01 (observability for review automation)
- **External:** Google Sheets API stability, GitHub Actions free tier limits
- **Other goals:** goal-g09 (process documentation) ensures this system is documented as reference implementation

