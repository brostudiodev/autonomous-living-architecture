---
title: "G12: Roadmap"
type: "goal_roadmap"
status: "active"
owner: "Michal"
updated: "2026-03-28"
goal_id: "goal-g12"
---

# Roadmap (2026)

## Q1 (Jan–Mar)
- [x] Finalize Goal Documentation Standard (GDS) and ensure all existing goals conform
- [x] All 12 goal READMEs updated to follow Documentation Standard (2026-02-16)
- [x] Implement automated generation of `Activity-log.md` from daily logs (WF105 deployed in n8n, weekly Sundays 8PM)
- [x] Develop templates for Automation Specification (.md) for n8n, scripts, and Home Assistant
- [x] Establish version control and publishing workflow for documentation
- [x] Conduct initial audit of existing systems and automations against GDS (2026-02-16)
  - [x] All 12 system READMEs (S00-S11) updated to follow standard
  - [x] 2 legacy duplicate systems removed
  - [x] Automation specs verified (following template)
- [x] Integrate documentation status into G12 (Meta-System) for tracking completeness ✅ (Feb 24)
- [x] **Context Resumer (v1.5):** Enhanced with executable terminal commands for rapid mission resumption ✅ (Mar 23)
- [x] **AI Journaling Support:** Automated prompt generation injected into daily reflections ✅ (Mar 23)

## Q2 (Apr–Jun)
- [x] Document all existing critical systems (S00-S10) according to GDS (done 2026-02-16)
- [x] Update system READMEs (S00-S11) to follow Documentation Standard (done 2026-02-16)
- [x] Implement **G12 Auto-Documenter** script (uses Gemini to generate .md specs from code) ✅ (Mar 05)
- [x] Document all existing production automations (n8n, scripts, HA) ✅ (Mar 23)
- [x] **Interactive Architectural Diagrams:** Launched dynamic Mermaid.js connectivity map at `/map` ✅ (Mar 28)
- [x] Develop a system for auto-generating cross-references and links within documentation ✅ (Mar 06 - G12 Link Maintainer)
- [x] Implement a periodic review process for documentation accuracy and currency ✅ (Mar 23)
- [x] **Conduct Q2 audit of all goals against GDS (monthly)** ✅ (Mar 23)
- [x] Explore LLM-assisted documentation generation for routine tasks ✅ (Mar 23)

## Q3 (Jul–Sep)
- [ ] Develop a search and knowledge retrieval system for all documentation
- [ ] Establish a change management process for documentation updates
- [ ] Automate documentation deployment to a dedicated knowledge base (e.g., static site generator)
- [ ] **Conduct Q3 audit of all goals against GDS (monthly)**
- [ ] **Review and update all automation specifications**
- [ ] Integrate G09 insights into G12 (Meta-System) for knowledge accessibility

## Q4 (Oct–Dec)
- [ ] Achieve comprehensive and current documentation for all autonomous living systems
- [ ] Document lessons learned and strategy for 2027 documentation maintenance
- [ ] Ensure all documentation supports G12 (Meta-System) for holistic understanding
- [ ] **Conduct Q4 audit of all goals against GDS (monthly)**
- [ ] **Final documentation review and cleanup**
- [ ] Conduct a final audit of all documentation for completeness, accuracy, and adherence to GDS

## Dependencies
- **Systems:** S08 (Automation Orchestrator for publishing workflows), G12 (Meta-System for integration tracking)
- **External:** LLM APIs (for documentation assistance), static site generators (e.g., MkDocs)
- **Other goals:** All other goals depend on G09 for clear, consistent, and current documentation.
