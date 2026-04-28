---
title: "Life Expiry Sentinel (G04)"
type: "automation_spec"
status: "active"
owner: "Michał"
updated: "2026-04-19"
---

# Purpose
The **Life Expiry Sentinel** (`G04_life_sentinel.py`) is a proactive monitoring agent for critical life documents, asset maintenance, and appliance health. It eliminates the mental load of tracking expiry dates and maintenance schedules by autonomously alerting the user based on tiered urgency thresholds and a 90-day lookahead.

# Scope
- **In Scope:** Identity documents (Passport, ID), Asset maintenance (Car, Home), Health checkups, Subscriptions, Warranties, **Yearly Anniversaries (Birthdays, Wedding, etc.)**, **Appliance Maintenance (Cycles or Time-based)**.
- **Out Scope:** Daily tasks or calendar events without a specific `alert_threshold_days` or `maintenance_period_days`.

# Alert Threshold Logic
The sentinel uses a tiered escalation model based on days remaining until `due_date`, next anniversary occurrence, or maintenance due date:

| Tier | Window | Marker | Mission Weight |
|------|--------|--------|----------------|
| **EMERGENCY** | < 7 days or OVERDUE | 🚨 | 31 (Critical) |
| **CELEBRATION** | Within threshold (Anniv) | 🎁 | 21 (High) |
| **URGENT** | 8 - 30 days | ⚠️ | 21 (High) |
| **WARNING** | 31 - 90 days | ℹ️ | 11 (Standard) |

- **Anniversary Logic (NEW Apr 14):** Automatically calculates the next occurrence of a yearly event based on the `original_date` in the `anniversaries` table.
- **Appliance Maintenance Logic (NEW Apr 19):**
    - **Cycle-based:** Triggers `🚨 EMERGENCY` when `cycles_since_maintenance` exceeds `maintenance_threshold`.
    - **Time-based:** Triggers `⚠️ URGENT` 7 days before and `🚨 EMERGENCY` on the day of maintenance (based on `last_maintenance_date + maintenance_period_days`).
- **Filtering:** Items are only reported if `CURRENT_DATE + 90 days >= due_date`.

# Inputs/Outputs
- **Inputs:** `autonomous_life_logistics` and `anniversaries` (DB_LOGISTICS), `appliance_status` (DB_TWIN).
- **Outputs:** High-priority mission items for the `G11_mission_aggregator`.

# Dependencies
- **Systems:** S04 (Digital Twin), S11 (Meta-System), G04 (Logistics), G03 (Household Ops)
- **Database:** `autonomous_life_logistics`, `digital_twin_michal`

# Procedure
- Automatically executed as part of the daily sync via `autonomous_daily_manager.py`.
- Results are ranked with a base Weight of 11, boosted to 21 (Urgent) or 31 (Emergency).

# Failure Modes
| Scenario | Detection | Response |
|----------|-----------|----------|
| DB Connection Fail | Script logs error | Sentinel skips check; Mission Aggregator continues with other sources. |
| Missing Threshold | NULL value in DB | No alert sent (Expected behavior). |
| Overdue Item | `days_left < 0` | Marked as `🚨 EMERGENCY` and `OVERDUE` in the mission list. |

# Security Notes
- Accesses logistical metadata only.
- Database credentials stored in `.env`.

# Owner + Review Cadence
- **Owner:** Michał
- **Review:** Monthly (verify sync integrity between Google Sheets and DB)

---
*Updated: 2026-04-14 | Integrated yearly anniversary tracking logic.*
