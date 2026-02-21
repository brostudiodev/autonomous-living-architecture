---
title: "Runbook: Budget Alert Response"
type: "runbook"
status: "active"
owner: "{{OWNER_NAME}}"
updated: "2026-02-21"
---

# Runbook: Budget Alert Response

## Purpose
Action steps when a CRITICAL or HIGH budget alert is received.

## Procedure
1. Identify the breaching category.
2. Review recent transactions for errors or unplanned large expenses.
3. Determine if rebalancing is possible using `G05_finance_optimizer.py`.
4. If unavoidable, adjust next month's budget or reduce discretionary spending.
