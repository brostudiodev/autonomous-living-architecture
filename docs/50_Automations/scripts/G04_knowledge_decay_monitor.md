---
title: "G04: Knowledge Decay Monitor"
type: "automation_spec"
status: "active"
automation_id: "G04_knowledge_decay_monitor"
goal_id: "goal-g04"
systems: ["S04", "S11"]
owner: "Michal"
updated: "2026-03-12"
---

# G04: Knowledge Decay Monitor

## Purpose
Maintains the integrity of the Second Brain (Obsidian) by identifying "Orphaned" notes (no internal links) and "Dying" notes (active project notes not updated in >30 days).

## Triggers
- Scheduled: Part of the `autonomous_daily_manager.py` daily sync cycle.

## Inputs
- Filesystem: `Obsidian Vault` (Markdown files).

## Processing Logic
1. **Scan:** Iterate through all markdown files in the vault.
2. **Orphan Check:** Identify notes that contain zero `[[` wiki-link brackets.
3. **Decay Check:** For notes with `status: active` in YAML, compare the last modification time to current date.
4. **Alert:** Generate a summary of orphans and stale notes.

## Outputs
- Integrity report injected into the Digital Twin status.
- Activity log entry.

## Error Handling
| Failure Scenario | Detection | Response | Alert |
|---|---|---|---|
| Large Vault Timeout | Script takes >60s | Optimize scan or skip subfolders | Log Warning |
| Permission Denied | OS error | Log failure | Log Warning |
