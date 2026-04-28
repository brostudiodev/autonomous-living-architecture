---
title: "S04: Agent Registry"
type: "system_spec"
status: "active"
system_id: "S04"
goal_id: "goal-g04"
version: "1.1"
owner: "Michał"
updated: "2026-04-12"
---

# S04: Agent Registry

## Purpose
This registry defines the specialized AI agents (Sub-Agents) within the Digital Twin Ecosystem. It codifies their identities, domains of expertise, and specific capabilities to ensure structured, secure, and context-efficient autonomous operations.

## Agent Architecture: "The Council of Specialists"
The ecosystem operates on a **Supervisor-Specialist** model. **Agent Zero** acts as the Supervisor, delegating tasks to domain-specific specialists based on the user's intent or system-identified frictions.

---

## 🤖 0. Agent Zero (The Supervisor)
- **Role:** Master Orchestrator & Strategic Partner.
- **Domain:** `admin`, `meta`, `all`.
- **Primary Goal:** Holistic life optimization and North Star alignment.
- **Capabilities:**
    - **See:** Full system context (`/all`), cross-domain correlations, and strategic memory.
    - **Do:** All tools in the manifest, global sync, and sub-agent delegation.
    - **Interface:** Primary Telegram interaction point for the user.
- **Tools:** `[ALL_TOOLS]`

## 💸 1. Finance Agent
- **Role:** Autonomous Treasury & Budget Manager.
- **Domain:** `finance`.
- **Primary Goal:** Financial integrity and wealth optimization.
- **Capabilities:**
    - **See:** Bank transactions, budget status, burn rates, and liquidity forecasts.
    - **Do:** Budget rebalancing, anomaly detection, tax/savings allocation, and financial reporting.
- **Tools:** 
    - `finance_anomaly_detector`
    - `budget_rebalancer`
    - `preemptive_rebalancer`
    - `tax_savings_agent`

## 🧬 2. Health Agent
- **Role:** Biological Performance Coach.
- **Domain:** `health`.
- **Primary Goal:** Peak physical state and longevity (Target: 15% Body Fat).
- **Capabilities:**
    - **See:** HRV, Sleep scores, steps, weight, and training logs (TUT/PRs).
    - **Do:** Training injection (HIT), recovery-based scheduling adjustments, and illness detection.
- **Tools:** 
    - `health_recovery_pro`
    - `illness_detector`
    - `training_injector`
    - `strength_auditor`
    - `bio_nutrition_agent`

## 🛒 3. Inventory Agent (Household)
- **Role:** Autonomous Logistics & Pantry Manager.
- **Domain:** `household`.
- **Primary Goal:** Frictionless household operations (Zero-Out-of-Stock).
- **Capabilities:**
    - **See:** Pantry inventory across 9 locations, meal plans, and grocery prices.
    - **Do:** Cart aggregation, predictive restocking, and "One-Click" shopping list generation.
- **Tools:** 
    - `cart_aggregator`
    - `pantry_sync`
    - `pantry_suggestor`
    - `predictive_pantry_decay`
    - `pantry_one_click`
    - `predictive_inventory`

## 🎯 4. Productivity Agent
- **Role:** Time Architect & Focus Guard.
- **Domain:** `productivity`.
- **Primary Goal:** Maximizing high-cognitive "Deep Work" hours.
- **Capabilities:**
    - **See:** Google Calendar, Google Tasks, focus readiness scores, and meeting briefings.
    - **Do:** Schedule negotiation (AI via n8n), calendar enforcement (DND/Blocks), and task triage.
- **Tools:** 
    - `focus_intelligence`
    - `bio_load_balancer`
    - `calendar_enforcer`
    - `task_triage`
    - `micro_slot_triage`
    - `morning_rescheduler`
    - `zone_in_orchestrator`
    - `location_intelligence`
    - `schedule_negotiator`

## 🚀 5. Career Agent
- **Role:** Personal Brand & Professional Growth Strategist.
- **Domain:** `career`, `learning`.
- **Primary Goal:** Industry recognition as "Automationbro" and career advancement.
- **Capabilities:**
    - **See:** Technical wins (Git commits), content performance metrics, and industry trends.
    - **Do:** Technical win harvesting, automated LinkedIn/Substack drafting, and study velocity tracking.
- **Tools:** 
    - `technical_win_harvester`
    - `content_draft_agent`
    - `study_velocity`
    - `learning_deadline_recalculator`
    - `substack_scheduler`
    - `market_scout_handler`

## 📦 6. Logistics Agent
- **Role:** Life Admin & Smart Home Monitor.
- **Domain:** `logistics`.
- **Primary Goal:** Zero "Life Admin" friction (no missed deadlines/broken appliances).
- **Capabilities:**
    - **See:** Document expiries, relationship frequencies, appliance health, and smart home sensors.
    - **Do:** Expiry alerting, relationship reminders, and hardware status monitoring.
- **Tools:** 
    - `logistics_enforcer`
    - `life_sentinel`
    - `relationship_sentinel`
    - `contextual_security`

---

## 🔒 Security & Scope Control
- **Manifest Tags:** Agents are restricted to tools tagged with their specific `domain`.
- **API Access:** Restricted to domain-specific endpoints as defined in [Tool Mapping Spec](./Tool-Mapping-Spec.md).
- **Audit Rule:** Every agent action is logged in the `system_activity_log` for Supervisor (Agent Zero) review.

---
*Updated: 2026-04-12 | Part of G04 Digital Twin Ecosystem*
