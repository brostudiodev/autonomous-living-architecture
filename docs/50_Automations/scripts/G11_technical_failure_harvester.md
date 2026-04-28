---
title: "G11: Technical Failure Harvester"
type: "automation_spec"
status: "active"
owner: "Michał"
goal_id: "goal-g11"
updated: "2026-04-28"
---

# G11: Technical Failure Harvester

## Purpose

Scans the `system_activity_log` for entries with `FAILURE` status and extracts technical details (tracebacks, error messages). It populates the `friction_log` with these entries to ensure that technical system failures are visible to the human-led and AI-led optimization processes.

## Scope

### In Scope
- Scanning `system_activity_log` for `status = 'FAILURE'`.
- Deduplicating failures before inserting into `friction_log`.
- Mapping `script_name` to specific system domains (Finance, Health, etc.).
- Categorizing failures as `auto_technical` source.

### Out of Scope
- Resolving the failures (handled by G11: Failure Resolver).
- Analyzing patterns (handled by G11: Failure Analyzer).

## Inputs/Outputs

### Input
- **Source:** PostgreSQL Table `system_activity_log`
- **Criteria:** `status = 'FAILURE'` and `details IS NOT NULL`

### Output
- **Target:** PostgreSQL Table `friction_log`
- **Fields:** `description` (from details), `source` ('auto_technical'), `domain`, `severity` (4), `status` ('pending').

## Dependencies

### Systems
- [S03 Data Layer](../../20_Systems/S03_Data-Layer/README.md)
- [G11 Meta-System](../../10_Goals/G11_Meta-System-Integration-Optimization/README.md)

### Infrastructure
- PostgreSQL `digital_twin_michal` database.

## Procedure

### Manual Execution
```bash
cd {{ROOT_LOCATION}}/autonomous-living/scripts
{{ROOT_LOCATION}}/autonomous-living/.venv/bin/python3 G11_technical_failure_harvester.py
```

## Failure Modes

| Scenario | Detection | Response |
|----------|-----------|----------|
| Database Connection Failure | Script logs error to stderr | Check Postgres container status |
| Duplicate insertion | Subquery check in SQL | Expected behavior (no action) |

## Owner + Review Cadence
- **Owner:** Michał
- **Review:** Monthly (during G11 reliability audit)
- **Last Updated:** 2026-04-28
