---
title: "G04: Roadmap"
type: "goal_roadmap"
status: "active"
owner: "Michał"
updated: "2026-05-01"
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
- [x] **n8n Service Documentation Complete:** Documented 38+ n8n automation services in G12 ✅ (Apr 10)
- [x] **Schedule Master List:** Created `SCHEDULE_All-Workflows.md` with all trigger times ✅ (Apr 10)
- [x] **Appliance Maintenance Integration (G04-AMI):** Integrated HVAC/Water Softener status into the life sentinel for unified mission injection ✅ (Apr 19)
- [x] **API Architectural Hardening (G04-AAH):** Resolved port conflicts and consolidated Digital Twin endpoints ✅ (Apr 16)
- [x] **Unlimited History Unlock (G04-UHU):** Standardized 10-year lookback and removed data retrieval limits across all agents, engines, and endpoints ✅ (Apr 19)
- [x] **Digital Twin System Hardening (G04-STB):** Resolved parameter mismatches and command translation errors in Engine/API ✅ (Apr 17)
- [x] **Briefing Tactical Optimization (G04-BTO):** Filtered redundant audit tasks from briefings for mission clarity ✅ (Apr 16)
- [x] **Personal Bio-Context Expansion (G04-PBC):** Create separate "Personal" folder for document-based context about Michal. Fully integrated into Digital Twin via G04_personal_context_sync.py. ✅ (Apr 25)
- [x] **API Resilience & Discovery (G04-ARD):** Fixed endpoint shadowing and redundant route clashing. Upgraded project discovery to recursive scanning to support nested PARA-style projects. ✅ (Apr 25)
- [x] **Personal Intelligence API (G04-PIA):** Launched `/personal` endpoint providing deep bio-context (CV, Identity, Health Baselines) directly from PostgreSQL for zero-touch AI awareness. ✅ (Apr 25)

> [!tip] 🚀 **Event-Driven Architecture (EDA) Transition (G04-EDA)**
> **Goal:** Transition from REST polling to real-time reactive events for life telemetry.
- [x] **Message Broker Deployment:** RabbitMQ live in Docker ✅ (May 01)
- [x] **WebSocket Bridge:** Implemented RabbitMQ-to-WebSocket bridge in API for real-time UI updates ✅ (May 12)
- [x] **Core Script Emission:** Progressive update of all sync scripts to emit `LifeEvents` (Ongoing)
  - [x] `G07_zepp_sync.py` (Health) ✅
  - [x] `G05_finance_sync.py` (Finance) ✅
  - [x] `pantry_sync.py` (Pantry) ✅
  - [x] `G10_activitywatch_sync.py` (Productivity) ✅
  - [x] `G07_weight_sync.py` (Weight) ✅ (May 21)
  - [x] `G02_substack_sync.py` (Brand) ✅ (May 21)
  - [x] `G06_learning_sync.py` (Learning) ✅ (May 21)
- [x] **n8n Trigger Migration: Pantry Sync** ✅ (May 22)
- [ ] **n8n Trigger Migration: Finance Data Sync**
- [ ] **n8n Trigger Migration: Finance Budget Sync**
- [ ] **n8n Trigger Migration: AI Strategic Auditor**
- [ ] **n8n Trigger Migration: Budget Intelligence** (Triggered by Sync)

> [!danger] 🛡️ **Infrastructure Hardening (Phase 5 - Post-Audit)**
- [x] **PgBouncer Alignment:** Migrate Digital Twin API and internal tools from Port 5432 to 6432 (PgBouncer) for connection pooling. ✅ (May 22)
- [x] **Log Permission Alignment:** Standardized `structured_logs` ownership. Core services now run as non-root (UID 1000) with `group_add` for Docker socket access. ✅ (May 24)
- [x] **Active Health Checks:** Implemented "RabbitMQ-Aware" health probes in API/Bridge to detect silent consumer death. Upgraded Docker healthchecks to use `AUDIT_MODE`. ✅ (May 24)

> [!danger] 🚀 **NEW: Event-Driven Twin Foundation (G04-EDT)**

> **Gap:** REST polling is too slow for reactive life telemetry. Transitioning to real-time events.
- [x] **Message Broker Integration:**
  - [x] **Sub-task: RabbitMQ Producer** - Enable G04 API to emit "LifeEvents" to RabbitMQ ✅ (May 21)
  - [x] **Sub-task: State Change Emitter** - Auto-emit events on state cache refresh (e.g., "Health readiness dropped below 60") ✅ (May 21)
  - [x] **Sub-task: WebSocket Bridge** - Implement lightweight WebSocket server for real-time Dashboard updates ✅ (May 12)
- [ ] **LLM Operational Guardrails (G04-LOG):** Implement a pre-processing "Guardrail" layer in n8n Language Gate to detect prompt injection and prevent high-risk autonomous actions.
- [ ] **API Security Hardening (G04-ASH):**
    - [ ] **Bearer Token Auth:** Transition from simple API keys to standard Bearer Token authentication.
    - [ ] **Swagger/OpenAPI:** Implement interactive API documentation at `/docs` for service discovery.
    - [ ] **SSO/OIDC Integration:** Implement OpenID Connect (OIDC) using Authentik/Authelia for unified identity management across UI and API.

> [!tip] 🚀 **Multi-User Package Support**
- [ ] **API user context:** Add X-User-ID header routing for multi-user isolation
- [ ] **Port configuration:** Ensure all ports configurable via .env
- [ ] **Test with multiple instances:** Verify parallel deployments work

- [x] Integrate additional data sources (e.g., smart home sensors, health trackers)
- [x] Implement event-driven architecture for real-time twin updates
- [x] Develop advanced querying capabilities and data analysis within S04
- [x] Create interactive 3D/2D visualization of twin state (e.g., Home Assistant integration) ✅ (Basic via Telegram Dashboard)

## Q3 (Jul–Sep) - Phase: Agentic Orchestration

> [!tip] 🚀 **Priority: Missing n8n Agents (Optimization First)**
- [x] **Missing n8n Agents:** Implement the 2 agents not yet in n8n ✅ (Apr 15)
  - [x] **Sub-task: Career Agent (G09)** - LinkedIn/Substack automation agent in n8n ✅ (Apr 15)
  - [x] **Sub-task: Productivity Agent (G10)** - Calendar/Task orchestration agent in n8n ✅ (Apr 15)

> [!tip] 🚀 **Future Infrastructure (Transitioned to Q2)**
> - [ ] **WebSocket Layer:** Implementation accelerated
> - [ ] **Message Broker:** Integrated via G11 Meta-System
> - ⚠️ **GraphQL API:** See G11 Meta-System Q3

### Core Agentic Framework (Already ✅ Implemented in n8n)
...
- [x] **Simulation Mode Implementation (G04-SMI):** Monte Carlo models for long-term goal impact. [See Project P07](projects/P07_Monte-Carlo-Predictive-Engine.md) ✅ (May 21)

## Q4 (Oct–Dec) - Phase: The Predictive Partner

> [!tip] 🚀 **Infrastructure Transitioned to Q2**
> - ⚠️ **GraphQL API:** Deferred to 2027 - depends on G11 Message Broker
> - ⚠️ **Vector DB:** Deferred to 2027 - depends on Message Broker infrastructure
> - ⚠️ **Agent-to-Agent Protocol:** Deferred to 2027 - depends on Message Broker

### Core Q4 Deliverables (Focus on Optimization)
...
## Dependencies
- **Systems:** S03 (Data Layer for persistence), S04 (Digital Twin for core logic), S08 (Automation Orchestrator for data processing workflows)
- **External:** Google Gemini API (for LLM interactions), various data source APIs
- **Other goals:** G01, G02 (Automationbro), G03, G05 (Finance), G06, G07, G08, G09, G10, G11 (all feed data into the Digital Twin), G12 (Meta-System for holistic view).
