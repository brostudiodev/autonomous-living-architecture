---
title: "G12_documentation_audit.py: System Compliance Auditor"
type: "automation_spec"
status: "active"
automation_id: "documentation-audit"
goal_id: "goal-g12"
systems: ["S11", "S12"]
owner: "Michal"
updated: "2026-02-24"
---

# G12_documentation_audit.py: System Compliance Auditor

## Purpose
Enforces the Documentation Standard by automatically auditing all 12 Goals and 12 Systems for file completeness, frontmatter accuracy, and link traceability.

## Triggers
- **Scheduled:** Daily (06:00 AM Weekdays / 09:00 AM Weekends) via `autonomous_daily_manager.py`.
- **Manual:** `python3 scripts/G12_documentation_audit.py`

## Inputs
- **Directory Structure:** `/docs/10_Goals` and `/docs/20_Systems`.
- **Validation Rules:** Required files list and frontmatter field list.

## Processing Logic
1. **Goal Audit:** Checks for README, Outcomes, Metrics, Systems, and Roadmap files in every `Gxx` folder.
2. **Frontmatter Check:** Validates mandatory YAML fields in READMEs.
3. **Traceability:** Scans `Systems.md` for broken relative links to other documentation.
4. **Roadmap Health:** Calculates Q1 completion percentages.

## Outputs
- **Audit Report:** [G12_Documentation_Audit_Report.md](../../G12_Documentation_Audit_Report.md).
- **Console Stats:** Summary of health percentage and error count.

## Dependencies
### Systems
- [S11 Meta-System Integration](../../20_Systems/S11_Meta-System-Integration/README.md)
- [S12 Complete Process Documentation](../../20_Systems/S12_Complete-Process-Documentation/README.md)

## Error Handling
| Failure Scenario | Detection | Response | Alert |
|---|---|---|---|
| Missing Folder | `FileNotFoundError` | Skip and log error | Console output |
| Broken Traceability | Regex link matching | Flag as ⚠️ in report | Audit Report Table |

## Monitoring
- **Health Metric:** "Overall Documentation Health" % in the generated report.
