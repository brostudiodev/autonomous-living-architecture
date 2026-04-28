---
title: "G11: Failure Analyzer"
type: "automation_spec"
status: "active"
owner: "Michał"
goal_id: "goal-g11"
updated: "2026-04-28"
---

# G11: Failure Analyzer

## Purpose

Analyzes `friction_log` entries harvested from technical failures to identify recurring patterns. It groups errors by type (e.g., DB Permissions, Network Failures) and provides a report to help populate the `failure_knowledge_base`.

## Scope

### In Scope
- Regex-based pattern matching on `friction_log` descriptions.
- Grouping and counting occurrences of specific error types.
- Suggesting Knowledge Base entries based on identified patterns.

### Out of Scope
- Automatic insertion into the Knowledge Base (handled by G11: Populate KB).
- Human-readable summarization (handled via n8n workflows).

## Inputs/Outputs

### Input
- **Source:** PostgreSQL Table `friction_log` where `source = 'auto_technical'`

### Output
- **Target:** CLI Report / Log output.
- **Insights:** Frequency of specific failure types.

## Dependencies

### Systems
- [G11 Meta-System](../../10_Goals/G11_Meta-System-Integration-Optimization/README.md)

## Procedure

### Manual Execution
```bash
cd {{ROOT_LOCATION}}/autonomous-living/scripts
{{ROOT_LOCATION}}/autonomous-living/.venv/bin/python3 G11_failure_analyzer.py
```

## Failure Modes

| Scenario | Detection | Response |
|----------|-----------|----------|
| Regex failure | Grouped as 'Other/Unknown' | Update patterns in script |

## Owner + Review Cadence
- **Owner:** Michał
- **Review:** Bi-weekly
- **Last Updated:** 2026-04-28
