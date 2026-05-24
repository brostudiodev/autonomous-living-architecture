---
title: "Automations"
type: "index"
status: "active"
owner: "Michał"
updated: "2026-05-23"
---

# Automations

## 🧭 Interactive Automations Index
Click on a category to view specific workflows and script documentation:

- **[n8n Workflows](./n8n/)** (Business Process Automation)
- **[Python Scripts](./scripts/)** (Data Processing & Logic)
- **[Home Assistant](./home-assistant/)** (Smart Home Logic)
- **[GitHub Actions](./github-actions/)** (CI/CD & Sync)
- **[Documentation Templates](./templates/)** (Standardization)

## What belongs here
- n8n workflows (exports + docs)
- scripts
- Home Assistant automations/configs

## Rule
Every automation requires a matching doc describing:
purpose, dependencies, failure modes, rollback, and owner.

## Current Documentation Status
The production source of truth for Python automation logic is now `modules/<domain>/scripts/`, with `scripts/` retained primarily as a legacy/proxy layer after the modular migration.

Before trusting a script spec:
1. Check [G12 Documentation Audit Report](../G12_Documentation_Audit_Report.md).
2. Prefer module paths over legacy root `scripts/` paths.
3. Verify the spec frontmatter `script_hash` matches the active script.
4. Do not bulk regenerate specs with placeholder content; update real Purpose, Scope, Inputs/Outputs, Dependencies, Procedure, Failure Modes, Security Notes, and Owner/Review Cadence sections.

## 🧠 Intelligence Layer (LLM Services)
These services centralize all AI-driven decision-making and content generation in n8n, providing a unified API for local Python scripts.

| Service | Endpoint | Purpose |
|---------|----------|---------|
| [LLM Categorize](n8n/workflows/SVC_LLM_Categorize.md) | `/llm/categorize` | Transaction classification & breach detection. |
| [LLM Generate Idea](n8n/workflows/SVC_LLM_Generate-Idea.md) | `/llm/generate-idea` | ROI-based content ideation. |
| [LLM Draft Content](n8n/workflows/SVC_LLM_Draft-Content.md) | `/llm/draft-content` | Platform-specific content drafting. |
| [LLM Decision Proposal](n8n/workflows/SVC_LLM_Decision-Proposal.md) | `/llm/decision-proposal` | G11 Strategic rules engine evaluation. |


---

## ☕ Fuel the Architecture

Building and maintaining this level of technical rigor is a massive investment. If this blueprint helps your own engineering journey, I would be grateful for your support.

<a href='https://ko-fi.com/michalnowakowski' target='_blank'><img height='60' style='border:0px;height:60px;' src='https://storage.ko-fi.com/cdn/kofi3.png?v=3' border='0' alt='Buy Me a Coffee at ko-fi.com' /></a>

**Support my hard work in engineering a fully autonomous life.** Every coffee fuels another line of code, another automated insight, and another step toward the 2026 North Star. Your contributions help maintain the infrastructure and research shared in this open-source blueprint.
