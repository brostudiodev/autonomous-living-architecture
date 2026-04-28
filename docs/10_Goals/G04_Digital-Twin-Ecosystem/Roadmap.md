---
title: "G04: Roadmap"
type: "goal_roadmap"
status: "active"
owner: "Michał"
updated: "2026-04-17"
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

> [!tip] 🚀 **Future Infrastructure (Deferred to Q4)**
> - ⚠️ **WebSocket Layer:** Deferred - requires Message Broker foundation first
> - ⚠️ **Message Broker:** See G11 Meta-System Q3 (foundation for real-time)
> - ⚠️ **GraphQL API:** See G11 Meta-System Q3

### Core Agentic Framework (Already ✅ Implemented in n8n)
> [!note] The following are already implemented in n8n (no action needed):
> - ✅ Agent Zero (Supervisor) - SVC_AI-Agent-Interactive.json with LangChain + PostgreSQL Memory
> - ✅ Finance Agent - PROJ_Finance-Intelligence-System.json
> - ✅ Inventory Agent - PROJ_Inventory Management.json
> - ✅ Training/Health Agent - PROJ_Training-Intelligence-System.json
> - ✅ Digital Twin API Agent - PROJ_Digital-Twin-API-Agent.json
> 
> **TODO: Complete n8n Service Documentation**
> - [x] **Missing 15 MD files** - All 38+ n8n services documented in `docs/50_Automations/n8n/services/` ✅ (Apr 10)
> 
> **TODO: Add Domain-Specific Tools to Each Agent**
> - [ ] **Domain Tool Assignment:** Add specialized tools to each AI agent based on their domain:
>   - [ ] **Finance Agent Tools:** budget queries, transaction search, expense categorization, savings rate calculation
>   - [ ] **Training Agent Tools:** workout logging, progression tracking, recovery analysis, measurement history
>   - [ ] **Inventory Agent Tools:** pantry CRUD, low-stock alerts, expiration tracking, shopping list generation
>   - [ ] **Scheduler/Productivity Agent Tools:** calendar CRUD, task management, focus mode control
>   - [ ] **Create Tool manifests** in n8n for each agent with specific capabilities
> 
> [!tip] 🚀 **Autonomy Enhancement (High Priority)**
- [x] **#3 Cross-Domain Auto-Pivot (G04-CAP):** Dynamic scheduling based on biological reality (e.g., HIT session logs → auto-pivot tomorrow to Recovery/Admin mode) ✅ (Apr 19)
- [ ] **#4 Context-Aware Notifications:** Only notify when out of norm or action needed (not fixed schedule).
- [ ] **#5 Memory Semantic Search:** Implement vector DB or embedding-based search across strategic_memory.

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

> [!tip] 🚀 **Infrastructure Deferred (Requires G11 Message Broker First)**
> - ⚠️ **GraphQL API:** Deferred to 2027 - depends on G11 Message Broker
> - ⚠️ **Vector DB:** Deferred to 2027 - depends on Message Broker infrastructure
> - ⚠️ **Agent-to-Agent Protocol:** Deferred to 2027 - depends on Message Broker

### Core Q4 Deliverables (Focus on Optimization)
- [ ] Implement "What-If" Life Simulator (Monte Carlo simulations for long-term goal impact)
- [ ] Achieve a comprehensive and real-time representation of the "autonomous living" ecosystem
- [ ] Finalize the integration of G04 as the central data hub for G12 (Meta-System)
- [ ] Document lessons learned and strategy for 2027 development
- [ ] Establish continuous validation and calibration mechanisms for the Digital Twin
- [ ] **System Optimization:** Focus on stability, performance, and autonomous operation of existing systems

## Dependencies
- **Systems:** S03 (Data Layer for persistence), S04 (Digital Twin for core logic), S08 (Automation Orchestrator for data processing workflows)
- **External:** Google Gemini API (for LLM interactions), various data source APIs
- **Other goals:** G01, G02 (Automationbro), G03, G05 (Finance), G06, G07, G08, G09, G10, G11 (all feed data into the Digital Twin), G12 (Meta-System for holistic view).
