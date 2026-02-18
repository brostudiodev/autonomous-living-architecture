---
title: "G01: Roadmap"
type: "goal_roadmap"
status: "active"
goal_id: "goal-g01"
owner: "Michał"
updated: "2026-02-07"
---

# Roadmap (2026)

## Q1 (Jan–Mar)
- [x] Google Sheets capture UI setup (Jan 22)
- [x] GitHub Actions sync automation (Jan 23)
- [x] CSV schema validation (Jan 23)
- [x] Add Google Sheets dropdowns (exercise_id, workout_id validation at source)
- [x] Establish initial body composition baseline (20.8% → 15% target)
  - Withings Scale: Daily tracking (baseline: 20.8% BF)
  - Waist: Every 15 days max
  - Photos: Monthly
  - DEXA: Only at target (optional)
- [ ] Develop script for monthly progress summary generation
- [ ] Integrate smart scale data API with S03 Data Layer
- [ ] Define initial data model for health metrics in S03

## Q2 (Apr–Jun)
- [ ] Implement next session planner script with recommendations
- [ ] Create Obsidian dashboard for visual progress tracking (Dataview queries)
- [ ] Evaluate smart scale BF% data validity; refine tracking methodology
- [ ] Mid-year review: Analyze BF% trends; decide on nutrition tracking necessity
- [ ] Automate data import from fitness trackers (e.g., Garmin, Oura)

## Q3 (Jul–Sep)
- [ ] Integrate n8n reminders for workout logging (7+ days inactivity alert)
- [ ] Add conditional formatting to Google Sheets for performance insights
- [ ] Experiment with nutrition data integration if BF% progress stagnates
- [ ] Develop basic predictive models for health trends in S06

## Q4 (Oct–Dec)
- [ ] Year-end review: Compare baseline vs. end-of-year results
- [ ] Document lessons learned for 2027 planning
- [ ] Decide on training style pivot based on results and goals
- [ ] Finalize integration of G01 data into G12 Meta-System for holistic insights

## Dependencies
- **Systems:** S01 (observability for review automation), S03 (stable data layer), S06 (health performance system)
- **External:** Google Sheets API, GitHub Actions, Smart Scale API/integration
- **Other goals:** goal-g09 (process documentation) ensures this system is documented as reference implementation, G12 (meta-system integration) for holistic view.