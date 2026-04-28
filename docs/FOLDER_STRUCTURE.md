---
title: "Folder Structure"
type: "documentation"
status: "draft"
owner: "Michał"
updated: "2026-04-21"
---

# Folder Structure

> **⚠️ DRAFT** - This structure is a proposal for organizing the Autonomous Living package.

## Purpose

Establish a clean, spawnable folder structure for multi-user deployment.

## Complete Structure

```
autonomous-living/                  # Root - entire package
│
├── .env                     # Your actual environment (NOT copied - personal)
├── .env.example              # Template for new user
├── docker-compose.yml        # Unified compose (THIS FILE IS DRAFT)
├── docker-compose.draft.md   # Compose documentation
├── SPAWN.md               # Spawn procedure (THIS FILE IS DRAFT)
│
├── scripts/                 # Python automation scripts
│   ├── db_config.py
│   ├── autonomous_daily_manager.py
│   ├── G01_*.py           # Training related
│   ├── G04_*.py           # Digital Twin
│   ├── G05_*.py           # Finance
│   ├── G07_*.py           # Health
│   ├── G10_*.py           # Productivity
│   └── Dockerfile.digital-twin
│
├── docs/                   # Documentation
│   ├── 00_Start-here/
│   ├── 10_Goals/          # G01-G13 goal documentation
│   ├── 20_Systems/       # System architecture
│   ├── 30_Sops/          # Procedures
│   ├── 40_Runbooks/       # Incident response
│   ├── 50_Automations/   # Automation specs
│   ├── 60_Decisions_adrs/ # Architecture decisions
│   └── FOLDER_STRUCTURE.md
│
├── infrastructure/           # Docker infrastructure
│   ├── docker-compose.yml  # OLD - to be removed
│   ├── n8n/
│   │   ├── workflows/    # n8n workflow JSONs
│   │   └── agents/      # n8n agent configs
│   ├── grafana/
│   │   ├── dashboards/
│   │   └── provisioning/
│   ├── prometheus/
│   │   └── prometheus.yml
│   ├── database/
│   │   └── init-scripts/ # SQL schemas
│   └── scripts/
│       ├── Dockerfile.exporter
│       └── Dockerfile.metrics-exporter
│
├── obsidian/               # Obsidian Web (optional)
│   ├── config/
│   └── data/
│
├── shared/                 # Shared data between services
│
├── _meta/                 # Meta files
│   └── G04_tool_manifest.json
│
└── README.md
```

## Current vs Proposed

| Component | Current Location | Proposed Location |
|-----------|----------------|-----------------|
| Main docker-compose | infrastructure/docker-compose.yml | docker-compose.yml |
| Grafana (separate) | /home/{{USER}}/grafana/ | infrastructure/grafana/ |
| Ollama/n8n (separate) | ai-agents-masterclass/local-ai-packaged/ | infrastructure/ |
| Scripts | {{ROOT_LOCATION}}/scripts/ | scripts/ |
| Monitoring | infrastructure/prometheus/ | infrastructure/prometheus/ |

## Key Files

| File | Purpose |
|------|---------|
| `.env.example` | Template - copy to .env for new user |
| `docker-compose.yml` | All services unified |
| `SPAWN.md` | How to duplicate for new user |
| `scripts/` | All automation scripts |
| `docs/` | Full documentation |

## What's NOT Part of Package

These remain personal and are NOT copied:

| Item | Reason |
|------|-------|
| `.env` | Contains secrets |
| Obsidian data | Personal notes |
| Database data | User-specific |
| Git history | Personal repo |

## Spawn Process Summary

```bash
# 1. Copy package
cp -r autonomous-living/ autonomous-wife/

# 2. Create .env from template
cd autonomous-wife
cp .env.example .env

# 3. Update .env with new values
nano .env

# 4. Start
docker-compose up -d
```

---

## Owner

- **Owner:** Michał
- **Review Cadence:** Monthly
- **Last Updated:** 2026-04-21
- **Status:** DRAFT

## See Also

- [docker-compose.yml](../docker-compose.yml)
- [.env.example](../.env.example)
- [SPAWN.md](./SPAWN.md)