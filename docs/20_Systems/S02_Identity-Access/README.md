---
title: "S02: Identity & Access"
type: "system"
status: "active"
system_id: "system-s02"
owner: "Michał"
updated: "2026-04-08"
review_cadence: "monthly"
---

# S02: Identity & Access

## Purpose
Manage authentication, authorization, and access control across all autonomous living systems. Ensure secure access to services while maintaining ease of use.

## Scope
### In Scope
- User authentication & Single Sign-On (SSO)
- Identity Provider integration (Authentik)
- API key management & Bearer Tokens
- OIDC / SAML support for internal services
- Credential storage & Access control lists

### Out of Scope
- Biometric authentication (Local hardware)
- Public-facing user registration (Invite only)

## Interfaces
### Inputs
- Authentication requests (OAuth2/OIDC)
- Credential updates
- User session data (Redis)

### Outputs
- Auth tokens (JWT)
- Access decisions
- Unified identity context

### APIs/events
- Authentik API (9000/9444)
- Local authentication
- Credential APIs

## Dependencies
### Services
- **Authentik Server/Worker** - Primary Identity Provider
- **Redis** - Session and task caching
- **PostgreSQL** - Identity database
- n8n credential manager

## Procedure
1. **Daily:** Monitor Authentik worker logs for sync failures.
2. **Monthly:** Review credential rotation and user session activity.
3. **Quarterly:** Audit access permissions and OIDC application links.

## Failure Modes
| Scenario | Detection | Response |
|----------|-----------|----------|
| Authentik Offline | 500/502 on login pages | Check Docker logs, restart server/worker |
| Redis Connection Fail | Authentik worker timeout | Ensure Redis healthcheck is passing in docker-compose |
| Port Conflict (9443) | Docker startup error | Mapped to 9444 to avoid Portainer conflict |
| Credential expires | Auth fails | Update credential / Rotate token |

## Security Notes
- Credentials stored in system keychain
- No plaintext passwords
- API keys rotated regularly

## Owner & Review
- **Owner:** Michał
- **Review Cadence:** Monthly
- **Last Updated:** 2026-04-25

---

## ☕ Fuel the Architecture

Building and maintaining this level of technical rigor is a massive investment. If this blueprint helps your own engineering journey, I would be grateful for your support.

<a href='https://ko-fi.com/michalnowakowski' target='_blank'><img height='60' style='border:0px;height:60px;' src='https://storage.ko-fi.com/cdn/kofi3.png?v=3' border='0' alt='Buy Me a Coffee at ko-fi.com' /></a>

**Support my hard work in engineering a fully autonomous life.** Every coffee fuels another line of code, another automated insight, and another step toward the 2026 North Star. Your contributions help maintain the infrastructure and research shared in this open-source blueprint.
