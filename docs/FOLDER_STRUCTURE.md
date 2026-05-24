# FOLDER_STRUCTURE.md (G12)

## Repository Layout
The Autonomous Living repo follows a strict enterprise-grade structure to ensure portability and AI-agent compatibility.

```text
.
├── autonomous_sdk/         # [SHARED] Unified Database, Event, and Logging Library
├── core/                   # [KERNEL] Core system logic (Engine, Agent, API, Registry)
├── docs/                   # [DOCS] Entry point for all documentation
│   ├── 00_Start-here/      # Principles, North Star, Onboarding
│   ├── 10_Goals/           # The 13 Power Goals (Roadmaps, Metrics)
│   ├── 20_Systems/         # Architectural layers (Data, Twin, UI)
│   ├── 30_Sops/            # Standard Operating Procedures
│   ├── 40_Runbooks/        # Disaster Recovery and manual fix guides
│   ├── 50_Automations/     # Specifications for scripts and workflows
│   ├── 60_Decisions_adrs/  # Architecture Decision Records (ADR)
│   └── 90_Attachments/     # Static assets and diagrams
├── infrastructure/         # [INFRA] Persistent data for Docker services (DB, RMQ, Prometheus)
├── modules/                # [USERLAND] Domain-specific modular logic
│   └── <domain>/           # (Health, Finance, Productivity, etc.)
│       ├── scripts/        # Production-grade automation scripts
│       └── manifest.yaml   # Module registration and metadata
├── n8n/                    # [INTELLIGENCE] Workflow backups and credentials
├── scripts/                # [LEGACY] Redundant utilities and proxy scripts (DEPRECATED)
│   └── archive/            # Final resting place for decommissioned scripts
├── docker-compose.yml      # Service orchestration
├── main.py                 # Primary API entry point
└── .env.example            # Environment template
```

## Governance Rules
1. **Source of Truth:** All automation logic MUST reside in `modules/<domain>/scripts/`.
2. **Kernel vs Userland:** Core system logic resides in `core/`. Domain-specific logic belongs in `modules/`.
3. **SDK Usage:** Direct database or event library imports are forbidden; use `autonomous_sdk`.
4. **Visibility:** Every script MUST log `STARTED`, `SUCCESS`, or `FAILURE` to appear on the system map.
5. **No Data in Root:** Data belongs in `infrastructure/` or `_meta/`.
6. **Relative Linking:** All documentation links MUST be relative.
