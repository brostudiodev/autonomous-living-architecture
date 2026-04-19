---
title: "G01: Roadmap"
type: "goal_roadmap"
status: "active"
owner: "Michal"
updated: "2026-04-19"
goal_id: "goal-g01"
---

# Roadmap (2026)

## Q1 (Jan–Mar)
- [x] Establish baseline body fat percentage and weight measurements (Withings sync) ✅
- [x] Define target body fat range and timeline for 2026 ✅
- [x] Implement initial tracking system for workouts and nutrition (Postgres + Sheets) ✅
- [x] Set up automated reporting for weekly/monthly progress ✅
- [x] Integrate health data from G07 (Predictive Health Management) for readiness-based training ✅
- [x] **HIT Productionization:** Unified exercise database and training templates in PostgreSQL ✅ (Mar 10)
- [x] **Progressive Overload Agent:** Automated suggestions for weight/rep increases based on previous session ✅ (Mar 10)
- [x] **Dynamic Progression:** Readiness-based weight and TUT adjustment suggestions ✅ (Mar 31)
- [x] **Strength Gains Visualization:** Monthly reporting on 1RM and volume trends ✅ (Mar 20)

## Q2 (Apr–Jun) - Optimization Phase

> [!tip] 🚀 **Q2 Focus: Optimize Existing Systems**
- [ ] **System Stability Audit:** Verify all automated health syncs are working reliably
  - [ ] **Sub-task: Withings Sync Check** - Ensure weight/BF% data flows to DB without gaps
  - [ ] **Sub-task: Workout Log Automation** - Verify training data syncs to PostgreSQL
- [ ] **Missing Automation Implementation:**
  - [ ] **Sub-task: Photo Logging Workflow** - Implement automated monthly photo logging
  - [ ] **Sub-task: Waist/BF% Trend Analysis** - Add automated mid-year review generation
- [ ] **Integration Optimization:**
  - [ ] **Sub-task: G07 Health Integration** - Ensure readiness score flows into training decisions
  - [ ] **Sub-task: G03 Nutrition Link** - Verify procurement automation for recovery foods

- [/] Implement monthly photo logging workflow
- [x] Optimize training-recovery balance using G07/G10 readiness data (Mar 18)
- [x] **Performance Nutrition Auto-Pilot:** Link HIT schedule to G03 procurement for recovery staples ✅ (Mar 28)
- [x] **n8n Training Workflows:** SVC_Daily-Workout-Suggestion, PROJ_Training-Intelligence-System ✅ (Apr 10)
- [x] **Zepp Health Sync:** SVC_Zepp-Health-Sync workflow with Amazfit integration ✅ (Apr 10)
- [x] **Unlimited Training History Unlock (G01-UHU):** Standardized 3650-day lookback for Training Intelligence Agent ✅ (Apr 19)
- [/] Mid-year review: Analyze waist & BF% trends

## Q3 (Jul–Sep)
- [ ] Reach 15% body fat range through controlled progression
- [ ] Transition to maintenance protocol if goal achieved early
- [ ] Integrate n8n reminders for workout logging (7+ days inactivity alert)
- [ ] Add conditional formatting to Google Sheets for performance insights
- [ ] Experiment with nutrition data integration if BF% progress stagnates

## Q4 (Oct–Dec)
- [ ] Finalize 2026 body transformation analysis
- [ ] Establish sustainable maintenance routine for 2027
- [ ] Document lessons learned and strategy for long-term body composition management
- [ ] Explore advanced biomechanics tracking or performance metrics

## Dependencies
- **Systems:** S03 (Data Layer for tracking), S06 (Health Performance System for training/recovery), S01 (Observability for dashboards)
- **External:** Withings API (weight/BF%), Training App APIs (if applicable)
- **Other goals:** G07 (Health Management) for readiness, G03 (Household Ops) for nutrition procurement, G12 (Meta-System) for holistic health view.
