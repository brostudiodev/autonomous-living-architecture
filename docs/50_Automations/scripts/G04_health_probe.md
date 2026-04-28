---
title: "G04: Domain Health Probe"
type: "automation_spec"
status: "active"
automation_id: "G04_health_probe.py"
goal_id: "goal-g04"
systems: ["S04"]
owner: "Michał"
updated: "2026-04-17"
---

# G04: Domain Health Probe

## Purpose
A high-speed diagnostic utility for verifying connectivity to specific domain databases. Used for manual troubleshooting and integrated into the Digital Twin API's per-domain health monitoring.

## Key Features
- **Targeted Probing:** Check health of a single domain (e.g., `finance`, `health`).
- **Resilient Connectivity:** Uses a short (2s) timeout to prevent hanging on unresponsive databases.
- **Multi-Format Output:** Supports human-readable console output and machine-readable JSON.
- **Exit Codes:** Returns `0` on success and `1` on failure for easy integration with CI/CD or health scripts.

## Triggers
- **Manual:** `python3 scripts/G04_health_probe.py [domain]`
- **JSON Mode:** `python3 scripts/G04_health_probe.py [domain] --json`

## Inputs
- **Domain Name:** String (finance, health, pantry, training, logistics, career, learning, twin).
- **Credentials:** Automatically loaded from `db_config.py` and `.env`.

## Outputs
- **Console:** ✅/❌ status messages.
- **JSON:** `{ "status": "OK/OFFLINE", "domain": "name", "timestamp": "ISO", "error": "msg" }`

## Dependencies
### Systems
- [S04 Digital Twin Hub](../../20_Systems/S04_Digital-Twin/README.md)
- [G04: Domain Isolator (Circuit Breaker)](./G04_domain_isolator.md)

## Error Handling
| Failure Scenario | Detection | Response |
|---|---|---|
| Unknown Domain | `ValueError` | Returns error message with list of valid domains. |
| Database Timeout | `OperationalError` | Reports OFFLINE with timeout details. |
