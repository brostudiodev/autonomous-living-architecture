---
title: "G09: Automated Career Intelligence"
type: "goal"
status: "active"
goal_id: "goal-g09"
owner: "Michal"
updated: "2026-04-08"
review_cadence: "quarterly"
---

# G09: Automated Career Intelligence

## 🌟 What you achieve
*   **Skill-Market Fit:** Automatically track your technical skills against market demand to identify what to learn next.
*   **Portfolio Automation:** Your GitHub contributions and project wins are automatically logged for future resume updates.
*   **Network Insights:** Keep track of key professional contacts and when you last engaged with them.
*   **Strategic Growth:** Move from "working a job" to "engineering a career" with data-backed decision support.

## Purpose
Build an automated system for tracking career growth, skill development, professional network, and market opportunities. Integrate with certifications (G06), recognition (G02), and the Meta-System to provide career decision support.

## Scope
### In Scope
- Career metrics tracking (skills, projects, networking)
- LinkedIn profile integration
- Project repository analysis
- Skill gap analysis
- Learning opportunity identification
- Integration with G06 certifications
- Integration with G02 recognition

### Out of Scope
- Job application automation
- Salary negotiation tools
- Professional services marketplace

## Intent
Build an automated system for tracking career growth, skill development, and professional network intelligence.

## Definition of Done (2026)
- [ ] Key career metrics defined
- [ ] Initial data sources integrated
- [ ] Data ingestion pipelines established
- [ ] Data model in S03 defined
- [ ] Dashboards in S01 set up
- [ ] Integration with G12 Meta-System

## Inputs
- LinkedIn profile data
- GitHub repository metrics
- Project contributions
- Certification progress (G06)
- Professional events

## Outputs
- Career progress dashboards
- Skill gap analysis
- Learning recommendations
- Network insights
- Integration with G12 Meta-System

## Dependencies
### Systems
- S01 Observability (dashboards)
- S03 Data Layer (storage)
- S08 Automation Orchestrator
- G02 Automationbro Recognition
- G06 Certification Exams
- G12 Meta-System

### External
- LinkedIn API
- GitHub API
- Job board APIs (future)
- Learning platforms

## Key Links
- Outcomes: [Outcomes.md](Outcomes.md)
- Metrics: [Metrics.md](Metrics.md)
- Systems: [Systems.md](Systems.md)
- Roadmap: [Roadmap.md](Roadmap.md)
- Activity Log: [Activity-log.md](Activity-log.md)

## Procedure
1. **Monthly:** Review career metrics
2. **Quarterly:** Update skill assessment
3. **After certifications:** Update G06 integration
4. **After content:** Update G02 integration

## Failure Modes
| Scenario | Detection | Response |
|----------|-----------|----------|
| API rate limit | LinkedIn/GitHub returns 429 | Backoff, use cached data |
| Data stale | No updates in 30 days | Manual refresh, check tokens |

## Security Notes
- LinkedIn data is public - no sensitive info
- GitHub tokens stored securely
- Keep career data private

## Owner & Review
- **Owner:** Michal
- **Review Cadence:** Quarterly
- **Last Updated:** 2026-02-16

---

## ☕ Fuel the Architecture

Building and maintaining this level of technical rigor is a massive investment. If this blueprint helps your own engineering journey, I would be grateful for your support.

<a href='https://ko-fi.com/michalnowakowski' target='_blank'><img height='60' style='border:0px;height:60px;' src='https://storage.ko-fi.com/cdn/kofi3.png?v=3' border='0' alt='Buy Me a Coffee at ko-fi.com' /></a>

**Support my hard work in engineering a fully autonomous life.** Every coffee fuels another line of code, another automated insight, and another step toward the 2026 North Star. Your contributions help maintain the infrastructure and research shared in this open-source blueprint.
