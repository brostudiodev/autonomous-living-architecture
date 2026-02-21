---
title: "SOP: Projection Validation"
type: "sop"
status: "active"
owner: "{{OWNER_NAME}}"
updated: "2026-02-21"
---

# SOP: Projection Validation

## Purpose
Validate the accuracy of month-end financial projections.

## Procedure
1. Compare "Projected Month End" from `v_budget_performance` with previous months' actuals.
2. Check if burn rate calculation handles mid-month anomalies.
3. Verify savings rate projection logic against `v_real_savings_monthly`.
