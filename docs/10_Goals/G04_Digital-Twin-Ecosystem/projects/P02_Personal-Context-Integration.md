---
title: "Project: Personal Context Integration"
type: "project"
status: "completed"
owner: "Michał"
created: "2026-04-25"
updated: "2026-04-25"
goal_id: "goal-g04"
---

# P02: Personal Context Integration

## Purpose
Establish a deep, document-based personal context layer for the Digital Twin. This allows AI agents to understand Michał's identity, history, professional preferences, and decision frameworks without manual prompting.

## Scope
- **In Scope**:
    - Creation of a structured "Personal" folder in Obsidian.
    - Implementation of core identity documents (Identity, CV, Work History, Hobbies, Health Baselines).
    - Database synchronization script (`G04_personal_context_sync.py`).
    - Integration into `G04_digital_twin_engine.py` and `G11_global_sync.py`.
- **Out Scope**:
    - Real-time editing of personal documents via the API.
    - Multi-user isolation (deferred to Q2 roadmap).

## Inputs/Outputs
- **Inputs**: Markdown files in `Obsidian Vault/99_System/Personal/`.
- **Outputs**: `personal_intelligence` table in `digital_twin_michal` database.

## Dependencies
- **Systems**: S03 (Data Layer), S04 (Digital Twin).
- **Files**: `G04_personal_context_sync.py`, `G04_tool_manifest.json`.

## Procedure
1. Update Markdown files in the Obsidian "Personal" folder.
2. The `G11_global_sync.py` script automatically triggers `G04_personal_context_sync.py` during the daily cycle.
3. The `DigitalTwinEngine` loads the latest data via `get_personal_status()`.

## Failure Modes
| Scenario | Detection | Response |
|----------|-----------|----------|
| JSON Serialization Error | `system_activity_log` shows FAILURE | Fixed via `json_serial` helper in sync script to handle date objects. |
| Missing Personal Folder | Sync script logs ERROR | Ensure the folder exists in the configured Obsidian path. |
| Port Conflict | API fails to start | Verify port settings in `.env` and `G04_digital_twin_api.py`. |

## Security Notes
- Personal documents may contain sensitive history; ensure the `Obsidian Vault` and database are only accessible via authenticated local/Docker channels.
- Database uses RBAC (Least Privilege) as per G11-SSH standards.

## Owner + Review Cadence
- **Owner**: Michał
- **Review Cadence**: Quarterly (aligned with Goal G04 review).
