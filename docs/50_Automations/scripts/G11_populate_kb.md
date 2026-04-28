---
title: "G11: Populate KB"
type: "automation_spec"
status: "active"
owner: "Michał"
goal_id: "goal-g11"
updated: "2026-04-28"
---

# G11: Populate KB

## Purpose

Standardizes the population of the `failure_knowledge_base`. It maps regex error patterns to specific resolution types (command, advice) and payloads.

## Scope

### In Scope
- Inserting curated regex patterns into `failure_knowledge_base`.
- Preventing duplicate patterns via database checks.
- Mapping technical errors to "Self-Healing" actions.

## Inputs/Outputs

### Input
- **Curated List:** Internal dictionary of patterns and resolutions.

### Output
- **Target:** PostgreSQL Table `failure_knowledge_base`.

## Dependencies

### Systems
- [G11 Meta-System](../../10_Goals/G11_Meta-System-Integration-Optimization/README.md)

## Procedure

### Manual Execution
```bash
cd {{ROOT_LOCATION}}/autonomous-living/scripts
{{ROOT_LOCATION}}/autonomous-living/.venv/bin/python3 G11_populate_kb.py
```

## Owner + Review Cadence
- **Owner:** Michał
- **Review:** Monthly
- **Last Updated:** 2026-04-28
