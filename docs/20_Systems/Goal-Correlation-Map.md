---
title: "Goal Correlation Map & Data Flow"
type: "architecture"
status: "active"
owner: "Michał"
updated: "2026-04-27"
---

# Goal Correlation Map & Data Flow

## Purpose

This document describes how all 12 Power Goals (G01-G12) and the Meta-System integrate through G04 (Digital Twin) as the central nervous system. The goal is to show that the autonomous living system is not 12 isolated components, but one interconnected organism where data flows between domains enable intelligent, cross-domain decision-making.

**Why this matters:** Before granting autonomous authority to any domain, the system must understand how changes in one area affect others. This map documents those relationships.

---

## Scope

### In Scope
- G01-G12 goal integration via Digital Twin
- Cross-domain data flows and correlations
- Daily/weekly automated cycles
- Meta-System (G11) orchestration patterns
- Documentation dependencies

### Out of Scope
- Technical implementation details (see Low-Level-Design.md)
- Specific API endpoints (see S04_Digital-Twin/API-Specification.md)
- Individual goal Roadmaps (see 10_Goals/GXX/Roadmap.md)

---

## The Connected Ecosystem: Diagram

```
                                    ┌──────────────────────────────────────┐
                                    │         G04 DIGITAL TWIN            │
                                    │    (Central Nervous System)        │
                                    │         Connects ALL Goals          │
                                    └──────────────┬───────────────────────┘
                                                   │
         ┌────────────────────────────────────────┼────────────────────────────────────────┐
         │                    │                    │                    │                  │
         ▼                    ▼                    ▼                    ▼                  ▼
┌─────────────────┐  ┌─────────────────┐  ┌─────────────────┐  ┌─────────────────┐  ┌─────────────────┐
│  G07 HEALTH     │  │  G05 FINANCE    │  │  G10 PRODUCTIVITY│  │  G03 HOUSEHOLD  │  │  G09 CAREER     │
│  (Readiness)    │◄─┤  (Budget)        │  │  (Energy)        │  │  (Pantry)       │  │  (Skills)       │
└────────┬────────┘  └────────┬────────┘  └────────┬────────┘  └────────┬────────┘  └────────┬────────┘
         │                    │                    │                    │                    │
         │                    │                    │                    │                    │
         ▼                    ▼                    ▼                    ▼                    ▼
    ┌─────────┐         ┌─────────┐          ┌─────────┐          ┌─────────┐         ┌─────────┐
    │G01 Body │         │G01 Body │          │G07      │          │G05      │         │G02 Brand│
    │Training │◄───────►│Diet     │          │Readiness│◄────────►│Groceries│◄───────►│Content  │
    └─────────┘         └─────────┘          └─────────┘          └─────────┘         └─────────┘
                                                                         │
                                          ┌─────────────────────────────┘
                                          │
                                          ▼
                                    ┌───────────┐
                                    │ G08 SMART │◄──── G07 Sleep Quality
                                    │ HOME      │
                                    └───────────┘
```

---

## Data Flow: The Morning Decision Cycle

```
5:00 AM - G07 (Health) syncs biometric data (Zepp → DB)
    │
    ▼
5:05 AM - G04 (Digital Twin) reads readiness score
    │
    ├──► "Readiness is 85/100" → G10 (Productivity)
    │       └──► Schedule optimized for deep work
    │
    ├──► "Sleep was 7h" → G01 (Training)
    │       └──► High-intensity workout suggested
    │
    └──► Health dashboard updated for G11 (Meta)
            └──► Morning briefing generated with ALL context
```

---

## Correlation Matrix

| Goal | Feeds Into | Receives From | Primary Correlation |
|------|------------|---------------|---------------------|
| **G01 Body** | G05, G07 | G05, G07, G10 | Training affects diet budget; readiness affects workout intensity |
| **G02 Brand** | G09 | G09, G10, G11 | Career content builds brand; requires productivity time |
| **G03 Household** | G05, G11 | G01, G05, G10 | Training diet → grocery needs; budget → shopping |
| **G04 Digital Twin** | ALL | ALL | Central hub - receives and distributes all data |
| **G05 Finance** | G11 | G01, G03, G07 | Training costs, groceries, health supplements |
| **G06 Learning** | G09, G11 | G10 | Schedule affects study time; career growth |
| **G07 Health** | G01, G08, G10, G11 | G08 | Sleep → readiness → schedule/training |
| **G08 Smart Home** | G07, G11 | G07 | Bedroom environment → sleep quality → health |
| **G09 Career** | G02, G11 | G02, G10 | Brand builds career; productivity enables growth |
| **G10 Productivity** | ALL | G07, G05, G09 | Readiness, budget, career all affect daily plan |
| **G11 Meta** | ALL | ALL | Orchestrates and monitors everything |
| **G12 Docs** | - | ALL | Documents all changes |

---

## Practical Example: Friday Night Decision

**Scenario:** Friday night, approaching weekend, readiness lower (72/100)

```
G07 (Health) → "Readiness lower today"
    │
    ▼
G04 (Digital Twin) → Correlates with late bedtime (G08 data)
    │
    ▼
G10 (Productivity) → "Switch to recovery mode?"
    │
    ├──► G01 (Training) → De-prioritize HIT workout
    ├──► G03 (Pantry) → Boost recovery food priority
    ├──► G08 (Home) → Set up early sleep environment
    └──► G11 (Meta) → Log decision → "Weekend recovery protocol"
```

---

## Daily Automated Cycles

### Morning Cycle (4:00 - 7:00 AM)

| Time | System Action | Involved Goals |
|------|---------------|----------------|
| **4:00 AM** | G11 Global Sync | G07, G05, G03 |
| **4:30 AM** | G07 Health Processing | G07 → G04 → G10 |
| **5:00 AM** | Daily Note Created | G10 → G12 |
| **6:15 AM** | Morning Briefing | G04 → G11 |

### Evening Cycle (6:00 - 10:00 PM)

| Time | System Action | Involved Goals |
|------|---------------|----------------|
| **6:00 PM** | Evening Manager | G11 orchestrates all |
| **6:30 PM** | Tomorrow Planner | G10 → G04 → G01 |
| **8:00 PM** | AI Journal Generator | G10 → G12 |
| **9:00 PM** | Pre-Bed Advisor | G08 ← G07 |

---

## Failure Modes

| Scenario | Detection | Response |
|----------|-----------|----------|
| G07 health sync fails | G11 system_health check | Retry 3x, fallback to cached data |
| G05 budget breach during low readiness | Cognitive penalty rule | Halve autonomy thresholds |
| Cross-domain correlation breaks | G11 dependency graph | Alert + manual review |
| G04 API slow/unavailable | Health check endpoint | Fallback to direct DB |

---

## Dependencies

**Systems:**
- [S03 Data Layer](../20_Systems/S03_Data-Layer/README.md)
- [S04 Digital Twin](../20_Systems/S04_Digital-Twin/README.md)
- [S08 Automation Orchestrator](../20_Systems/S08_Automation-Orchestrator/README.md)

**Credentials:**
- PostgreSQL (dt_sync_worker)
- Redis cache
- Telegram Bot API

---

## Owner + Review Cadence

- **Owner:** Michał
- **Review Cadence:** Monthly (with Roadmap updates)
- **Last Updated:** 2026-04-27

---

## Cross-References

- [Roadmap Overview](../10_Goals/README.md)
- [Low-Level-Design](./Low-Level-Design.md)
- [Architecture Diagrams](./Architecture-Diagrams.md)
- [S04 Digital Twin README](../20_Systems/S04_Digital-Twin/README.md)
- [G11 Meta-System Roadmap](../10_Goals/G11_Meta-System-Integration-Optimization/Roadmap.md)