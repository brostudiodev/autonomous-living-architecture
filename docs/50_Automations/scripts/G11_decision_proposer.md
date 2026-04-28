---
title: "G11_decision_proposer: Proactive Strategy Engine"
type: "automation_spec"
status: "active"
automation_id: "G11_decision_proposer"
goal_id: "goal-g11"
systems: ["S04", "S08"]
owner: "Michał"
updated: "2026-04-14"
---

# G11_decision_proposer: Proactive Strategy Engine

## Purpose
Analyzes the current state of all technical systems (Health, Finance, Logistics, Pantry, Roadmap) via the Digital Twin Engine and automatically generates high-confidence **Decision Requests** for human approval or **Implicit Actions** for high-trust domains.

## 🚀 Enhancements (Apr 14)
1. **Rich Reporting & Standardized Payloads:** Harmonized `propose_decision` with `RulesEngine` to include `recommended_action`, `reason`, and `description` in the database payload. This ensures that the "Decision" reported by Meta-Integration or n8n is never `null`.
2. **Subprocess Execution Fix:** Standardized the `G11_decision_handler.py` trigger to use a clean argument list for better reliability.
3. **Policy-Driven Context:** Now dynamically loads policy descriptions to enrich human-in-the-loop requests.

## Triggers
- **System Sync:** Part of the `G11_global_sync.py` pipeline.
- **Manual:** `python3 G11_decision_proposer.py`
- **Roadmap:** Triggered by `G11_roadmap_enforcer.py` for Q2 task backlog.

## Inputs
- **Digital Twin State:** Unified context from `G04_digital_twin_engine.py`.
- **Autonomy Policies:** `autonomy_policies.yaml` for authority level checks.
- **Databases:** `autonomous_health`, `autonomous_finance`, `autonomous_pantry`, `autonomous_life_logistics`.

## Processing Logic
0. **Autonomy Check (NEW):**
   - Loads `autonomy_policies.yaml` at runtime.
   - For every proposal, checks the `authority_level` of the (domain, policy) pair.
   - If `authority_level == 'full'`, the request is marked as `APPROVED` and passed to the execution handler immediately (Implicit Autonomy).
1. **Health Audit:**
...
4. **Logistics Audit:**
   - Detects deadlines within 3 days.
   - Proposes "Task Injection" for urgent document/payment handling.
5. **Roadmap Enforcement (NEW):**
   - Receives tasks from `G11_roadmap_enforcer.py`.
   - Injects them as `meta.roadmap_task_enforcement` decisions.
6. **Deduplication:**
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
