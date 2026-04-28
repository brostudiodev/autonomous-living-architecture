---
title: "G09: Relationship Harvester"
type: "automation_spec"
status: "active"
owner: "Michał"
goal_id: "goal-g09"
updated: "2026-04-28"
---

# G09: Relationship Harvester

## Purpose
Automates social logging by correlating Google Calendar events with the Relationships database. It eliminates the friction of manual "Last Contact" updates by recognizing meeting names and participants.

## Scope
### In Scope
- Fetching today's events from the Primary Google Calendar.
- Matching event titles/descriptions against names in the `relationships` table.
- Updating `last_contact_date` for matched individuals.
- Logging successful discoveries to `system_activity_log`.

### Out of Scope
- Syncing from Google Sheets (handled by `G04_relationships_sync.py`).
- Automatic contact (messaging) people.

## Inputs/Outputs
### Input
- **Source:** Google Calendar API (via `G10_calendar_client`).
- **Reference:** PostgreSQL `autonomous_life_logistics.public.relationships`.

### Output
- **Target:** PostgreSQL `relationships` table (`last_contact_date` column).
- **Audit:** `system_activity_log`.

## Procedure
### Manual Execution
```bash
python3 G09_relationship_harvester.py
```

## Logic
1. Fetch all people from the DB.
2. Fetch today's calendar events.
3. For each event, check if any person's name (case-insensitive) appears in the title or description.
4. If found, update the database record for that person with today's date.

## Integration
- **Orchestrator:** `autonomous_daily_manager.py` (runs in parallel).
- **Synergy:** Works with `G04_relationship_sentinel.py` to prevent false reminders for people recently met.

## Owner + Review Cadence
- **Owner:** Michał
- **Review:** Bi-weekly.
---
