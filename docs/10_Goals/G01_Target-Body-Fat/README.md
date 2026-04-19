---
title: "G01: Reach Target Body Fat"
type: "goal"
status: "active"
goal_id: "goal-g01"
owner: "Michal"
updated: "2026-04-08"
review_cadence: "monthly"
---

# G01: Reach Target Body Fat

## 🌟 What you achieve
*   **Automatic Progress Tracking:** Your weight and body fat are automatically pulled from your smart scale—no manual typing required.
*   **Minimalist High-Impact Training:** Focus on 2-3 short, intense workouts per week (HIT) that are proven to build strength.
*   **Visual Dashboards:** See your fat-loss trends and strength gains in beautiful, real-time charts.
*   **Dynamic Progression:** The system automatically suggests weight and TUT (Time Under Tension) adjustments based on your biological readiness (G07/G10).
*   **Data-Driven Decisions:** The system tells you when to adjust your training or nutrition based on real data, not guesswork.

> [!insight] 📝 **Automationbro Insight:** [HIT Training: Stop Wasting Time in the Gym. Start Training With Systems](https://automationbro.substack.com/p/hit-training-stop-wasting-time-in)

## Purpose
Achieve visible body recomposition (lower body fat, maintain health) through low-volume HIT training and smart-scale trend tracking. The primary physical markers of success are body weight, waist circumference, and monthly progress photos.

## Scope
### In Scope
- HIT (High Intensity Training) workout tracking
- Health parameters (Resting HR, HRV via G07)
- Body weight and body fat monitoring via smart scale
- Waist circumference tracking (Primary physical metric)
- Monthly progress photos
- Automated data sync from Google Sheets to PostgreSQL
- Monthly progress automation

### Out of Scope
- Detailed bodybuilding metrics (Chest, Arms, Legs measurements)
- Detailed nutrition tracking (unless progress stagnates)
- DEXA scans (only at target)
- Detailed macronutrient tracking

## Intent
Achieve visible body recomposition (lower body fat, maintain/gain strength) through low-volume HIT training and smart-scale trend tracking, with zero manual logging friction.

## Definition of Done (2026)
- [ ] Body fat trend shows sustained 2–4% reduction (smart scale 7-day moving average)
- [ ] Training system runs with <60s post-workout logging overhead
- [ ] All workout data automatically synced to PostgreSQL (Google Sheets → n8n → Database)
- [ ] Automated progression metrics active in Digital Twin / Prometheus
- [ ] Monthly progress reviews automated

## Inputs
- Workout data via Google Sheets (exercise, sets, reps, weight, RPE)
- Daily weight and body fat from Withings Scale API (synced to PostgreSQL)
- Waist measurements (every 15 days)
- Monthly progress photos

## Outputs
- PostgreSQL tables in `autonomous_training` (SSOT)
- Obsidian queries for dashboards (via Digital Twin API)
- Monthly progress summaries (automated)
- Body fat trend charts (Grafana)

## Dependencies
### Systems
- S03 Data Layer (PostgreSQL persistence)
- S01 Observability (Grafana dashboards)
- Google Sheets API (UI layer)
- n8n Automation (Sync engine)
- Withings Scale API

### External
- Withings Smart Scale
- Google Sheets (mobile UI)
- Obsidian (dashboards)

## Key Links
- Outcomes: [Outcomes.md](Outcomes.md)
- Metrics: [Metrics.md](Metrics.md)
- Systems: [Systems.md](Systems.md)
- Roadmap: [Roadmap.md](Roadmap.md)
- Activity Log: [Activity-log.md](Activity-log.md)
- Training Journal: [Training/README.md](Training/README.md)

## Procedure
1. **Daily:** Weigh on Withings scale (morning, after toilet)
2. **After workout:** Log in Google Sheets (mobile) or CLI (`smart_log_workout.py`)
3. **Every 15 days:** Measure waist
4. **Monthly:** Review automated progress summary
5. **Quarterly:** Review trend, decide on nutrition tracking if needed

## Failure Modes
| Scenario | Detection | Response |
|----------|-----------|----------|
| Scale sync fails | Missing data in S03 | Manual re-sync, check Withings API |
| Database sync fails | Dashboard shows stale data | Check n8n logs for Training-Sync workflow |
| Data inconsistency | SQL view errors | Validate data formats in Google Sheets |
| Progress stagnates | 4+ weeks no BF% change | Review training intensity, consider nutrition tracking |

## Security Notes
- No health data stored in cloud services beyond Withings and Google Sheets
- Homelab PostgreSQL database is private
- No PII beyond basic health metrics

## Current Status
**Phase:** Database-First Operations (as of 2026-02-25)
- ✅ Google Sheets capture UI (mobile-ready)
- ✅ PostgreSQL Single Source of Truth (SSOT) active
- ✅ n8n Training Sync operational
- ✅ Prometheus Exporter (PostgreSQL-driven) active
- 🚧 Monthly review automation (planned Q1)
- 🚧 Progression planner (planned Q2)

## Owner & Review
- **Owner:** Michal
- **Review Cadence:** Monthly
- **Last Updated:** 2026-02-25

---

## ☕ Fuel the Architecture

Building and maintaining this level of technical rigor is a massive investment. If this blueprint helps your own engineering journey, I would be grateful for your support.

<a href='https://ko-fi.com/michalnowakowski' target='_blank'><img height='60' style='border:0px;height:60px;' src='https://storage.ko-fi.com/cdn/kofi3.png?v=3' border='0' alt='Buy Me a Coffee at ko-fi.com' /></a>

**Support my hard work in engineering a fully autonomous life.** Every coffee fuels another line of code, another automated insight, and another step toward the 2026 North Star. Your contributions help maintain the infrastructure and research shared in this open-source blueprint.
