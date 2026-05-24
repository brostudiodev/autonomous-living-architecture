---
title: "Home Module: Smart Home Orchestration"
type: "system_specification"
status: "active"
owner: "Michał"
updated: "2026-05-13"
goal_id: "goal-g08"
---

# Home Module (G08-MSM)

## Purpose
Interface with Home Assistant to monitor environmental status, home security, and device health.

## Scope
-   **Environmental Monitoring:** Temperature and battery levels.
-   **Home Security:** Real-time motion detection and contact sensor state.
-   **Event Emission:** Alerts for low battery or security anomalies.

## Inputs/Outputs
-   **Inputs:** Home Assistant REST API.
-   **Outputs:** RabbitMQ Events (`home.low_battery_alert`), `/api/v1/home` endpoints.

## Dependencies
-   **Systems:** Home Assistant (External).
-   **Infrastructure:** Kernel SDK, RabbitMQ.

## Procedure
The module fetches the entire state tree from Home Assistant on every sync. It filters for temperature sensors and battery levels. If any battery is below 20%, a warning event is emitted to the system bus.

## Failure Modes
-   **HA Unreachable:** Returns a standard error response; logs the connection failure.
-   **Auth Failure:** Circuit breaker opens to prevent flooding HA with bad requests.

## Security Notes
-   Uses `HA_TOKEN` for bearer authentication.
-   Read-Only access is enforced by architectural intent (G08 is monitoring only).

## Owner + Review Cadence
-   **Owner:** Michał
-   **Review Cadence:** Monthly
