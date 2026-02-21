---
title: "SOP: Service Deployment"
type: "sop"
status: "active"
owner: "{{OWNER_NAME}}"
updated: "2026-02-21"
---

# SOP: Service Deployment

## Purpose
Standardize deployment of new FastAPI or n8n services.

## Procedure
1. Register service in `docs/20_Systems/Service-Registry.md`.
2. Deploy Docker container or n8n workflow.
3. Verify health endpoint (`/health`).
4. Update Digital Twin API dependencies if applicable.
