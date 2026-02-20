---
title: "script: G04_digital_twin_engine.py"
type: "automation_spec"
status: "active"
automation_id: "g04-digital-twin-engine"
goal_id: "goal-g04"
systems: ["S03", "S04"]
owner: "{{OWNER_NAME}}"
updated: "2026-02-19"
---

# script: G04_digital_twin_engine.py

## Purpose
The core aggregation engine for Goal G04. It pulls real-time state data from Finance and Training databases, persists the state to a historical tracking table, and generates a human-readable status summary.

## Triggers
- **Manual:** Run to get an instant snapshot of your "Digital Twin" state.
- **Integration:** Can be called by n8n or the Daily Manager to fetch consolidated life metrics.

## Inputs
- **Finance DB (`autonomous_finance`):** MTD Net cashflow and active budget alerts.
- **Training DB (`autonomous_training`):** Last workout date and latest body composition (weight/BF%).

## Processing Logic
1. **Health Sync:** Queries `workouts` and `v_body_composition` for the latest entries.
2. **Finance Sync:** Calculates current month's P&L and counts active alerts from `get_current_budget_alerts()`.
3. **Persistence:** Saves the state as JSONB into the `digital_twin_updates` table for historical analysis and API consumption.
4. **Summary Generation:** Formats the collected data into a clean text block with emojis.

## Outputs
- **Database:** New records in `autonomous_finance.public.digital_twin_updates`.
- **Console:** Status summary text block.

## Dependencies
### Systems
- [S03 Data Layer](../../20_SYSTEMS/S03_Data-Layer/README.md)
- [Digital Twin System](../../20_SYSTEMS/S04_Digital-Twin/README.md)

### External Services
- PostgreSQL (Docker)

## Error Handling
| Failure Scenario | Detection | Response | Alert |
|---|---|---|---|
| Training DB Down | psycopg2 exception | Logs "DB Training Error", continues with Finance | Console output |
| Finance DB Down | psycopg2 exception | Logs "DB Finance Error", continues with Health | Console output |
| Persistence Fail | try/except block | Prints error message, summary still generated | Console output |

## Manual Fallback
Data can be queried manually via SQL:
```sql
SELECT * FROM digital_twin_updates ORDER BY created_at DESC LIMIT 5;
```

## Related Documentation
- [Goal: G04 Digital Twin Ecosystem](../../10_GOALS/G04_Digital-Twin-Ecosystem/README.md)
- [Low-Level Design](../../20_SYSTEMS/Low-Level-Design.md)
