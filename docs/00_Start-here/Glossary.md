---
title: "Glossary"
type: "reference"
status: "active"
owner: "Michal"
updated: "2026-02-28"
---

# 📖 Comprehensive Glossary: Autonomous Living

This glossary defines the technical, architectural, and philosophical terms used throughout the Autonomous Living ecosystem.

---

## 🏛️ Core Architectural Terms

- **[Goal](../10_Goals/README.md):** A high-level outcome-focused target for 2026 (e.g., G01 Reach Target Body Fat). Every line of code must trace back to a Goal.
- **[System](../20_Systems/README.md):** A reusable technical capability that enables one or more goals (e.g., S03 Data Layer).
- **[SOP](../30_Sops/README.md):** Standard Operating Procedure. A set of repeatable, human-executable steps.
- **[Runbook](../40_Runbooks/README.md):** A specialized SOP used specifically for incident response, troubleshooting, or recovering from a system failure.
- **[ADR](../60_Decisions_adrs/README.md):** Architecture Decision Record. A document that captures a critical design choice and the "why" behind it.
- **[Traceability](../10_Goals/Documentation-Standard.md):** The ability to link an automation back to a specific System, and that System back to a specific Goal.
- **[Decoupling](Principles.md):** Designing systems so they can function independently. (e.g., the Digital Twin can calculate state even if Telegram is down).
- **[SSOT (Single Source of Truth)](../20_Systems/S03_Data-Layer/README.md):** The definitive location for a specific data point. In my architecture, I use a hybrid SSOT: **PostgreSQL** is the canonical store for all metrics and structured data (finance, health, pantry), while **Obsidian** is the SSOT for mission context, strategies, and daily logs.

---

## 🤖 AI & Intelligence (G04, G11)

- **[Digital Twin](../10_Goals/G04_Digital-Twin-Ecosystem/README.md):** A virtual, AI-powered representation of your life state, aggregating health, finance, and productivity data.
- **[Intelligence Router (S11)](../20_Systems/S11_Meta-System-Integration/README.md):** The AI component that analyzes incoming messages (e.g., via Telegram) and decides which system should handle the request.
- **[Gemini 1.5 Pro/Flash:](Principles.md)** The primary Large Language Models (LLMs) used for natural language processing and decision support.
- **[Intent Recognition:](../20_Systems/S11_Meta-System-Integration/README.md)** The process of the AI understanding *what* you want to do (e.g., "Add milk" -> Intent: `pantry_update`).
- **[RAG (Retrieval-Augmented Generation):](../10_Goals/G04_Digital-Twin-Ecosystem/Rag-knowledge-base.md)** Providing the AI with specific documentation or data from your database before it generates a response.
- **[Mission Refractor:](../50_Automations/scripts/G11_mission_refractor.md)** A specialized script that analyzes Git commits and Roadmaps to draft your daily activity logs automatically.

---

## ⚙️ Infrastructure & Automation (S00, S08)

- **[Homelab](../20_Systems/S00_Homelab-Platform/README.md):** The private server environment (mini-PCs, NAS) where your databases and automation engines run.
- **[Docker / Docker Compose:](../20_Systems/S00_Homelab-Platform/Services.md)** The technology used to "containerize" services like PostgreSQL and Grafana so they run reliably across different machines.
- **[n8n](../20_Systems/S08_Automation-Orchestrator/README.md):** My primary low-code automation platform. It acts as the "glue" between APIs, databases, and AI.
- **[Webhook:](../20_Systems/S08_Automation-Orchestrator/README.md)** A way for one system to send real-time data to another (e.g., Withings sends a webhook to n8n when you step on the scale).
- **[Cron Job / Scheduled Task:](../20_Systems/cron.md)** An automation that runs at a specific time (e.g., every morning at 06:00).
- **[Self-Healing:](../20_Systems/S01_Observability-Monitoring/README.md)** A system's ability to detect an error (like a failed sync) and automatically try to fix it (re-authenticating or retrying).

---

## 📊 Data & Monitoring (S01, S03, S05)

- **[PostgreSQL](../20_Systems/S03_Data-Layer/README.md):** The professional-grade database used to store all long-term life data.
- **[Grafana](../20_Systems/S05_Observability-Dashboards/README.md):** The visualization tool used to build beautiful dashboards for your health, finance, and goals.
- **[Prometheus](../20_Systems/S01_Observability-Monitoring/README.md):** A monitoring system that tracks "metrics" (numbers over time) and alerts you if a script stops working.
- **[Exporter:](../20_Systems/S01_Observability-Monitoring/README.md)** A small script that takes data from a database and "exports" it in a format Prometheus can understand.
- **[P&L (Profit and Loss):](../10_Goals/G05_Autonomous-Financial-Command-Center/README.md)** A financial report showing your income vs. expenses.
- **[Real Savings Rate:](../60_Decisions_adrs/Adr-0008-Real-Savings-Rate-Calculation.md)** A calculation that excludes internal transfers and "fake" accounting artifacts to show your actual wealth growth.

---

## 📓 Second Brain & Productivity (G10, G12)

- **[Obsidian:](03_Quick-Start-Guide.md)** The markdown-based note-taking app used as your "Second Brain" and primary interface for documentation.
- **[Daily Note:](03_Quick-Start-Guide.md)** The central note created every day that acts as your dashboard for tasks, missions, and metrics.
- **[Frontmatter (YAML):](../10_Goals/Documentation-Standard.md)** The block of data at the top of a note (between `---`) that allows the system to read the note's status programmatically.
- **[Dataview:](03_Quick-Start-Guide.md)** An Obsidian plugin that allows you to query your notes like a database.
- **[MINS (Most Important Next Step):](04_FAQ.md)** The single most impactful task for a goal, identified daily to prevent decision fatigue.
- **[Deep Work:](../10_Goals/G10_Intelligent-Productivity-Time-Architecture/README.md)** High-focus time blocks (usually 06:00-09:00) protected by the system from interruptions.
- **[ROI of Autonomy:](../10_Goals/G12_Complete-Process-Documentation/README.md)** Measuring how many minutes of your life are "reclaimed" by a specific automation.

---

## 🏥 Health & Home (G03, G07, G08)

- **[Biometrics:](../10_Goals/G07_Predictive-Health-Management/README.md)** Biological measurements like Heart Rate Variability (HRV), Sleep Score, and Muscle Mass.
- **[Zepp / Amazfit:](../50_Automations/scripts/G07_zepp_sync.md)** The platform used to capture daily activity and sleep data from wearables.
- **[Withings:](../50_Automations/scripts/G07_weight_sync.md)** The smart scale ecosystem used for high-precision body composition tracking.
- **[Home Assistant](../20_Systems/S07_Smart-Home/README.md):** The open-source hub used to control your physical home (lights, temperature, sensors).
- **[Zigbee / Z-Wave:](../20_Systems/S07_Smart-Home/README.md)** Wireless protocols used by smart home devices to communicate without clogging your WiFi.
- **[HIT (High Intensity Training):](../10_Goals/G01_Target-Body-Fat/README.md)** A strength training philosophy focused on low volume and maximum intensity.
- **[RPE (Rate of Perceived Exertion):](../10_Goals/G01_Target-Body-Fat/Training/README.md)** A 1-10 scale used to log how hard a workout set actually felt.

---
*Glossary Version: 2.0 | Last Updated: 2026-02-28*
