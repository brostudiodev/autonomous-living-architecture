---
title: "G11: Roadmap"
type: "goal_roadmap"
status: "active"
owner: "Michał"
updated: "2026-05-13"
goal_id: "goal-g11"
---

# Roadmap (2026)

## Q1 (Jan–Mar)
- [x] Define Meta-System architecture and core data integration patterns ✅ (Feb 20)
- [x] Conduct a detailed review of `docs/20_Systems/S04_Digital-Twin/` and `docs/20_Systems/S08_Automation-Orchestrator/` to understand their current design and intended integration points. ✅ (Feb 27)
- [x] Systematically map inputs and outputs for all goals (G01-G11) ✅ (Implemented via G11_meta_mapper.py)
- [x] Begin defining a high-level unified data schema for S03 Data Layer that can accommodate data from diverse goals. ✅ (Feb 27 - [Unified-Schema.md](../../20_Systems/S03_Data-Layer/Unified-Schema.md))
- [x] Prototype a basic Meta-System dashboard in S01 (Observability) to display aggregated KPIs from at least two integrated goals ✅ (Connectivity Matrix deployed)
- [x] Document identified correlations and dependencies between the goals to inform future optimization strategies (In Progress: Technical Matrix v1.0)
- [x] **Level 5 Autonomy Elevation:** auto_account_rebalance and auto_procurement now FULL authority ✅ (Mar 27)
- [x] **Bulk Approval Authority:** Launch /approve_all Telegram command ✅ (Mar 27)

## Q2 (Apr–Jun)

> [!tip] 🚀 **High-Impact Autonomy Tasks**
- [x] **Autonomous System Self-Healer (G11-ASH):** Automated retry and cleanup logic for failed syncs ✅ (Apr 02, Fix: Name mapping hardened Apr 09, Docker/Permission Fixes May 06)
- [x] **Zero-Friction Goal Recommender (G11-ZGR):** Automated data-driven Power Goal selection ✅ (Apr 02)
- [x] **Logistics Enforcer (G11-LE):** Interactive Telegram prompts for overdue items (Done/Snooze) ✅ (Apr 03)
- [x] **Complete n8n Service Documentation:** Documented all 38+ n8n automation services in G12 ✅ (Apr 15)
- [x] **Schedule Master List:** Created `SCHEDULE_All-Workflows.md` tracking all workflow trigger times ✅ (Apr 10)
- [x] **Bio-Feedback Load Balancer (G10-BFLB):** Autonomous schedule pivoting based on readiness ✅ (Apr 03)
- [x] **Pre-emptive Financial Rebalancer (G05-PFR):** Automated budget reallocations based on friction forecasts ✅ (Apr 03)
- [x] **System Startup Probe Resilience:** Hardened service discovery for varied container naming ✅ (Apr 27)
- [x] **Approval Noise Reduction:** Silenced stale task requests for < 30 days overdue ✅ (Apr 27)
- [x] **Task Triage Hardening:** Aggressive noise reduction (>14d) with Goal/Commitment protection ✅ (May 06)
- [x] **Instant Self-Healing Loop:** Integrated script failure events with targeted supervisor repair. ✅ (May 01)
- [x] **High-Level Event Emission:** Upgraded core sync scripts (Health, Finance, Pantry, Weight, Brand, Learning) to broadcast completion. ✅ (May 21)
- [x] **Biometric Sanity Guard:** Prevented sensor glitches from polluting health context ✅ (Apr 27)
- [x] **Net Worth Automation:** Month-end financial snapshot and FIRE calculation automated ✅ (Apr 27)

> [!danger] 🚀 **NEW: Event-Driven Architecture Acceleration (EDA)**
- [x] **Message Broker (RabbitMQ) Deployment:** ✅ (May 01)
  - [x] **Sub-task: Broker Setup** - Deploy RabbitMQ with Management UI in Docker ✅ (May 01)
  - [x] **Sub-task: n8n Integration** - Configure n8n RabbitMQ Trigger nodes ✅ (May 01)
  - [x] **Sub-task: LifeEvent Schema** - Define standardized JSON format (Source, Domain, Severity, Payload) ✅ (May 01)
  - [x] **Sub-task: Twin Event Emitter** - Update core scripts and API to emit events on state change ✅ (May 05)

> [!tip] 🚀 **NEW: Recurring Friction & Failure Intelligence**
- [x] **Friction Log System:** Capture repeated frustrations automatically (Implemented via G11_friction_harvester.py) ✅ (Apr 24)
  - [x] **Sub-task: Manual Friction Prompt** - Daily: "What frustrated you today?" (Obsidian Frontmatter sync established) ✅ (Apr 24)
  - [x] **Sub-task: Cross-Repo Link Standard:** Root Symlinking Strategy ✅ (Apr 23)
  - [x] **Sub-task: Auto-Capture** - System failures logged automatically (already in G11-FH) ✅
  - [x] **Sub-task: Pattern Detection** - Identify recurring friction themes via G11_lifestyle_auditor.py ✅
- [x] **Failure Knowledge Base:** Build resolution database ✅ (May 03)
  - [x] **Sub-task: Error → Resolution Mapping** - Store how each failure was fixed via failure_resolutions table ✅
  - [x] **Sub-task: Prevention Triggers** - "If X fails, try Y before alerting user" ✅
- [x] **Reliability Hardening (G11-RH):** Implemented biometric freshness gating and n8n orchestration ✅ (Apr 16)
- [x] **API Architectural Cleanup (G11-AAC):** Resolved port conflicts and consolidated Digital Twin endpoints ✅ (Apr 16)
- [x] **Docker Infrastructure Hardening:** Refactored volume paths to eliminate absolute host dependencies ✅ (Apr 25)

> [!danger] 🛡️ **System Security Hardening (G11-SSH)**
- [ ] **API Security Migration:**
  - [x] **Phase 1: Permissive Logging** - Implement `X-API-KEY` logic ✅ (Apr 22)
  - [ ] **Phase 2: Node Identification** - Audit logs to identify callers
  - [ ] **Phase 3: Full Enforcement** - Reject requests without valid `X-API-KEY`
- [x] **DB Least Privilege (RBAC):** Migrated entire stack from `root` to service-specific restricted users ✅ (Apr 22)
- [x] **Container Hardening:** Updated core services to run as non-privileged users (`UID 1000`) ✅ (Apr 22)

> [!danger] 🛡️ **Infrastructure Hardening (Phase 5 - Post-Audit)**
- [x] **Global PgBouncer Migration:** Align Grafana, `db-event-bridge`, and monitoring exporters to use the PgBouncer pooler (Port 6432). ✅ (May 22)
- [ ] **DLX Queue Bindings:** Configure all core EDA queues to utilize the `life.events.dlx` Dead Letter Exchange for fault tolerance.
- [ ] **Infrastructure Backup Service:** Deploy a dedicated `db-backup` container in `docker-compose` for automated, non-kernel-dependent snapshots.
- [ ] **Centralized Log Aggregation:** Implement Grafana Loki to unify Python, n8n, and Docker logs into a single observability pane.

> [!tip] 🚀 **Infrastructure Restructure (Multi-User Package)**
- [x] **Unified docker-compose:** Created single docker-compose.yml combining all services ✅ (Apr 27)
- [x] **Weekly Note Generator:** Resolved 700+ broken Wikilinks via G12_weekly_note_backfiller.py ✅ (Apr 27)
- [x] **Folder structure documentation:** Created docs/FOLDER_STRUCTURE.md ✅ (May 06)
- [x] **Spawn procedure:** Created docs/SPAWN.md step-by-step spawn guide ✅ (May 06)
- [x] **Environment template:** Created .env.example with all required variables ✅ (May 06)

> [!danger] 🚀 **NEW: System Observability & Reliability Hardening**
- [x] **RabbitMQ Dead Letter Architecture:** Implemented DLX/DLQ to prevent silent event drops ✅ (May 12)
- [x] **Structured Logging Migration:** Refactor core scripts to JSON standard via `utils/structured_logger.py` ✅ (May 12)
  - [x] Phase 1: Core G11 Refactor - Listener, Emitter, and Startup Probe migrated ✅ (May 12)
  - [x] Phase 2: High-Frequency Syncs - Migrate G03, G05, and G07 primary sync scripts ✅ (May 12)
  - [x] Phase 3: System-Wide Decommissioning - Eliminate legacy `print()` in favor of `logger.info()` ✅ (May 12)
- [ ] **End-to-End Correlation Tracking:** Implement trace auditing across script execution boundaries

## Q3 (Jul–Sep) - Phase: The Enterprise Nervous System

> [!tip] 🚀 **Q3 Focus: Cognitive & Self-Healing Intelligence**
- [x] **Friction & Failure Intelligence (G11-FFI):** Build a resolution database mapping friction logs to fixes ✅ (May 06)
- [x] **Decision Pattern Intelligence (G11-DPI):** Implemented outcome tracking and structured Decision Logs (What/Why/Constraints) ✅ (May 22)
- [x] **Real-Time Data Pipeline Phase 1 (CDC):** Transition to True CDC (WAL Streaming) ✅ (May 07)
- [x] **2026-05-09 Update:** Decommissioned WAL Streaming in favor of robust **LISTEN/NOTIFY** triggers to remove plugin dependencies (wal2json) and improve reliability across all 8 DBs. ✅ (May 09)
  - [x] **Sub-task: Trigger Consolidation** - Deploy unified triggers to all domain databases. ✅ (May 09)
  - [x] **Sub-task: Bridge Refactor** - Update db-event-bridge to handle multi-threaded LISTEN sessions. ✅ (May 09)
- [x] **Decision Log Enhancement:** Structured capture: What, Why, Constraints, Outcome (Integrated into G11-DPI) ✅ (May 22)
- [ ] **Cognitive Pattern Analysis:** Identify decision-making biases (recency, loss aversion)
- [ ] **Enhanced Cross-Domain Analytics:** Strengthen the unified daily intelligence view

> [!construction] 🏗️ **Modular SDK & Module System (G11-MSM) - ACCELERATED TO Q2**
>
> **Objective:** Formalize the implicit SDK patterns into a clean `autonomous_sdk` package and migrate all legacy root scripts into domain modules.
>
> **Current Status:** [MODULAR_MIGRATION_STATUS.md](../../_meta/MODULAR_MIGRATION_STATUS.md)
>
> ### Phase 1-5: Infrastructure & Hardening ✅ (May 14)
> - [x] **Create `autonomous_sdk/` package** (Re-export layer for DB, Log, Event, CB)
> - [x] **Module Manifest Standard** (Pydantic validation + Discovery)
> - [x] **Orchestrator Modernization** (Registry-driven tiered execution)
> - [x] **Modular API** (Domain-based routers: `/api/v1/pantry`, etc.)
> - [x] **Module Generator** (Automated skeleton reification)
>
### Phase 6: Migration & Cleanup ✅ (May 15)
- [x] **Migrate G01 (Training)** - 10 scripts moved to module
- [x] **Migrate G03 (Pantry)** - 8 scripts moved to module
- [x] **Migrate G05 (Finance)** - 9 scripts moved to module
- [x] **Migrate G07 (Health)** - 6 scripts moved to module
- [x] **Migrate G10 (Productivity)** - 10 scripts moved to module
- [x] **Migrate remaining domains** (Career, Learning, Logistics, Home, Brand) ✅ (May 15)
- [x] **Full Domain Logic Exhaustion** (Migrate peripheral/secondary scripts for G03, G05, G07) ✅ (May 15)
- [x] **Finalize Proxy Layer** — move migrated files to modular directories and replace root scripts with lightweight proxies for 100% backward compatibility. ✅ (May 15)

> [!danger] 🚀 **NEW: Event-Driven Efficiency & Optimization (Q2 Final)**
>
> **Objective:** Transition to "Intelligence-as-a-Service" model. Offload all deterministic routing and recovery logic to System-Native Python, reserving n8n exclusively for LLM reasoning and Human-in-the-Loop interaction.
>
> - [ ] **Intelligence-as-a-Service (IaaS) Migration:**
>   - [x] **Sub-task: Native EDA Router** - Refactor `G11_event_listener.py` to handle all domain routing (`if health then...`) locally via `subprocess` or `module.sync()`. ✅ (May 21)
>   - [ ] **Sub-task: Tiered Self-Healing** - Implement "Strategy Patterns" in `G11_self_healing_logic.py`. Only call n8n `self-healing` webhook if local retry patterns fail 3x.
>   - [ ] **Sub-task: n8n De-Cluttering** - Decommission `Universal-Autonomy-Orchestrator` in favor of high-signal, targeted webhooks for **Decision Advisory** only.
>   - [ ] **Sub-task: Stability Audit** - Ensure all system-native APIs and connections are hardened for 100% uptime before offloading n8n crons.


## Q4 (Oct–Dec) - Phase: The Autonomous Director

> [!tip] 🚀 **Real-Time Data Pipeline Phase 2 (Hardening)**
- [ ] **Sub-task: LSN Resilience** - Implement Log Sequence Number tracking for zero-loss restarts
- [ ] **Sub-task: Legacy Cleanup** - Remove old PostgreSQL triggers to reduce DB overhead

> [!tip] 🚀 **Full Autonomy Implementation**
- [ ] **Strategic "CEO" Reallocation Engine:** Autonomous goal conflict resolution
- [ ] **Infrastructure-as-Code (Ansible/Terraform):** Standardize system recoverability
- [ ] **Unified Data API (GraphQL):** Replace domain-specific REST calls
- [ ] **Centralized Secret Management (Vault):** Eliminate .env risks
- [ ] **Level 5 Autonomy Expansion:** Scale automated decision logic to Career and Learning domains

## Dependencies
- **Systems:** S01 (Observability), S03 (Data Layer), S04 (Digital Twin), S08 (Automation Orchestrator)
- **External:** All other goals (G01-G11) for data sources and functional components.
- **Other goals:** G09 (Complete Process Documentation) for documenting Meta-System architecture and processes. All other goals are feeders/consumers of G12.
