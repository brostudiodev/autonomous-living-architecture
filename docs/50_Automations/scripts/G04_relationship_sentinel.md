---
title: "Relationship Sentinel (G04)"
type: "automation_spec"
status: "active"
owner: "Michał"
updated: "2026-04-02"
---

# Purpose
The **Relationship Sentinel** (`G04_relationship_sentinel.py`) ensures social consistency by autonomously monitoring the time since last contact with key individuals. It prevents meaningful relationships from fading due to neglect by injecting proactive reminders into the daily mission list.

# Scope
- **In Scope:** Individuals in the `relationships` table with a defined `desired_frequency_days`.
- **Out Scope:** General contacts or acquaintances without tracking requirements.

# Logic
- **Reminder Trigger:** `last_contact_date + desired_frequency_days <= CURRENT_DATE`.
- **Ranking:** High-priority alerts are ranked with Weight 6 in the `G11_mission_aggregator`.

# Inputs/Outputs
- **Inputs:** `relationships` table in the `autonomous_life_logistics` database.
- **Outputs:** Contact task alerts for the Golden Mission.

# Dependencies
- **Systems:** S04 (Digital Twin), S11 (Meta-System), G04 (Logistics)
- **Database:** `autonomous_life_logistics`

# Procedure
- Executed automatically as part of the morning sync.
- Reports are limited to the top 3 most overdue contacts to avoid overwhelming the daily list.

# Failure Modes
| Scenario | Detection | Response |
|----------|-----------|----------|
| Missing Frequency | `desired_frequency_days` is NULL | Person is skipped from monitoring. |
| Missing Last Date | `last_contact_date` is NULL | Person is skipped from monitoring. |

# Security Notes
- Read-only access to relationship metadata.

# Owner + Review Cadence
- **Owner:** Michał
- **Review:** Monthly (update contact list and frequencies)
