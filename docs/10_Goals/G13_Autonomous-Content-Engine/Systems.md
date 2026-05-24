---
title: "G13: Systems"
type: "goal_systems"
status: "active"
owner: "Michal"
updated: "2026-05-23"
goal_id: "goal-g13"
---

# Systems

## Purpose
Map the Autonomous Content Engine outcomes to the concrete systems, scripts, and operating procedures that support them.

## Enabling Systems
- [S03 Data & Messaging Layer](../../20_Systems/S03_Data-Layer/README.md)
- [S04 Digital Twin](../../20_Systems/S04_Digital-Twin/README.md)
- [S08 Automation Orchestrator](../../20_Systems/S08_Automation-Orchestrator/README.md)
- [S09 Productivity Time](../../20_Systems/S09_Productivity-Time/README.md)
- [G02 Automationbro Recognition](../G02_Automationbro-Recognition/README.md)
- [G09 Automated Career Intelligence](../G09_Automated-Career-Intelligence/README.md)
- [G11 Meta-System Integration](../G11_Meta-System-Integration-Optimization/README.md)

## Inputs / Outputs
| Type | Source / Destination | Notes |
|---|---|---|
| Input | Goal `Activity-log.md` files | Main source for recent system wins |
| Input | `system_activity_log` | Reliability and ROI evidence for content |
| Input | G09 career strategy | Market and positioning context |
| Output | `Obsidian Vault/00_Inbox/Content Ideas/` | Harvest files |
| Output | `Obsidian Vault/00_Inbox/Content-Drafts/` | Unified draft agent output |
| Output | `Obsidian Vault/00_Inbox/LinkedIn Drafts/` | LinkedIn-specific generator output |
| Output | `Obsidian Vault/00_Inbox/Substack Drafts/` | Substack-specific generator output |
| Output | Google Tasks | Publishing tasks via G10 integration |

## Traceability
| Outcome | System | Automation | SOP / Runbook |
|---|---|---|---|
| Harvest work into content ideas | S04, G12 | [G13_content_idea_generator.md](../../50_Automations/scripts/G13_content_idea_generator.md) | Weekly content review |
| Draft platform-specific content | S08, n8n LLM bridge | [G13_content_draft_agent.md](../../50_Automations/scripts/G13_content_draft_agent.md) | Human review before publishing |
| Generate LinkedIn drafts | G02, S08 | [G13_linkedin_draft_generator.md](../../50_Automations/scripts/G13_linkedin_draft_generator.md) | G02 publishing cadence |
| Generate Substack drafts | G02, S08 | [G13_substack_draft_generator.md](../../50_Automations/scripts/G13_substack_draft_generator.md) | G02 publishing cadence |
| Create publishing tasks | G10, Google Tasks | [G13_substack_scheduler.md](../../50_Automations/scripts/G13_substack_scheduler.md) | Weekly content review |
| Monitor failures | G11 | `modules/content/module.py`, G11 activity logging | G11 system reliability review |

## Dependencies
- **Databases:** `autonomous_career`, `digital_twin_michal`
- **External Services:** n8n LLM bridge (`N8N_LLM_DRAFT_URL`), Google Tasks, Obsidian Vault
- **Environment Variables:** `N8N_LLM_DRAFT_URL`
- **Code Source of Truth:** `modules/content/`

## Failure Modes
| Scenario | Detection | Response |
|---|---|---|
| Content ideas directory missing | Script returns no output or logs filesystem error | Verify `VAULT_PATH` and recreate Inbox folders |
| n8n LLM bridge unavailable | HTTP timeout or non-2xx response | Retry after n8n health check; do not bypass centralized LLM policy |
| Drafts include sensitive data | Manual review or content sanity check | Reject draft and update prompt/context filters |
| Google Tasks scheduling fails | Scheduler returns false / G11 failure log | Check G10 Google Tasks auth and scheduler dependency |

## Security Notes
- Do not include secrets, raw credentials, private finance details, or medical details in public drafts.
- Do not call LLM providers directly from new G13 scripts; use the n8n bridge.
- Keep generated drafts in Obsidian as review artifacts until approved.

## Owner + Review Cadence
- **Owner:** Michal
- **Review Cadence:** Monthly
