---
title: "G11: System Heartbeat Monitor"
type: "automation_spec"
status: "active"
automation_id: "G11_system_heartbeat"
goal_id: "goal-g11"
systems: ["S11"]
owner: "Michal"
updated: "2026-04-18"
---

# G11: System Heartbeat Monitor

## Purpose
Ensures the high availability of the Digital Twin API by performing periodic health checks. Monitors latency and status codes to detect system degradation before it impacts user experience.

## Triggers
- Scheduled: Part of the `autonomous_daily_manager.py` daily sync cycle.

## Inputs
- External: `http://localhost:5677/status` (Digital Twin API).

## Processing Logic
1. **Request:** Perform an HTTP GET request to the status endpoint.
2. **Measure:** Calculate response time (latency).
3. **Verify:** Check for status 200 OK.
4. **Log:** Record the result and latency in the activity log.

## Outputs
- Latency telemetry in `system_activity_log`.
- Critical failure alert (if unresponsive).

## Error Handling
| Failure Scenario | Detection | Response | Alert |
|---|---|---|---|
| API Timeout | `requests.timeout` | Log critical failure | Log Critical |
| Slow Response | Latency > 2s | Log warning | Log Warning |
