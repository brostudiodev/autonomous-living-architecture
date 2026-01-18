# Agent Instructions – autonomous-living

## 1. Purpose of This Repository

This repo is the **technical and system-design backbone** of my Automation-First Living vision.

It contains:
- Architecture, workflows, and automations that implement my 12 Power Goals
- Configuration, scripts, and integrations for homelab, smart home, finance, health, and career systems
- Documentation that could eventually be reused as **consulting methodology** for enterprises

North Star:
> By the end of 2026, my daily life is run by interconnected, self-monitoring systems that minimize manual, repetitive work and maximize time for strategy, design, relationships, and teaching.

## 2. 12 Power Goals (System Targets)

1. Reach Target Body Fat (Workout)
2. Be Recognizable Automationbro (Automation / Brand)
3. Autonomous Household Operations System (Home Ops)
4. Digital Twin Ecosystem – Virtual Assistant (AI)
5. Autonomous Financial Command Center (Finance)
6. Pass Certification Exams (Learning)
7. Predictive Health Management & Performance Optimization System
8. Predictive Smart Home Orchestration
9. Automated Career Intelligence & Positioning System
10. Intelligent Productivity & Time Architecture System
11. Meta-System Integration & Continuous Optimization Engine
12. Complete Process Documentation

This repo implements **systems and automations** that move these from “idea” to “running infra”.

## 3. Repository Structure (To Be Kept Consistent)

> Adjust as needed, but keep the intent.

- `/docs/`
  - High-level architecture
  - Per-goal system design (`docs/goals/01-body-fat.md`, etc.)
  - How-to guides for operating the system
- `/infra/`
  - Homelab setup (Docker, Kubernetes, Proxmox, etc.)
  - Monitoring & logging stack
- `/automations/`
  - Individual workflows (Python scripts, RPA, Node-RED, Home Assistant automations, etc.)
  - Grouped by domain: `finance/`, `home/`, `health/`, `career/`, `meta/`
- `/integrations/`
  - Connectors to external systems (APIs, SAP, banks, fitness trackers, etc.)
- `/meta-system/`
  - Orchestration logic for **Goal 11** (Meta-System)
  - Schedulers, rules engines, evaluation scripts
- `/experiments/`
  - Prototypes, PoCs, and experimental automations
- `/tests/`
  - Automated tests for critical workflows

## 4. Coding & Design Guidelines

- Languages/tools: follow existing patterns in the repo (likely Python, .NET, RPA tools, Home Assistant, etc.)
- Priorities:
  - Reliability over cleverness
  - Observability: logs, metrics, and alerts are **mandatory** for critical flows
  - Idempotence: automations should be safe to re-run

**Error handling:**
- Anticipate failures in external systems (APIs, hardware, networks).
- Fail safely: no silent data corruption, no infinite loops.
- Log with enough context to debug, but **no secrets**.

**Testing:**
- For any automation that runs regularly or affects finances/health, add:
  - At least a smoke test
  - Clear manual test procedure in `/docs/`

## 5. Automation Philosophy

- Use the **ROI rule**: if building + maintaining an automation will cost more time than manual execution over one year, deprioritize it.
- Prefer **end-to-end working slices** over large unfinished frameworks.
- Every system should implement:
  - **Input → Processing → Output → Monitoring → Documentation**

For each Power Goal, aim for at least:
- A **v1 architecture doc** under `/docs/goals/`
- One or more **concrete workflows** in `/automations/`
- A minimal **monitoring & review loop**

## 6. Meta-System & Data Flow (Goals 4, 5, 10, 11, 12)

- **Goal 4 (Digital Twin)**: central data model for “Michał and his systems.”
  - Implements:
    - unified data schemas,
    - state tracking,
    - behavioral and event logs.
- **Goal 5 (Finance)**:
  - Aggregates financial data from bank APIs, expense trackers, subscriptions, etc.
  - Outputs:
    - budgets,
    - alerts,
    - optimization suggestions.
- **Goal 10 (Productivity)**:
  - Pulls tasks/projects from second brain and tools (e.g., calendars, task managers).
  - Allocates time and focus to Power Goals based on rules.
- **Goal 11 (Meta-System)**:
  - Orchestrates:
    - what should run,
    - how often,
    - with what thresholds.
  - Consumes metrics from all systems and adjusts configurations.
- **Goal 12 (Documentation)**:
  - Ensures every running system has:
    - a doc page,
    - a quickstart / runbook,
    - failure modes and recovery procedures.

When editing or adding new automations, always think:
> “How does this plug into Digital Twin (4), Finance (5), Productivity (10), Meta-System (11), and Docs (12)?”

## 7. Constraints & Safety

- Never commit:
  - API keys
  - passwords
  - tokens
  - raw personal identifiers beyond what’s already in the repo.

Use:
- `.env` files
- secrets managers (Vault, 1Password, etc.)
- configuration templates with placeholders.

For anything that touches:
- **Health** (Goal 7, body metrics)
- **Money** (Goal 5)
use **extra caution**:
- dry-run mode where possible
- clear logs
- manual confirmation on dangerous actions (e.g., transfers).

## 8. How the AI Agent Should Work in This Repo

- Before large changes:
  - Propose an architecture or plan in `/docs/` first.
- Prefer incremental PR-style changes:
  - small, testable commits
  - clear descriptions of impact
- When asked to “build X system”:
  1. Clarify which **Power Goal(s)** it supports.
  2. Draft a short design doc under `docs/goals/`.
  3. Implement minimal viable automation in `/automations/`.
  4. Add monitoring/logging.
  5. Update related documentation (Goal 12).

If unsure about:
- where something belongs,
- how it should be integrated,
then **ask for clarification** or propose 2–3 simple options.

## 9. Interaction Style

- Keep recommendations realistic for:
  - ~20 hours/week system-building capacity,
  - a full-time job,
  - homelab maintenance.
- Challenge overly complex architectures that:
  - add more maintenance than value,
  - are likely to stay unfinished.

Default stance: **pragmatic automation architect**, not academic perfectionist.

End of instructions.