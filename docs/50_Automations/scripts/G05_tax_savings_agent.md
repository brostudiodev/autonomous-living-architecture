---
title: "G05: Tax & Savings Allocation Agent"
type: "automation"
status: "active"
owner: "Michał"
updated: "2026-04-28"
goal_id: "goal-g05"
---

# G05: Tax & Savings Allocation Agent

## Purpose
Autonomously identifies new income in the finance database and generates decision requests for tax (19%) and savings (10%) allocations.

## Scope
- **In Scope:**
    - Scanning `autonomous_finance.transactions` for income.
    - Identifying unprocessed transactions in the `digital_twin_michal.decision_requests` table.
    - Calculating allocation amounts.
- **Out Scope:**
    - Automated execution of bank transfers (requires human approval/manual move).

## Inputs/Outputs
- **Inputs:**
    - `autonomous_finance.transactions` (PostgreSQL).
- **Outputs:**
    - `digital_twin_michal.decision_requests` entries.

## Dependencies
- **Systems:** [S03 Data Layer](../../20_Systems/S03_Data-Layer/README.md)
- **Database:** `autonomous_finance`, `digital_twin_michal`

## Procedure
Executed automatically via `autonomous_daily_manager.py`:
```bash
{{ROOT_LOCATION}}/autonomous-living/.venv/bin/python3 scripts/G05_tax_savings_agent.py
```

## Failure Modes
| Scenario | Detection | Response |
|---|---|---|
| DB Connection Fail | Error Log | Check PostgreSQL container. |
| Duplicate Processing | Status: SUCCESS (0 items) | Script correctly identifies processed IDs. |

## Owner + Review Cadence
- **Owner:** Michał
- **Review Cadence:** Monthly financial review.
