---
title: "Goal Documentation Standard"
type: "standard"
status: "active"
owner: "Michal"
updated: "2026-03-27"
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

```text
docs/10_Goals/ 
└── GXX_Goal-Name/ # Human-readable folder name (capitalized) 
    ├── README.md # Entry point (goal brief + navigation) 
    ├── Outcomes.md # Primary/secondary outcomes, constraints, non-goals 
    ├── Metrics.md # KPIs, leading/lagging indicators, measurement methods 
    ├── Systems.md # Traceability matrix (Outcome → System → Automation → SOP/Runbook) 
    ├── Roadmap.md # Quarterly milestones + dependencies 
    ├── Progress-monitor.md # Milestone-level narrative (human-curated)
    ├── Activity-log.md # [AUTO-GENERATED] Do not edit manually. Updated via sync_daily_goals.py
    └── projects/ # Optional: sub-projects (only when goal spawns multiple projects) 
        ├── P01_Project-Name.md 
        └── P02_Another-Project.md
```

## File Templates (Illustrative)

*Note: Links in templates are placeholders and should be updated to point to the actual target in the final document.*

### README.md (Goal Entry Point)
```markdown
# GXX: Goal Name

## Key Links
- Outcomes: [Outcomes.md](./Outcomes.md)
- Metrics: [Metrics.md](./Metrics.md)
- Systems: [Systems.md](./Systems.md)
- Roadmap: [Roadmap.md](./Roadmap.md)
```

### `Systems.md` (Critical: Traceability Matrix)
```markdown
# Systems

## Enabling systems
List systems that will carry this goal:
- [S01 Observability & Monitoring](../../20_Systems/S01_Observability-Monitoring/README.md)
- [S03 Data Layer](../../20_Systems/S03_Data-Layer/README.md)

## Traceability (Outcome → System → Automation → SOP)
| Outcome | System | Automation | SOP/Runbook |
|---|---|---|---|
| Track daily activities | S03 Data Layer | [WF001 Agent Router](../../50_Automations/n8n/workflows/WF001_Agent_Router.md) | [Daily-Review-SOP.md](../../30_Sops/Daily-Review-SOP.md) |
| Monitor progress | S01 Observability | [script: metrics.py](../../50_Automations/scripts/metrics.py) | [Weekly-Review-SOP.md](../../30_Sops/Weekly-Review-SOP.md) |
```

## Cross-Reference Standards

### Relative Paths
Always use relative paths from the current file location:

```markdown
# From goal README to system
../../20_Systems/S03_Data-Layer/README.md

# From goal README to automation
../../50_Automations/n8n/workflows/WF001__daily-sync.md

# From automation to SOP
../../30_Sops/Daily-Review-SOP.md
```

## Quality Standards
- **Concrete over abstract:** Show examples, not just descriptions.
- **Actionable:** Every procedure must be executable copy-paste commands.
- **Current:** Mark update date, don't leave stale docs.
- **Linked:** Every doc references related systems/automations/SOPs.

## Security & Secret Management (CRITICAL)
To ensure documentation is ready for public architecture sharing, **NEVER** include real secrets or internal infrastructure details.

1. **Placeholder Protocol:** Use placeholders for all sensitive data:
   - IPs: Use `[INTERNAL_IP]`
   - Passwords: Use `[DB_PASSWORD]` or `${ENV_VAR_NAME}`
   - Tokens: Use `[BOT_TOKEN]` or `[API_KEY]`
2. **Environment Synchronization:** 
   - Before creating documentation, check the root `.env` file for existing variables.
   - If a variable exists, use its name as the placeholder.
   - If a new secret is required, add a placeholder entry to `.env` first, then document it.
3. **Audit Rule:** Any documentation containing `192.168.x.x` or plaintext passwords will fail the G12 Documentation Audit.

## References
- [Principles](../00_Start-here/Principles.md)
- [North Star](../00_Start-here/North-Star.md)
- [Adr-0001: Repo Structure](../60_Decisions_adrs/Adr-0001-Repo-Structure.md)
