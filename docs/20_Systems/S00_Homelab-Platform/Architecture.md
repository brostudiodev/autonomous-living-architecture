---
title: "S00: Homelab Architecture"
type: "architecture"
status: "active"
owner: "Michał"
updated: "2026-04-22"
---

# Homelab Architecture (Autonomous Living)

## Goals
- **Reliable hosting** for automations and AI services.
- **Easy recovery** (Enterprise Recovery Shield protocol).
- **Observability-first** (Unified Health Dashboards).
- **Zero-Trust & Shield Mode** (PostgreSQL RBAC + API Keys).

## Core Security Layers (Shield Mode)

### 1. Data Layer Hardening
- **RBAC Enforcement:** Superuser (`root`) is restricted to administrative tasks. Services use restricted users (`dt_api_agent`, `dt_n8n_orchestrator`, etc.) inheriting `role_archivist` or `role_brain`.
- **Inheritance Logic:** All service users use the `INHERIT` attribute to automatically receive permissions from functional roles.

### 2. API Security Migration
- **X-API-KEY Protocol:** All internal and external API calls to `G04_digital_twin_api` require a valid `X-API-KEY` header (Phase 1 active).
- **Refer:** [API-Security-Migration-Runbook.md](../../40_Runbooks/G11/API-Security-Migration-Runbook.md)

### 3. Container Integrity
- **Non-Root Runtime:** Core containers (`digital-twin-api`, `n8n`, `postgres`, `grafana`) run as non-privileged users (UID 1000/999).
- **Volume Synchronization:** Host volumes are synchronized to container UIDs via the [Infrastructure-Hardening-Recovery-Runbook.md](../../40_Runbooks/G11/Infrastructure-Hardening-Recovery-Runbook.md).

## Infrastructure Components

| Layer | System | Details |
| :--- | :--- | :--- |
| **Orchestration** | Docker Compose | Centralized multi-container management. |
| **Intelligence** | Python 3.11+ | G-series script execution and Digital Twin Engine. |
| **Workflow** | n8n | Long-running automation sequences and triggers. |
| **Storage** | PostgreSQL 16 | Relational multi-domain data store (TimescaleDB aware). |
| **Connectivity** | zrok.io | Secure, public-facing shares for Telegram/Webhooks. |
| **Monitoring** | Grafana / Prometheus | System-wide reliability and goal tracking. |

## Threat Model (Shielded)
- **External exposure** is mitigated by `zrok` tunnels and `X-API-KEY` enforcement.
- **Privilege Escalation** is blocked by PostgreSQL RBAC.
- **Data Loss** is mitigated by the `G11_db_recovery_shield` and volume chown protocols.

---
*Last Architectural Audit: 2026-04-22*
