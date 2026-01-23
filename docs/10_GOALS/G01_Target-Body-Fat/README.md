---
title: "G01: Reach Target Body Fat"
type: "goal"
status: "active"
goal_id: "goal-g01"
owner: "Michał"
updated: "2026-01-23"
---

# G01: Reach Target Body Fat

## Intent
Achieve visible body recomposition (lower body fat, maintain/gain strength) through low-volume HIT training and smart-scale trend tracking, with zero manual logging friction.

## Definition of Done (2026)
- [ ] Body fat trend shows sustained 2–4% reduction (smart scale 7-day moving average)
- [ ] Training system runs with <60s post-workout logging overhead
- [ ] All workout data automatically synced to Git (Google Sheets → GitHub → Obsidian)
- [ ] CSV schema validation prevents data corruption
- [ ] Monthly progress reviews automated

## Key Links
- Outcomes: [Outcomes.md](Outcomes.md)
- Metrics: [Metrics.md](Metrics.md)
- Systems: [Systems.md](Systems.md)
- Roadmap: [Roadmap.md](Roadmap.md)
- Activity Log: [ACTIVITY_LOG.md](ACTIVITY_LOG.md)
- Training Journal: [Training/README.md](Training/README.md)

## Current Status
**Phase:** Active logging + validation (as of 2026-01-23)
- ✅ Google Sheets capture UI (mobile-ready)
- ✅ GitHub Actions sync (every 6 hours)
- ✅ CSV schema validation
- 🚧 Monthly review automation (planned Q1)
- 🚧 Progression planner (planned Q2)

## Notes
Training data lives in Google Sheets for capture speed. GitHub is source of truth. Obsidian queries the CSV for dashboards.
