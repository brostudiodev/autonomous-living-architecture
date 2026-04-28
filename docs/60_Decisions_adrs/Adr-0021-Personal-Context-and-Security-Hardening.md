---
title: "ADR 0021: Personal Context Integration & Enterprise Security Hardening"
status: "accepted"
date: "2026-04-25"
owner: "Michal"
---

# ADR 0021: Personal Context Integration & Enterprise Security Hardening

## Context

As the Autonomous Living ecosystem matures toward "Enterprise-Grade" (North Star 2026), two critical gaps were identified:
1. **Lack of Deep Personal Awareness**: AI agents lacked a persistent, document-driven understanding of Michal's professional history, skills, and decision-making frameworks.
2. **Security & Observability Debt**: The Digital Twin API used simple API keys and lacked standardized documentation (Swagger). Infrastructure lacked a centralized Identity Provider (SSO), creating friction for future multi-user or multi-app expansion.

## Decision

We have decided to implement the following architectural enhancements:

1. **Personal Bio-Context Layer**: 
    - Establish a dedicated `99_System/Personal/` folder in Obsidian as the source of truth for identity.
    - Implement `G04_personal_context_sync.py` to synchronize these documents into a `personal_intelligence` table in PostgreSQL.
    - Integrate this context directly into the `DigitalTwinEngine` state.

2. **Enterprise Security (Authentik & Redis)**:
    - Deploy **Authentik** as the primary OIDC/SSO provider for the ecosystem.
    - Introduce **Redis** for session management and high-performance caching.
    - Map Authentik to port `9444` to avoid conflicts with existing services (Portainer).

3. **API Observability (Swagger/OpenAPI)**:
    - Standardize the Digital Twin API (FastAPI) with comprehensive OpenAPI metadata.
    - Expose interactive documentation at `/docs`.
    - Integrate documentation access directly into the Mission Control UI.

## Consequences

### Positive
- **Deep AI Awareness**: Agents can now provide context-aware advice based on Michal's actual work history and preferences.
- **Improved Security**: Foundation laid for OIDC/SAML authentication across all tools (n8n, Grafana, API).
- **Reduced Developer Friction**: Interactive API docs make it easier to test endpoints and for autonomous agents to discover new tools.
- **System Resilience**: Redis caching improves response times for session-heavy operations.

### Negative / Risks
- **Increased Resource Footprint**: Adding Authentik and Redis increases the baseline RAM usage of the Docker host.
- **Configuration Complexity**: Maintaining OIDC flows and secret keys adds complexity to the `.env` management.
- **Port Management**: Non-standard ports (9444) must be tracked to avoid future collisions.

## Alternatives Considered
- **Direct LLM Prompting**: Rejected as it consumes excessive tokens and lacks persistence.
- **Simple API Keys**: Deprecated in favor of the more secure and scalable OIDC/Bearer Token pattern.
- **Authelia**: Considered as an alternative to Authentik; Authentik was selected for its superior UI and built-in support for more diverse protocols.

## Status
**Accepted** - Implemented 2026-04-25.
