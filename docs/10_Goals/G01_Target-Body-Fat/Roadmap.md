---
title: "G01: Roadmap"
type: "goal_roadmap"
status: "active"
goal_id: "goal-g01"
owner: "Michal"
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
- [x] Develop script for monthly progress summary generation ✅ (G01_monthly_reporter.py)
- [ ] Integrate smart scale data API with S03 Data Layer (Pending hardware refresh)
- [ ] Define initial data model for health metrics in S03

## Q2 (Apr–Jun)
- [x] Implement next session planner script with recommendations ✅ (Feb 24 - G01_training_planner.py)
- [ ] Create Obsidian dashboard for visual progress tracking (Dataview queries)
- [ ] Refine nutrition macros based on Q1 progress and energy levels
- [ ] Optimize training-recovery-productivity balance using G10 data
- [ ] Implement pattern recognition for personal optimization opportunities
- [ ] Mid-year review: Analyze BF% trends; decide on nutrition tracking necessity

## Q3 (Jul–Sep)
- [ ] Reach 15% body fat range through controlled progression
- [ ] Transition to maintenance protocol if goal achieved early
- [ ] Integrate n8n reminders for workout logging (7+ days inactivity alert)
- [ ] Add conditional formatting to Google Sheets for performance insights
- [ ] Experiment with nutrition data integration if BF% progress stagnates

## Q4 (Oct–Dec)
- [ ] Maintain 15% body fat target
- [ ] Establish sustainable long-term maintenance protocols for 2027
- [ ] Document enterprise-grade methodology for consulting applications
- [ ] Year-end review: Compare baseline vs. end-of-year results
- [ ] Finalize integration of G01 data into G12 Meta-System for holistic insights

## Dependencies
- **Systems:** S01 (observability for review automation), S03 (stable data layer), S06 (health performance system)
- **External:** Google Sheets API, GitHub Actions, Smart Scale API/integration
- **Other goals:** goal-g09 (process documentation) ensures this system is documented as reference implementation, G12 (meta-system integration) for holistic view.