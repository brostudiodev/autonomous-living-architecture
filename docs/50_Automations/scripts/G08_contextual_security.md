---
title: "G08: Contextual Security Agent"
type: "automation"
status: "active"
owner: "Michal"
updated: "2026-04-18"
goal_id: "goal-g08"
---

# G08: Contextual Security Agent

## Purpose
Proposes home security and energy-saving actions based on the user's calendar ("Away" status) and external weather conditions.

## Scope
- **In Scope:**
    - Checking Google Calendar for out-of-home locations.
    - Checking weather conditions (Temperature/Sky).
    - Proposing HA "Away Mode" or blind adjustments.
- **Out Scope:**
    - Direct device control (delegated to Home Assistant via Decision Engine).

## Inputs/Outputs
- **Inputs:**
    - Google Calendar API
    - Weather API (Open-Meteo)
- **Outputs:**
    - `decision_requests` in `digital_twin_michal`.

## Dependencies
- **Systems:** [S07 Smart Home System](../../20_Systems/S04_Digital-Twin/README.md)
- **External:** Home Assistant API

## Procedure
```bash
{{ROOT_LOCATION}}/autonomous-living/.venv/bin/python3 scripts/G08_contextual_security.py
```

## Owner + Review Cadence
- **Owner:** Michal
- **Review Cadence:** Monthly review of decision accuracy.
