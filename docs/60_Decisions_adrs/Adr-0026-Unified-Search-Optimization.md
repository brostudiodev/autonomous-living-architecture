---
title: "Adr-0026: Unified Search Optimization"
type: "adr"
status: "accepted"
date: "2026-05-06"
---

# Adr-0026: Unified Search Optimization

## Context
System knowledge is split between two repositories: `autonomous-living/docs` (technical) and `Obsidian Vault` (personal/daily). Agents and users had to perform multiple manual searches (grep, ripgrep, or native Obsidian search) to find cross-domain context, leading to high "information lookup latency."

## Decision
Expose a unified `/search` endpoint in the Digital Twin API.

1.  **Logic:** Centralized `search_docs` method in `G04_digital_twin_engine.py`.
2.  **Engine:** Uses `grep -rli` for fast file discovery and Python `re` for snippet extraction with context.
3.  **Scope:** Simultaneously searches `BASE_DIR/docs` and `OBSIDIAN_VAULT`.
4.  **Interface:** AgentZero `/search` command and `/chat` endpoint.

## Consequences
- **Positive:** Single entry point for all system knowledge. Drastically reduced token usage for LLMs (snippets vs reading whole files).
- **Negative:** Search performance depends on disk I/O; potentially slower as the vault grows to 10k+ files.
