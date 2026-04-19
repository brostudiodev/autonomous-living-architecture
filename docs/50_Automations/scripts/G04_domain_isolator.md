---
title: "G04: Domain Isolator (Circuit Breaker)"
type: "automation_spec"
status: "active"
automation_id: "G04_domain_isolator.py"
goal_id: "goal-g04"
systems: ["S04"]
owner: "Michal"
updated: "2026-04-17"
---

# G04: Domain Isolator (Circuit Breaker)

## Purpose
A system-wide registry and orchestration module that prevents cascading failures across the Digital Twin ecosystem. It implements the **Circuit Breaker** pattern, ensuring that if one domain database (e.g., Health) hangs or fails, the rest of the system remains responsive.

## Key Features
- **Failure Tracking:** Tracks consecutive errors per domain (Finance, Health, Pantry, etc.).
- **Fast-Fail Mechanism (Open Circuit):** After 3 consecutive failures, the circuit "opens" for 60 seconds. During this time, all requests to that domain fail immediately without attempting a database connection.
- **Auto-Recovery (Half-Open):** After the timeout, a single trial request is allowed. If successful, the circuit "closes" (resumes normal operation).
- **Graceful Degradation:** Provides standardized "degraded" state objects for callers when a domain is offline.

## Usage
- **As a Decorator:** Used in `G04_digital_twin_engine.py` via `@domain_circuit_breaker(domain_name)`.
- **As a Registry:** The `isolator` singleton is imported by the API and Engine to check or report status.

## Status Modes
| Status | Meaning | Action |
|---|---|---|
| **closed** | Normal operation. | All requests allowed. |
| **open** | Failure threshold reached. | Requests blocked (fast-fail). |
| **half-open** | Recovery timeout expired. | Single trial request allowed. |

## Dependencies
### Systems
- [S04 Digital Twin Hub](../../20_Systems/S04_Digital-Twin/README.md)
- [G04: API Resilience Standard](./G04_api_resilience_standard.md)

## Error Handling
| Failure Scenario | Detection | Response |
|---|---|---|
| Domain Registry Conflict | KeyError | Default to "closed" state. |
| Reset Timeout Failure | Time comparison error | Circuit stays "open" for safety. |
