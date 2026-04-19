---
title: "Principles"
type: "strategy"
status: "active"
owner: "Michal"
updated: "2026-04-19"
---

# Principles of Autonomous Living

## 🤖 Automation Principles
1.  **Automate the *Boring* First:** Don't automate a passion project; automate the tasks you'd pay someone else to do.
2.  **Observe Before Acting (The Telemetry Rule):** You cannot automate what you cannot measure. Living without journaling/logging is "running in no-telemetry mode." Every workflow begins with a telemetry source.
3.  **Reliable Simplicity > Fragile Cleverness:** A Python script with 10 lines is better than an n8n workflow with 50 nodes if it achieves the same result.
4.  **Manual Fallback Required:** Until an automation is "v2.0 Proven," there must be a way to execute the task manually without breaking the data flow.
5.  **Assume & Act (G10/G11):** Autonomous systems should take the most likely action and log it, rather than waiting for user permission (unless the risk is financial or physical).
6.  **The Friction Rule:** Automation is not about replacing humanity; it is about eliminating administrative friction to allow for higher-level human judgment and focus.

## 📖 Documentation Principles
- **Write for Future-You on Low Sleep:** If you can't understand the doc at 6 AM after a bad night's rest, the doc is too complex.
- **Traceable logic:** Every goal README must link to the specific system and automation that enables it.
- **Checklists > Paragraphs:** Use bullet points for procedures; humans (and AIs) parse them faster.
- **Documentation is Your New Source Code:** If the documentation doesn't match the current code/workflow, the system is technically "broken." Compounding knowledge through documentation is as important as code commits.

## 🏛️ Architectural Philosophy
- **Unified Meta-System (The "Loop" Principle):** Avoid building "islands" of automation. True life-systems are interconnected where data from one domain (Nutrition) influences others (Sleep, Productivity).
- **Database-First Intelligence:** Store your "Single Source of Truth" in PostgreSQL, not in YAML frontmatter or ephemeral API calls.
- **Security-First AI Mandate:** 
    - Never point AI at production without isolation (Sandboxes).
    - Secrets/Credentials never enter prompts.
    - Explicitly prompt for security (SQLi/XSS protection) as AI defaults to the "happy path."
- **Privacy by Design:** Keep sensitive biometric and financial data in your homelab. Use cloud services (like Gemini) only as stateless processing units.
- **The "Digital Twin" Hub:** No system should stand alone. If it's not feeding the Digital Twin (G04), it's not part of your life-system.
- **Decoupled Interfaces:** Your Second Brain (Obsidian) is for *visualizing* and *planning*; the Database is for *storing*; n8n is for *moving*. Keep these roles separate.

## 🚀 Mindset: Autonomy > Automation
Automation is about *performing* a task. Autonomy is about *managing* the entire lifecycle of that task.
- **Goal:** Reach a state where you don't even have to *think* about the task existing anymore.
- **Strategic Seniority:** In the age of AI, seniority is defined by **Value per Hour** and **Strategic Decision-Making**, not syntax knowledge. Focus on being the "Conductor" of your system.

