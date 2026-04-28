---
title: "G10: Roadmap"
type: "goal_roadmap"
status: "active"
goal_id: "goal-g10"
owner: "Michał"
updated: "2026-04-16"
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

## Q2 (Apr–Jun) - Optimization Phase

> [!tip] 🚀 **Q2 Focus: System Stability & Missing Agent Implementation**
- [ ] **System Stability Audit:** Verify productivity automations working reliably
  - [ ] **Sub-task: Evening Manager Check** - Ensure 18:00 workflow runs without errors
  - [ ] **Sub-task: Daily Manager Check** - Verify morning briefing triggers correctly
  - [ ] **Sub-task: Calendar Sync Check** - Test Google Calendar integration
- [x] **Missing n8n Agent Implementation:** ✅ (Apr 15)
  - [x] **Sub-task: n8n Productivity Agent** - Implement native n8n agent for calendar/task orchestration ✅ (Apr 15)
    - [x] **Sub-task: Agent Design** - Create n8n workflow with LangChain for productivity domain ✅ (Apr 15)
    - [x] **Sub-task: Calendar Integration** - Connect to Google Calendar API ✅ (Apr 15)
    - [x] **Sub-task: Tasks Integration** - Connect to Google Tasks API ✅ (Apr 15)
    - [x] **Sub-task: Smart Scheduling** - LLM-powered optimal time block suggestions ✅ (Apr 15)
- [ ] **Minor Features:**
  - [ ] **Sub-task: Location Intelligence** - Complete address validation for calendar events
  - [ ] **Sub-task: Focus Pattern Analysis** - Complete AI-driven analysis implementation

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
- [x] **Task Triage Pro (v1.0):** Energy-aware task categorization into URGENT_TODAY/BACKLOG/RECOVERY ✅ (Apr 01)
- [x] **Calendar Enforcer (v1.1):** Real-time synchronization of bio-optimized schedule to Google Calendar (Focus Shield) ✅ (Apr 01)
- [x] **Dynamic Load Balancing (G10-BFLB):** Automatically adjust schedule based on Amazfit Readiness Score ✅ (Apr 03)
- [x] **Weekly Productivity ROI Reporting:** Automated generation of weekly time-reclaimed and reliability reports ✅ (Apr 03)
- [x] **n8n Daily Briefings:** Calendar Brief, Tasks Brief, Morning Brief, Evening Planner workflows ✅ (Apr 10)
- [x] **PROJ_Training-Intelligence-System:** AI-powered workout and training insights ✅ (Apr 10)
- [x] **n8n Schedule Negotiator (G10-SN):** Migrated legacy Python script to n8n workflow for biometric-aware planning ✅ (Apr 16)
- [x] **Focus Intelligence Hardening:** Resolved `Path` and `BASE_DIR` errors in `G10_focus_intelligence.py`. Added robust absolute path logic for Docker compatibility. ✅ (Apr 25)
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

> [!note] ⚠️ **n8n Productivity Agent moved to Q2** - Implementation will happen in Q2 for optimization

> [!tip] 🚀 **Remaining Q3 Tasks:**
- [ ] Implement AI "Schedule Negotiator" (Agent optimizes calendar based on energy)
  - [ ] **Sub-task: Conversation Memory** - Store productivity queries in PostgreSQL for context
  - [ ] **Sub-task: Focus Pattern Analysis** - Use LLM to analyze when you're most productive
  - [ ] **Sub-task: Smart Scheduling** - Let LLM suggest optimal time blocks based on energy cycles
- [ ] Implement AI "Schedule Negotiator" (Agent optimizes calendar based on energy)
- [x] **Dynamic Load Balancing:** Automatically adjust schedule based on Amazfit Readiness Score ✅ (Apr 03)
- [x] **Automated generation of daily/weekly productivity ROI reports** ✅ (Apr 03)
- [ ] Smart break management based on cognitive load indicators
- [ ] Integration with evening planning workflow for next-day "Pre-Commitment"

> [!tip] 🚀 **ActivityWatch Integration (Digital Footprint)** ✅
> **Status:** Core infrastructure complete - collecting data
> **Gap:** G10 productivity optimization has blind spot - doesn't know actual screen time or interruption patterns.
> **Solution:** ActivityWatch running in Docker provides passive window/app tracking.
- [x] **ActivityWatch Docker Setup:** ✅ (Apr 16)
  - [x] **Sub-task: Docker Container** - ActivityWatch running in Docker ✅
  - [x] **Sub-task: Database Schema** - `activity_watch_events` table ready ✅
  - [x] **Sub-task: Sync Script** - `G10_activitywatch_sync.py` tested ✅
  - [x] **Sub-task: Watchers** - `aw-watcher-window` + `aw-watcher-afk` running ✅
- [ ] **Data Ingestion Pipeline:** Build automated sync
  - [ ] **Sub-task: n8n Workflow** - Create n8n workflow for scheduled ActivityWatch sync
  - [ ] **Sub-task: Hourly Sync** - Sync every hour to capture daily patterns
  - [ ] **Sub-task: Daily Brief Injection** - Add productivity stats to morning briefing
- [ ] **Productivity Analysis:**
  - [ ] **Sub-task: Daily Focus Report** - Calculate productive vs unproductive hours
  - [ ] **Sub-task: App Category Breakdown** - Development, Social, Entertainment, etc.
  - [ ] **Sub-task: Focus Score Calculation** - Score based on uninterrupted blocks
  - [ ] **Sub-task: Distraction Alerts** - Warn when entering unproductive apps
- [ ] **Dashboard & Visualization:**
  - [ ] **Sub-task: Daily Dashboard** - Real-time screen time in Obsidian
  - [ ] **Sub-task: Weekly Summary** - Productivity trends with ActivityWatch data
  - [ ] **Sub-task: Grafana Integration** - Visualize focus patterns over time
- [ ] **Distraction Pattern Analysis:** AI-powered insights
  - [ ] **Sub-task: Pattern Detection** - Identify time-of-day + app = distraction
  - [ ] **Sub-task: Prediction Model** - Warn before high-distraction periods
  - [ ] **Sub-task: Blocker Suggestions** - "Block Twitter 9-11am tomorrow"

## Q4 (Oct–Dec)

> [!tip] 🚀 **Full Productivity Autonomy**
- [ ] **Personal Productivity OS:** Unified productivity interface powered by n8n + LLM
  - [ ] **Sub-task: Natural Language Tasks** - Create tasks via chat ("Zaplanuj trening na jutro o 7")
  - [ ] **Sub-task: Autonomous Scheduling** - System auto-blocks focus time based on energy
  - [ ] **Sub-task: Context-Aware Reminders** - Smart notifications based on location/task

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
