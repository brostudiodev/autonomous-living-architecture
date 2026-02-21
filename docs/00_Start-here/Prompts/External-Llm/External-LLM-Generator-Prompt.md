---
title: "External LLM: Documentation Generator Prompt"
type: "prompt"
status: "active"
owner: "{{OWNER_NAME}}"
updated: "2026-02-07"
---

# External LLM Documentation Generator Prompt (copy/paste)

## Role
You are writing documentation for the `autonomous-living` repository.

## Hard requirements
1. Always refer to goals using `goal-gXX` (example: `goal-g01`). Never output `goal-01`.
2. Output must be ready to paste into files (no commentary).
3. If information is missing, write `TBD` (do NOT invent details).
4. Use relative links between docs (no absolute filesystem paths).
5. Canonical docs go under `docs/**`. (Auto-generated daily logs in `goal-gXX/Activity.md` are out of scope.)
6. Never include secrets.
7. Always output a patch snippet that adds the new item(s) to the goal traceability matrix in `{{GOAL_DIR}}/Systems.md`.

## Naming conventions
- Goals: `goal-gXX` (e.g., `goal-g01`)
- n8n workflow IDs: `WFnnn__descriptive-name` (3 digits, lowercase + hyphens)
  - Example: `WF001__daily-goals-sync`
- Script IDs (Python, bash, etc.): `lowercase-with-hyphens`
  - Example: `calorie-workout-tracker`
- Home Assistant automation IDs: `lowercase-with-hyphens`
  - Example: `pantry-alerts`

## Output format (strict)
- Produce one or more sections.
- Each section must start with: `FILE: <relative/path>`
- Immediately after that line, output the full file contents.
- Do not output any other text.

## Document templates (required)

### 1) Automation spec (`*.md`)
Use this exact structure:

---
title: "{ID}: {Name}"
type: "automation_spec"
status: "active"
automation_id: "{ID}"
goal_id: "goal-gXX"
systems: ["SXX", "SYY"]
owner: "{{OWNER_NAME}}"
updated: "YYYY-MM-DD"
---

# {ID}: {Name}

## Purpose
TBD

## Triggers
- TBD

## Inputs
- TBD

## Processing Logic
1. TBD

## Outputs
- TBD

## Dependencies
### Systems
- TBD

### External Services
- TBD

### Credentials (names only)
- TBD

## Error Handling
TBD

## Monitoring
TBD

## Manual Fallback
TBD

## Test Procedure
TBD

## Related Documentation
- Goal Systems: `{{GOAL_DIR}}/Systems.md`
- TBD

### 2) Script skeleton (`*.py`)
- Minimal scaffolding only (TODO markers)
- Explicit CLI args
- Explicit exit codes
- Basic logging

### 3) Home Assistant YAML (`*.yaml`)
- Minimal scaffolding only (TODO markers)
- No secrets

### 4) SOP (`docs/30_Sops/*.md`)
Use this structure:

---
title: "{Name}"
type: "sop"
status: "active"
goal_id: "goal-gXX"
owner: "{{OWNER_NAME}}"
updated: "YYYY-MM-DD"
---

# {Name}

## Purpose
TBD

## Trigger / Frequency
TBD

## Inputs
- TBD

## Steps
1. TBD

## Outputs
- TBD

## Failure modes / escalation
- TBD

## Related Documentation
- Goal Systems: `{{GOAL_DIR}}/Systems.md`
- TBD

### 5) Runbook (`docs/40_Runbooks/*.md`)
Use this structure:

---
title: "{Name}"
type: "runbook"
status: "active"
goal_id: "goal-gXX"
owner: "{{OWNER_NAME}}"
updated: "YYYY-MM-DD"
---

# {Name}

## Common failure scenarios
- TBD

## Symptoms & detection
- TBD

## Quick diagnosis
```bash
# TBD
```

## Resolution steps
1. TBD

## Prevention & monitoring
- TBD

## Related Documentation
- Goal Systems: `{{GOAL_DIR}}/Systems.md`
- TBD

## Systems.md.patch format (required)
Additionally, you must always generate a file:
- `{{GOAL_DIR}}/Systems.md.patch`

That file must contain ONLY:
- One markdown table row (no header, no commentary)

The row must have exactly 4 columns:
`Outcome | System | Automation | SOP/Runbook`

Rules:
- Use the request fields: `TRACE_OUTCOME`, `TRACE_SYSTEM`, `TRACE_AUTOMATION_REF`, `TRACE_SOP_RUNBOOK_REF`.
- Automation/SOP/Runbook cells must be relative markdown links when known; otherwise `TBD`.

## Input format you will receive
The user will paste a filled block like this:

DOCUMENTATION REQUEST
DOC_KIND: one of [goal_project | automation_n8n | automation_script | automation_home_assistant | sop | runbook]
TODAY: YYYY-MM-DD
OWNER: {{OWNER_NAME}}

GOAL
GOAL_ID: goal-gXX
GOAL_CODE: GXX
GOAL_NAME: <human name>
GOAL_DIR: docs/10_Goals/GXX_<Goal-Dir-Name>
SYSTEMS: [SXX, SYY]

TRACEABILITY (for updating {{GOAL_DIR}}/Systems.md)
TRACE_OUTCOME: <which outcome this doc supports>
TRACE_SYSTEM: <SXX>
TRACE_AUTOMATION_REF: <relative link to automation doc OR 'TBD'>
TRACE_SOP_RUNBOOK_REF: <relative link(s) OR 'TBD'>

(Then additional fields depending on DOC_KIND)

## What you must generate
Depending on DOC_KIND:

### automation_n8n
Generate exactly 3 files:
- `docs/50_Automations/n8n/workflows/{{AUTOMATION_ID}}.md`
- `docs/50_Automations/n8n/workflows/{{AUTOMATION_ID}}.json` (placeholder export if not provided)
- `{{GOAL_DIR}}/Systems.md.patch`

### automation_script
Generate exactly 3 files:
- `docs/50_Automations/scripts/{{AUTOMATION_ID}}.md`
- `docs/50_Automations/scripts/{{AUTOMATION_ID}}.py` (skeleton if not provided)
- `{{GOAL_DIR}}/Systems.md.patch`

### automation_home_assistant
Generate exactly 3 files:
- `docs/50_Automations/home-assistant/{{AUTOMATION_ID}}.md`
- `docs/50_Automations/home-assistant/{{AUTOMATION_ID}}.yaml` (skeleton if not provided)
- `{{GOAL_DIR}}/Systems.md.patch`

### sop
Generate exactly 2 files:
- `docs/30_Sops/{{SOP_NAME}}.md`
- `{{GOAL_DIR}}/Systems.md.patch`

### runbook
Generate exactly 2 files:
- `docs/40_Runbooks/{{RUNBOOK_NAME}}.md`
- `{{GOAL_DIR}}/Systems.md.patch`

### goal_project
Generate exactly 2 files:
- `{{GOAL_DIR}}/projects/{{PROJECT_ID}}_{{PROJECT_NAME}}.md`
- `{{GOAL_DIR}}/Systems.md.patch`
