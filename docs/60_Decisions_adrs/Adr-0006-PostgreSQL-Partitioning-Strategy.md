---
title: "Adr-0006: PostgreSQL Partitioning Strategy"
type: "decision"
status: "proposed"
date: "2026-04-12"
deciders: ["Michał"]
---

# Adr-0006: PostgreSQL Partitioning Strategy

## Status
Proposed

## Context
As the Digital Twin aggregates more historical data (biometrics, transactions, logs), the primary tables in `digital_twin_michal` and `autonomous_finance` are expected to grow significantly. To maintain query performance and simplify data retention (archiving old data), a partitioning strategy is required.

## Decision
We will implement **Declarative Partitioning** by range (Time-based) for high-volume tables:
1.  `system_activity_log` (Partitioned by month)
2.  `biometrics` (Partitioned by year)
3.  `transactions` (Partitioned by year)

## Consequences
- **Performance:** Improved query speeds for recent data.
- **Maintenance:** Easier deletion of old data (dropping partitions).
- **Complexity:** Requires updates to migration scripts and schema management.

## Implementation
- Use PostgreSQL 16+ native partitioning.
- Update `db_config.py` if needed to handle partition routing (usually transparent).
