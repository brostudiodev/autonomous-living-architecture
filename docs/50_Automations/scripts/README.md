---
title: "Scripts"
type: "index"
status: "active"
owner: "Michał"
updated: "2026-05-23"
---

# Scripts

## Purpose
Small, reliable utilities that n8n/HA/scheduled jobs can call.

## Scope
### In Scope
- Production script specs for `modules/<domain>/scripts/`.
- Legacy/proxy script specs where the root `scripts/` file is still an active compatibility entry point.
- Operational documentation for inputs, outputs, dependencies, failure modes, and review cadence.

### Out of Scope
- Runtime logs, generated JSON logs, temporary one-off debugging files, and service data.
- Specs for scripts that have been archived or replaced unless the doc is explicitly marked `legacy`.

## Standards
- Idempotent where possible
- Logs are explicit and use `autonomous_sdk.log` / structured logging where possible.
- Exit codes matter.
- Document inputs/outputs in a matching `.md` under this directory.
- New production logic belongs in `modules/<domain>/scripts/`; do not add new production features to root `scripts/`.
- Every spec should include the GDS sections: Purpose, Scope, Inputs/Outputs, Dependencies, Procedure, Failure Modes, Security Notes, Owner + Review Cadence.
- If a spec has `script_hash`, keep it synchronized with the active script.

## Current Audit Snapshot
As of the 2026-05-23 G12 audit:
- Active Python scripts/proxies scanned: 543
- Canonical scripts checked for spec freshness: 295
- Script documentation files: 438
- Missing script specs: 0
- Stale script specs: 0
- Specs with placeholders/TBD: 0
- Legacy/proxy basename collisions: 248, caused by root compatibility proxies plus modular implementations
- Active orphan script docs: 0

See [G12 Documentation Audit Report](../../G12_Documentation_Audit_Report.md) for the current generated detail.

## Update Procedure
1. Locate the active implementation in `modules/<domain>/scripts/`.
2. Check whether a same-named root `scripts/` file is only a proxy or still contains logic.
3. Update or create `docs/50_Automations/scripts/<script_name>.md`.
4. Include concrete inputs, outputs, dependencies, failure modes, security notes, and review cadence.
5. Regenerate the G12 audit report with `.venv/bin/python modules/docs/scripts/G12_documentation_audit.py`.

## Quick Links
- **[Coding Patterns & Standards](Coding-Patterns.md)** - Mandatory patterns for all new scripts
- **[db_config.py](db_config.md)** - Centralized database configuration (Migrated 2026-04-09)

---

## ☕ Fuel the Architecture

Building and maintaining this level of technical rigor is a massive investment. If this blueprint helps your own engineering journey, I would be grateful for your support.

<a href='https://ko-fi.com/michalnowakowski' target='_blank'><img height='60' style='border:0px;height:60px;' src='https://storage.ko-fi.com/cdn/kofi3.png?v=3' border='0' alt='Buy Me a Coffee at ko-fi.com' /></a>

**Support my hard work in engineering a fully autonomous life.** Every coffee fuels another line of code, another automated insight, and another step toward the 2026 North Star. Your contributions help maintain the infrastructure and research shared in this open-source blueprint.
