---
title: "Runbook: Data Import Recovery"
type: "runbook"
status: "active"
owner: "{{OWNER_NAME}}"
updated: "2026-02-21"
---

# Runbook: Data Import Recovery

## Purpose
Steps to resolve failed financial data imports (Google Sheets → PostgreSQL).

## Procedure
1. Check n8n execution logs for `WF101__finance-import-transactions`.
2. Verify Google Sheet data format (date strings, number separators).
3. Check PostgreSQL connection status.
4. Re-run workflow manually for the affected range.
