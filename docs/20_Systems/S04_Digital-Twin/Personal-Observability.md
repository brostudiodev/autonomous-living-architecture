---
title: "S04: Personal Observability (AI Journaling)"
type: "system_spec"
status: "active"
goal_id: "goal-g10"
system_id: "S04"
owner: "Michał"
updated: "2026-04-19"
---

# S04: Personal Observability Architecture

## Purpose
Evolves traditional journaling into a high-fidelity telemetry stream for the Digital Twin. This system transforms qualitative life experiences into quantitative data for autonomous analysis.

---

## 🏗️ The Three-Layer Observability Model

### **Layer 1: System Config (Context Anchor)**
- **Source:** `00_Start-here/Principles.md`, `North-Star.md`, and known behavioral patterns.
- **Role:** Provides the LLM with the "Operating Manual" for Michał. Values, long-term goals, and hard constraints.
- **Implementation:** Injected into Agent Zero's system prompt and RAG context.

### **Layer 2: Runtime Logging (Daily Telemetry)**
- **Source:** Obsidian Daily Notes, Telegram `/mood` and `/energy` commands, and the `/ouch` friction log.
- **Role:** Captures the "Current State" of the human system. Decisions made, emotions felt, and operational friction encountered.
- **Implementation:** Structured JSONB storage in `daily_intelligence` table.

### **Layer 3: Retrospectives (Behavioral Debugging)**
- **Source:** `G11_decision_pattern_analyzer.py` and `G11_friction_discovery.py`.
- **Role:** Weekly AI-driven analysis to identify behavioral "bugs" (recurring toxic patterns) or "memory leaks" (energy-draining habits).
- **Implementation:** Automated n8n workflows (`WF_decision_pattern_analyzer`) generating the Weekly Review.

---

## 🛠️ Key Telemetry Streams

| Stream | Tool | Frequency | Purpose |
| :--- | :--- | :--- | :--- |
| **Mood/Energy** | `/mood`, `/energy` | 3x / day | Correlation with productivity score. |
| **Friction** | `/ouch` | As it happens | Identifying system bottlenecks. |
| **Reflection** | `/reflect` | Evening | Qualitative summary of the day's wins/losses. |
| **Attention** | `aw-server-rust` | Passive | Measuring "Reality Audit" vs. Intent. |

---

## 🔄 The "Telemetry Rule"
*Living without journaling is running in 'no-telemetry mode'. You cannot optimize a system (yourself) that you aren't logging.*

This system ensures that every strategic decision is grounded in historical reality rather than recency bias.

---

## 🔗 Related Components
- [Digital Twin Strategy](../../10_Goals/G04_Digital-Twin-Ecosystem/Digital-twin-strategy.md)
- [G11 Meta-System Architecture](../S11_Meta-System-Integration/README.md)
- [Daily Note Interface Spec](./Daily-Note-Interface-Spec.md)

---
*Updated: 2026-04-19 | Personal Observability v1.0*
