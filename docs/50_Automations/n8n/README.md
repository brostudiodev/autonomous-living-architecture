# n8n Automation Intelligence Hub

This directory contains the specifications for AI-driven intelligence workflows managed by n8n. Following the project mandate, all LLM-based reasoning, summarization, and agentic behavior is strictly handled by n8n, while Python scripts act as deterministic data providers and executors.

## Active Intelligence Workflows

| Goal | Workflow Name | Template | Purpose |
|------|---------------|----------|---------|
| G04 | Proactive Reflection Drafter | [WF_proactive_reflection_drafter.json](./templates/WF_proactive_reflection_drafter.json) | Generates daily journal reflection drafts based on 360° system state. |
| G05 | Financial AI Categorizer | [WF_financial_categorizer.json](./templates/WF_financial_categorizer.json) | Assigns budget categories to uncategorized transactions using LLM reasoning. |
| G06 | Learning Ingester | [WF_learning_ingester.json](./templates/WF_learning_ingester.json) | Transforms raw study notes into structured Atomic Notes for the Brain. |
| G11 | Task Triage Pro | [WF_task_triage_pro.json](./templates/WF_task_triage_pro.json) | Prioritizes Google Tasks based on daily biometric readiness. |
| G11 | Decision Pattern Analyzer | [WF_decision_pattern_analyzer.json](./templates/WF_decision_pattern_analyzer.json) | Performs meta-analysis of manual decisions to identify cognitive biases. |
| G13 | Content Draft Agent | [WF_content_draft_agent.json](./templates/WF_content_draft_agent.json) | Drafts LinkedIn and Substack content based on daily technical wins. |

## Architectural Pattern: "Python = Body, n8n = Brain"

1.  **Data Harvesting (Python):** Scripts scan DBs, file systems, or APIs to collect "Raw Facts".
2.  **Context Delivery (API/File):** Facts are exposed via the Digital Twin API (`/all`, `/reflection`) or temporary JSON files in `_meta/`.
3.  **Intelligence (n8n):** Workflows trigger on schedules, fetch the context, consult Gemini LLM, and make a "Qualitative Decision".
4.  **Execution (n8n/Python):** n8n either executes the action directly (e.g., updating a DB row) or triggers a Python "Executor" script to finalize the change.

## Maintenance
- **Review Cadence:** Monthly audit of LLM prompt effectiveness in n8n.
- **Fail-Safe:** Python scripts must always provide a deterministic fallback or "Wait for n8n" state if the intelligence layer is unavailable.
