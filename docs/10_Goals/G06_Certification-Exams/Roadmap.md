---
title: "G06: Roadmap"
type: "goal_roadmap"
status: "active"
owner: "Michal"
updated: "2026-04-19"
goal_id: "goal-g06"
---

# Roadmap (2026)

## Q1 (Jan–Mar)
- [x] Identify target certifications ✅ (AWS, AI/ML, Six Sigma)
- [x] Establish a structured study plan with measurable milestones ✅ (Feb 24)
- [x] Integrate study progress tracking into Digital Twin (G06_learning_sync.py) ✅ (Feb 24)
- [x] Six Sigma Yellow Belt (Started Sep 2025, in progress)
- [x] AI Architect Class (Devstyle) - Starts Mar 30, 2026
- [x] Define learning data model in dedicated 'autonomous_learning' DB ✅ (Feb 24)
- [x] Set up monitoring dashboards in Digital Twin (v_learning_progress) ✅ (Feb 24)
- [x] Schedule first certification exam (AWS)
- [x] Document learning resources and study strategies for future reference (G09)

- [x] **G06 Learning Architecture:** Automated Atomic Note generation and goal-linking from raw study logs ✅ (Mar 26)
- [x] **Unlimited Learning History Unlock (G06-UHU):** Standardized 3650-day lookback and removed data retrieval limits in the Learning Agent ✅ (Apr 19)

## Q2 (Apr–Jun) - Exam Preparation Phase

> [!tip] 🚀 **NEW: Learning Intelligence & Decay (Q3 Focus)**
- [ ] **Skill Decay Model (G06-SDM):** Proactive flags for learned concepts not applied in commits/logs for 30+ days.
- [ ] **Learning Effectiveness Tracker:** Link study session impact to actual project performance and retention.
- [ ] **Retention Audit Agent:** Monthly AI-generated "Retention Quiz" based on last month's atomic notes.

> [!tip] 🚀 **Q2 Focus: Complete Certification Exams**
- [ ] **System Stability Audit:** Verify study tracking working reliably
  - [ ] **Sub-task: Learning Sync Check** - Ensure study progress syncs to DB
  - [ ] **Sub-task: Progress Dashboard Check** - Verify dashboards show accurate data
- [ ] **Exam Execution:**
  - [ ] **Sub-task: AWS Architect Exam** - Complete preparation and take exam
  - [ ] **Sub-task: Results Analysis** - Analyze exam results, identify improvements
  - [ ] **Sub-task: G09 Update** - Update Career Intelligence with new certifications

- [/] Complete preparation and take the first wave of certification exams (AWS Architect)
- [/] Analyze exam results and identify areas for improvement
- [/] Adjust study strategies based on performance
- [/] Update G09 (Career Intelligence) with new certifications and skill data

> [!tip] 🚀 **NEW: Learning Effectiveness Tracking**
> **Gap:** G06 Metrics.md is empty - no actual learning effectiveness metrics defined.
- [ ] **Learning Effectiveness Database:** Create `learning_effectiveness` table
  - [ ] **Sub-task: Skill Tracking** - Log skills being learned with confidence levels (1-5)
  - [ ] **Sub-task: Application Tracking** - Track when skills are practically applied
  - [ ] **Sub-task: Retention Testing** - Periodic self-assessment scores
- [ ] **Skill Decay Model:** Create `skill_usage` table
  - [ ] **Sub-task: Usage Logging** - Track when skills are used in projects/work
  - [ ] **Sub-task: Decay Alerts** - Warn if skill not used in 30+ days
  - [ ] **Sub-task: Half-Life Report** - Calculate time-to-stale for each skill
- [ ] **Application Rate Dashboard:** Track % of learned skills applied in practice
- [ ] **Study Velocity Tracker:** Time-to-competency per skill area

## Q3 (Jul–Sep)
- [ ] Complete preparation and take the second wave of certification exams (AI/ML)
- [ ] Explore practical application of certified skills in projects (e.g., G04 updates)
- [ ] Network with professionals holding desired certifications
- [ ] Document project case studies showcasing newly acquired skills (G12)

## Q4 (Oct–Dec)
- [ ] Evaluate overall progress towards 2026 certification goals
- [ ] Document lessons learned and strategy for 2027 certification planning
- [ ] Ensure all certification data is captured in G09 (Career Intelligence)
- [ ] Provide a summary of new capabilities and expertise to G12 (Meta-System)

## Dependencies
- **Systems:** G11 (Productivity Time Architecture for study scheduling/tracking), G10 (Automated Career Intelligence for skill impact analysis)
- **External:** Exam providers, online learning platforms
- **Other goals:** G09 (Complete Process Documentation) for documenting study guides and exam strategies.