---
title: "Automation Spec: G11 Decision Pattern Analyzer"
type: "automation_spec"
status: "active"
automation_id: "G11_decision_pattern_analyzer"
goal_id: "goal-g11"
systems: ["S11", "S04"]
owner: "Michał"
updated: "2026-03-26"
---

# G11: Decision Pattern Analyzer

## Purpose
Enables life-level meta-learning by logging manual decisions and analyzing the underlying logic patterns. It identifies cognitive biases and recurring friction points to optimize future decision-making.

## Triggers
- **Telegram Command:** `/decide [action] --reason [reason]`
- **Monthly Run:** Aggregates data for the Monthly Progress Summary.

## Inputs
- **Decision Log:** `manual_decisions` table in `digital_twin_michal`.
- **AI Synthesis:** Gemini Pro for meta-analysis.

## Processing Logic
1.  **Collection:** Fetches all manual decisions from the last 30 days.
2.  **Theme Extraction:** Uses LLM to find recurring topics (e.g., "Health vs. Work trade-offs").
3.  **Bias Detection:** Analyzes the reasoning for potential biases (e.g., loss aversion, sunk cost).
4.  **Optimization:** Generates concrete suggestions for improving the "Personal OS" logic.

## Outputs
- **Meta-Intelligence Report:** Markdown analysis for the Monthly Summary.
- **System Activity Log:** Records the completion of the analysis.

## Dependencies
- **PostgreSQL:** `digital_twin_michal`
- **Gemini API:** For high-level reasoning.

## Monitoring
- **Monthly Summaries:** `Obsidian Vault/02_Projects/Monthly Summaries/`
