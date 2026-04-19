---
title: "G12: Knowledge Retrieval Agent"
type: "automation"
status: "active"
owner: "Michal"
updated: "2026-04-08"
goal_id: "goal-g12"
---

# G12: Knowledge Retrieval Agent

## Purpose
Provides natural language search capabilities across the Obsidian Vault by bridging user queries to the Digital Twin API's search endpoint.

## Scope
- **In Scope:**
    - Querying the `/search` endpoint of the Digital Twin.
    - Formatting snippets for n8n/AI consumption.
- **Out Scope:**
    - OCR of images in the vault.

## Inputs/Outputs
- **Inputs:**
    - Natural language string.
- **Outputs:**
    - Markdown-formatted documentation snippets.

## Dependencies
- **Systems:** [S04 Digital Twin API](../../20_Systems/S04_Digital-Twin/API-Specification.md)
- **Endpoint:** `/search`

## Procedure
Call via CLI or Agent Zero delegation:
```bash
{{ROOT_LOCATION}}/autonomous-living/.venv/bin/python3 scripts/G12_knowledge_agent.py "How do I rebalance my budget?"
```

## Owner + Review Cadence
- **Owner:** Michal
- **Review Cadence:** Part of G12 Documentation Audit.
