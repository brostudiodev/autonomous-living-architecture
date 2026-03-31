---
title: "G10: Google Tasks Injection"
type: "automation_spec"
status: "active"
automation_id: "G10__google-tasks-injection"
goal_id: "goal-g10"
systems: ["S04", "S09", "S10"]
owner: "Michal"
updated: "2026-03-02"
---

# G10: Google Tasks Injection

## Purpose
Proactively pushes dynamic task recommendations (from Health, Finance, and Roadmap) into the "Today's Autonomous Focus" Google Tasks list.

## Triggers
- **Manual:** Triggered via Digital Twin API `POST /tasks/sync_recommendations`.
- **Planned:** To be integrated into the morning briefing workflow.

## Inputs
- **Digital Twin Engine State:** (PostgreSQL: `autonomous_health`, `autonomous_finance`, `autonomous_pantry`).
- **Roadmap Data:** Markdown files in `docs/10_Goals/G*/Roadmap.md`.
- **Google API Credentials:** `client_secret.json` and `google_tasks_token.pickle`.

## Processing Logic
1. **Analyze State:** `DigitalTwinEngine` evaluates biological readiness, budget breaches, and low pantry stock.
2. **Roadmap Scan:** Extracts the first uncompleted Q1 task from each active goal.
3. **Task Synthesis:** Generates a list of structured recommendations with priorities and notes.
4. **Deduplication:** Checks the target Google Task list for existing, uncompleted tasks with the same title.
5. **Injection:** Calls Google Tasks API to create new tasks for missing recommendations.

## Outputs
- **Google Tasks:** New entries in the "Today's Autonomous Focus" list.
- **API Response:** JSON report summarizing synced tasks and any errors.

## Dependencies
### Systems
- [S04 Digital Twin](../../20_Systems/S04_Digital-Twin/README.md)
- [S09 Productivity & Time](../../20_Systems/S09_Productivity-Time/README.md)
- [S10 Task Management](../../20_Systems/S10_Daily-Goals-Automation/README.md)

### External Services
- **Google Tasks API:** Requires OAuth2 authentication.

### Credentials
- `scripts/client_secret.json`: Google Cloud Console credentials.
- `scripts/google_tasks_token.pickle`: User-authorized refresh token.

## Error Handling
| Failure Scenario | Detection | Response | Alert |
|---|---|---|---|
| Token Expired | API returns 401 | `G10_google_tasks_sync` attempts refresh | Log in API console |
| Network Offline | `requests` exception | Returns 500 error to caller | Log in `api_5678.log` |
| Duplicate Title | Logic matches existing title | Skips creation (Idempotent) | Silent (Expected) |

## Monitoring
- **Success metric:** Task count in Google Tasks matches engine recommendations.
- **Alert on:** API failure in `Digital Twin` logs.

## Manual Fallback
If the API call fails, tasks can be manually added from the recommendations displayed in the `Daily Note` or by calling the script directly:
```bash
# To view recommendations without syncing
curl http://localhost:5677/tasks/recommendations

# To trigger sync
curl -X POST http://localhost:5677/tasks/sync_recommendations
```

## Related Documentation
- [SOP: Daily-Task-Review](../../30_Sops/SOP_Daily_Task_Review.md)
- [System: S04 Digital Twin](../../20_Systems/S04_Digital-Twin/README.md)
