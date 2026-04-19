---
title: "Adr-0016: Event-Driven Architecture"
type: "decision"
status: "accepted"
date: "2026-02-25"
deciders: ["Michal"]
---

# Adr-0016: Event-Driven Architecture

## Status
Accepted

## Context
The system initially relied on polling (scripts running on crontab) to detect changes in the database or external state. This created latency and unnecessary database load. To enable real-time responses (e.g., instant Telegram alerts when a pantry item is removed), the system needs to move to an event-driven model.

## Decision
We implement a real-time event loop using PostgreSQL `LISTEN/NOTIFY`:
1.  **Triggers:** Database triggers on core tables (pantry, workouts) issue a `NOTIFY` command on change.
2.  **Listener:** A dedicated daemon (`G04_digital_twin_listener.py`) listens for these events.
3.  **Action:** The listener routes events to the appropriate notifier or handler.

## Consequences
- **Positive:** Near-zero latency for critical alerts. Reduced database polling load.
- **Negative:** Adds a long-running daemon process that needs monitoring (S01).

## Implementation
- Implemented in `G04_digital_twin_listener.py`.
- Triggers defined in `autonomous_pantry_schema.sql` and others.
