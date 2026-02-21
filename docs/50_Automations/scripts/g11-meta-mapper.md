---
title: "G11: Meta-System Mapper"
type: "automation_spec"
status: "active"
automation_id: "g11-meta-mapper"
goal_id: "goal-g11"
systems: ["S01"]
owner: "{{OWNER_NAME}}"
updated: "2026-02-21"
---

# G11: Meta-System Mapper

## Purpose
Visualizes and audits the connectivity between all 12 power goals and their supporting source databases and APIs.

## Triggers
- Manual execution
- Daily Note sync process

## Inputs
- PostgreSQL DBs: `finance`, `training`, `pantry`
- Digital Twin API status

## Outputs
- `G11_System_Connectivity_Map.md` in goal-g11 folder.
