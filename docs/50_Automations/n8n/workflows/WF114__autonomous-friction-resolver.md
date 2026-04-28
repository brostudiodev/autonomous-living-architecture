---
title: "Workflow Spec: WF114 Autonomous Friction Resolver"
type: "n8n_workflow"
status: "active"
owner: "Michał"
updated: "2026-04-10"
---

# 🤖 Workflow Spec: WF114 Autonomous Friction Resolver

## 📝 Overview
**Purpose:** Bridges qualitative user frustrations with quantitative system metrics to propose automation "Quick Wins" and lifestyle adjustments.
**Goal Alignment:** G11 Meta-System Integration & G12 Continuous Optimization Engine.

## 🏗️ Workflow Architecture
1. **Cron Trigger:** Runs every 30 minutes (configurable).
2. **Data Ingestion (Digital Twin API):** 
    - Calls `GET /all` to retrieve full system context.
    - Extracts `frustration` from the Obsidian Daily Note frontmatter.
    - Fetches `system_failures` and `budget_alerts` from the last 24 hours.
3. **AI Analysis (Gemini 1.5 Flash):**
    - **Prompt:** "Analyze the following system context and user frustration to propose a 'Quick Win' automation or a system adjustment. User Frustration: [FRUSTRATION]. System State: [SUMMARY]. Recent Failures: [FAILURES]."
    - **Context:** Subjective notes + Objective metrics.
4. **Action Proposal:**
    - Generates a concrete, technical proposal for a new script, n8n node, or habit change.
5. **Notification:** Sends the proposal via Telegram with a summary of the reasoning.

## ⚡ Technical Details
- **Trigger:** Schedule Trigger (30 min)
- **Primary Source:** `http://digital-twin-api:5677/all`
- **AI Model:** Gemini 1.5 Flash
- **Integrations:** Telegram, Digital Twin API.
- **Template:** `docs/50_Automations/n8n/templates/WF_Friction_Resolver.json`

## 📤 Outputs
- **Telegram Proposal:** 🕵️ **Friction Resolution Proposal**: [AI Suggestion]
- **Activity Log:** Logs the analysis event to `system_activity_log`.

## ⚠️ Known Issues / Maintenance
- **Data Freshness:** Depends on `G11_global_sync.py` and `autonomous_daily_manager.py` having run recently to provide accurate context.
- **LLM Noise:** If frustrations are vague, AI may propose generic advice.

---
*Introduced 2026-04-10 to replace legacy Python-heavy friction logic.*
