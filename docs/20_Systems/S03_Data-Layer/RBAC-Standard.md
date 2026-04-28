---
title: "Data Layer: Role-Based Access Control (RBAC) Standard"
type: "standard"
status: "active"
owner: "Michał"
updated: "2026-04-21"
goal_id: "goal-g11"
---

# PostgreSQL RBAC Standard (Shield Mode)

## Purpose
Eliminate the risk of privilege escalation by migrating all services away from the `root` superuser. This standard ensures that even if a service (like n8n or an API) is compromised, the attacker cannot delete the entire database cluster or access unauthorized domains.

## Scope
- **In Scope:** PostgreSQL User/Role creation, Schema-level permissions (GRANTs), and Default Privilege automation.
- **Out Scope:** Firewall/Network rules (handled in Docker Standard).

## 1. Identity Matrix

### Functional Roles (Permissions Containers)
These roles do not log in; they represent "sets of abilities."

| Role | Permissions | Use Case |
| :--- | :--- | :--- |
| `role_observer` | `SELECT` on all tables/sequences | Dashboards, read-only monitoring |
| `role_archivist` | `CRUD` on domain tables | Data synchronization scripts |
| `role_brain` | `CRUD` on Digital Twin tables | AI logic, Decision logging |

### Service Users (Login Credentials)
These users inherit the roles above.

| User | Inherits | Primary System |
| :--- | :--- | :--- |
| `dt_api_agent` | `role_observer`, `role_brain` | Digital Twin API |
| `dt_sync_worker` | `role_archivist` | Python Sync Scripts |
| `dt_grafana` | `role_observer` | Grafana Dashboards |
| `dt_n8n_orchestrator`| `role_observer`, `role_archivist`, `role_brain` | n8n Workflows |

## 2. Standard Assignment Procedure

To apply this standard to a new database (e.g., `autonomous_finance`), use the following logic:

### The "Shield" Function (Conceptual)
1. **Schema Usage:** Grant `USAGE` on the `public` schema to all roles.
2. **Read Access:** Grant `SELECT` on all existing tables to `role_observer`.
3. **Write Access:** Grant `INSERT, UPDATE, DELETE` on all existing tables to `role_archivist`.
4. **Sequence Access:** Grant `USAGE, SELECT` on all sequences (required for auto-increment IDs).
5. **Auto-Hardening:** Alter **Default Privileges** so that any tables created in the future automatically inherit these permissions.

## 3. Implementation Checklist
- [ ] Create Global Roles and Users.
- [ ] Apply "Shield" to `autonomous_finance` (Phase 1).
- [ ] Apply "Shield" to remaining 7 databases.
- [ ] Update `.env` and `db_config.py` with service user credentials.
- [ ] Disable `root` login for non-administrative tasks.

## Failure Modes
| Scenario | Detection | Response |
| :--- | :--- | :--- |
| Permission Denied | Script fails with `403` / `Insufficient Privileges` | Re-run Assignment Procedure for the specific table |
| Password Leak | Unauthorized login attempt | Rotate service user password; roles remain intact |

## Security Notes
- Passwords MUST be unique per service user.
- The `postgres` (root) password must be stored offline in a secure vault.
