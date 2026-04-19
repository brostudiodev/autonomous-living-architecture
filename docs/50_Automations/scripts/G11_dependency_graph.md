---
title: "G11_dependency_graph.py: Script Execution Order"
type: "automation_spec"
status: "active"
automation_id: "G11_dependency_graph"
goal_id: "goal-g11"
systems: ["S11"]
owner: "Michal"
updated: "2026-04-18"
---

# G11: Script Execution Dependency Graph

## Purpose
Defines the hierarchical structure of script execution within the G11 Meta-System. It ensures that data providers run before analysis tools, and analysis tools run before final reporting consumers.

## Tiered Architecture
- **Tier 0 (Providers)**: External sync scripts (Pantry, Zepp, Withings, Google Tasks, ActivityWatch).
- **Tier 1 (Transformers)**: Local domain analysis (Finance Categorizer, Training Sync, Mood Engine, Task Triage).
- **Tier 2 (Consumers)**: Higher-order logic and reporting (Digital Twin Engine, Mission Control, Decision Proposer, Global Sync).

## Logic
1. **Tier Mapping**: Assigns each known script to a tier.
2. **Ordered Execution**: Provides a flattened list of scripts in their optimal execution sequence.
3. **Fallback**: Defaults unknown scripts to Tier 1 to maintain system integrity.

---
*Related Documentation:*
- [G11_global_sync.md](G11_global_sync.md)
- [G11_self_healing_supervisor.md](G11_self_healing_supervisor.md)
