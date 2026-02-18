---
title: "G09: Automated Career Intelligence"
type: "goal"
status: "active"
goal_id: "goal-g09"
owner: "Michał"
updated: "2026-02-16"
review_cadence: "quarterly"
---

# G09: Automated Career Intelligence

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
- Activity Log: [ACTIVITY_LOG.md](ACTIVITY_LOG.md)

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
- **Owner:** Michał
- **Review Cadence:** Quarterly
- **Last Updated:** 2026-02-16
