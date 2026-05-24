---
title: "S11: Meta Kernel"
type: "system_specification"
status: "active"
owner: "Michał"
updated: "2026-05-23"
---

# S11: Meta Kernel

The Meta Kernel is the orchestration layer that manages system discovery, module execution, and cross-domain stability.

## Key Components
- [Module Registry](../../S11_Meta_Kernel/README.md) (Internal)
- [Orchestrator](../../S11_Meta_Kernel/README.md) (Internal)
- [SyncGuard Utility](./SyncGuard-Utility.md)
- [Structured Logging Standard](../S01_Observability-Monitoring/Modular-Script-Logging-Standard.md)

## Automated Tools
- [G11_global_sync.py](../../50_Automations/scripts/G11_global_sync.md)
- [G11_system_audit.py](../../50_Automations/scripts/G11_system_audit.md)
- [G11_self_healing_logic.py](../../50_Automations/scripts/G11_self_healing_logic.md)
