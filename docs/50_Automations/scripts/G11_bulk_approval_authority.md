---
title: "WF: G11 Bulk Approval Authority"
type: "automation_spec"
status: "active"
automation_id: "G11_bulk_approval_authority"
goal_id: "goal-g11"
systems: ["S11"]
owner: "Michał"
updated: "2026-03-27"
---

# G11: Bulk Approval Authority

## Purpose
Enables one-tap approval of all pending system decisions (Level 4/5 autonomy) via the `/approve all` Telegram command.

## Triggers
- **Manual:** User sends `/approve all` to the Telegram bot.
- **Scheduled:** Potential for end-of-day bulk resolution (Future).

## Inputs
- **Database:** `digital_twin_michal.decision_requests` (Filter: `status = 'PENDING'`)
- **Telegram:** Bot command trigger

## Processing Logic
1. Telegram Bot receives `/approve all`.
2. Bot calls `G11_decision_handler.py --all`.
3. Handler fetches all IDs from `decision_requests` where `status = 'PENDING'`.
4. Handler iterates through each request and executes the corresponding domain action.
5. Handler updates the status of each request to `RESOLVED` / `SUCCESS`.

## Outputs
- **Telegram:** Confirmation message with the number of processed approvals.
- **Database:** Updated `decision_requests` and `autonomous_decisions` logs.
- **System Change:** Execution of individual actions (Bank transfers, shopping list additions, etc.)

## Dependencies
### Systems
- [S04 Digital Twin Hub](../../20_Systems/S04_Digital-Twin/README.md)
- [S11 Meta-System Integration](../../20_Systems/S11_Meta-System-Integration/README.md)

### External Services
- Telegram Bot API
- Domain-specific APIs (Google Sheets, Google Tasks)

## Error Handling
| Failure Scenario | Detection | Response | Alert |
|---|---|---|---|
| Execution failure | Action returns `False` | Mark request as `FAILED`, continue to next | Report count of failures to Telegram |
| DB Connectivity | psycopg2 exception | Script exits with error | Notify via Telegram |

## Monitoring
- Success metric: Number of `RESOLVED` requests in `digital_twin_michal`.
- Alert on: Any bulk run where `FAILED` count > 0.

## Manual Fallback
If the bulk command fails:
1. Approve requests individually via Telegram buttons.
2. Manually check the Daily Note and approve by checking `#approve_ID` boxes.
3. Run the handler manually: `python3 scripts/G11_decision_handler.py <ID>`
