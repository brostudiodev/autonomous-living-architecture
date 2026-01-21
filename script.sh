#!/usr/bin/env bash
set -euo pipefail

TODAY="2026-01-15"
OWNER_NAME="Michał"
REPO_NAME="autonomous-living"

write_file () {
  local path="$1"
  shift
  mkdir -p "$(dirname "$path")"
  cat > "$path" <<'EOF'
EOF
}

# -----------------------------
# ROOT FILES
# -----------------------------
cat > README.md <<EOF
---
title: "Autonomous Living"
type: "index"
status: "active"
owner: "${OWNER_NAME}"
repo: "${REPO_NAME}"
updated: "${TODAY}"
---

# Autonomous Living

## North Star (2026)
**Automation-first living**: by end of 2026, daily operations should run with minimal manual effort while remaining observable, secure, and recoverable.

## How this repo is structured
- **Goals** = outcomes (what success looks like)
- **Systems** = reusable building blocks (how outcomes happen)
- **SOPs** = repeatable procedures (how life runs day-to-day)
- **Runbooks** = what to do when things break
- **Automations** = n8n workflows, scripts, HA automations

Start here: [docs/00_START-HERE/North-Star.md](docs/00_START-HERE/North-Star.md)

## Goals (2026)
- [G01 Target Body Fat](docs/10_GOALS/G01_Target-Body-Fat/README.md)
- [G02 Automationbro Recognition](docs/10_GOALS/G02_Automationbro-Recognition/README.md)
- [G03 Autonomous Household Operations](docs/10_GOALS/G03_Autonomous-Household-Operations/README.md)
- [G04 Digital Twin Ecosystem](docs/10_GOALS/G04_Digital-Twin-Ecosystem/README.md)
- [G05 Autonomous Financial Command Center](docs/10_GOALS/G05_Autonomous-Financial-Command-Center/README.md)
- [G06 Certification Exams](docs/10_GOALS/G06_Certification-Exams/README.md)
- [G07 Predictive Health Management](docs/10_GOALS/G07_Predictive-Health-Management/README.md)
- [G08 Predictive Smart Home Orchestration](docs/10_GOALS/G08_Predictive-Smart-Home-Orchestration/README.md)
- [G09 Complete Process Documentation](docs/10_GOALS/G09_Complete-Process-Documentation/README.md)
- [G10 Automated Career Intelligence](docs/10_GOALS/G10_Automated-Career-Intelligence/README.md)
- [G11 Productivity & Time Architecture](docs/10_GOALS/G11_Intelligent-Productivity-Time-Architecture/README.md)
- [G12 Meta-System Integration & Optimization](docs/10_GOALS/G12_Meta-System-Integration-Optimization/README.md)

## Systems (high level)
- [Homelab Platform](docs/20_SYSTEMS/S00_Homelab-Platform/README.md)
- [Observability & Monitoring](docs/20_SYSTEMS/S01_Observability-Monitoring/README.md)
- [Identity & Access](docs/20_SYSTEMS/S02_Identity-Access/README.md)
- [Data Layer](docs/20_SYSTEMS/S03_Data-Layer/README.md)
- [Digital Twin](docs/20_SYSTEMS/S04_Digital-Twin/README.md)
- [Finance Automation](docs/20_SYSTEMS/S05_Finance-Automation/README.md)
- [Health & Performance](docs/20_SYSTEMS/S06_Health-Performance/README.md)
- [Smart Home](docs/20_SYSTEMS/S07_Smart-Home/README.md)
- [Career Intelligence](docs/20_SYSTEMS/S08_Career-Intelligence/README.md)
- [Productivity & Time](docs/20_SYSTEMS/S09_Productivity-Time/README.md)

## Rules (non-negotiable)
- **No secrets in Git**. Use environment variables / secret stores.
- Every automation must have a matching \`*.md\` description (purpose, dependencies, failure modes, rollback).
- Everything important must be observable (logs/metrics/alerts) or it will rot.

EOF

cat > .gitignore <<'EOF'
# OS
.DS_Store
Thumbs.db

# Editors
.vscode/
.idea/

# Python
__pycache__/
*.pyc
.venv/
.env

# Node
node_modules/
npm-debug.log*
yarn-debug.log*
yarn-error.log*

# Secrets (never commit)
*.key
*.pem
*.p12
*.kdbx
secrets.*
**/secrets/
**/.secrets/
**/*token*
**/*apikey*
EOF

cat > CONTRIBUTING.md <<EOF
---
title: "Contributing"
type: "process"
status: "active"
updated: "${TODAY}"
---

# Contributing

## Why this exists
This repo is meant to be **maintainable by future-you and AI**. That means predictable structure, explicit scope, and change hygiene.

## Basic workflow
1. Make a small change.
2. Create a PR (even if you are the only contributor).
3. Link the change to a **Goal** and/or **System**.
4. Update docs + automation together.

## Required for any automation change
- Docs: purpose, inputs/outputs, dependencies, failure modes, rollback
- Observability: where logs go, how failure is detected
- Safety: no secrets committed, credentials referenced via secret manager or env vars

EOF

# -----------------------------
# START HERE
# -----------------------------
cat > docs/00_START-HERE/North-Star.md <<EOF
---
title: "North Star"
type: "strategy"
status: "active"
updated: "${TODAY}"
---

# North Star (Automation-First Living)

## Definition
By end of 2026, ordinary life operations run with minimal manual work, backed by:
- **Automation** (workflows, scripts, orchestrations)
- **Observability** (metrics/logs/traces, alerts)
- **Recoverability** (backups, rollback, runbooks)
- **Security** (identity, least privilege, audit trail)

## Outcomes (non-hand-wavy)
- Time reclaimed weekly (tracked)
- Reduced manual decisions for repeatable tasks
- Lower error rate in finance/admin tasks
- Predictable routines (health, training, learning)

## Constraints
- Privacy first (especially health + finance)
- “Automation that can’t be monitored is just a future outage”
- If a system can’t be restored, it doesn’t exist

EOF

cat > docs/00_START-HERE/How-to-navigate.md <<EOF
---
title: "How to navigate this repo"
type: "guide"
status: "active"
updated: "${TODAY}"
---

# How to navigate

## If you have a goal
Go to: \`docs/10_GOALS/Gxx_*/README.md\` and follow the links to Systems and SOPs.

## If you have a system/component
Go to: \`docs/20_SYSTEMS/Sxx_*/README.md\`.

## If you need to do something repeatably
Go to: \`docs/30_SOPS/\`.

## If something broke
Go to: \`docs/40_RUNBOOKS/\`.

## If you’re looking for automations
Go to: \`docs/50_AUTOMATIONS/\`.

EOF

cat > docs/00_START-HERE/Glossary.md <<EOF
---
title: "Glossary"
type: "reference"
status: "active"
updated: "${TODAY}"
---

# Glossary

## Terms (initial)
- **Goal**: outcome-focused target for 2026
- **System**: reusable capability enabling multiple goals
- **SOP**: standard operating procedure (repeatable steps)
- **Runbook**: what to do during incidents/outages
- **ADR**: architecture decision record (why we chose X)

EOF

cat > docs/00_START-HERE/Principles.md <<EOF
---
title: "Principles"
type: "strategy"
status: "active"
updated: "${TODAY}"
---

# Principles

## Automation principles
1. Automate the *boring* first.
2. Automate only what you can observe.
3. Prefer simple + reliable over clever + fragile.
4. Every automation must have a manual fallback (until proven stable).

## Documentation principles
- Write for future-you on low sleep.
- If a procedure can’t be followed, it’s not documented.
- Prefer checklists over paragraphs.

EOF

# -----------------------------
# INDEX READMEs
# -----------------------------
cat > docs/10_GOALS/README.md <<EOF
---
title: "Goals"
type: "index"
status: "active"
updated: "${TODAY}"
---

# Goals (2026)

## How to use
Each goal folder contains:
- **Outcomes**: what “done” means
- **Metrics**: how we measure progress
- **Systems**: the enabling building blocks
- **Roadmap**: milestones by quarter

EOF

cat > docs/20_SYSTEMS/README.md <<EOF
---
title: "Systems"
type: "index"
status: "active"
updated: "${TODAY}"
---

# Systems

## What belongs here
Reusable capabilities that support multiple goals:
- identity/access
- observability
- data layer
- homelab platform
- domain systems (finance, health, smart home, etc.)

## What does NOT belong here
One-off experiments and personal notes. Keep those in Obsidian.

EOF

cat > docs/30_SOPS/README.md <<EOF
---
title: "SOPs"
type: "index"
status: "active"
updated: "${TODAY}"
---

# SOPs (Standard Operating Procedures)

## Purpose
Document repeatable life operations so they can be:
- executed manually
- automated safely
- audited and improved

## Format standard
Each SOP should include:
- Trigger / frequency
- Inputs
- Steps (checklist)
- Outputs
- Failure modes and escalation

EOF

cat > docs/40_RUNBOOKS/README.md <<EOF
---
title: "Runbooks"
type: "index"
status: "active"
updated: "${TODAY}"
---

# Runbooks

## Purpose
When something breaks, you should not need creativity. You need a checklist.

## Common runbook types
- service down
- backup restore
- credential rotation
- data corruption
- alert storms

EOF

cat > docs/50_AUTOMATIONS/README.md <<EOF
---
title: "Automations"
type: "index"
status: "active"
updated: "${TODAY}"
---

# Automations

## What belongs here
- n8n workflows (exports + docs)
- scripts
- Home Assistant automations/configs

## Rule
Every automation requires a matching doc describing:
purpose, dependencies, failure modes, rollback, and owner.

EOF

cat > docs/50_AUTOMATIONS/n8n/README.md <<EOF
---
title: "n8n Automations"
type: "index"
status: "active"
updated: "${TODAY}"
---

# n8n Automations

## Storage convention
- \`workflows/WF###__name.json\` = exported workflow
- \`workflows/WF###__name.md\` = human-readable spec

## Minimal workflow doc template
- Purpose
- Trigger(s)
- Inputs / outputs
- Credentials used (names only, no values)
- Dependencies (services/APIs)
- Failure modes + alerts
- Test procedure
- Rollback

EOF

cat > docs/50_AUTOMATIONS/n8n/templates/credentials-template.md <<EOF
---
title: "Credentials Template (no secrets)"
type: "template"
status: "active"
updated: "${TODAY}"
---

# Credentials Template (NO SECRETS)

## Credential name
- Name:
- Used by workflow(s):
- Stored in:
  - [ ] n8n credential store
  - [ ] environment variable(s)
  - [ ] secret manager (recommended)

## Rotation
- Rotation interval:
- Owner:
- Last rotated:

EOF

cat > docs/50_AUTOMATIONS/home-assistant/README.md <<EOF
---
title: "Home Assistant"
type: "index"
status: "active"
updated: "${TODAY}"
---

# Home Assistant

## Purpose
Home orchestration lives here: automations, dashboards, sensors.

## Policy
- No secrets committed
- Prefer packages/modules over one giant config file
- Every automation of consequence should link to a Goal and a System

EOF

cat > docs/50_AUTOMATIONS/scripts/README.md <<EOF
---
title: "Scripts"
type: "index"
status: "active"
updated: "${TODAY}"
---

# Scripts

## Purpose
Small, reliable utilities that n8n/HA/scheduled jobs can call.

## Standards
- Idempotent where possible
- Logs are explicit
- Exit codes matter
- Document inputs/outputs in a sibling \`.md\`

EOF

cat > docs/60_DECISIONS_ADRS/README.md <<EOF
---
title: "Architecture Decisions (ADRs)"
type: "index"
status: "active"
updated: "${TODAY}"
---

# ADRs

## Why
When you change tools every two months, you lose years. ADRs prevent that by recording *why* decisions were made.

## Format
- Context
- Decision
- Alternatives considered
- Consequences

EOF

cat > docs/60_DECISIONS_ADRS/ADR-0001-Repo-Structure.md <<EOF
---
title: "ADR-0001: Repo Structure"
type: "adr"
status: "accepted"
updated: "${TODAY}"
---

# ADR-0001: Repo Structure

## Context
We need one repo that is readable for humans, maintainable by future-you, and suitable for AI-assisted updates.

## Decision
Use a docs-first structure:
- Goals
- Systems
- SOPs
- Runbooks
- Automations
- ADRs

## Consequences
- Predictable locations enable automation and indexing
- Requires discipline: no random dumping of files

EOF

# -----------------------------
# GOAL TEMPLATES (README + 4 files)
# -----------------------------
create_goal () {
  local goal_id="$1" goal_name="$2" goal_dir="$3"

  cat > "docs/10_GOALS/${goal_dir}/README.md" <<EOF
---
title: "${goal_id}: ${goal_name}"
type: "goal"
status: "active"
owner: "${OWNER_NAME}"
updated: "${TODAY}"
---

# ${goal_id}: ${goal_name}

## Intent
What outcome are we actually buying here (not vanity metrics)?

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
Keep “thinking” in Obsidian. Keep “canonical truth” here.

EOF

  cat > "docs/10_GOALS/${goal_dir}/Outcomes.md" <<EOF
---
title: "${goal_id}: Outcomes"
type: "goal_outcomes"
status: "active"
updated: "${TODAY}"
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

EOF

  cat > "docs/10_GOALS/${goal_dir}/Metrics.md" <<EOF
---
title: "${goal_id}: Metrics"
type: "goal_metrics"
status: "active"
updated: "${TODAY}"
---

# Metrics

## KPI list
| Metric | Target | How measured | Frequency | Owner |
|---|---:|---|---|---|
| Example KPI | TBD | TBD | weekly | ${OWNER_NAME} |

## Leading indicators
- ...

## Lagging indicators
- ...

EOF

  cat > "docs/10_GOALS/${goal_dir}/Systems.md" <<EOF
---
title: "${goal_id}: Systems"
type: "goal_systems"
status: "active"
updated: "${TODAY}"
---

# Systems

## Enabling systems
List systems that will carry this goal.

## Traceability (Outcome → System → Automation → SOP)
| Outcome | System | Automation | SOP |
|---|---|---|---|
| TBD | TBD | TBD | TBD |

EOF

  cat > "docs/10_GOALS/${goal_dir}/Roadmap.md" <<EOF
---
title: "${goal_id}: Roadmap"
type: "goal_roadmap"
status: "active"
updated: "${TODAY}"
---

# Roadmap (2026)

## Q1
- [ ] ...

## Q2
- [ ] ...

## Q3
- [ ] ...

## Q4
- [ ] ...

## Dependencies
- ...

EOF
}

create_goal "G01" "Target Body Fat" "G01_Target-Body-Fat"
create_goal "G02" "Automationbro Recognition" "G02_Automationbro-Recognition"
create_goal "G03" "Autonomous Household Operations" "G03_Autonomous-Household-Operations"
create_goal "G04" "Digital Twin Ecosystem" "G04_Digital-Twin-Ecosystem"
create_goal "G05" "Autonomous Financial Command Center" "G05_Autonomous-Financial-Command-Center"
create_goal "G06" "Certification Exams" "G06_Certification-Exams"
create_goal "G07" "Predictive Health Management" "G07_Predictive-Health-Management"
create_goal "G08" "Predictive Smart Home Orchestration" "G08_Predictive-Smart-Home-Orchestration"
create_goal "G09" "Complete Process Documentation" "G09_Complete-Process-Documentation"
create_goal "G10" "Automated Career Intelligence" "G10_Automated-Career-Intelligence"
create_goal "G11" "Productivity & Time Architecture" "G11_Intelligent-Productivity-Time-Architecture"
create_goal "G12" "Meta-System Integration & Optimization" "G12_Meta-System-Integration-Optimization"

# Extend Goal 09 with extra docs (overwrite those specific files with richer templates)
cat > docs/10_GOALS/G09_Complete-Process-Documentation/Documentation-Standard.md <<EOF
---
title: "Documentation Standard"
type: "standard"
status: "active"
updated: "${TODAY}"
---

# Documentation Standard

## Why
Documentation is not a diary. It's an operational artifact that must survive time, fatigue, and AI edits.

## Required sections (for most docs)
- Purpose
- Scope / non-scope
- Inputs / outputs
- Dependencies
- Procedure (checklist)
- Failure modes
- Security notes
- Owner + review cadence

## File naming
- Goals: \`G##_\`
- Systems: \`S##_\`
- Workflows: \`WF###__\`
- ADRs: \`ADR-####\`

EOF

cat > docs/10_GOALS/G09_Complete-Process-Documentation/AI-Update-Policy.md <<EOF
---
title: "AI Update Policy"
type: "policy"
status: "active"
updated: "${TODAY}"
---

# AI Update Policy

## Allowed
- Propose changes via PR
- Add missing sections to docs
- Update links, indexes, and navigation
- Suggest refactors that reduce duplication

## Not allowed (without explicit human approval)
- Anything touching secrets/credentials
- Financial transactions or automation that can move money
- Security policy changes
- Deleting large sections of docs

## Safety rails
- Every AI-generated change must reference the exact file(s) it modified
- Prefer small PRs
- Add test/verification steps when touching automations

EOF

cat > docs/10_GOALS/G09_Complete-Process-Documentation/Publishing.md <<EOF
---
title: "Publishing"
type: "process"
status: "active"
updated: "${TODAY}"
---

# Publishing

## Current state
- [ ] GitHub-only markdown
- [ ] Optional docs site (MkDocs/Docusaurus) later

## Publishing requirements
- Canonical docs live under \`/docs\`
- Attachments under \`/docs/90_ATTACHMENTS\`
- No binaries unless necessary

## Next steps
- Decide if public or private docs
- Add a docs site generator if needed

EOF

# -----------------------------
# SYSTEM READMEs
# -----------------------------
create_system () {
  local sys_id="$1" sys_name="$2" sys_dir="$3"

  cat > "docs/20_SYSTEMS/${sys_dir}/README.md" <<EOF
---
title: "${sys_id}: ${sys_name}"
type: "system"
status: "active"
owner: "${OWNER_NAME}"
updated: "${TODAY}"
---

# ${sys_id}: ${sys_name}

## Purpose
What capability does this system provide?

## Scope
- Included:
- Excluded:

## Interfaces
- Inputs:
- Outputs:
- APIs/events:

## Dependencies
- Services:
- Hardware:
- Credentials (names only):

## Observability
- Logs:
- Metrics:
- Alerts:

## Runbooks / SOPs
- Related SOPs:
- Related runbooks:

EOF
}

create_system "S00" "Homelab Platform" "S00_Homelab-Platform"
create_system "S01" "Observability & Monitoring" "S01_Observability-Monitoring"
create_system "S02" "Identity & Access" "S02_Identity-Access"
create_system "S03" "Data Layer" "S03_Data-Layer"
create_system "S04" "Digital Twin" "S04_Digital-Twin"
create_system "S05" "Finance Automation" "S05_Finance-Automation"
create_system "S06" "Health & Performance" "S06_Health-Performance"
create_system "S07" "Smart Home" "S07_Smart-Home"
create_system "S08" "Career Intelligence" "S08_Career-Intelligence"
create_system "S09" "Productivity & Time" "S09_Productivity-Time"

# Add richer starter docs for S00 Homelab Platform
cat > docs/20_SYSTEMS/S00_Homelab-Platform/Architecture.md <<EOF
---
title: "S00: Homelab Architecture"
type: "architecture"
status: "active"
updated: "${TODAY}"
---

# Homelab Architecture

## Goals
- Reliable hosting for automations and AI services
- Easy recovery (backup/restore)
- Observability-first

## Components (draft)
- Compute nodes:
- Storage:
- Network:
- Core services (DNS, reverse proxy, etc.):

## Threat model (minimal)
- External exposure is a liability
- Prefer VPN/Zero Trust access

EOF

cat > docs/20_SYSTEMS/S00_Homelab-Platform/Services.md <<EOF
---
title: "S00: Services Catalog"
type: "reference"
status: "active"
updated: "${TODAY}"
---

# Services Catalog

## Always-on (expected)
| Service | Purpose | Where hosted | Criticality | Notes |
|---|---|---|---|---|
| n8n | automation orchestrator | TBD | high | |
| Home Assistant | home orchestration | TBD | high | |

EOF

cat > docs/20_SYSTEMS/S00_Homelab-Platform/Backups.md <<EOF
---
title: "S00: Backups"
type: "runbook"
status: "active"
updated: "${TODAY}"
---

# Backups

## Backup policy (draft)
- Frequency:
- Retention:
- Offsite:
- Restore testing schedule:

## Restore drill
- [ ] Identify target
- [ ] Restore
- [ ] Validate
- [ ] Document time-to-restore

EOF

cat > docs/20_SYSTEMS/S00_Homelab-Platform/Security.md <<EOF
---
title: "S00: Security"
type: "policy"
status: "active"
updated: "${TODAY}"
---

# Security

## Baseline
- Least privilege
- Separate admin accounts
- Audit trail for critical systems
- No secrets in Git

## Access model (draft)
- VPN/Zero Trust entrypoint
- MFA where possible

EOF

echo "Starter content written successfully."
echo "Next: git add . && git commit -m \"Add starter content\" && git push"

