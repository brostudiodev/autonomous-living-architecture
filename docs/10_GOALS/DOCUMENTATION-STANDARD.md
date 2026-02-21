---
title: "Goal Documentation Standard"
type: "standard"
status: "active"
owner: "{{OWNER_NAME}}"
updated: "2026-02-16"
---

# Goal Documentation Standard

## Quick Reference: Required Sections

All goal and system documentation MUST include:

| Section | Description |
|---------|-------------|
| **Purpose** | What capability does this system provide? |
| **Scope** | In Scope / Out of Scope |
| **Inputs/Outputs** | Data flow |
| **Dependencies** | Systems, Services, Hardware, Credentials |
| **Procedure** | Daily/Weekly/Monthly checklist |
| **Failure Modes** | Table: Scenario → Detection → Response |
| **Security Notes** | Access control, sensitive data handling |
| **Owner + Review Cadence** | Who owns it, when reviewed |

## Goal Identification
**Always use:** `goal-gXX` format (e.g., `goal-g01`, `goal-g12`)

### Folder Structure

docs/10_GOALS/ └── GXX_Goal-Name/ # Human-readable folder name (capitalized) ├── README.md # Entry point (goal brief + navigation) ├── Outcomes.md # Primary/secondary outcomes, constraints, non-goals ├── Metrics.md # KPIs, leading/lagging indicators, measurement methods ├── Systems.md # Traceability matrix (Outcome → System → Automation → SOP/Runbook) ├── Roadmap.md # Quarterly milestones + dependencies ├── PROGRESS_MONITOR.md # Milestone-level narrative (human-curated)
├── ACTIVITY_LOG.md # Auto-generated daily log (from sync script) └── projects/ # Optional: sub-projects (only when goal spawns multiple projects) ├── P01_Project-Name.md └── P02_Another-Project.md


### Execution Artifacts Structure

goal-gXX/ # e.g., goal-g01/, goal-g12/ ├── ACTIVITY.md # Auto-generated daily log (from sync script) └── artifacts/ # Optional: exports, screenshots, raw outputs ├── exports/ └── screenshots/


## File Templates

### README.md (Goal Entry Point)
```markdown
---
title: "GXX: Goal Name"
type: "goal"
status: "active"
goal_id: "goal-gXX"
owner: "{{OWNER_NAME}}"
updated: "YYYY-MM-DD"
---

# GXX: Goal Name

## Intent
What outcome am I actually buying here (not vanity metrics)?

## Definition of Done (2026)
- [ ] Measurable target achieved
- [ ] System(s) running reliably
- [ ] Monitoring in place
- [ ] Runbooks exist for likely failures

## Key Links
- Outcomes: [Outcomes.md](Outcomes.md)
- Metrics: [Metrics.md](Metrics.md)
- Systems: [Systems.md](Systems.md)
- Roadmap: [Roadmap.md](Roadmap.md)

## Notes
Keep "thinking" in Obsidian. Keep "canonical truth" here.

Outcomes.md

---
title: "GXX: Outcomes"
type: "goal_outcomes"
status: "active"
goal_id: "goal-gXX"
updated: "YYYY-MM-DD"
---

# Outcomes

## Primary outcome
Define in measurable terms.

## Secondary outcomes
- ...

## Constraints
- Privacy:
- Budget:
- Time:

## Non-goals
Be explicit about what is NOT included.

Metrics.md

---
title: "GXX: Metrics"
type: "goal_metrics"
status: "active"
goal_id: "goal-gXX"
updated: "YYYY-MM-DD"
---

# Metrics

## KPI list
| Metric | Target | How measured | Frequency | Owner |
|---|---:|---|---|---|
| Example KPI | TBD | TBD | weekly | {{OWNER_NAME}} |

## Leading indicators
- ...

## Lagging indicators
- ...

## Data Sources
Document where measurement data comes from (n8n workflow, script, manual tracking, etc.)

Systems.md (Critical: Traceability Matrix)

---
title: "GXX: Systems"
type: "goal_systems"
status: "active"
goal_id: "goal-gXX"
updated: "YYYY-MM-DD"
---

# Systems

## Enabling systems
List systems that will carry this goal:
- [S01 Observability & Monitoring](../../20_SYSTEMS/S01_Observability-Monitoring/README.md)
- [S03 Data Layer](../../20_SYSTEMS/S03_Data-Layer/README.md)

## Traceability (Outcome → System → Automation → SOP)
| Outcome | System | Automation | SOP/Runbook |
|---|---|---|---|
| Track daily activities | S03 Data Layer | [WF001__daily-sync](../../50_AUTOMATIONS/n8n/workflows/WF001__daily-sync.md) | [Daily-Review.md](../../30_SOPS/Daily-Review.md) |
| Monitor progress | S01 Observability | [script: metrics.py](../../50_AUTOMATIONS/scripts/metrics.py) | [Weekly-Review.md](../../30_SOPS/Weekly-Review.md) |

**Note:** Every automation/script referenced here MUST have corresponding documentation in `docs/50_AUTOMATIONS/`.

Roadmap.md

---
title: "GXX: Roadmap"
type: "goal_roadmap"
status: "active"
goal_id: "goal-gXX"
updated: "YYYY-MM-DD"
---

# Roadmap (2026)

## Q1
- [ ] ...

<h2>Q2</h2>
- [ ] ...

<h2>Q3</h2>
- [ ] ...

<h2>Q4</h2>
- [ ] ...

## Dependencies
- Systems: S03, S05
- External: API access to XYZ
- Other goals: goal-g09 (documentation must be ready first)

PROGRESS_MONITOR.md (Human-Curated Milestones)

---
title: "GXX: Progress Monitor"
type: "progress_monitor"
status: "active"
goal_id: "goal-gXX"
created: "YYYY-MM-DD"
last_updated: "YYYY-MM-DD"
version: "1.0"
---

# GXX Goal Name - Progress Monitor

**Purpose:** Track major achievements, milestones, and progress for GXX Goal Name goal.

**Update Frequency:** Updated manually or based on monthly summaries

---

## 🎯 Executive Summary - Q1 2026 Progress

### Overall Completion Status
- **Q1 Progress**: ...
- **Current Phase**: ...
- **Key Focus**: ...

---

## ✅ Major Achievements

### [Achievement Name] (Date)
**Implementation Summary:**
- ...

**Technical Specifications:**
- ...

**Performance Results:**
- ...

### Lessons Learned
- ...

---

## 🔄 Current Status

### Active Systems
- ...

### Recent Activity (Last 10 Days)
- ...

### Personal Insights from Daily Notes
- ...

---

## 📋 Next Milestones (QY YYYY)

### Immediate Priorities
- [ ] ...

---

*Last Updated: YYYY-MM-DD*  
*Next Review: YYYY-MM-DD*  
*Goal Status: ...*

ACTIVITY_LOG.md (Auto-generated Daily Log)

---
title: "GXX: Detailed Activity Log"
type: "activity_log"
status: "active"
goal_id: "goal-gXX"
updated: "YYYY-MM-DD"
---

# GXX Goal Name - Activity Log

**Purpose:** Auto-generated daily log (not for human-curated milestones - those are in `goal-gXX/PROGRESS_MONITOR.md`)

## Template for Future Entries

## YYYY-MM-DD | [Milestone Name]

### Implementation Summary
**What:**  
**Why:**  
**How:**  
**Result:**

### Technical Specifications
- Component details
- Architecture decisions

### Performance Results
- Metrics achieved
- Success criteria validation

### Time Investment Breakdown
- Detailed effort tracking

### Documentation Artifacts
- [ ] List of created/updated docs

### Lessons Learned
- What worked well
- What to improve next time

### Next Milestone
- [ ] Immediate next steps

Automation Documentation
Naming Conventions
n8n Workflows

docs/50_AUTOMATIONS/n8n/workflows/
├── WF001__name.json         # Export (workflow code)
└── WF001__name.md           # Specification (human docs)

Format: WFnnn__descriptive-name (3 digits, lowercase with hyphens)
Python Scripts

docs/50_AUTOMATIONS/scripts/
├── script-name.py           # Executable
└── script-name.md           # Documentation

Format: lowercase-with-hyphens.py
Home Assistant

docs/50_AUTOMATIONS/home-assistant/
├── automation-name.yaml     # Automation config
└── automation-name.md       # Documentation

Automation Documentation Template

File: docs/50_AUTOMATIONS/{category}/{ID}__name.md

---
title: "{ID}: Name"
type: "automation_spec"
status: "active"
automation_id: "{ID}__name"
goal_id: "goal-gXX"
systems: ["SXX", "SYY"]
owner: "{{OWNER_NAME}}"
updated: "YYYY-MM-DD"
---

# {ID}: Name

## Purpose
One-sentence description of what this automation does.

## Triggers
- When: Scheduled daily at 23:00 UTC
- Or: Webhook from external service
- Or: Manual execution via Obsidian hotkey

## Inputs
- Obsidian daily note: `YYYY-MM-DD.md`
- Config file: `config.yaml`
- Environment variables: `GITHUB_TOKEN`, `VAULT_PATH`

## Processing Logic
1. Parse daily note YAML frontmatter
2. Extract checked goals with activity content
3. Generate JSON telemetry
4. Update goal-specific activity logs
5. Commit and push to Git

## Outputs
- JSON log: `_meta/daily-logs/YYYY-MM-DD.json`
- Activity logs: `goal-gXX/ACTIVITY.md` (updated)
- Git commit: `Daily sync: YYYY-MM-DD`

## Dependencies
### Systems
- [S03 Data Layer](../../20_SYSTEMS/S03_Data-Layer/README.md)
- [S10 Daily Goals Automation](../../20_SYSTEMS/S10_Daily-Goals-Automation/README.md)

### External Services
- GitHub API (authentication via SSH key)
- Obsidian vault (file system access)

### Credentials
- GitHub SSH key (stored: `~/.ssh/id_ed25519`)
- No secrets in code or Git

## Error Handling
| Failure Scenario | Detection | Response | Alert |
|---|---|---|---|
| Git conflict | `git push` fails | Nuclear reset to `origin/main`, retry | Log warning |
| Parse error | Invalid YAML | Skip file, log error | Notify via Obsidian |
| Missing vault | Path not found | Exit with error code 1 | User must fix path |

<h2>Monitoring</h2>
- Success metric: Daily JSON log created
- Alert on: 2 consecutive failures
- Dashboard: (link to monitoring dashboard when available)

## Manual Fallback
If automation fails:
```bash
cd autonomous-living
git pull origin main
# Manually create JSON log from daily note
# Manually update ACTIVITY.md
git add .
git commit -m "Manual sync: YYYY-MM-DD"
git push origin main

Related Documentation

    SOP: Daily Review
    Runbook: Git-Conflict-Resolution
    System: S10 Daily Goals Automation


## Cross-Reference Standards

### Relative Paths
Always use relative paths from the current file location:

```markdown
# From goal README to system
../../20_SYSTEMS/S03_Data-Layer/README.md

# From goal README to automation
../../50_AUTOMATIONS/n8n/workflows/WF001__daily-sync.md

# From automation to SOP
../../30_SOPS/Daily-Review.md

Goal References

Always use goal-gXX format in:

    Frontmatter: goal_id: "goal-gXX"
    Code/paths: autonomous-living/goal-gXX/
    Documentation text: "This automation supports goal-gXX..."
    Traceability matrices: Reference column entries

System References

Always use SXX format:

    S01, S02, ..., S11 (with leading zero)
    Full name in first mention, then abbreviation

Automation References

    n8n: WFnnn__name (3 digits)
    Scripts: script-name.py
    Home Assistant: automation-name.yaml

Update Workflow
When Creating New Automation

    Create automation code (JSON/script/YAML)
    Create automation documentation (.md)
    Update goal's Systems.md traceability matrix
    Create/update SOP if needed
    Create/update Runbook if automation can fail

When Modifying Existing Automation

    Update code
    Update documentation (mark changed sections with update date)
    Update traceability matrix if I/O changed
    Test manual fallback procedure
    Update related SOPs/Runbooks

Weekly Review Checklist

    All automations have .md documentation
    All automations referenced in goal traceability matrices
    All goal-XX references updated to goal-gXX
    All cross-references use correct relative paths
    All automation IDs follow naming conventions

Quality Standards
Documentation Quality

    Concrete over abstract: Show examples, not just descriptions
    Actionable: Every procedure must be executable copy-paste commands
    Current: Mark update date, don't leave stale docs
    Linked: Every doc references related systems/automations/SOPs

Code Quality

    Idempotent: Running twice produces same result
    Observable: Logs are explicit and parseable
    Recoverable: Manual fallback documented
    Testable: Include test procedure in docs

File Organization

    Predictable: Follow folder structure strictly
    Flat hierarchy: Avoid deep nesting (max 3 levels)
    Descriptive names: No cryptic abbreviations
    Version control: All docs in Git, no binary blobs

Migration Checklist (Fixing Existing Docs)
Phase 1: Goal ID Standardization

    Search for goal-[0-9][0-9] and goal-[0-9] patterns
    Replace goal-01 → goal-g01, goal-12 → goal-g12, etc.
    Update script that generates ACTIVITY.md to use goal-gXX
    Update all Code: fields in activity logs

Phase 2: Goal Documentation

    Add goal_id: "goal-gXX" to frontmatter of all goal docs
    Verify all 5 core files exist (README/Outcomes/Metrics/Systems/Roadmap)
    Move sub-project docs (e.g., Pantry-Management-System.md) to projects/ subfolder
    Populate Systems.md traceability matrices

Phase 3: Automation Documentation

    Assign IDs to all n8n workflows (WF001, WF002, ...)
    Create .md docs for all automations
    Document all scripts following template
    Update goal traceability matrices with automation links

Phase 4: Cross-References

    Verify all relative paths work
    Add "Related Documentation" sections to all files
    Update navigation in README files

Tools & Helpers
Search for Non-Standard Goal IDs

# From autonomous-living root
grep -rn "goal-[0-9][0-9]" . --include="*.md" --exclude-dir=".git"
grep -rn "goal-[0-9]" . --include="*.md" --exclude-dir=".git"

List Automations Needing Documentation

# n8n workflows without docs
cd docs/50_AUTOMATIONS/n8n/workflows
for json in *.json; do
    md="${json%.json}.md"
    [[ ! -f "$md" ]] && echo "Missing: $md"
done

Validate Goal Structure

# Check each goal has 5 core files
for goal in docs/10_GOALS/G*/; do
    echo "Checking: $goal"
    for file in README.md Outcomes.md Metrics.md Systems.md Roadmap.md; do
        [[ ! -f "$goal/$file" ]] && echo "  Missing: $file"
    done
done

References

    Principles
    North Star
    ADR-0001: Repo Structure