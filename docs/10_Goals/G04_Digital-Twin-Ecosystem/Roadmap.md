---
title: "G04: Roadmap"
type: "goal_roadmap"
status: "active"
owner: "Michal"
updated: "2026-03-27"
goal_id: "goal-g04"
---

# Roadmap (2026)

## Q1 (Jan–Mar)
- [x] Initial Intelligence Hub (WF004) for multi-modal input processing (text, PDF, CSV, audio) ✅
- [x] Define core data models for Digital Twin entities (e.g., Person, Home, Goals) ✅ (Feb 20)
- [x] Implement initial data ingestion pipelines from key sources (e.g., Obsidian, Postgres) ✅ (Feb 24)
- [x] Establish a REST API layer (S04 Digital Twin) for querying state ✅ (Feb 24)
- [x] Add `/suggested` endpoint for autonomous intelligence reports ✅ (Feb 26)
- [x] Develop basic visualization of Digital Twin state (Telegram Dashboard) ✅ (Feb 24)
- [x] Implement proactive notification system (Autonomous Morning Briefing) ✅ (Feb 26)
- [x] Integrate foundational components with G12 (Meta-System) for early data flow ✅ (Feb 24)
- [x] **Life Logistics Subsystem:** Automated tracking of document expiries and recurring payments ✅ (Mar 03)
- [x] **Contextual Memory (Agent Zero):** Digital Twin remembers previous strategic decisions and queries ✅ (Mar 04)
- [x] **Local Control Center (Web UI):** Prototype terminal UI for platform-independent command execution ✅ (Mar 10)
- [x] **Automated ROI Engine:** Real-time calculation of time saved based on system activity ✅ (Mar 25)

## Q2 (Apr–Jun)
- [x] Implement Amazfit & Zepp API integration for real-time health telemetry ✅ (Mar 04)
- [x] **Predictive Focus Switching:** System autonomously suggests schedule adjustments based on cross-domain alert priority ✅ (Mar 04)
- [x] **Cross-Domain Correlation Engine:** Identify how spending impacts stress/sleep, etc. ✅ (Mar 04)
- [x] **Strategic Querying:** `/ask` endpoint for natural language interactions with the Twin ✅ (Mar 04)
- [x] **Historical Trend Analysis:** Expanded `/all` endpoint to support 7d and 30d biometric/financial velocity ✅ (Mar 10)
- [x] **Temporal Memory Implementation:** Automated nightly state snapshots in PostgreSQL JSONB ✅ (Mar 19)
- [x] **Relational Cross-Domain Context:** Unified "Relationships" sync with task injection logic ✅ (Mar 19)
- [x] **Strategic Audit API:** Exposed `/strategic_audit` endpoint for qualitative "Truth Audits" ✅ (Mar 27)
- [x] **Mood & Energy Engine:** Automated daily intelligence suggestions based on health/finance ✅ (Mar 31)
- [x] **AI Strategic Auditor:** Created `PROJ_AI-Strategic-Auditor.json` for n8n-Gemini integration ✅ (Mar 27)
- [x] **Advanced Trend Visualization:** Build UI/CLI charts comparing historical snapshots (7d vs 30d) ✅ (Mar 27)
- [x] Integrate additional data sources (e.g., smart home sensors, health trackers)
- [x] Implement event-driven architecture for real-time twin updates
- [x] Develop advanced querying capabilities and data analysis within S04
- [x] Create interactive 3D/2D visualization of twin state (e.g., Home Assistant integration) ✅ (Basic via Telegram Dashboard)

## Q3 (Jul–Sep) - Phase: Agentic Orchestration
- [ ] Transition from "Script Hub" to "Agentic Framework" (Digital Twin as Orchestrator)
  - [ ] **Sub-task: Agent Registry** - Define list of available agents (Finance, Health, Logistics, Productivity) with their capabilities
  - [ ] **Sub-task: Tool Mapping** - Map each agent to specific API endpoints they can access
  - [ ] **Sub-task: Agent Zero Router** - Update Agent Zero to route queries to appropriate sub-agents
  - [ ] **Sub-task: Memory Sharing** - Ensure all agents can read/write to strategic_memory table
- [ ] Implement Multi-Agent collaboration (e.g., Finance Agent talks to Logistics Agent)
  - [ ] **Sub-task: Cross-Domain `/correlate` Endpoint** - Create endpoint that joins data from multiple domains (e.g., finance + health)
  - [ ] **Sub-task: Correlation Engine** - Algorithm to find patterns between domains (spending → sleep, diet → energy, etc.)
  - [ ] **Sub-task: Data Join View** - Create PostgreSQL materialized view with joined daily data (finance + health + productivity)
  - [ ] **Sub-task: Agent Delegation Protocol** - Define how one agent can request data from another
- [ ] **Concept Reveal:** Public demonstration of "The Self-Directing Life" (Brand Integration)
- [ ] Integrate Long-Term Memory (Vector DB) for persistent context across sessions
  - [ ] **Sub-task: Vector DB Evaluation** - Research options (Pinecone, Qdrant, pgvector)
  - [ ] **Sub-task: Semantic Search** - Enable semantic similarity search across memories
- [ ] Develop "Simulation Mode" to predict impacts of daily choices on long-term goals
  - [ ] **Sub-task: Scenario Input** - Define format for "what-if" scenarios
  - [ ] **Sub-task: Impact Model** - Build model to predict outcomes (financial, health, productivity)

## Q4 (Oct–Dec) - Phase: The Predictive Partner
- [ ] Implement "What-If" Life Simulator (Monte Carlo simulations for long-term goal impact)
- [ ] Achieve a comprehensive and real-time representation of the "autonomous living" ecosystem
- [ ] Finalize the integration of G04 as the central data hub for G12 (Meta-System)
- [ ] Document lessons learned and strategy for 2027 development
- [ ] Establish continuous validation and calibration mechanisms for the Digital Twin

## Dependencies
- **Systems:** S03 (Data Layer for persistence), S04 (Digital Twin for core logic), S08 (Automation Orchestrator for data processing workflows)
- **External:** Google Gemini API (for LLM interactions), various data source APIs
- **Other goals:** G01, G02 (Automationbro), G03, G05 (Finance), G06, G07, G08, G09, G10, G11 (all feed data into the Digital Twin), G12 (Meta-System for holistic view).
