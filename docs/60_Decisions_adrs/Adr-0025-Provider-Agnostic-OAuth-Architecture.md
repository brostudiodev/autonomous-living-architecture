---
title: "ADR 0025: Provider-Agnostic OAuth Architecture"
type: "adr"
status: "accepted"
owner: "Michał"
updated: "2026-05-05"
---

# ADR 0025: Provider-Agnostic OAuth Architecture

## Status
Accepted

## Context
The system uses Authentik as a centralized identity provider. However, the user frequently switches between different remote access methods (zrok, ngrok, ZeroTier/VPN) to access the n8n interface. Strict Redirect URI matching in OAuth2 providers caused authorization failures when the access URL changed.

Additionally, n8n rejected requests with `ERR_ERL_UNEXPECTED_X_FORWARDED_FOR` because it did not trust the headers from these dynamic proxies.

## Decision
1. **Enable Trust Proxy:** Set `N8N_TRUST_PROXY=true` in the infrastructure configuration to allow n8n to process headers from zrok, ngrok, and other proxies.
2. **Flexible Redirect URIs:** Configure Authentik to support multiple redirect URIs for the n8n provider, utilizing both strict matching and regex patterns for maximum flexibility.
3. **Regex-Based Trust:** Implement regex matching for common fallback providers (e.g., ngrok) to avoid manual updates when tunnel URLs change.

## Implementation
- **Authentik SQL Update:**
    - Zrok: `https://n8n-gmktek.shares.zrok.io/rest/oauth2-callback` (Strict)
    - Local: `http://localhost:5678/rest/oauth2-callback` (Strict)
    - Ngrok: `^https://.*\.ngrok-free\.app/rest/oauth2-callback` (Regex)

## Consequences
- **Positive:** OAuth2 remains functional regardless of the active remote access provider.
- **Positive:** Reduced administrative overhead when switching network configurations.
- **Positive:** Improved n8n reliability behind proxies (rate-limiting stability).
- **Negative:** Regex matching for redirect URIs is slightly less secure than strict matching (mitigated by using provider-specific domain patterns).

## Validation
- Verified n8n environment for `N8N_TRUST_PROXY`.
- Verified Authentik database `UPDATE 1` for redirect URIs.
