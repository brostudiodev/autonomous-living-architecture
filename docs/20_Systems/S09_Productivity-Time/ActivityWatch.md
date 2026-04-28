---
title: "S09: ActivityWatch Telemetry"
type: "system_component"
status: "active"
owner: "Michał"
updated: "2026-04-16"
---

# ActivityWatch Telemetry

## Purpose
Provides automated, passive time tracking and attention telemetry. It eliminates the need for manual logging of "Deep Work" hours and identifies digital distractions.

## Scope
- **In Scope:** Application usage tracking, window title monitoring, idle detection.
- **Out Scope:** Keystroke logging, screen recording (screenshots).

## Inputs/Outputs
- **Inputs:** Local OS window/process events (via aw-watchers).
- **Outputs:** REST API at `http://{{INTERNAL_IP}}:5600/api/` providing bucket and event data.

## Dependencies
- **Hardware:** Local host where work is performed (needs `aw-watcher-window` and `aw-watcher-afk` installed locally).
- **Services:** `activitywatch` container running in Docker stack.
- **Data Persistence:** `./infrastructure/aw-data` volume in Docker.

## Procedure
### 1. Deployment
- Ensure the service is in `infrastructure/docker-compose.yml`.
- Run `docker-compose up -d activitywatch`.

### 2. Local Watcher Setup
ActivityWatch server runs in Docker, but watchers must run on the machine where you work:
1. Download ActivityWatch for your OS.
2. Disable the local `aw-server`.
3. Configure `aw-watcher-window` and `aw-watcher-afk` to point to the Docker instance:
   - Edit `aw-client` config (usually `~/.config/activitywatch/aw-client/aw-client.toml`).
   - Set `server_url = "http://{{INTERNAL_IP}}:5600"`.

### 3. Verification
- Access the Web UI at `http://localhost:5600`.
- Verify buckets are receiving events from your local machine.

## Failure Modes
| Scenario | Detection | Response |
|----------|-----------|----------|
| Container crash | `G04_digital_twin_monitor.py` alerts on port 5600 down. | `docker restart activitywatch`. |
| Watcher disconnected | No new events in the last 1 hour in `/api/0/buckets/`. | Check local watcher process and network connectivity to server. |
| Disk Full | Docker logs show "No space left on device". | Prune old buckets or expand `./aw-data` storage. |

## Security Notes
- **Privacy:** Data is stored locally on the homelab. No cloud sync is enabled.
- **Access:** The API is exposed on port 5600. Ensure your local firewall limits access to your internal network.

## Owner + Review Cadence
- **Owner:** Michał
- **Review Cadence:** Monthly (part of G10 Productivity Audit).

---
*Created: 2026-04-16 | Integrated into S09 Productivity & Time Architecture*
