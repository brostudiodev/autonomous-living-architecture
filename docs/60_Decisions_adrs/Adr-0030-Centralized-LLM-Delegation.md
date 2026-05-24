---
title: "Adr-0030: Centralized LLM Delegation (n8n-as-Brain)"
type: "adr"
status: "accepted"
date: "2026-05-10"
deciders: ["Michał"]
---

# Adr-0030: Centralized LLM Delegation (n8n-as-Brain)

## Context
The system previously had decentralized AI logic, with multiple Python scripts directly calling the Google Gemini API or local Ollama instances. This led to:
1. **Scattered Logic:** Prompt engineering and model configuration were duplicated across scripts.
2. **Infrastructure Fragility:** Hardware limitations (CPU/RAM) on the host machine made running local LLMs (Ollama) unreliable for real-time script execution.
3. **Observability Gaps:** No central audit trail for AI reasoning costs or failures.
4. **Security Risk:** Sensitive API keys were required across multiple Docker images.

## Decision
We will enforce a strict **"n8n-as-Brain"** architecture for all Large Language Model (LLM) and embedding tasks.

1.  **Mandate:** Python scripts are strictly deterministic. They MUST NOT import `google-generativeai` or `ollama` libraries.
2.  **Centralized Bridge:** All AI requests must go through the `G05_ollama_wrapper.py` bridge.
3.  **Delegation:** The bridge routes all requests to a unified n8n entry point (`SVC_LLM_Unified_Wrapper`).
4.  **Abstraction:** n8n handles model selection (Gemini vs. Ollama), prompt versioning, and error handling.
5.  **Embeddings:** Vectorization (embeddings) is also delegated to n8n to ensure consistent model usage across the Digital Twin.

## Consequences
- **Positive:** Centralized prompt management and cost tracking in n8n.
- **Positive:** Reduced Docker image sizes and attack surface (no AI libs in API containers).
- **Positive:** Increased system resilience; n8n can handle retries and model fallbacks transparently.
- **Negative:** Increased latency for simple AI tasks due to network overhead between Python and n8n.
- **Neutral:** Requires all developers/agents to maintain the `G05_ollama_wrapper` as the single source of truth for AI communication.
