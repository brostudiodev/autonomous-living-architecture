---
title: "Adr-0023: Intelligence Layer Delegation (n8n Brain)"
type: "decision"
status: "accepted"
date: "2026-05-02"
deciders: ["Michał"]
---

# Adr-0023: Intelligence Layer Delegation (n8n Brain)

## Status
Accepted

## Context
As the ecosystem expanded, AI-driven logic (Gemini calls, strategic reasoning) became scattered across multiple local Python scripts. This made it difficult to maintain a consistent "voice" for the system, manage API costs, and swap LLM models. Additionally, direct Telegram notifications from background scripts caused "notification spam" and lacked contextual awareness.

## Decision
We established a strict **Split-Brain Architecture**:
1.  **Intelligence Layer (n8n):** Designated as the primary "Strategic Brain." All LLM-driven tasks (categorization, ideation, drafting, strategic approval) are offloaded to n8n via synchronous webhooks (`SVC_LLM_*`).
2.  **Execution Layer (Python):** Local scripts are designated as "Silent Executioners." They handle deterministic tasks, data integrity, and system broadcasting.
3.  **Unified Entry Point:** n8n is the sole handler for incoming/outgoing Telegram messages. Local scripts must never call the Telegram API directly.

## Consequences
- **Positive:** Centralized LLM management. Context-aware notifications (n8n fetches global state before alerting). Clean separation of concerns.
- **Negative:** Increased dependency on n8n uptime for routine tasks (e.g., transaction categorization).

## Implementation
- **Services:** `SVC_LLM_Categorize`, `SVC_LLM_Generate-Idea`, `SVC_LLM_Draft-Content`.
- **Refactored Scripts:** `G05_llm_categorizer.py`, `G02_linkedin_drafter.py`, `G11_event_listener.py` (Silent Mode).
