---
title: "G11: Friction Resolver"
type: "automation"
status: "deprecated"
owner: "Michal"
updated: "2026-04-16"
goal_id: "goal-g11"
---

# G11: Friction Resolver (n8n Migrated)

> [!danger] **DEPRECATED**
> The standalone Python script `G11_friction_resolver.py` has been archived. This automation is now entirely managed by **n8n** to ensure reliability and complex logic handling.

## Purpose
Bridges qualitative frustrations (reported in Daily Notes) and quantitative frictions (statistical correlations) to autonomously propose new automation tasks (Quick Wins) or Decision Requests.

## Orchestration (n8n)
- **Trigger:** Weekly Mission sync or manual Telegram command `/friction`.
- **Workflow:** `WF011_Friction-Resolver`
- **Actions:**
    1. Parse frustrations from Obsidian Daily Notes via `Digital Twin API`.
    2. Fetch correlation data from PostgreSQL.
    3. Generate proposals using LLM reasoning.
    4. Inject recommendations into `G11_goal_recommender.py`.

## Procedure
This automation no longer runs as a local Python script. It is triggered by the n8n orchestrator.
To manually trigger:
- Use Telegram command: `/friction`
- Or manually start the n8n workflow `WF011_Friction-Resolver`.

## Archive Status
The original script is located in `scripts/archive/G11_friction_resolver.py` for reference.

## Failure Modes
| Scenario | Detection | Response |
|---|---|---|
| n8n Webhook Offline | Connection Error | Ensure n8n Docker container is running. |
| Daily Note Missing | Skip execution | Check if note for today exists. |
| Empty Frustrations | Status: SUCCESS (0 items) | Normal behavior if no friction reported. |

## Owner + Review Cadence
- **Owner:** Michal
- **Review Cadence:** Weekly during system audit.
