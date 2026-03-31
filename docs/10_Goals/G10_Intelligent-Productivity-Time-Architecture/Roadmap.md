---
title: "G10: Roadmap"
type: "goal_roadmap"
status: "active"
goal_id: "goal-g10"
owner: "Michal"
updated: "2026-03-27"
---

# Roadmap (2026)

## Q1 (Jan–Mar)

### Calendar Management ✅
- [x] Basic calendar intent routing from main intelligence hub
- [x] Gemini 1.5 Pro-powered calendar agent with Polish language support
- [x] "Assume & Act" system - no confirmation dialogs
- [x] Integration with Google Calendar API for create/read operations
- [x] **Digital Focus Shielding (v1.0):** Automated Telegram alerts for manual DND during focus windows ✅ (Mar 23)

### Productivity System
- [x] Identify key productivity metrics (e.g., focus time, task completion) ✅ (Implemented in Master Brain)
- [x] Integrate initial data sources (e.g., calendar, DBs) ✅ (Feb 20)
- [x] Establish data ingestion pipelines for continuous productivity data collection ✅ (Feb 24)
- [x] Develop a structured data model for productivity and time allocation in S03 (Data Layer) ✅ (Feb 24)
- [x] Set up basic dashboards in S01 (Observability) for productivity trend monitoring ✅ (SQL Views created Feb 24)
- [x] Automated daily planning based on biological state & metrics ✅ (Feb 28)
- [x] Integration with evening planning workflow for next-day "Pre-Commitment" ✅ (Feb 28)
- [x] Begin feeding productivity data into G12 (Meta-System) ✅ (Implemented via G11 Mapper)

## Q2 (Apr–Jun)

> [!tip] 🚀 **High-Impact Autonomy Tasks**
> - [x] **Focus Mode Status Check** - Query HA sensors, lights, device status for deep work readiness (NO device control) ✅ (Mar 20)
> - [x] **Auto-fill "One thing to remember"** - AI generates daily insight from goals/decisions ✅ (Mar 20)
> - [x] **Foundation First Auto-Check** - Tomorrow's prep with calendar + tasks ✅ (Mar 20)
> - [x] **Daily Pattern Analysis** - Rule-based stats, flags, trends (no LLM) ✅ (Mar 20)
> - [x] **Journal Data Collection** - Complete daily context to JSON ✅ (Mar 20)
> - [x] **Weekly Rollup** - 7-day aggregation, trends, recommendations (no LLM) ✅ (Mar 20)
- [x] **Automated daily planning based on energy cycles** - AI schedules tasks by readiness score ✅ (Mar 23)
- [x] **Overdue Task Triage:** Proactive approval for deleting tasks > 7 days old ✅ (Mar 25)
- [x] **Smart List Hygiene:** Automated Google Tasks deduplication logic ✅ (Mar 25)
- [x] **Interactive Evening Reflection Prompts:** Automated question generation based on daily data logs ✅ (Mar 27)
- [/] **AI-driven focus/distraction pattern analysis** - Optimize when you work best
> 
> **Architecture:** System checks data → Triggers HA webhook if action needed → HA handles device control

### Calendar Management
- [x] Automated schedule optimization based on energy/pattern analysis
- [x] Support for event modification and deletion via Natural Language
- [x] Recurring event creation ("co środę o 19:00") ✅ (Mar 31)
- [/] Location intelligence (address validation and suggestions)

### Productivity System
- [x] Expand data sources: communication platforms (Slack, email activity) ✅ (Calendar/Task integration complete)
- [x] Implement AI-driven analysis of focus/distraction patterns (Claude API)
- [x] Automated daily planning based on energy cycles and constraints
- [x] Develop n8n workflows for automated time blocking and focus modes ✅ (G10_calendar_enforcer.py)
- [x] Home Assistant focus mode automation (lighting, DND mode) ✅ (G10_focus_enforcer.py)
> 
> **NEW: Evening Automation System** (Mar 27) - Complete daily journal workflow:
> - Journal Data Collector → Reflection Generator → Memory Generator → Foundation Checker → Daily Pattern Analyzer
> - Weekly Rollup with rule-based insights (no LLM)
> - See [SOP: Evening Automation System](../../30_Sops/Evening-Automation-System.md)

## Q3 (Jul–Sep) - Phase: Cognitive Load Balancing
- [ ] Implement AI "Schedule Negotiator" (Agent optimizes calendar based on energy)
- [ ] **Dynamic Load Balancing:** Automatically adjust schedule based on Amazfit Readiness Score
- [ ] Automated generation of daily/weekly productivity ROI reports
- [ ] Smart break management based on cognitive load indicators
- [ ] Integration with evening planning workflow for next-day "Pre-Commitment"

## Q4 (Oct–Dec)

### Calendar Management
- [ ] Performance optimization and cost reduction
- [ ] System reliability and edge case hardening

### Productivity System
- [ ] Achieve 40% increase in effective productive hours milestone
- [ ] Finalize integration of G10 as core data contributor to G12
- [ ] Document lessons learned and strategy for 2027
- [ ] Continuous validation and improvement mechanisms for insights

## Dependencies
- **Systems:** 
  - S01 (Observability for dashboards)
  - S03 (Data Layer for storage/processing)
  - S05 (Intelligent Routing Hub)
  - S08 (Personal Agents)
- **External:** 
  - Calendar APIs (Google Calendar, Outlook)
  - Task management APIs (Todoist, Asana)
  - Time tracking apps (Toggl, RescueTime)
  - Google Calendar API
  - Google Gemini API
- **Other goals:** 
  - G06 (Certification Exams) for study planning
  - G10 (Career Intelligence) for task prioritization
  - G12 (Meta-System) for holistic personal optimization
