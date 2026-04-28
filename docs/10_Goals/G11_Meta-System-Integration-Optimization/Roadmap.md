---
title: "G11: Roadmap"
type: "goal_roadmap"
status: "active"
owner: "Michał"
updated: "2026-04-23"
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
> - [x] **Unified Daily Intelligence View** - Integrated into Telegram via `G11_approval_prompter.py` (Mar 18)
> - [x] **Quick Wins Generation** - Unified execution zone in Daily Note (Mar 20)
> - [x] **Predictive "Ghost" Schema** - Track system forecasting accuracy ✅ (Mar 23)
> - [x] **Self-Healing Automation** - Unified approval loop for system issues (Mar 18)
> - [x] **Stale Task Archiver** - Weekly cleanup of overdue Google Tasks (enhanced Mar 20, auto-approve >30d Mar 26)
> - [x] **Agentic Approval Framework:** Transition from reporting to proactive "Ask & Act" via Telegram ✅ (Mar 25)
> - [x] **G11 Decision Intelligence:** Manual decision reasoning log and monthly cognitive pattern analysis ✅ (Mar 26)
> - [x] **Robust Sync Orchestration:** Producer/Consumer decoupling with retry-aware health sync ✅ (Mar 27)
> - [x] **Autonomy Promotion Agent:** Self-evolving system that upgrades policy levels based on trust thresholds ✅ (Mar 28)
> - [x] **Hidden Friction Discovery:** Statistical correlation engine identifying cross-domain lifestyle triggers ✅ (Mar 28)
> - [x] **Maintenance Triage:** Consolidated hardware/logistics alerts to Sunday Admin task ✅ (Mar 31)
> - [x] **Hygiene Agent:** Automated Google Tasks resolution based on DB state ✅ (Mar 31)
> - [x] **Failure Hardening (G11-FH):** Implemented proactive failure notifications for all G-scripts via Telegram ✅ (Apr 01)
> - [x] **Clutter-Free Intelligence (G11-CFI):** Developed a smart collapsible dashboard for the Daily Note (Apr 01)
> - [x] **Golden Mission Aggregator (G11-GMA):** Automated Top 5 mission ranking from multi-source triaged tasks ✅ (Apr 02)
> - [x] **Parallel Sync Orchestration (G11-PSO):** Refactored Daily Manager for concurrent execution (ThreadPool) ✅ (Apr 02)
> - [x] **Enterprise Recovery Shield (G11-ERS):** Verified and encrypted database backup pipeline ✅ (Apr 02)
> - [x] **Autonomous System Self-Healer (G11-ASH):** Automated retry and cleanup logic for failed syncs ✅ (Apr 02, Fix: Name mapping hardened Apr 09)
> - [x] **Zero-Friction Goal Recommender (G11-ZGR):** Automated data-driven Power Goal selection ✅ (Apr 02)
> - [x] **Logistics Enforcer (G11-LE):** Interactive Telegram prompts for overdue items (Done/Snooze) ✅ (Apr 03)
- [x] **Complete n8n Service Documentation:** Documented all 38+ n8n automation services in G12 ✅ (Apr 15)
> - [x] **Schedule Master List:** Created `SCHEDULE_All-Workflows.md` tracking all workflow trigger times ✅ (Apr 10)
> - [x] **Bio-Feedback Load Balancer (G10-BFLB):** Autonomous schedule pivoting based on readiness ✅ (Apr 03)
> - [x] **Pre-emptive Financial Rebalancer (G05-PFR):** Automated budget reallocations based on friction forecasts ✅ (Apr 03)
- [x] **System Startup Probe Resilience:** Hardened service discovery for varied container naming ✅ (Apr 27)
- [x] **Approval Noise Reduction:** Silenced stale task requests for < 30 days overdue ✅ (Apr 27)
- [x] **Biometric Sanity Guard:** Prevented sensor glitches from polluting health context ✅ (Apr 27)
- [x] **Net Worth Automation:** Month-end financial snapshot and FIRE calculation automated ✅ (Apr 27)

> [!tip] 🚀 **NEW: Recurring Friction & Failure Intelligence**
> **Gap:** G11 needs systematic failure logging for true self-healing and proactive maintenance.
- [x] **Friction Log System:** Capture repeated frustrations automatically (Implemented via G11_friction_harvester.py) ✅ (Apr 24)
  - [x] **Sub-task: Manual Friction Prompt** - Daily: "What frustrated you today?" (Obsidian Frontmatter sync established) ✅ (Apr 24)
  - [x] **Sub-task: Cross-Repo Link Standard:** Propose a standard for linking from Obsidian to the docs/ folder that works across both the filesystem and the web. ✅ (Apr 23 - Root Symlinking Strategy)
  - [ ] **Sub-task: Auto-Capture** - System failures logged automatically (already in G11-FH)
  - [ ] **Sub-task: Pattern Detection** - Identify recurring friction themes
- [ ] **Failure Knowledge Base:** Build resolution database
  - [ ] **Sub-task: Error → Resolution Mapping** - Store how each failure was fixed
  - [ ] **Sub-task: Prevention Triggers** - "If X fails, try Y before alerting user"
  - [ ] **Sub-task: Time Lost Tracking** - Quantify impact of system issues
- [ ] **Proactive Bottleneck Detection:** Prevent issues before they happen
  - [ ] **Sub-task: Resource Monitoring** - Track CPU/memory/disk trends
  - [ ] **Sub-task: Predictive Alerts** - "Disk will be full in 3 days"
  - [ ] **Sub-task: Maintenance Scheduling** - Auto-schedule maintenance windows
- [x] **Unified Daily Intelligence View** - Integrated into Telegram via `G11_approval_prompter.py` (Mar 18)
- [x] **Quick Wins Generation** - Unified execution zone in Daily Note (Mar 20)
- [x] **Predictive "Ghost" Schema** - Track system forecasting accuracy ✅ (Mar 23)
- [x] **Self-Healing Automation** - Unified approval loop for system issues (Mar 18)
- [x] **Stale Task Archiver** - Weekly cleanup of overdue Google Tasks (enhanced Mar 20, auto-approve >30d Mar 26)
- [x] **Agentic Approval Framework:** Transition from reporting to proactive "Ask & Act" via Telegram ✅ (Mar 25)
- [x] **G11 Decision Intelligence:** Manual decision reasoning log and monthly cognitive pattern analysis ✅ (Mar 26)
- [x] **Robust Sync Orchestration:** Producer/Consumer decoupling with retry-aware health sync ✅ (Mar 27)
- [x] **Autonomy Promotion Agent:** Self-evolving system that upgrades policy levels based on trust thresholds ✅ (Mar 28)
- [x] **Hidden Friction Discovery:** Statistical correlation engine identifying cross-domain lifestyle triggers ✅ (Mar 28)
- [x] **Maintenance Triage:** Consolidated hardware/logistics alerts to Sunday Admin task ✅ (Mar 31)
- [x] **Hygiene Agent:** Automated Google Tasks resolution based on DB state ✅ (Mar 31)
- [x] **Failure Hardening (G11-FH):** Implemented proactive failure notifications for all G-scripts via Telegram ✅ (Apr 01)
- [x] **Clutter-Free Intelligence (G11-CFI):** Developed a smart collapsible dashboard for the Daily Note (Apr 01)
- [x] **Golden Mission Aggregator (G11-GMA):** Automated Top 5 mission ranking from multi-source triaged tasks ✅ (Apr 02)
- [x] **Parallel Sync Orchestration (G11-PSO):** Refactored Daily Manager for concurrent execution (ThreadPool) ✅ (Apr 02)
- [x] **Enterprise Recovery Shield (G11-ERS):** Verified and encrypted database backup pipeline ✅ (Apr 02)
- [x] **Autonomous System Self-Healer (G11-ASH):** Automated retry and cleanup logic for failed syncs ✅ (Apr 02, Fix: Name mapping hardened Apr 09)
- [x] **Zero-Friction Goal Recommender (G11-ZGR):** Automated data-driven Power Goal selection ✅ (Apr 02)
- [x] **Logistics Enforcer (G11-LE):** Interactive Telegram prompts for overdue items (Done/Snooze) ✅ (Apr 03)
- [x] **Complete n8n Service Documentation:** Documented all 38+ n8n automation services in G12 ✅ (Apr 15)
- [x] **Schedule Master List:** Created `SCHEDULE_All-Workflows.md` tracking all workflow trigger times ✅ (Apr 10)
- [x] **Bio-Feedback Load Balancer (G10-BFLB):** Autonomous schedule pivoting based on readiness ✅ (Apr 03)
- [x] **Pre-emptive Financial Rebalancer (G05-PFR):** Automated budget reallocations based on friction forecasts ✅ (Apr 03)
- [x] **System Startup Probe Resilience:** Hardened service discovery for varied container naming ✅ (Apr 27)
- [x] **Approval Noise Reduction:** Silenced stale task requests for < 30 days overdue ✅ (Apr 27)
- [x] **Biometric Sanity Guard:** Prevented sensor glitches from polluting health context ✅ (Apr 27)
- [x] **Net Worth Automation:** Month-end financial snapshot and FIRE calculation automated ✅ (Apr 27)
- [x] **Reliability Hardening (G11-RH):** Implemented strict biometric freshness gating and n8n orchestration migration ✅ (Apr 16)
- [x] **API Architectural Cleanup (G11-AAC):** Resolved port conflicts and consolidated Digital Twin endpoints ✅ (Apr 16)
- [x] **Docker Infrastructure Hardening:** Refactored volume path calculation in core engines (`G04`, `G12`) to eliminate absolute host path dependencies. Improved container-local path resilience. ✅ (Apr 25)

> [!danger] 🛡️ **System Security Hardening (G11-SSH)**
> **Gap:** Critical vulnerabilities identified in database access (root user), API exposure (no auth), and container permissions.
- [ ] **API Security Migration:**
  - [x] **Phase 1: Permissive Logging** - Implement `X-API-KEY` logic that logs missing keys without blocking requests. ✅ (Apr 22)
  - [ ] **Phase 2: Node Identification** - Audit logs to identify and update all n8n/script callers with the new key.
  - [ ] **Phase 3: Full Enforcement** - Reject all requests missing a valid `X-API-KEY`.
- [x] **DB Least Privilege (RBAC):** Migrated entire stack from `root` to service-specific restricted users. ✅ (Apr 22)
- [x] **Container Hardening:** Updated Dockerfiles and Compose to run all core services as non-privileged users (`UID 1000`). ✅ (Apr 22)
- [ ] **Credential Rotation:** System-wide rotation of DB passwords and n8n encryption keys.

> [!tip] 🌍 **Global Language Agnostic Layer (Translation Gate)**
> **Gap:** Multi-language inputs (PL/EN) complicate regex and tool-calling accuracy.
- [ ] **Phase 1: Translation Ingestion** - Implement front-door translation to Standardized English for all incoming queries.
- [ ] **Phase 2: Intent Simplification** - Refactor AgentZero and scripts to use English-only keyword/intent detection (removing Polish regex).
- [ ] **Phase 3: Bidi-Response Engine** - Ensure system detects input language and translates English internal logic back to User's language for responses.

> [!tip] 🚀 **Infrastructure Restructure (Multi-User Package) - [IMPL_Infrastructure_Consolidation.md](IMPL_Infrastructure_Consolidation.md)**
- [x] **Unified docker-compose:** Create single docker-compose.yml combining all services from scattered locations ✅ (Apr 27)
  - [x] **Sub-task: Merge** - Combine grafana/, local-ai-packaged/, infrastructure/docker-compose.yml ✅ (Apr 27)
  - [ ] **Sub-task: Consolidate exporters** - g01 + goals → metrics-exporter (port 8081)
  - [ ] **Sub-task: Add profiles** - CPU/GPU for Ollama, optional for Obsidian
  - [x] **Sub-task: Refactor volumes** - Move absolute paths (e.g. /home/{{USER}}/...) to relative or standard container paths ✅ (Apr 27)
  - [ ] **Sub-task: Dockerfile Hardening** - Add .dockerignore and optimize G04/metrics images to exclude secrets
- [x] **Weekly Note Generator:** Create a script to "touch" the missing weekly notes based on the template to resolve the 700+ broken Wikilinks. ✅ (Apr 27 - G12_weekly_note_backfiller.py)
- [ ] **Folder structure documentation:** Create docs/FOLDER_STRUCTURE.md defining spawnable structure
- [ ] **Spawn procedure:** Create SPAWN.md documentation for duplicating to new users
- [ ] **Environment template:** Create .env.example with all configurable variables
- [ ] **Test package spawn:** Verify new instance spawns correctly

- **Architecture Principle:** All device control stays in Home Assistant. System provides intelligence, recommendations, and triggers HA webhooks when needed.

- [x] **Data Intelligence:** Deploy `v_unified_daily_intelligence` materialized view for cross-domain health analysis.
- [x] **CEO Weekly Briefing:** Unified executive summary via Telegram (enhanced Mar 26 with full data aggregation)
- [x] **Monthly Progress Summary** - Automated G01 reporter added to sync (Mar 20)
- [x] **ROI Dashboard:** Quantify time saved vs. time invested analysis ✅ (Mar 08 - Autonomy ROI Tracker deployed)
- [x] **Self-Healing Supervisor:** Proctor script that monitors system health and generates LLM fix prompts ✅ (Mar 06)

## Q3 (Jul–Sep) - Phase: The Enterprise Nervous System

> [!tip] 🚀 **Q3 Focus: Cognitive & Self-Healing Intelligence**
- [ ] **Friction & Failure Intelligence (G11-FFI):** Build a resolution database mapping recurring errors to successful fixes via `/ouch` (friction) log.
- [ ] **Decision Pattern Intelligence (G11-DPI):** Implement outcome tracking and "Post-Decision Audits" to advise future actions based on historical success.
- [ ] **Real-Time Data Pipeline:** Replace polling with event-driven data sync
>   - [ ] **Sub-task: Change Data Capture** - Implement CDC from PostgreSQL (Debezium or custom)
>   - [ ] **Sub-task: Stream Processing** - Set up data streaming for real-time dashboards
>   - [ ] **Sub-task: Materialized Views** - Create refreshed-on-change views for cross-domain queries
> - [ ] **Enhanced Cross-Domain Analytics:** Strengthen the unified daily intelligence view
>   - [ ] **Sub-task: Data Join Optimization** - Optimize `v_unified_daily_intelligence` for faster queries
>   - [ ] **Sub-task: New Correlations** - Add finance ↔ productivity, health ↔ productivity correlations

> [!tip] 🚀 **NEW: Cognitive & Decision Pattern Intelligence**
> **Gap:** G11 Decision Intelligence needs historical data to advise "based on similar past decisions."
- [ ] **Decision Log Enhancement:** Build decision history
  - [ ] **Sub-task: Decision Template** - Structured capture: What, Why, Constraints, Outcome
  - [ ] **Sub-task: Outcome Follow-up** - Prompt: "Did the decision work? 1-10"
  - [ ] **Sub-task: Context Linking** - Connect decisions to goals/situations
- [ ] **Cognitive Pattern Analysis:** Identify decision-making biases
  - [ ] **Sub-task: Bias Detection** - Flag recency bias, loss aversion, etc.
  - [ ] **Sub-task: Decision Speed Tracking** - Time-to-decision vs. quality
  - [ ] **Sub-task: Reversal Rate** - Track decisions that were undone
- [ ] **Predictive Decision Advisor:** AI-powered recommendations
  - [ ] **Sub-task: Similar Past Decision Lookup** - "Similar decision: X, outcome was Y"
  - [ ] **Sub-task: Decision Confidence Score** - AI rates confidence in recommendation
  - [ ] **Sub-task: Learning Loop** - Track if user followed AI advice, outcome comparison
- [ ] **Real-Time Data Pipeline:** Replace polling with event-driven data sync
  - [ ] **Sub-task: Change Data Capture** - Implement CDC from PostgreSQL (Debezium or custom)
  - [ ] **Sub-task: Stream Processing** - Set up data streaming for real-time dashboards
  - [ ] **Sub-task: Materialized Views** - Create refreshed-on-change views for cross-domain queries
- [ ] **Enhanced Cross-Domain Analytics:** Strengthen the unified daily intelligence view
  - [ ] **Sub-task: Data Join Optimization** - Optimize `v_unified_daily_intelligence` for faster queries
  - [ ] **Sub-task: New Correlations** - Add finance ↔ productivity, health ↔ productivity correlations

> [!tip] 🚀 **Core Infrastructure Deferred to Q4**
> - ⚠️ **Message Broker:** Deferred to Q4 - requires more system stability first
> - ⚠️ **GraphQL API:** Deferred to Q4 - requires Message Broker foundation
> - ⚠️ **Infrastructure-as-Code:** Deferred to Q4
> - ⚠️ **Secret Management:** Deferred to Q4

- [ ] **Automated Load Balancing** and failover for high-availability Digital Twin
- [ ] **AI-driven autonomous decision-making** across integrated systems

## Q4 (Oct–Dec) - Phase: The Autonomous Director

> [!tip] 🚀 **Infrastructure Phase (Event-Driven Architecture)**
- [ ] **Message Broker (RabbitMQ)** for true Event-Driven responses
  - [ ] **Sub-task: Broker Setup** - Deploy RabbitMQ in Docker
  - [ ] **Sub-task: n8n Integration** - Configure n8n to consume events from message broker
  - [ ] **Sub-task: Digital Twin Events** - Emit events from Python scripts to broker
  - [ ] **Sub-task: Event Schema** - Define event format (JSON with domain, action, payload)
- [ ] **Unified Data API (GraphQL)** to replace domain-specific REST calls
  - [ ] **Sub-task: Schema Definition** - Create unified GraphQL schema across all databases
  - [ ] **Sub-task: GraphQL Server** - Deploy via FastAPI/Strawberry
  - [ ] **Sub-task: Migration Path** - Update n8n workflows to use GraphQL progressively
- [ ] **Infrastructure-as-Code (Ansible/Terraform)** for system recoverability
  - [ ] **Sub-task: Inventory** - Document all services requiring IaC
  - [ ] **Sub-task: Ansible Playbooks** - Create playbooks for Docker stack deployment
  - [ ] **Sub-task: Recovery Testing** - Validate restore from code on clean system
- [ ] **Centralized Secret Management (Vault)** to eliminate .env risks
  - [ ] **Sub-task: Vault Setup** - Deploy HashiCorp Vault (or bitwarden_rs for simpler alternative)
  - [ ] **Sub-task: Secret Migration** - Move API keys from .env to Vault
  - [ ] **Sub-task: n8n Integration** - Configure n8n to read secrets from Vault

> [!tip] 🚀 **Full Autonomy Implementation**
- [ ] **Strategic "CEO" Reallocation Engine** (Autonomous goal conflict resolution)
  - [ ] **Sub-task: Conflict Detection** - Identify when goals compete for resources (time/money)
  - [ ] **Sub-task: Decision Matrix** - Implement weighted scoring for resource allocation
  - [ ] **Sub-task: Autonomous Execution** - Auto-adjust schedules/budgets based on priority
- [ ] **Priority Matrix:** Weighted objective function to reallocate Time/Money across systems
- [ ] **Full Meta-System:** Complete ecosystem optimization with automated improvements
- [ ] **Predictive maintenance** for all automation systems
- [ ] **Finalize "Personal OS"** experience with intuitive controls and assistants
- [ ] **Document advanced enterprise methodology** ready for consulting
- [ ] **Comprehensive security and resilience audit** of the entire ecosystem

## Dependencies
- **Systems:** S01 (Observability), S03 (Data Layer), S04 (Digital Twin), S08 (Automation Orchestrator)
- **External:** All other goals (G01-G11) for data sources and functional components.
- **Other goals:** G09 (Complete Process Documentation) for documenting Meta-System architecture and processes. All other goals are feeders/consumers of G12.
G12.
