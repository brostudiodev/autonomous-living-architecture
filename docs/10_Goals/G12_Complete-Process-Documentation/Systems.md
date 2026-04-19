---
title: "G12: Systems"
type: "goal_systems"
status: "active"
owner: "Michal"
updated: "2026-04-02"
goal_id: "goal-g12"
---

# Systems

## Enabling systems
- [S10 Daily Goals Automation](../../20_Systems/S10_Daily-Goals-Automation/README.md) - Documentation sync and integrity.
- [S11 Intelligence Router](../../20_Systems/S11_Meta-System-Integration/README.md) - System-wide coordination.

## Traceability (Outcome → System → Automation → SOP/Runbook)

| Outcome | System | Automation | SOP/Runbook |
|---------|--------|------------|-------------|
| Automated Process Specs | S10 Automation | [g12-auto-documenter.md](../../50_Automations/scripts/G12_auto_documenter.md) | - |
| System Documentation Audit | S10 Automation | [G12_documentation_audit.py](../../50_Automations/scripts/G12_documentation_audit.md) | - |
| Structural Integrity Verification | S11 Router | [G11_system_audit.py](../../50_Automations/scripts/G11_system_audit.md) | - |
| Automated Sync Reporting | S11 Router | [G11_global_sync.md](../../50_Automations/scripts/G11_global_sync.md) | - |
| Proactive Stale Doc Detection | S10 Automation | [G12_stale_docs_monitor.md](../../50_Automations/scripts/G12_stale_docs_monitor.md) | [SOP: Monthly Doc Audit](../../30_Sops/Monthly-Doc-Audit.md) |
| Broken Link Prevention | S10 Automation | [G12_link_maintainer.md](../../50_Automations/scripts/G12_link_maintainer.md) | - |

---
*Updated: 2026-04-02 by Digital Twin Assistant*
