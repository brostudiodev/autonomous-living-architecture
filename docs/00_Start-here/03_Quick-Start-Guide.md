---
title: "03: Quick Start Guide"
type: "guide"
status: "active"
owner: "Michal"
updated: "2026-02-28"
---

# 🚀 Quick Start Guide: Day 1 with Autonomous Living

Welcome to the future of personal engineering. This guide will help you understand how I set up my "Second Brain" and "Digital Twin".

> [!IMPORTANT]
> This repository is an **Architectural Showcase**. To protect my privacy and secrets, I do not provide the actual Python scripts (`.py`) or shell scripts (`.sh`) in the public version. Instead, I provide detailed **Automation Specifications** so you can implement the logic in your own environment.

## 🛠 Prerequisites
Before you begin, ensure you have:
1. **Obsidian** installed (for your Second Brain).
2. **Docker & Docker Compose** installed (to run the AI and Database engine).
3. **Python 3.11+** (if you plan to implement the sync scripts).

---

## 🏗 Step 1: Clone and Infrastructure
1. Clone this repository to your local machine.
2. Open a terminal in the root directory.
3. Start the core services (I provide the `docker-compose.yml` but you must prepare your own `.env`):
   ```bash
   cd infrastructure
   docker-compose up -d
   ```
   *This starts PostgreSQL (Data Layer), Grafana (Dashboards), and n8n (Automation).*
   - **How to prepare:** See [S00: Homelab Platform Architecture](../20_Systems/S00_Homelab-Platform/Architecture.md).

---

## 🧠 Step 2: Second Brain Setup (Obsidian)
1. Open Obsidian and "Open folder as vault".
2. Select the `Obsidian Vault/` folder within this repository.
3. Install the **Periodic Notes** and **Dataview** community plugins.
4. Look at the template structure in `99_System/Templates/`.

---

## 🔄 Step 3: Implementing Your First Sync
In my private environment, I run a global sync supervisor to pull data from health, finance, and home APIs into PostgreSQL. To build this yourself, follow the logic defined here:
- **[Specification: Global Sync Supervisor](../50_Automations/scripts/G11_global_sync.md)**
- **[Specification: Zepp/Amazfit Sync](../50_Automations/scripts/G07_zepp_sync.md)**
- **[Specification: Weight Sync](../50_Automations/scripts/G07_weight_sync.md)**

---

## 🎯 Step 4: Define Your Missions
1. Navigate to `docs/10_Goals/`.
2. Pick one goal (e.g., **G01: Target Body Fat**).
3. Open its `Roadmap.md` and see how I track tasks and progress.
4. My system automatically detects checked tasks and updates my **Morning Mission Briefing**.
   - **How to prepare:** See [Specification: Autonomous Daily Manager](../50_Automations/scripts/autonomous_daily_manager.md).

---

## 🆘 Common "Day 1" Questions

### "Where are my dashboards?"
Go to `http://localhost:3003` for Grafana. I use automated provisioning for my data sources.
- **How to prepare:** See [S05: Observability Dashboards](../20_Systems/S05_Observability-Dashboards/README.md).

### "How do I talk to my Digital Twin?"
I interact with my system via a Telegram bot.
- **How to prepare:** See [Specification: Digital Twin API](../50_Automations/scripts/G04_digital_twin_api.md).

### "I see broken links!"
I use a custom auditor to keep my 1000+ files linked correctly.
- **How to prepare:** See [Specification: Documentation Auditor](../50_Automations/scripts/G12_documentation_audit.md).

---

**Next Step:** Read [02: What Is Autonomous Living?](./02_What-Is-Autonomous-Living.md) to understand the philosophy behind these steps.
