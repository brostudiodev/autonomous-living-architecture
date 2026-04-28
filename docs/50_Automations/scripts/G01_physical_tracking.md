---
title: "G01: Streamlined Physical Tracking"
type: "automation_spec"
status: "active"
automation_id: "g01-physical-tracking"
goal_id: "goal-g01"
systems: ["S03", "S04"]
owner: "Michał"
updated: "2026-03-02"
review_cadence: "Monthly"
---

# G01 Physical Tracking

## Purpose
Standardizes the tracking of physical markers for the "Reach Target Body Fat" goal. Following a simplification pivot, the system now focuses exclusively on Body Weight, Waist Circumference, and Monthly Photos, removing complex bodybuilding-specific measurements to reduce friction and increase compliance.

## Scope
### In Scope
- Manual/Scale logging of body weight (kg).
- Manual logging of waist circumference (cm) every 15 days.
- Monthly progress photo status tracking.
- Visualization of waist/weight trends in the Digital Twin.

### Out of Scope
- Chest, Arms, Legs, and other bodybuilding metrics.
- Direct image storage in PostgreSQL (Obsidian handles photos).

## Triggers
- **Manual Input:** Data entered into the `physical_measurements` table via SQL or helper scripts.
- **Reporting:** Daily via `G04_digital_twin_engine.py`.

## Inputs
- **PostgreSQL (`autonomous_health`):**
    - `biometrics`: Source for body weight.
    - `physical_measurements`: Source for waist and photo status.

## Processing Logic
1.  **State Fetch:** The Digital Twin Engine queries the latest row from `physical_measurements`.
2.  **Trend Analysis:** Compares current weight/waist against the monthly baseline.
3.  **Insight Generation:** If the waist trend is stable but weight is up, it may suggest a calorie/water retention check. If the waist is down, it confirms fat loss regardless of weight.

## Outputs
- **Twin Insights:** Confirmation of "Physical Markers" in the daily intelligence report.
- **Obsidian Dashboard:** Dataview or Twin-API driven charts showing waist progress.

## Dependencies
### Systems
- [S03 Data Layer](../../20_Systems/S03_Data-Layer/README.md) - PostgreSQL persistence.
- [S04 Digital Twin](../../20_Systems/S04_Digital-Twin/README.md) - Analysis and reporting.

## Error Handling
| Failure Scenario | Detection | Response | Alert |
|---|---|---|---|
| Missing Entry | Query returns 0 rows | Prompt for measurement in `/suggested` | Telegram |
| Outlier Data | Logic check (e.g. Waist < 50cm) | Log warning and use previous valid entry | Console |

## Security Notes
- **Privacy:** Physical dimensions are strictly local and private. No cloud sync for raw measurement data.

## Related Documentation
- [Goal: G01 Reach Target Body Fat](../../10_Goals/G01_Target-Body-Fat/README.md)
- [Goal: G07 Predictive Health](../../10_Goals/G07_Predictive-Health-Management/README.md)
