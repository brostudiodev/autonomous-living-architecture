---
title: "G11_decision_proposer: Proactive Strategy Engine"
type: "automation_spec"
status: "active"
automation_id: "G11_decision_proposer"
goal_id: "goal-g11"
systems: ["S04", "S08"]
owner: "Michal"
updated: "2026-03-25"
---

# G11_decision_proposer: Proactive Strategy Engine

## Purpose
Analyzes the current state of all technical systems (Health, Finance, Logistics, Pantry) via the Digital Twin Engine and automatically generates high-confidence **Decision Requests** for human approval.

## Triggers
- **System Sync:** Part of the `G11_global_sync.py` pipeline.
- **Manual:** `python3 G11_decision_proposer.py`

## Inputs
- **Digital Twin State:** Unified context from `G04_digital_twin_engine.py`.
- **Databases:** `autonomous_health`, `autonomous_finance`, `autonomous_pantry`, `autonomous_life_logistics`.

## Processing Logic
1. **Health Audit:**
   - Detects low readiness (< 65) combined with recent high training load.
   - Proposes "Mandatory Recovery Day" if CNS fatigue is likely.
2. **Financial Audit:**
   - Scans for budget breaches (utilization >= 100%).
   - Scans for categories with significant surplus (> 200 PLN and < 50% utilized).
   - Proposes "Auto-Rebalance" from surplus to breach.
3. **Household Audit:**
   - Identifies items below critical thresholds.
   - Proposes "Auto-Procurement" (Google Task injection).
4. **Logistics Audit:**
   - Detects deadlines within 3 days.
   - Proposes "Task Injection" for urgent document/payment handling.
5. **Deduplication:**
   - Checks `decision_requests` table to ensure identical pending requests aren't duplicated.

## Outputs
- **Database Entry:** New row in `digital_twin_michal.decision_requests` with `PENDING` status.
- **Console Log:** Summary of generated proposals.

## Dependencies
### Systems
- [S03 Data Layer](../../20_Systems/S03_Data-Layer/README.md)
- [S04 Digital Twin](../../20_Systems/S04_Digital-Twin/README.md)

### Credentials
- Database credentials via `.env`

## Error Handling
| Failure Scenario | Detection | Response | Alert |
|---|---|---|---|
| DB Connection Fail | psycopg2 Exception | Exit with error | Logged to `system_activity_log` |
| Invalid Payload | JSON/Key error | Skip specific proposal | Console warning |

## Monitoring
- Success metric: Number of proposals generated per run.
- Dashboard: Digital Twin API `/status`.

## Related Documentation
- [G11_approval_prompter](./G11_approval_prompter.md)
- [G11_decision_handler](./G11_decision_handler.md)
- [S04 Digital Twin API Specification](../../20_Systems/S04_Digital-Twin/API-Specification.md)
