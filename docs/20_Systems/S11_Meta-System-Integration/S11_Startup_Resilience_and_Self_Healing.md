---
title: "S11: Startup Resilience and Self-Healing"
type: "architecture"
status: "active"
system_id: "system-s11-resilience"
owner: "Michał"
updated: "2026-04-18"
---

# S11: Startup Resilience and Self-Healing

## Purpose
Provides a robust, self-aware infrastructure for the Meta-System integration layer. Ensures that all automations are resilient to dependency failures, database instability, and connectivity issues.

## Scope
- **In Scope:** Startup verification, circuit breaking, sequential execution ordering, proactive failure prediction, and autonomous script discovery.
- **Out of Scope:** Physical hardware repair, manual database recovery (handled by S03).

## 4-Phase Architecture

### Phase A: Startup Resilience
Ensures the system never hangs on boot.
- **Timeouts:** All `psycopg2`, `subprocess`, and `requests` calls use strict timeouts (5s-300s).
- **Probes:** `G11_startup_probe.py` verifies core service availability before cycle initiation.
- **Degraded Mode:** Scripts like `G11_global_sync.py` implement try/except blocks to provide partial functionality if sub-systems are offline.

### Phase B: Endpoint Isolation & Circuit Breakers
Prevents cascading failures.
- **Circuit Breakers:** Uses `G04_domain_isolator` to fast-fail unstable domains (e.g., `meta_sync`, `decision_handler`).
- **Health API:** `G11_health_endpoint.py` provides standardized `/health/ready` (200 OK with error payload).
- **Granular Metrics:** `G11_script_health.py` provides per-script success/failure telemetry.

### Phase C: Full Self-Healing
Autonomous remediation of common failure modes.
- **Dynamic Audit:** `G11_self_healing_supervisor.py` dynamically discovers and audits all G11 scripts.
- **Repair Protocols:** Automates Postgres restarts, token deletion, and dependency installs.
- **Execution Tiers:** `G11_dependency_graph.py` enforces a 3-tier sync model:
    - **Tier 0:** Source of Truth (External Syncs)
    - **Tier 1:** Analysis & Triage
    - **Tier 2:** Consumers & Decision Proposers

### Phase D: Discovery Layer
Ensures 100% observability of the automation surface.
- **Auto-Discovery:** `G11_auto_discover.py` registers new scripts into the `G04_tool_manifest.json`.
- **Orphan Monitoring:** Identifies unregistered scripts that might be executing without monitoring.
- **Unified Dashboard:** `G11_unified_health_dashboard.py` integrates all layers into a single strategic view.

## Dependencies
| Dependency | Usage |
|---|---|
| PostgreSQL | `system_activity_log` for reliability analysis |
| Docker | Service management and container status checks |
| FastAPI | Health and tools endpoints |
| G04 Isolator | Circuit breaker implementation |

## Failure Modes
| Scenario | Detection | Response |
|---|---|---|
| DB Connection Hang | 5s Timeout (Task A1) | Terminate connection, log failure, enter Degraded Mode |
| Cascading Script Failures | Circuit Breaker (Task B2) | Open circuit for domain, skip execution for 60s |
| Unregistered Script | Dashboard Orphan Check (Task D4) | Flag in UI, prompt for auto-registration |
| Sequential Failures (3+) | Failure Predictor (Task C5) | Flag as CRITICAL in dashboard, notify via Telegram |

## Owner + Review Cadence
- **Owner:** Michał
- **Review Cadence:** Weekly during system audit.
