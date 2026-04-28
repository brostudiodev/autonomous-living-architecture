---
title: "Runbook: API Security Migration"
type: "runbook"
status: "active"
owner: "Michał"
updated: "2026-04-22"
goal_id: "goal-g11"
---

# Runbook: API Security Migration (G11-SSH)

## Purpose
This runbook outlines the phased migration of the Digital Twin API to a secure `X-API-KEY` authentication model. This is part of the G11 System Security Hardening (G11-SSH) initiative.

## Scope
- **In Scope:** `G04_digital_twin_api.py`, `X-API-KEY` header validation, permissive logging, and full enforcement.
- **Out Scope:** Database RBAC (handled by `RBAC-Shield-Runbook.md`), TLS/SSL termination (handled by `zrok` or proxy).

## Inputs/Outputs
- **Inputs:** `DIGITAL_TWIN_API_KEY` (from `.env`), `X-API-KEY` request header.
- **Outputs:** HTTP 200 (Success), HTTP 403 (Forbidden - in Phase 3), Security Warnings in API logs.

## Dependencies
- **Systems:** S04 Digital Twin, S11 Meta-System.
- **Credentials:** `DIGITAL_TWIN_API_KEY` in `.env`.

## Migration Phases

### Phase 1: Permissive Logging (ACTIVE)
- **Status:** Implemented on 2026-04-22.
- **Logic:** Middleware checks for `X-API-KEY`. If missing or invalid, logs a `WARNING` but allows the request to proceed (`SECURITY_ENFORCE = False`).
- **Goal:** Identify all callers (n8n nodes, scripts) that need updating.

### Phase 2: Node Identification (PENDING)
- **Task:** Audit `digital-twin-api` logs for `SECURITY_ALERT` entries.
- **Action:** Update all identified callers to include the `X-API-KEY` header using the value from `.env`.

### Phase 3: Full Enforcement (PENDING)
- **Task:** Flip the enforcement switch.
- **Action:** Set `SECURITY_ENFORCE = True` in `G04_digital_twin_api.py`.
- **Outcome:** All requests missing a valid key will receive an HTTP 403 Forbidden response.

## Procedure: Verification (Phase 1)
To verify that permissive logging is working:
1. **Send a request without a key:**
   ```bash
   curl -s http://{{INTERNAL_IP}}:5677/health/dashboard
   ```
2. **Check API logs for warning:**
   ```bash
   docker logs digital-twin-api | grep "SECURITY_ALERT"
   ```
3. **Send a request with the correct key:**
   ```bash
   curl -s http://{{INTERNAL_IP}}:5677/health/dashboard -H "X-API-KEY: [API_KEY]"
   ```
4. **Verify no warning is logged for the valid request.**

## Failure Modes
| Scenario | Detection | Response |
|----------|-----------|----------|
| API Crash on startup | `docker ps` shows Restarting, logs show `PermissionError` | Ensure `STATIC_PATH` exists with correct permissions (check `Dockerfile.digital-twin`). |
| Middleware blocks all traffic | HTTP 403 on all requests | Verify `SECURITY_ENFORCE` is `False` for Phase 1/2. |
| Key mismatch | Logs show `INVALID` instead of `MISSING` | Synchronize key between `.env` and caller. |

## Security Notes
- `DIGITAL_TWIN_API_KEY` must be kept secret and rotated periodically.
- Security enforcement should only be enabled after all critical n8n workflows have been updated.

## Owner + Review Cadence
- **Owner:** Michał
- **Review Cadence:** Monthly until Phase 3 completion, then Quarterly.
