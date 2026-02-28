---
title: "script: system-audit"
type: "automation_spec"
status: "active"
automation_id: "system-audit"
goal_id: "goal-g11"
systems: ["S01", "S11"]
owner: "Michal"
updated: "2026-02-22"
---

# script: system-audit

## Purpose
Performs a deep structural health check of the entire autonomous ecosystem, identifying "Technical Debt" and broken integrations before they impact the North Star goal.

## Triggers
- **API Call:** Triggered via the `/audit` endpoint of the Digital Twin API.
- **Manual Execution:** `python3 G11_system_audit.py`.

## Inputs
- **PostgreSQL:** Status and freshness metadata from all 3 production databases.
- **File System:** Existence check for critical `.json` and `.pickle` credentials.
- **Documentation:** File modification times for all goal `Activity-log.md` files.

## Processing Logic
1. **DB Freshness Probe:** Queries the latest update timestamp from each database. Data > 48h old is flagged as "Stale".
2. **Credential Audit:** Verifies all OAuth2 tokens and service account keys are present in the `/scripts` directory.
3. **Log Audit:** Flags any Goal ID whose activity log hasn't been updated in 7 days as "Starved".
4. **Status Scoring:** Assigns an overall status (Healthy, Degraded, Critical).

## Outputs
- **JSON Object:** Detailed metrics for each audited component.
- **Markdown Text:** Status summary with color-coded status emojis (🟢/🟡/🔴).

## Dependencies
### Systems
- [Observability Monitoring](../../20_Systems/S01_Observability-Monitoring/README.md)
- [Intelligence Router](../../20_Systems/S11_Intelligence_Router/README.md)

### External Services
- **Docker Compose:** Databases must be running.

## Error Handling
| Failure Scenario | Detection | Response |
|---|---|---|
| DB Connection Refused | Exception in audit | Mark database as "❌ Error" and set status to Critical |
| Credentials missing | File existence check | Identify specific missing file in the report |

## Manual Fallback
Check Docker container logs and manually verify database table freshness via pgAdmin.
