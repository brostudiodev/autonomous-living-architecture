---
title: "G07: Roadmap"
type: "goal_roadmap"
status: "active"
owner: "Michal"
updated: "2026-02-07"
---

# Roadmap (2026)

## Q1 (Jan–Mar)
- [x] Identify key health metrics to track (e.g., sleep, activity, heart rate variability, nutrition) ✅ (Feb 26)
- [x] Integrate initial data sources (e.g., smart scale, fitness tracker APIs) into S03 Data Layer ✅ (WF003/Withings)
- [x] Establish data ingestion pipelines for continuous health data collection ✅ (G07_zepp_sync.py staged)
- [x] Define baseline health metrics and ranges for personalized analysis ✅ (Feb 26)
- [x] Set up basic dashboards in Obsidian daily notes (G10 Summarizer integration) ✅ (Feb 28)
- [x] Begin feeding health data into G12 (Meta-System) for holistic insights ✅ (Implemented via G11 Mapper)

## Q2 (Apr–Jun) - Phase: The Biometric Stream
- [ ] Implement Amazfit/Zepp API data extraction (Heart Rate, HRV, Sleep Quality)
- [ ] Establish "Biological Readiness Score" algorithm (S03 Data Layer)
- [ ] Connect health telemetry to G04 Digital Twin for real-time state updates
- [ ] Automate daily health trend reporting in Obsidian
- [ ] Refine data models for complex health interactions in S03 Data Layer

## Q3 (Jul–Sep) - Phase: Biological Closed-Loop
- [ ] Implement "Recovery-First" scheduling (G07 feeds G10 Dynamic Scheduler)
- [ ] Predictive health anomaly detection (AI identifies oncoming illness/fatigue)
- [ ] Automate supplement/nutrition recommendations based on biometric load
- [ ] Achieve 100% automated health baseline monitoring

## Q4 (Oct–Dec)
- [ ] Achieve a comprehensive and integrated predictive health management system
- [ ] Finalize the integration of G07 as a core data contributor to G12 (Meta-System)
- [ ] Document lessons learned and strategy for 2027 health optimization
- [ ] Establish continuous validation and improvement mechanisms for predictive models

## Dependencies
- **Systems:** S01 (Observability for dashboards), S03 (Data Layer for storage/processing), S06 (Health Performance System for specific health tools), S08 (Automation Orchestrator for workflows)
- **External:** Smart scale APIs, fitness tracker APIs (Garmin, Oura, etc.), potential medical APIs
- **Other goals:** G01 (Target Body Fat) for fitness data, G11 (Intelligent Productivity) for impact on well-being, G12 (Meta-System) for holistic health view.