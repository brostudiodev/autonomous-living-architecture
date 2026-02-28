---
title: "G08: Roadmap"
type: "goal_roadmap"
status: "active"
owner: "Michal"
updated: "2026-02-18"
---

# Roadmap (2026)

## Q1 (Jan–Mar)
- [x] Inventory existing smart home devices and capabilities (e.g., Home Assistant integrations) ✅ DONE
- [x] Define core smart home data model in S03 (Data Layer) ✅ DONE (using MariaDB directly)
- [x] Establish initial data ingestion pipelines from smart home sensors (G08_home_monitor.py) ✅ (Feb 24)
- [x] Transition from direct MariaDB to Home Assistant REST API for real-time monitoring ✅ (Feb 26)
- [x] Implement specialized security and active lighting monitoring endpoints ✅ (Feb 26)
- [x] Implement basic automation rules (Low Battery Alerts) ✅ (Feb 24)
- [x] Set up monitoring dashboards in S04 (Digital Twin Dashboard) ✅ (Feb 24)
- [x] Integrate foundational smart home data into G12 (Meta-System) ✅ (Feb 24)

## Q2 (Apr–Jun)
- [ ] Occupancy & Activity Prediction models (scikit-learn/Prophet)
- [ ] Activity classification via multi-sensor data fusion (Bayesian inference)
- [ ] Implement Predictive Climate Orchestration (thermal modeling, MPC)
- [ ] Weather-aware optimization anticipating external conditions
- [ ] Intelligent Lighting & Ambiance (circadian lighting, activity scenes)
- [ ] Integrate with G03 (Household Operations) for task automation

## Q3 (Jul–Sep)
- [ ] Local AI integration (Ollama) for intelligent decision-making
- [ ] Natural language command processing (Agent Zero)
- [ ] AI-powered anomaly investigation and diagnosis
- [ ] Adaptive learning (reinforcement learning) for climate/lighting control
- [ ] Energy intelligence: dynamic pricing and solar forecasting optimization

## Q4 (Oct–Dec)
- [ ] Cross-system intelligence (Finance, Digital Twin, Health, Household)
- [ ] Advanced Scenarios: Probabilistic reasoning for conflict resolution
- [ ] Predictive failure detection for home infrastructure
- [ ] Automated security integration and weather emergency preparation
- [ ] Achieving 90% Zero Manual Interaction (ZMI) milestone

## Dependencies
- **Systems:** S01 (Observability for dashboards), S03 (Data Layer for storage/models), S07 (Smart Home System for core platform), S08 (Automation Orchestrator for complex rules)
- **External:** Home Assistant, various smart device APIs (Zigbee, Z-Wave, WiFi devices)
- **Other goals:** G03 (Household Operations) for task automation, G07 (Health Management) for environmental health, G11 (Productivity) for optimal work environment, G12 (Meta-System) for holistic view.