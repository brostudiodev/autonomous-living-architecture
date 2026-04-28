---
title: "Automation: Friction & Failure Intelligence (G11)"
type: "automation"
status: "active"
owner: "Michał"
updated: "2026-04-21"
goal_id: "goal-g11"
---

# Friction & Failure Intelligence (G11)

## Purpose
Systematically capture, analyze, and resolve operational friction and script failures to prevent time leaks and maintain Level 5 Autonomy.

## Scope
- **In Scope:** Manual "ouch" logging via Telegram/API, failure pattern matching, auto-resolution proposals, and lock-file management.
- **Out Scope:** Complex hardware failure physical repairs.

## Inputs/Outputs
- **Inputs:** 
    - `/ouch <note>` command (Manual)
    - `system_activity_log` FAILURE entries (Automated)
    - `failure_knowledge_base` (Static Patterns)
- **Outputs:**
    - `friction_log` entries (DB)
    - Triage/Decision proposals (for approval)
    - Telegram notifications with 💡 auto-resolution tips.

## Dependencies
- **Systems:** [S03 Data Layer](../../20_Systems/S03_Data-Layer/README.md), [S04 Digital Twin](../../20_Systems/S04_Digital-Twin/README.md)
- **Scripts:** `G11_log_system.py`, `G11_failure_resolver.py`, `G11_setup_friction_db.py`, `G04_digital_twin_api.py`
- **Database:** `digital_twin_michal` (PostgreSQL)

## Procedure

### 1. Database Setup (One-time or Migration)
```bash
python3 scripts/G11_setup_friction_db.py
```

### 2. Manual Friction Logging
- Send `/ouch <description>` to the Telegram bot.
- Domain and severity default to `general` and `3` respectively.

### 3. Adding Failure Resolutions
Insert new patterns into the `failure_knowledge_base` table:
```sql
INSERT INTO failure_knowledge_base (error_pattern, resolution_type, resolution_payload) 
VALUES ('.*database.*locked.*', 'command', 'sudo service postgresql restart');
```

## Failure Modes

| Scenario | Detection | Response |
|----------|-----------|----------|
| Unknown Failure | No match in KB | Notify user via Telegram as standard FAILURE |
| DB Connection Loss | Exception in log_activity | Fallback to console print; Trigger G11_db_recovery_shield |
| Recursive Auto-fix | Loop detection | Knowledge base success_count stops after N failures |

## Security Notes
- Database credentials managed via central `db_config.py`.
- No sensitive keys stored in the `failure_knowledge_base`.

## Owner + Review Cadence
- **Owner:** Michał
- **Review Cadence:** Monthly during System Audit.
