---
title: "G04: Roadmap"
type: "goal_roadmap"
status: "active"
owner: "Michał"
updated: "2026-02-07"
---

# Roadmap (2026)

## Q1 (Jan–Mar)
- [x] Initial Intelligence Hub (WF004) for multi-modal input processing (text, PDF, CSV, audio)
- [ ] Define core data models for Digital Twin entities (e.g., Person, Home, Goals)
- [ ] Implement initial data ingestion pipelines from key sources (e.g., Obsidian, Google Sheets)
- [ ] Establish a GraphQL API layer (S04 Digital Twin) for querying and updating twin state
- [ ] Develop basic visualization of Digital Twin state (e.g., simple dashboard)
- [ ] Integrate foundational components with G12 (Meta-System) for early data flow

## Q2 (Apr–Jun)
- [ ] Expand Digital Twin data models to include relationships and temporal aspects
- [ ] Integrate additional data sources (e.g., smart home sensors, health trackers)
- [ ] Implement event-driven architecture for real-time twin updates
- [ ] Develop advanced querying capabilities and data analysis within S04
- [ ] Create interactive 3D/2D visualization of twin state (e.g., Home Assistant integration)

## Q3 (Jul–Sep)
- [ ] Implement predictive modeling capabilities within the Digital Twin (e.g., future states)
- [ ] Develop simulation and "what-if" analysis tools
- [ ] Integrate with G08 (Predictive Smart Home Orchestration) for active control
- [ ] Explore AI agents within the twin for autonomous decision-making
- [ ] Refine data governance and privacy controls for twin data

## Q4 (Oct–Dec)
- [ ] Achieve a comprehensive and real-time representation of the "autonomous living" ecosystem
- [ ] Finalize the integration of G04 as the central data hub for G12 (Meta-System)
- [ ] Document lessons learned and strategy for 2027 development
- [ ] Establish continuous validation and calibration mechanisms for the Digital Twin

## Dependencies
- **Systems:** S03 (Data Layer for persistence), S04 (Digital Twin for core logic), S08 (Automation Orchestrator for data processing workflows)
- **External:** Google Gemini API (for LLM interactions), various data source APIs
- **Other goals:** G01, G02 (Automationbro), G03, G05 (Finance), G06, G07, G08, G09, G10, G11 (all feed data into the Digital Twin), G12 (Meta-System for holistic view).