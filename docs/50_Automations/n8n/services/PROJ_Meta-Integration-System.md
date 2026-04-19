---
title: "PROJ: Meta-Integration System (G11)"
type: "automation_spec"
status: "active"
automation_id: "PROJ_Meta-Integration-System"
goal_id: "goal-g11"
systems: ["S04", "S11"]
owner: "Michal"
updated: "2026-04-14"
---

# PROJ_Meta-Integration-System

## Purpose
The **Meta-Integration System** is the strategic "Chief of Staff" agent for the autonomous ecosystem. It monitors global system health, manages cross-domain decision requests, detects behavioral anomalies, and aggregates data into high-level mission directives. It ensures that the various domain agents work in harmony toward the 2026 North Star.

## Triggers
- **Sub-workflow:** Primary destination for Agent Zero (Supervisor) for complex, cross-domain inquiries.
- **Natural Language:** Responds to commands like `/meta`, `/sys`, or general status questions ("How is my system doing?").

## Inputs
- **Query:** Strategic or technical inquiry.
- **Metadata:** Session data and trace IDs for cross-service tracking.

## Processing Logic
1. **Multi-Stream Ingestion (PostgreSQL - digital_twin_michal):**
   - `Get Pending Decisions`: Fetches unresolved requests from `v_internal_decisions`.
   - `Get Anomalies`: Retrieves unacknowledged items from `behavioral_anomalies`.
   - `Get System Health`: Scans the `system_activity_log` for recent script failures.
   - `Get Daily Intelligence`: Pulls today's high-level AI synthesis.
2. **Global Context Construction:** Integrates health, decisions, anomalies, and intelligence into a master state snapshot.
3. **Intelligence Layer:** Google Gemini (Temp 0.15) analyzes the snapshot to identify the single most critical bottleneck or opportunity.
4. **Execution Dispatch:** Calls specialized tools if specific actions are requested (e.g., self-healing, mission aggregation).

## AI Agent Configuration
- **Role:** Ecosystem Strategist & System Architect (G11).
- **Model:** Google Gemini (Temp 0.15).
- **Tools:** 
    - `mission_aggregator`: Ranks priorities across all domains.
    - `system_reliability_auditor`: Calculates global success scores.
    - `stall_detector`: Identifies stagnant goals.

## Dependencies
### Systems
- [Meta-System Integration (G11)](../../../10_Goals/G11_Meta-System-Integration-Optimization/README.md)
- [Digital Twin Ecosystem (G04)](../../../10_Goals/G04_Digital-Twin-Ecosystem/README.md)

## Error Handling
| Failure Scenario | Detection | Response |
|----------|-----------|----------|
| Context Overload | Context > 32k tokens | Agent uses specialized summary tools to compress history. |
| DB Timeout | PostgreSQL node error | Supervisor (G11) attempts auto-restart of the DB container. |
| Tool Conflict | Concurrent tool calls | Implementation of strict LISTEN/NOTIFY locking (ADR-0016). |

## Security Notes
- **Authority:** High-level system control; sensitive execution requires dual-factor confirmation (ADR-0015).
- **Auditing:** Every decision analyzed is logged to the meta-audit trail.

---

*Documentation synchronized with PROJ_Meta-Integration-System.json v1.0 (2026-04-14)*
