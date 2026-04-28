---
title: "Adr-0014: Centralized System Observability and ROI Tracking"
type: "decision"
status: "accepted"
date: "2026-03-08"
deciders: ["Michał", "Gemini CLI"]
consulted: []
informed: []
---

# Adr-0014: Centralized System Observability and ROI Tracking

## Status
Accepted

## Context
As the autonomous-living ecosystem grows to 12+ goals and dozens of scripts, it has become difficult to:
1.  **Quantify Value:** There is no empirical way to measure how much time the system is actually saving.
2.  **Monitor Health:** Identifying which script failed and why requires manual log checking across different Docker containers and cron jobs.
3.  **Ensure Consistency:** Different systems (Health, Finance, Pantry) have varying levels of reporting, making it hard for the Digital Twin (Agent Zero) to provide a unified "System Health" report.

## Decision
I will implement a centralized **System Activity Log** and **Autonomy ROI Tracker** within the `digital_twin_michal` database.

### **Architecture Pattern**
- **Unified Ledger:** All scripts report their execution status (SUCCESS/FAILURE) and time saved (ROI) to a central database.
- **Heartbeat Mechanism:** The Digital Twin API uses these logs to determine "System Freshness."
- **Standardized Logging:** A unified `log_activity` and `log_roi` method in the `DigitalTwinEngine`.

### **Technical Implementation**
```sql
-- System Activity Log
CREATE TABLE system_activity_log (
    id SERIAL PRIMARY KEY,
    script_name VARCHAR(100) NOT NULL,
    status VARCHAR(20) NOT NULL, -- 'SUCCESS', 'FAILURE', 'PARTIAL'
    items_processed INTEGER DEFAULT 0,
    details TEXT,
    logged_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Autonomy ROI
CREATE TABLE autonomy_roi (
    id SERIAL PRIMARY KEY,
    source VARCHAR(100) NOT NULL,
    category VARCHAR(50) NOT NULL,
    minutes_saved INT NOT NULL,
    details TEXT,
    logged_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
```

### **ROI Value Logic (Standardized)**
- **Logistics (G03):** 5m base + 1m per item discovered.
- **Finance (G05):** 2m per transaction successfully categorized.
- **Planning (G10):** 10m per mission briefing generated.

## Consequences

### **Positive Consequences**
- **Empirical Value:** Direct measurement of system ROI (Time Saved).
- **Faster Debugging:** AI Assistant can immediately identify and explain script failures.
- **Improved Reliability:** "Freshness" status is now based on actual execution logs.
- **Strategic Continuity:** Better historical context for Agent Zero to reason about system performance.

### **Negative Consequences**
- **Database Dependency:** Scripts now require connectivity to `digital_twin_michal` to log progress.
- **Execution Overhead:** Minor latency increase due to additional database writes.

## Implementation (Mar 08, 2026)
- ✅ **Database:** Tables created in `digital_twin_michal`.
- ✅ **Engine:** `DigitalTwinEngine` updated with `log_activity` and `log_roi`.
- ✅ **Orchestrator:** `G11_global_sync.py` now logs every heartbeat event.
- ✅ **Spokes:** G03, G05, and G10 integrated with ROI logging.

## Related Decisions
- [Adr-0004](./Adr-0004-Digital-Twin-Architecture.md) - Digital Twin as Central Hub
- [Adr-0010](./Adr-0010-Hub-and-Spoke-Integration.md) - Hub-and-Spoke Integration Pattern

---
*Last updated: 2026-03-08*
