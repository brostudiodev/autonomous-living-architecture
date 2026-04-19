---
title: "Knowledge Intelligence System (G12)"
type: "automation_spec"
status: "active"
automation_id: "PROJ_Knowledge-Intelligence-System"
goal_id: "goal-g12"
systems: ["S04", "S12"]
owner: "Michal"
updated: "2026-04-13"
---

# Purpose
The **Knowledge Intelligence System** is an autonomous n8n agent designed to manage and retrieve information from Michal's Second Brain (Obsidian Vault and PostgreSQL activity logs). It bridges the gap between raw documentation and actionable insights, ensuring that system architecture, SOPs, and historical decisions are always accessible.

# Scope
- **In Scope:** Searching Obsidian Vault content, reporting documentation activity logs, monitoring vault health (stale notes, empty files), and providing technical context to Agent Zero.
- **Out Scope:** Modifying core application code (scripts), managing external cloud storage (outside of Drive backups), and non-technical personal notes.

# Inputs/Outputs
- **Inputs:** 
    - Natural language queries from Telegram/Agent Zero (via `ROUTER_Intelligent_Hub`).
    - `system_activity_log` from PostgreSQL (`digital_twin_michal`).
    - Vault statistics from PostgreSQL.
- **Outputs:** 
    - Formatted Markdown responses with documentation links, snippets, and vault stats.
    - Success/Failure signals to the system activity log.
    - Email alerts via Gmail if data retrieval fails.

# Architecture: "The Knowledge Brain"
The workflow follows a linear intelligence pipeline:
1.  **Trigger:** `When Executed by Router` (workflow trigger).
2.  **Normalization:** `Normalize Input` (JS Code) cleanses query, session ID, and user context.
3.  **Data Ingestion:**
    - `PostgreSQL: Get Vault Stats`: Fetches 7-day operation counts and last activity.
    - `PostgreSQL: Get Recent Activity`: Fetches the last 20 G11/G12 logs.
4.  **Merging:** `Merge: Knowledge Data` combines stats and logs into a single data stream.
5.  **Validation:** `IF: Has Knowledge Data?` checks for successful DB retrieval.
    - *Fallback:* `Gmail: No Data Alert` + `Handle No Data` (Error response).
6.  **Context Construction:** `Build AI Context` (JS Code) wraps raw data in `<knowledge_context>` XML tags for the LLM.
7.  **Intelligence Layer:** `Knowledge AI Agent` (LangChain) orchestrates the response using **Google Gemini**.
8.  **Output Formatting:** `Format Response` + `Return to Router` (JS Code) packages the final answer.

# Dependencies
- **Systems:** [S04 Digital Twin](../../20_Systems/S04_Digital-Twin/README.md), [S12 Complete Process Documentation](../../20_Systems/S12_Complete-Process-Documentation/README.md)
- **AI Model:** Google Gemini (via `googlePalmApi` credentials).
- **Tools:** 
    - `VaultSearch`: n8n Workflow tool for deep vault searches.
    - `DiscoverCapabilities`: HTTP tool (GET) for discovering `G11_*/G12_*` scripts.
    - `ExecuteTool`: HTTP tool (POST) for running discovered scripts.
- **Infrastructure:** n8n, PostgreSQL ({{INTERNAL_IP}}), Google Gemini API.

# Procedure
- **Trigger:** Automatic via the Intelligent Hub when keywords related to "knowledge", "vault", "docs", or "G12" are detected.
- **Agent Rules:**
    - **Language:** Responds in the same language as the user (PL/EN).
    - **Tooling:** Must call `DiscoverCapabilities` before `ExecuteTool`.
    - **Scope:** Restricted to executing tool IDs starting with `G11_` or `G12_`.

# Failure Modes
| Scenario | Detection | Response |
|----------|-----------|----------|
| DB Connection Loss | "relation does not exist" or timeout | `IF` node routes to `Gmail Alert`; returns "cannot retrieve data" to user. |
| Gemini 400 Error | empty key in function_declarations | Fix: `sendHeaders` removed from HTTP tools in build 0007. |
| No Knowledge Found | LLM determines search returned empty | LLM suggests alternative documentation or GDS audit. |

# Security Notes
- **Access Control:** Restricted to the `meta` and `documentation` domains in the tool manifest.
- **Secret Management:** PostgreSQL credentials managed via n8n `postgres` account (id: `QfdnaC6sZDNbgpsT`).
- **Data Privacy:** Sensitive data placeholders used in responses; raw DB credentials never exposed in agent context.

# Owner + Review Cadence
- **Owner:** Michal
- **Review:** Weekly (verify search accuracy and documentation coverage via `G12_documentation_audit.py`)
