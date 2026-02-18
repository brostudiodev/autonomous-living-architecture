---
title: "G01: Reach Target Body Fat"
type: "goal"
status: "active"
goal_id: "goal-g01"
owner: "Michał"
updated: "2026-02-16"
review_cadence: "monthly"
---

# G01: Reach Target Body Fat

## Purpose
Achieve visible body recomposition (lower body fat, maintain/gain strength) through low-volume HIT training and smart-scale trend tracking, with zero manual logging friction. The goal is to reach ~15% body fat while maintaining strength through automated tracking and data-driven progression.

## Scope
### In Scope
- HIT (High Intensity Training) workout tracking
- Body fat percentage monitoring via smart scale
- Automated data capture from Google Sheets to GitHub to Obsidian
- CSV schema validation for data integrity
- Monthly progress automation

### Out of Scope
- Detailed nutrition tracking (unless progress stagnates)
- DEXA scans (only at target)
- Detailed macronutrient tracking
- Gym equipment integration

## Intent
Achieve visible body recomposition (lower body fat, maintain/gain strength) through low-volume HIT training and smart-scale trend tracking, with zero manual logging friction.

## Definition of Done (2026)
- [ ] Body fat trend shows sustained 2–4% reduction (smart scale 7-day moving average)
- [ ] Training system runs with <60s post-workout logging overhead
- [ ] All workout data automatically synced to Git (Google Sheets → GitHub → Obsidian)
- [ ] CSV schema validation prevents data corruption
- [ ] Monthly progress reviews automated

## Inputs
- Workout data via Google Sheets (exercise, sets, reps, weight, RPE)
- Daily weight and body fat from Withings Scale API
- Waist measurements (every 15 days)
- Monthly progress photos

## Outputs
- CSV files in `/data/` synced to GitHub
- Obsidian queries for dashboards
- Monthly progress summaries (automated)
- Body fat trend charts

## Dependencies
### Systems
- S03 Data Layer (data persistence)
- S01 Observability (dashboards)
- Google Sheets API
- GitHub Actions
- Withings Scale API

### External
- Withings Smart Scale
- Google Sheets (mobile)
- Obsidian (dashboards)

## Key Links
- Outcomes: [Outcomes.md](Outcomes.md)
- Metrics: [Metrics.md](Metrics.md)
- Systems: [Systems.md](Systems.md)
- Roadmap: [Roadmap.md](Roadmap.md)
- Activity Log: [ACTIVITY_LOG.md](ACTIVITY_LOG.md)
- Training Journal: [Training/README.md](Training/README.md)

## Procedure
1. **Daily:** Weigh on Withings scale (morning, after toilet)
2. **After workout:** Log in Google Sheets (mobile) - ~60s max
3. **Every 15 days:** Measure waist
4. **Monthly:** Review automated progress summary
5. **Quarterly:** Review trend, decide on nutrition tracking if needed

## Failure Modes
| Scenario | Detection | Response |
|----------|-----------|----------|
| Scale sync fails | Missing data in S03 | Manual re-sync, check Withings API |
| GitHub Actions fail | n8n alert, check Actions tab | Re-run workflow, check credentials |
| CSV validation fails | Workflow stops | Fix data in Google Sheets, re-sync |
| Progress stagnates | 4+ weeks no BF% change | Review training intensity, consider nutrition tracking |

## Security Notes
- No health data stored in cloud services beyond Withings
- GitHub repository is private
- Credentials stored in GitHub Secrets (Actions)
- No PII beyond basic health metrics

## Current Status
**Phase:** Active logging + validation (as of 2026-01-23)
- ✅ Google Sheets capture UI (mobile-ready)
- ✅ GitHub Actions sync (every 6 hours)
- ✅ CSV schema validation
- 🚧 Monthly review automation (planned Q1)
- 🚧 Progression planner (planned Q2)

## Owner & Review
- **Owner:** Michał
- **Review Cadence:** Monthly
- **Last Updated:** 2026-02-16
