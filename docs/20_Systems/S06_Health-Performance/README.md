---
title: "S06: Health & Performance"
type: "system"
status: "active"
system_id: "system-s06"
owner: "Michał"
updated: "2026-04-08"
---

# S06: Health & Performance

## Purpose
Manages the biological data lifecycle, from ingestion (Zepp/Withings) to actionable intelligence (Bio-Nutrition Agent, Recovery Adjustments).

## Key Components
- **Ingestion:** `G07_zepp_sync.py`, `G07_weight_sync.py`.
- **Analysis:** `G07_health_recovery_pro.py`, `G07_illness_detector.py`.
- **Action:** `G07_bio_nutrition_agent.py`, `G01_training_injector.py`.

## Data Model
Resides in `autonomous_health` and `autonomous_training` databases.

---
*Created: 2026-04-08 | Part of G11 Meta-System Integration*
