---
title: "LLM Documentation Generator Prompt"
type: "prompt"
status: "active"
owner: "{{OWNER_NAME}}"
updated: "2026-02-07"
---

# LLM Documentation Generator Prompt (copy/paste)

## Instructions to the LLM
You are writing documentation for the `autonomous-living` repository.

Hard requirements:
1. Follow the structure and templates in `docs/10_GOALS/DOCUMENTATION-STANDARD.md`.
2. Always refer to goals using `goal-gXX` (example: `goal-g01`). Never output `goal-01`.
3. Use YAML frontmatter exactly as shown in the standard. Include `goal_id: "goal-gXX"` where applicable.
4. If information is missing, write `TBD` (do NOT invent details).
5. Output must be ready to paste into files.
6. Use relative links between docs (no absolute filesystem paths).
7. Keep “canonical truth” in `/docs/**`. Daily/auto-generated logs belong to `goal-gXX/ACTIVITY.md` and are not part of this request.
8. Always output a patch snippet that adds the new item(s) to the goal traceability matrix in `{{GOAL_DIR}}/Systems.md`.

Output format (strict):
- Produce one or more sections.
- Each section must start with: `FILE: <relative/path>`
- Immediately after that line, output the full file contents.
- Do not add commentary before/between/after files.

Example output skeleton:
FILE: docs/50_AUTOMATIONS/n8n/workflows/WF001__daily-goals-sync.md
---
...

FILE: docs/10_GOALS/G12_Meta-System-Integration-Optimization/projects/P01_Something.md
---
...

## What you will receive as input
I (the user) will paste a filled “Documentation Request” block.

## Documentation Request (template)
Copy this section, fill it, and send it to the LLM.

DOCUMENTATION REQUEST
DOC_KIND: one of [goal_project | automation_n8n | automation_script | automation_home_assistant | sop | runbook]
TODAY: YYYY-MM-DD
OWNER: {{OWNER_NAME}}

GOAL
GOAL_ID: goal-gXX
GOAL_CODE: GXX
GOAL_NAME: <human name>
GOAL_DIR: docs/10_GOALS/GXX_<Goal-Dir-Name>
SYSTEMS: [SXX, SYY]  # optional but preferred

TRACEABILITY (for updating {{GOAL_DIR}}/Systems.md)
TRACE_OUTCOME: <which outcome this doc supports>
TRACE_SYSTEM: <SXX>
TRACE_AUTOMATION_REF: <relative link to automation doc OR 'TBD'>
TRACE_SOP_RUNBOOK_REF: <relative link(s) OR 'TBD'>

IF DOC_KIND == goal_project
PROJECT_ID: PNN  # e.g. P01
PROJECT_NAME: <short name>
PROJECT_SUMMARY: <1-3 sentences>
SCOPE_INCLUDED:
- ...
SCOPE_EXCLUDED:
- ...
DEPENDENCIES:
- ...
LINKS:
- Automations: [WFnnn__name, ...]
- SOPs: [docs/30_SOPS/..., ...]
- Runbooks: [docs/40_RUNBOOKS/..., ...]
SUCCESS_METRICS:
- ...
RISKS_AND_FAILURE_MODES:
- ...
NEXT_STEPS:
- ...

IF DOC_KIND starts with automation_
AUTOMATION_ID:
- n8n example: WF001__daily-goals-sync
- script example: sync-daily-goals
- home assistant example: pantry-alerts
AUTOMATION_NAME: <human name>
CATEGORY_PATH:
- n8n: docs/50_AUTOMATIONS/n8n/workflows/
- scripts: docs/50_AUTOMATIONS/scripts/
- home assistant: docs/50_AUTOMATIONS/home-assistant/
TRIGGERS:
- ...
INPUTS:
- ...
PROCESSING_LOGIC:
1. ...
OUTPUTS:
- ...
DEPENDENCIES:
- Systems: ...
- External services: ...
- Credentials (names only): ...
ERROR_HANDLING:
- ...
MONITORING:
- ...
MANUAL_FALLBACK:
- ...
TEST_PROCEDURE:
- ...
RELATED_DOCS:
- ...

IF DOC_KIND == sop
SOP_NAME: <name>
SOP_TRIGGER_FREQUENCY: <trigger + frequency>
SOP_INPUTS:
- ...
SOP_STEPS:
1. ...
SOP_OUTPUTS:
- ...
SOP_FAILURE_MODES_ESCALATION:
- ...

IF DOC_KIND == runbook
RUNBOOK_NAME: <name>
SYMPTOMS:
- ...
QUICK_DIAGNOSIS_COMMANDS:
- ...
RESOLUTION_STEPS:
1. ...
PREVENTION_MONITORING:
- ...

## What the LLM must generate
Depending on DOC_KIND:

### goal_project
Generate exactly 2 files:
- `{{GOAL_DIR}}/projects/{{PROJECT_ID}}_{{PROJECT_NAME}}.md`
- `{{GOAL_DIR}}/Systems.md.patch`

### automation_n8n
Generate exactly 3 files:
- `docs/50_AUTOMATIONS/n8n/workflows/{{AUTOMATION_ID}}.md`
- `docs/50_AUTOMATIONS/n8n/workflows/{{AUTOMATION_ID}}.json` (placeholder export if not provided)
- `{{GOAL_DIR}}/Systems.md.patch`

### automation_script
Generate exactly 3 files:
- `docs/50_AUTOMATIONS/scripts/{{AUTOMATION_ID}}.md`
- `docs/50_AUTOMATIONS/scripts/{{AUTOMATION_ID}}.py` (skeleton if not provided)
- `{{GOAL_DIR}}/Systems.md.patch`

### automation_home_assistant
Generate exactly 3 files:
- `docs/50_AUTOMATIONS/home-assistant/{{AUTOMATION_ID}}.md`
- `docs/50_AUTOMATIONS/home-assistant/{{AUTOMATION_ID}}.yaml` (skeleton if not provided)
- `{{GOAL_DIR}}/Systems.md.patch`

### sop
Generate exactly 2 files:
- `docs/30_SOPS/{{SOP_NAME}}.md`
- `{{GOAL_DIR}}/Systems.md.patch`

### runbook
Generate exactly 2 files:
- `docs/40_RUNBOOKS/{{RUNBOOK_NAME}}.md`
- `{{GOAL_DIR}}/Systems.md.patch`

## Notes for the LLM
- Use the automation documentation template from `docs/10_GOALS/DOCUMENTATION-STANDARD.md`.
- For code files (`.py`, `.yaml`, `.json`) generate minimal viable scaffolding with TODO markers, not full implementations.
- Never include secrets.

## Systems.md.patch format (required)
The file `{{GOAL_DIR}}/Systems.md.patch` must contain ONLY:
1. One markdown table row that can be pasted into the Traceability table in `{{GOAL_DIR}}/Systems.md`.
2. No surrounding commentary.

The row must have 4 columns:
`Outcome | System | Automation | SOP/Runbook`

Rules:
- Use `TRACE_OUTCOME`, `TRACE_SYSTEM`, `TRACE_AUTOMATION_REF`, `TRACE_SOP_RUNBOOK_REF` from the request.
- The Automation and SOP/Runbook cells must be relative markdown links when known, otherwise `TBD`.
