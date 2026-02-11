---
title: "G10: Automated Career Intelligence - Execution State"
type: "goal_execution"
status: "active"
goal_id: "goal-g10"
owner: "Michał"
updated: "2026-02-07"
---

# G10 Automated Career Intelligence - Execution State

## Current Context
**Phase:** Planning (Metrics & Data Sources)
**Milestone:** Initial career data sources integrated and metrics defined by Feb 28
**Strategic Context:** Proactive career positioning and skill development for future AI-driven market

---

## 🟢 NEXT (Ready for Morning)

- [ ] **Define key career metrics to track** `G10-T01` `60m` `@planning` `#p1`
  - Identify metrics like skill proficiency, project impact, networking activity
  - Establish measurable targets for each metric
  - Align metrics with desired career path and roles

---

## 🔵 READY (Dependencies Met, Available)

- [ ] **Integrate initial career data sources** `G10-T02` `90m` `depends:G10-T01` `@automation` `#p1`
  - Set up data ingestion for LinkedIn profile data (e.g., connections, posts)
  - Integrate data from project repositories (e.g., GitHub contributions)
  - Establish pipeline for professional event tracking
  - Document all integrated data sources

- [ ] **Develop structured data model for career data** `G10-T03` `75m` `depends:G10-T02` `@deep-work` `#p1`
  - Design schema for career-related information in S03 (Data Layer)
  - Ensure model supports skill tracking, project history, and networking
  - Define relationships between different career entities

- [ ] **Set up basic career progress dashboards** `G10-T04` `60m` `depends:G10-T03` `@observability` `#p2`
  - Create dashboards in S01 (Observability) to visualize career metrics
  - Develop initial reports on skill development and project impact
  - Configure alerts for significant changes in career-related data

---

## ⚪ BLOCKED (Waiting on Dependencies)

- [ ] **Begin feeding career data into G12 (Meta-System)** `G10-T05` `depends:G10-T04` `@integration` `#p2`
- [ ] **Expand data sources to include job market trends** `G10-T06` `depends:G10-T05` `@research` `#p3`

---

## ✅ DONE (Recently Completed)

- [x] **Initial career strategy defined** `G10-T00` `45m` `@strategic` `#p1` ✓2025-01-15 ⏱️45m
  - Clarified long-term career goals
  - Identified target industries and roles
  - Outlined initial skill development areas

---

## Intelligence Notes
- **Foundational Goal:** Provides essential insights for personal and professional growth.
- **Integration with G12:** Key contributor to the holistic personal growth insights in the Meta-System.
- **Automation Potential:** High leverage for automating data collection and analysis.
- **Strategic Importance:** Enables proactive adaptation to market changes and skill demands.