---
title: "G07: Weight & Body Composition Sync (DEPRECATED)"
type: "automation_spec"
status: "deprecated"
automation_id: "G07_weight_sync.py"
goal_id: "goal-g07"
systems: ["S03", "S07"]
owner: "Michał"
updated: "2026-04-15"
---

# G07: Weight & Body Composition Sync (DEPRECATED)

> [!danger] 🛑 **DEPRECATED**
> This script has been replaced by [G07_withings_direct_sync.md](./G07_withings_direct_sync.md). 
> 
> **Reason:** The original logic relied on a two-step sync (API → Sheets → DB) which introduced unnecessary latency and points of failure. The new script interacts directly with the Withings API.

## Purpose
(Legacy) Automates the transfer of weight and body fat data from the Withings Smart Scale (via Google Sheets) to the central PostgreSQL `autonomous_health` database. 

## Triggers
- **Manual only:** This script has been removed from the `G11_global_sync.py` registry.

## Manual Fallback
Do not use this script. Use `G07_withings_direct_sync.py` for health data synchronization.
