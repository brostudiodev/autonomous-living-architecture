---
title: "G09: Roadmap"
type: "goal_roadmap"
status: "active"
owner: "Michał"
updated: "2026-04-12"
goal_id: "goal-g09"
---

# Roadmap (2026)

## Q1 (Jan–Mar)
- [x] Define key career metrics to track (e.g., skill proficiency, project impact, networking activity) ✅
- [x] Integrate initial data sources (e.g., LinkedIn profile, project repositories, professional events) ✅
- [x] Establish data ingestion pipelines for continuous career data collection ✅ (G09_career_sync.py)
- [x] Develop a structured data model for career-related information in S03 (Data Layer) ✅ (autonomous_career DB)
- [x] Set up basic dashboards in S01 (Observability) for career progress monitoring ✅
- [x] Begin feeding career data into G12 (Meta-System) for holistic personal growth insights ✅ (Implemented via G11 Mapper)

## Q2 (Apr–Jun) - Career Agent Implementation Phase

> [!tip] 🚀 **Q2 Focus: Implement n8n Career Agent**
- [ ] **System Stability Audit:** Verify career tracking working reliably
  - [ ] **Sub-task: Career Sync Check** - Ensure skill/progress data syncs to DB
  - [ ] **Sub-task: Dashboard Check** - Verify career dashboards show accurate data

> [!tip] 🚀 **Missing n8n Agent Implementation**
- [ ] **n8n Career Agent:** Implement native n8n agent for LinkedIn/Substack automation
  - [ ] **Sub-task: Agent Design** - Create n8n workflow with LangChain for career domain
  - [ ] **Sub-task: LinkedIn Integration** - Connect to LinkedIn API for posting/messaging
  - [ ] **Sub-task: Substack Integration** - Connect to Substack for article scheduling
  - [ ] **Sub-task: Content Generator** - LLM-powered content generation from system data

- [/] Expand data sources: job market trends, target role requirements
- [x] Implement skill gap analysis based on target role specifications ✅ (Mar 06 - G09 AI Analyzer)
- [x] Automated system for identifying relevant learning opportunities (G06) ✅ (Mar 06 - G09 AI Analyzer)
- [/] **Active Track:** Six Sigma Yellow Belt (Targeting Q2 completion)
- [/] **Active Track:** AI Architect devstyle (Starts Mar 30)
- [x] Create automated reports on career growth and development areas
- [x] LinkedIn profile integration and professional profile maintenance
- [x] **Relationship Harvesting v1.0:** Deployed `G09_relationship_harvester.py` with bidirectional discovery (Google Calendar events + Obsidian Daily Journal scanning). ✅ (Apr 25)
- [x] **Autonomous Career Strategist Deployed:** Launched `G09_career_strategist.py` to link Learning (G06) progress with Skill Inventory and Market Demand. ✅ (2026-04-27)
- [x] **Market Pulse Integration:** Upgraded `G09_market_scout_handler.py` to autonomously update market demand in PostgreSQL from n8n data. ✅ (2026-04-27)
- [x] **Strategic Content Loop:** Integrated career advice into `G13_content_idea_generator.py` to drive high-value brand content. ✅ (2026-04-27)

## Q3 (Jul–Sep)
- [ ] AI-driven personalized career path recommendations
- [ ] Automated networking intelligence system for connection identification
- [ ] Implement automated resume/portfolio generation from project logs
- [ ] Automated follow-up sequences for networking and applications
- [ ] Integrate with G02 (Automationbro) for tracking public impact

> [!tip] 🚀 **NEW: Relationship Intelligence Subsystem**
> **Gap:** #1 predictor of happiness/longevity - currently 0% tracked. G09 extends to personal relationships.
- [ ] **Relationship Database:** Track important people in your life
  - [ ] **Sub-task: Contact Schema** - Name, relationship type, last contact, next check-in
  - [ ] **Sub-task: Relationship Types** - Family, Friend, Colleague, Mentor, Client
  - [ ] **Sub-task: Importance Score** - Rate relationship importance (1-10)
- [ ] **Interaction Logging:** Automated capture of meaningful interactions
  - [ ] **Sub-task: Daily Prompt** - "Who did you connect with today?"
  - [ ] **Sub-task: Quality Rating** - How fulfilling was the interaction?
  - [ ] **Sub-task: Duration Tracking** - Time spent with each person
- [ ] **Relationship Health Dashboard:** Proactive maintenance reminders
  - [ ] **Sub-task: Decay Alerts** - "You haven't contacted X in 14 days"
  - [ ] **Sub-task: Birthday Reminders** - Never miss important dates
  - [ ] **Sub-task: Social Energy Map** - Visualize who energizes vs. drains you
- [ ] **Social Capital Tracking:** Build and maintain your network strategically
  - [ ] **Sub-task: Network Size Metrics** - Total contacts, active relationships
  - [ ] **Sub-task: Support Network Mapping** - Who can you lean on for what
  - [ ] **Sub-task: Reciprocity Score** - Balance of giving vs. receiving

## Q4 (Oct–Dec)
- [ ] Achieve comprehensive predictive career intelligence system
- [ ] Finalize integration of G09 as core data contributor to G12
- [ ] Document lessons learned and strategy for 2027 career development
- [ ] Establish continuous validation and improvement mechanisms for insights

## Dependencies
- **Systems:** S01 (Observability for dashboards), S03 (Data Layer for storage/processing), S08 (Automation Orchestrator for data collection)
- **External:** LinkedIn API, job board APIs, learning platform APIs, GitHub API
- **Other goals:** G02 (Automationbro Recognition) for public profile, G06 (Certification Exams) for skill validation, G12 (Meta-System) for holistic personal growth.