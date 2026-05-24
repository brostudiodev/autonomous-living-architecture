---
title: "Implementation Plan: Modular SDK & Module System (G11-MSM)"
type: "implementation"
status: "active"
owner: "Michał"
updated: "2026-05-19"
goal_id: "goal-g11"
---

# Implementation Plan: Modular SDK & Module System (Kernel/Userland Refinement)

## Purpose

Transform the current flat script architecture into a modular, manifest-driven "Plugin" system. This refinement moves toward a **Kernel/Userland** architecture where a stable core (Kernel) provides services to domain-specific modules (Userland) via a standardized SDK. This enables selective deployment, clean cloning, and self-healing autonomy.

## Scope

### In Scope
- **Kernel Core:** Create `core/registry.py` for dynamic module loading and dependency injection.
- **Autonomous SDK:** Build a standardized base class `BaseModule` and service wrappers (DB, Events, Logging).
- **Dynamic API Bridge:** Modify `G04_digital_twin_api.py` to auto-mount module routers.
- **Unified Entry Point:** Create `run.py` as a shim for all script executions to handle paths and circuit breaking.
- **Shadow Mode:** Implement a "read-only" validation state for new modules.
- **Phased Migration:** Transition all 8 domains into the new structure.
- **Config Centralization:** Move all logic-driving YAMLs (Autonomy, Experiments) to `/config`.

### Out of Scope
- Rewriting existing business logic.
- Replacing RabbitMQ or PostgreSQL.
- Changing n8n workflow logic (only API endpoints/paths might be updated).

## Strategy

The implementation uses a **zero-downtime, kernel-first** approach:

```
Timeline:
  May W3  ── Phase 0: SDK & Kernel Core  ← COMPLETED ✅
  May W4  ── Phase 1: Dynamic API Bridge ← COMPLETED ✅
  Jun W1  ── Phase 2: Shadow Modules      ← COMPLETED ✅
  Jun W2  ── Phase 3: Unified Runner     ← COMPLETED ✅
  Jun W3  ── Phase 4: Full Migration     ← Domain-by-domain activation
  May W3  ── Phase 5: SDK Consolidation  ← COMPLETED ✅ (Centralized Rules & Modular SDK)
```

## Procedure

### Phase 4: Full Migration (Domain-by-domain activation)
- [x] **Pantry (G03) migrated ✅**
- [x] **Health (G07) migrated ✅**
- [x] **Training (G01) migrated ✅**
- [x] **Learning (G06) migrated ✅**
- [x] **Logistics (G04) migrated ✅**
- [x] **Career (G09) migrated ✅**
- [x] **Home (G08) migrated ✅**
- [ ] **Finance (G05) migrated**

### Phase 5: SDK Hardening & Config Centralization (COMPLETED ✅ May 19)
1. **Consolidate SDK Stubs:** Moved full implementations of `G11_log_system` and `G11_event_emitter` into `autonomous_sdk/log.py` and `autonomous_sdk/events.py`. ✅
2. **Centralize Policy:** Moved `autonomy_policies.yaml` and `experiments.yaml` to `/config/` and updated `db_config.py` to provide a universal `POLICY_PATH`. ✅
3. **Bulk Refactor:** Updated all 298+ module scripts to use the SDK version of `db_config`. ✅
4. **Shim Deployment:** Replaced root `scripts/db_config.py` and `scripts/G11_log_system.py` with proxies to prevent breaking legacy crontabs/n8n. ✅
5. **Validation:** Verified `G11_rules_engine.py` correctly evaluates centralized policies via the modular SDK. ✅

## Failure Modes

| Scenario | Detection | Response |
|----------|-----------|----------|
| Module Import Conflict | Registry logs `ImportError` on startup | Skip failing module; Keep core API alive |
| Dependency Loop | Registry detects circular `depends_on` | Error on startup; require manual fix |
| Shadow Mode Bypass | Audit script finds direct `psycopg2` calls | Reject module; enforce SDK usage |
| SDK Version Mismatch | System Sanity Auditor fails | Rollback to last stable SDK commit |

## Security Notes

- **Isolation:** Modules only access their declared `databases`.
- **RBAC:** API routers in modules inherit the core's JWT/API-Key security.
- **Config Protection:** `/config/` directory is restricted and backed up separately.

## Owner + Review Cadence

- **Owner:** Michał
- **Review Cadence:** Weekly
- **Next Review:** May 26, 2026
