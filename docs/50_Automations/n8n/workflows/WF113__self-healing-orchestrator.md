---
title: "Workflow Spec: WF113 Self-Healing Orchestrator"
type: "n8n_workflow"
status: "active"
owner: "Michal"
updated: "2026-03-16"
---

# 🤖 Workflow Spec: WF113 Self-Healing Orchestrator

## 📝 Overview
**Purpose:** Processes system failure reports from the CLI client using AI to analyze root causes and suggest recovery actions.
**Goal Alignment:** G11 Meta-System Integration (Closing the loop on stability).

## 🏗️ Workflow Architecture
1. **Webhook Trigger:** Receives failure JSON from `G11_self_healing_client.py`.
2. **AI Analysis (Gemini):**
    - **Prompt:** "Analyze these Python script failures. Identify if the root cause is DB connectivity, API token expiry, or logic error. Provide a 1-sentence recovery plan."
    - **Context:** Failure list + OS info + Previous activity logs.
3. **Decision Branch:**
    - **Known Issue:** If root cause is identified (e.g., Zepp Token expired), trigger specialized remedy.
    - **Complex Issue:** Send detailed Telegram alert to user with AI suggestion.
4. **Remedy Execution:**
    - Call `G07_auth_helper.py` or restart specific Docker containers via SSH/Command node.
5. **Notification:** Updates the user via Telegram on the healing status.

## ⚡ Technical Details
- **Trigger:** Webhook (POST)
- **AI Model:** Gemini 1.5 Flash (via n8n AI Node)
- **Primary Integrations:** Telegram, Digital Twin API, SSH (for service restarts).

## 📤 Outputs
- **Remedy Action:** Automated system fix.
- **Telegram Status:** "🩹 AI attempted self-healing for: [Script Name]. Result: [Success/Failure]."

## ⚠️ Known Issues / Maintenance
- **Infinite Loops:** The workflow must not trigger a script that subsequently triggers the workflow. Always use `--no-healing` or similar flags for remedy commands.

---
*Autonomous system stability via n8n/LLM introduced Q1 2026.*
