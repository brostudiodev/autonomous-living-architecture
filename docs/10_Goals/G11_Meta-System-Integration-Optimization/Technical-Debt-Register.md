---
title: "Technical Debt Register"
type: "register"
status: "active"
owner: "Michał"
updated: "2026-04-25"
---

# Technical Debt Register (G11)

## 🎯 Purpose
To track, categorize, and prioritize architectural shortcuts, outdated dependencies, and system inconsistencies that hinder the goal of "Total Autonomy."

## 📊 Summary
| Category | High Priority | Medium Priority | Low Priority |
|----------|---------------|-----------------|--------------|
| **Dependencies** | 2 | 5 | 10 |
| **Security** | 1 | 2 | 0 |
| **Architecture** | 1 | 3 | 5 |

---

## 🛠 Active Tech Debt Items

| ID | Item | Category | Impact | Strategy | Status |
|----|------|----------|--------|----------|--------|
| **TD001** | Docker `:latest` tags | Dependency | Low reliability | Accepted for ease of mgmt | ✅ Accepted |
| **TD002** | Venv vs Docker Parity | Environment | High friction | Unified `requirements.txt` | ✅ Resolved |
| **TD003** | Missing script versioning | Maintenance | Hard tracking | Implement `__version__` | ✅ Resolved |
| **TD004** | Redis fallback logic | Architecture | Medium resilience | Standardize decorators | ✅ Resolved |
| **TD005** | G05 Ollama Hardware Gap | Hardware | Blocked goal | Upgrade RAM or cloud-offload | 🔴 Open |
| **TD006** | Hardcoded Home Paths | Architecture | Portability | Move to relative/ENV paths | 🔴 Open |
| **TD007** | Blocking API Endpoints | Architecture | Reliability | Implement Async/Celery tasks | 🔴 Open |
| **TD008** | Script DB User Mismatch | Security | Medium friction| Force `dt_sync_worker` in G10 | ✅ Resolved |

---

## 📅 Monthly Audit Procedure
1. Run `python3 scripts/G11_tech_debt_monitor.py`
2. Review the generated `Technical-Debt-Audit-Report.md`
3. Update the Register (this file) with new items.
4. Schedule "Debt Clearance" tasks for the following month.

---
## 🔗 References
- [Documentation Standard](../Documentation-Standard.md)
- [G11 Roadmap](./Roadmap.md)
