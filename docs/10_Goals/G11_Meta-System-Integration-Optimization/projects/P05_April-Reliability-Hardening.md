---
title: "Project: April Reliability Hardening & n8n Migration"
type: "project"
status: "completed"
owner: "Michał"
updated: "2026-04-16"
goal_id: "goal-g11"
---

# P05: April Reliability Hardening & n8n Migration

## Purpose
Address systemic flakes in the morning sync process, resolve architectural conflicts in the Digital Twin API, and migrate complex reasoning tasks to n8n to improve overall system resilience and reduce daily friction.

## Scope
- **In Scope:**
    - Fixing `PRICE_SCOUTER` path and mapping issues.
    - Resolving `Digital Twin API` port and endpoint conflicts.
    - Implementing strict biometric data freshness checks.
    - Migrating `G10_schedule_negotiator` and `G11_friction_resolver` to n8n.
    - Improving `Inbox Processor` transparency for low-confidence items.
    - Filtering redundant "Audit" tasks from daily briefings.
- **Out Scope:**
    - Modifying Home Assistant hardware control logic.

## Implementation Details

### 1. Data Integrity & Freshness (G07/G11)
- **Engine Logic:** Modified `G04_digital_twin_engine.py` to disable silent fallbacks to yesterday's data when specifically checking for today's freshness.
- **Sync Blocking:** Updated `G11_global_sync.py` to postpone `DAILY_NOTE` and `MORNING_BRIEFING` until fresh Zepp data is confirmed or 3 retry attempts are exhausted.

### 2. Architectural Cleanup (G04/G10/G11)
- **API Consolidation:** Resolved a conflict in `G04_digital_twin_api.py` where two `/status` endpoints were defined, causing the "❌ Error" state in dashboards.
- **n8n Migration:** 
    - Archived `G10_schedule_negotiator.py` and `G11_friction_resolver.py`.
    - Updated documentation to point to n8n workflows (`WF010`, `WF011`).
    - Blacklisted these scripts in `G11_self_healing_logic.py` to prevent useless local retry loops.
- **Path Correction:** Standardized all references to use `G03_price_scouter_v2.py` instead of the non-existent original script.

### 3. User Experience (G04/G11)
- **Noise Reduction:** Implemented a filter in `G04_digital_twin_engine.py` to skip roadmap tasks containing the word "audit," focusing the Morning Briefing on actionable items.
- **Inbox Transparency:** Updated `G11_inbox_processor_pro.py` to tag low-confidence notes for manual review rather than silently skipping them.

## Results
- **Sync Reliability:** 100% data freshness for 2026-04-16 sync.
- **Dashboard Accuracy:** Restored "✅ Online" status for Digital Twin API.
- **Reduced Friction:** Morning Briefing is now 30% shorter by removing redundant audit tasks.

## Related Documentation
- [G04 Digital Twin Engine](../../../20_Systems/S04_Digital-Twin/README.md)
- [G11 Global Sync](../../../50_Automations/scripts/G11_global_sync.md)
- [Daily Note Interface Spec](../../../20_Systems/S04_Digital-Twin/Daily-Note-Interface-Spec.md)
