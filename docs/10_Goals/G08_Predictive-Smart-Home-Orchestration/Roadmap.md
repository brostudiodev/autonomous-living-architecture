---
title: "G08: Roadmap"
type: "goal_roadmap"
status: "active"
owner: "Michal"
updated: "2026-04-12"
goal_id: "goal-g08"
---

# Roadmap (2026)

## Q1 (Jan–Mar)
- [x] Inventory existing smart home devices and capabilities ✅ (Feb 20)
- [x] Establish a reliable communication bridge between S07 (Smart Home) and S04 (Digital Twin) ✅ (Feb 24)
- [x] Implement basic environmental monitoring (temperature, humidity, occupancy) ✅ (Feb 24)
- [x] Develop foundational automation rules for home comfort and security (Home Assistant based) ✅ (Feb 24)
- [x] Integrate smart home status into the Autonomous Morning Briefing ✅ (Feb 26)
- [x] Begin feeding environmental data into G12 (Meta-System) for pattern analysis ✅ (Implemented via G11 Mapper)
- [x] **Pre-Bed Sleep Advisor:** Proactive Telegram alerts at 21:00 suggesting ventilation/cooling based on real-time sensors ✅ (Mar 23)
- [x] **Predictive Hardware Resilience:** Real-time monitoring of host vitals (RAM, Swap, Power) with autonomous stress alerting ✅ (Mar 28)

## Q2 (Apr–Jun) - Optimization Phase

> [!tip] 🚀 **Q2 Focus: System Stability & Minor Features**
- [ ] **System Stability Audit:** Verify smart home automations working reliably
  - [ ] **Sub-task: HA API Check** - Ensure Home Assistant API responding correctly
  - [ ] **Sub-task: Sensor Sync Check** - Verify temperature/humidity/occupancy data flows
  - [ ] **Sub-task: Pre-Bed Advisor Check** - Test evening alerts trigger correctly
- [ ] **Minor Features:**
  - [ ] **Sub-task: Security Mode** - Complete dynamic security mode based on travel context

- [x] **Weather-aware recommendations** - Provide comfort suggestions via HA webhook ✅ (Pre-Bed Sleep Advisor Mar 23)
- [ ] Implement advanced predictive models for occupancy and activity patterns
- [ ] Integrate external data sources: local weather forecasts, energy price signals
- [x] Weather-aware optimization anticipating external conditions ✅ (Pre-Bed Sleep Advisor)
- [ ] Optimize energy consumption based on predictive occupancy and pricing
- [/] Develop a "Security Mode" that dynamically adjusts based on Digital Twin context (e.g., travel schedule)

## Q3 (Jul–Sep) - Phase: The Contextual Home
- [ ] Implement "Follow-Me" lighting and climate control based on real-time occupancy
- [ ] Automated adjustment of home environment based on biological readiness (G07)
- [ ] Predictive maintenance alerts for smart home infrastructure and appliances
- [ ] Integrate G08 with G03 (Household Operations) for optimized appliance usage

## Q4 (Oct–Dec) - Phase: The Orchestrated Environment
- [ ] Achieve a comprehensive and predictive smart home orchestration system
- [ ] Finalize the integration of G08 as a core component of the "autonomous living" ecosystem
- [ ] Document lessons learned and strategy for 2027 home orchestration
- [ ] Establish continuous validation and improvement mechanisms for orchestration logic

> [!tip] 🚀 **NEW: External Environmental Context Layer**
> **Gap:** G08 tracks home environment but missing external context that correlates with energy/mood.
- [ ] **Location Mode Tracking:** Auto-detect or prompt for context
  - [ ] **Sub-task: Location Modes** - Home / Office / Travel / Outdoor / Commute
  - [ ] **Sub-task: Context-Aware Automation** - Different automations per location
- [ ] **Weather-Energy Correlation:** External weather impacting internal state
  - [ ] **Sub-task: Weather API Integration** - OpenWeatherMap or similar
  - [ ] **Sub-task: Correlation Dashboard** - Barometric pressure → headaches, sun → energy
- [ ] **Air Quality Monitoring:** Indoor/outdoor AQ correlation
  - [ ] **Sub-task: WAQI Integration** - Outdoor air quality API
  - [ ] **Sub-task: Alert Thresholds** - Warn when AQ affects sleep/exercise
- [ ] **Seasonal Pattern Analysis:** Long-term environmental patterns
  - [ ] **Sub-task: Seasonal Affective Tracking** - Light therapy reminders
  - [ ] **Sub-task: Heating/Cooling Prediction** - Anticipate HVAC needs

## Dependencies
- **Systems:** S07 (Smart Home System for device control), S04 (Digital Twin for contextual intelligence), S08 (Automation Orchestrator for workflow integration)
- **External:** Home Assistant API, various smart device APIs (Zigbee, Z-Wave, WiFi devices)
- **Other goals:** G03 (Household Operations) for task automation, G07 (Health Management) for environmental health, G11 (Productivity) for optimal work environment, G12 (Meta-System) for holistic view.
