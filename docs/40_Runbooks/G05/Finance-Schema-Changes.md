---
title: "Runbook: Finance Schema Changes"
type: "runbook"
status: "active"
owner: "{{OWNER_NAME}}"
updated: "2026-02-21"
---

# Runbook: Finance Schema Changes

## Purpose
Safe procedure for updating the `autonomous_finance` PostgreSQL schema.

## Procedure
1. Backup database: `pg_dump -U root autonomous_finance > backup.sql`.
2. Apply changes in `docs/20_Systems/S03_Data-Layer/`.
3. Verify views and functions are still operational.
4. Update Grafana panels if column names changed.
