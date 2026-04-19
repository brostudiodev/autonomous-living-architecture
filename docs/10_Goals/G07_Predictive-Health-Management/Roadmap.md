---
title: "G07: Roadmap"
type: "goal_roadmap"
status: "active"
owner: "Michal"
updated: "2026-04-12"
goal_id: "goal-g07"
---

# Roadmap (2026)

## Q1 (Jan–Mar)
- [x] Identify key health metrics to track (e.g., sleep, activity, heart rate variability, nutrition) ✅ (Feb 26)
- [x] Integrate initial data sources (e.g., smart scale, fitness tracker APIs) into S03 Data Layer ✅ (WF003/Withings)
- [x] Establish data ingestion pipelines for continuous health data collection ✅ (G07_zepp_sync.py productionized)
- [x] Define baseline health metrics and ranges for personalized analysis ✅ (Feb 26)
- [x] Set up basic dashboards in Obsidian daily notes (G10 Summarizer integration) ✅ (Feb 28)
- [x] Begin feeding health data into G12 (Meta-System) for holistic insights ✅ (Implemented via G11 Mapper)

## Q2 (Apr–Jun) - Phase: The Biometric Stream

> [!tip] 🚀 **Q2 Focus: System Stability**
- [ ] **System Stability Audit:** Verify all health syncs working reliably
  - [ ] **Sub-task: Zepp Sync Check** - Ensure health data (HRV, sleep) syncs without gaps
  - [x] **Withings Sync Check** - Refactored to direct API sync (G07_withings_direct_sync.py) with muscle/bone/hydration tracking ✅ (Apr 15)
  - [ ] **Sub-task: Readiness Score Check** - Validate biometric algorithm accuracy

- [x] Implement Amazfit/Zepp API data extraction (Heart Rate, HRV, Sleep Quality - Deep/REM) ✅ (Mar 04)
- [x] Establish "Biological Readiness Score" algorithm (S03 Data Layer) ✅ (Unified in `biometrics` table via band-logic)
- [x] Connect health telemetry to G04 Digital Twin for real-time state updates ✅ (Integrated via `get_health_status` and `get_task_recommendations`)
- [x] Implement Database-Driven Hydration & Caffeine Tracking ✅ (Mar 08)
- [x] Establish Historical Health Persistence (`sleep_log`, `body_metrics`) ✅ (Mar 08)
- [x] Automate daily health trend reporting in Obsidian ✅ (Mar 11 - G01_progress_analyzer.py + Withings productionized)
- [x] **Robust 3-Retry Health Sync:** Hardened G07/G11 sync pipeline with 10-min retry logic ✅ (Mar 27)
- [x] Refine data models for complex health interactions in S03 Data Layer ✅ (Unified biometrics schema)

## Q3 (Jul–Sep) - Phase: Biological Closed-Loop
- [ ] Implement "Recovery-First" scheduling (G07 feeds G10 Dynamic Scheduler)
- [x] **Illness & Fatigue Detector (G07-ID):** Autonomous anomaly detection for HRV/Readiness drops ✅ (Apr 03)
- [ ] Automate supplement/nutrition recommendations based on biometric load
- [ ] Achieve 100% automated health baseline monitoring

> [!tip] 🚀 **NEW: Body Signals & Internal State Tracking**
> **Gap:** G07 health predictions incomplete without internal signals beyond wearables.
- [ ] **Gut Health Tracking:** Add digestion patterns to daily note
  - [ ] **Sub-task: Digestion Log** - Morning/evening gut comfort rating (1-5)
  - [ ] **Sub-task: Correlation Engine** - Link gut health to energy/food/stress
- [ ] **Supplement Compliance:** Automated tracking of supplement intake
  - [ ] **Sub-task: Supplement Schedule** - Define daily/weekly supplement protocol
  - [ ] **Sub-task: Compliance Dashboard** - Track missed doses, adherence rate
- [ ] **Stress Self-Assessment:** Periodic check-ins throughout day
  - [ ] **Sub-task: Mood Triggers** - Log what caused stress spikes
  - [ ] **Sub-task: Recovery Correlation** - Link stress to sleep/HRV
- [ ] **Bloodwork Integration:** Periodic biomarker tracking
  - [ ] **Sub-task: Manual Entry Form** - Easy input for lab results
  - [ ] **Sub-task: Trend Dashboard** - Vitamin D, cholesterol, etc.

## Q4 (Oct–Dec)
- [ ] Achieve a comprehensive and integrated predictive health management system
- [ ] Finalize the integration of G07 as a core data contributor to G12 (Meta-System)
- [ ] Document lessons learned and strategy for 2027 health optimization
- [ ] Establish continuous validation and improvement mechanisms for predictive models

## Dependencies
- **Systems:** S01 (Observability for dashboards), S03 (Data Layer for storage/processing), S06 (Health Performance System for specific health tools), S08 (Automation Orchestrator for workflows)
- **External:** Smart scale APIs, fitness tracker APIs (Garmin, Oura, etc.), potential medical APIs
- **Other goals:** G01 (Target Body Fat) for fitness data, G11 (Intelligent Productivity) for impact on well-being, G12 (Meta-System) for holistic health view.
