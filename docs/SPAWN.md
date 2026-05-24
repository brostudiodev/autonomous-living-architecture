# Autonomous Living: Spawn Guide (G12)

## Overview
This guide provides the procedure for "spawning" a new instance of the Autonomous Living ecosystem for a new user or a fresh environment.

## Prerequisites
- **Hardware:** Linux-based server (Ubuntu 22.04+ recommended) or powerful workstation.
- **Software:** 
  - Docker & Docker Compose v2.x
  - Python 3.10+
  - Git
- **Accounts (Optional but Recommended):**
  - Google Cloud Console (for Calendar/Tasks)
  - Zepp/Amazfit Cloud
  - Withings API
  - Telegram Bot Token

## Quick Start (The "Spawn" Command)

1. **Clone the repository:**
   ```bash
   git clone https://github.com/brostudiodev/autonomous-living.git
   cd autonomous-living
   ```

2. **Initialize Environment:**
   ```bash
   cp .env.example .env
   # Edit .env with your specific credentials
   nano .env
   ```

3. **Deploy the Stack:**
   ```bash
   docker compose up -d
   ```

4. **Initialize Databases:**
   The system will autonomously run migrations on first start, but you can trigger a manual sync:
   ```bash
   ./scripts/fill-daily.sh
   ```

## Folder Structure
Following the [Standard Folder Structure](FOLDER_STRUCTURE.md), ensure the following directories are present:
- `_meta/`: System logs and activity data.
- `docs/`: Technical and goal documentation.
- `infrastructure/`: Persistent data for Docker services (DBs, n8n).
- `scripts/`: The core automation engines.

## Post-Spawn Checklist
- [ ] Verify `postgres` container is healthy.
- [ ] Log in to `n8n` (localhost:5678) and import core workflows from `./n8n/backup`.
- [ ] Configure Telegram Bot in `.env` to receive real-time alerts.
- [ ] Run `G11_pre_flight_check.py` to verify domain connectivity.

## Troubleshooting
Refer to [Adr-0027: Container Resource Rationalization](60_Decisions_adrs/Adr-0027-Container-Resource-Rationalization.md) for details on memory limits and database tuning.
