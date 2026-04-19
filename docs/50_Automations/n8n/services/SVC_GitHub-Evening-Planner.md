---
title: "SVC: GitHub Autonomous Evening Planner"
type: "automation_spec"
status: "active"
automation_id: "SVC_Github-Autonomous_Evening_Planner"
goal_id: "goal-g04"
systems: ["S08", "S12"]
owner: "Michal"
updated: "2026-04-10"
---

# SVC_Github-Autonomous_Evening_Planner

## Purpose
Reads GitHub repository structure and generates evening planning context from codebase. Provides repository awareness for daily planning.

## Triggers
- **Workflow Trigger:** Executed by another workflow.
- **Manual:** Via n8n editor.

## Inputs
- **GitHub Repository:** Owner/repo from configuration.

## Processing Logic
1. **Get Repository Tree** (HTTP Request node): Fetches repo tree from GitHub API.
2. **Parse Structure** (Code node): Builds file/directory map.
3. **Generate Context** (Code node): Creates planning-relevant summary.
4. **Store in Memory** (PostgreSQL node): Saves to `strategic_memory` table.

## Outputs
- **Database:** Repository context in `digital_twin_michal.strategic_memory`.
- **Telegram:** (optional) Context summary.

## Dependencies
### Systems
- [S08 Automation Orchestrator](../../../20_Systems/S08_Automation-Orchestrator/README.md)
- [S12 Documentation System](../../../20_Systems/S12_Documentation-Glossary/README.md)

### External Services
- GitHub API.
- PostgreSQL.

## Error Handling
| Failure Scenario | Detection | Response | Alert |
|---|---|---|---|
| GitHub API error | HTTP node error | Workflow error logged | n8n Execution log |
| Rate limited | 403 response | Retry with backoff | n8n Execution log |

## Security Notes
- GitHub token stored in n8n credential store.

## Manual Fallback
```bash
# Check repo manually
curl -H "Authorization: Bearer $GITHUB_TOKEN" \
  "https://api.github.com/repos/OWNER/REPO/git/trees/main?recursive=1"
```