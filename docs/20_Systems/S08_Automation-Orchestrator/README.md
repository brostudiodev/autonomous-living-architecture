---
title: "S08: Automation Orchestrator"
type: "system"
status: "active"
system_id: "system-s08"
owner: "Michal"
updated: "2026-04-08"
---

# S08: Automation Orchestrator

## Purpose
The execution engine for all autonomous tasks. Manages the lifecycle of scripts, workflows, and decision-making processes.

## Components
- **Master Sync:** `G11_global_sync.py`.
- **Daily Manager:** `autonomous_daily_manager.py`.
- **Decision Engine:** `G11_decision_proposer.py`, `G11_decision_handler.py`.
- **Self-Healing:** `G11_self_healing_logic.py`.

---
*Created: 2026-04-08 | Part of G11 Meta-System Integration*
