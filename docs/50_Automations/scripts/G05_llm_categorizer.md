---
title: "G05: Financial Intelligence (LLM Categorizer)"
type: "automation_spec"
status: "active"
automation_id: "G05_llm_categorizer.py"
goal_id: "goal-g05"
systems: ["S05"]
owner: "Michal"
updated: "2026-04-19"
---

# G05: Financial Intelligence (LLM Categorizer)

## Purpose
Automates the classification of raw financial transactions into a hierarchical category structure. It transforms ambiguous bank data into high-signal financial intelligence using a hybrid logic approach.

## Key Features
- **Multi-Stage Classification:**
    1.  **Regex Match:** Immediate classification for known merchants.
    2.  **Historical Memory (Updated Apr 19):** Checks transaction history up to **3650 days (10 years)** back for similar patterns.
    3.  **LLM Inference:** Uses Gemini Pro to categorize unique or complex transactions based on descriptions.
- **Feedback Loop:** If the LLM is uncertain, it marks the transaction as "Other" and triggers a human review request via the `G05_LOOP` marker in Obsidian.
- **Accuracy Tracking:** Maintains logs of automated vs. human-corrected categories.

## Triggers
- **Automated:** Part of the `G11_global_sync.py` registry.
- **Manual:** `python3 scripts/G05_llm_categorizer.py`

## Inputs
- **Database:** `autonomous_finance` (Table: `transactions`).
- **External:** Google Gemini API (for LLM classification).

## Outputs
- **PostgreSQL:** Updated `category_id` and `confidence_score` in the `transactions` table.
- **System Activity Log:** Records classification statistics.

## Processing Logic
1.  **Fetch Uncategorized:** Retrieves transactions with 'Other' category IDs (24, 37).
2.  **Deterministic Logic:**
    - Checks for exact merchant matches in the `merchants` table (preserving `is_trusted` status).
    - Applies `get_regex_mapping()` for keyword matches.
    - If a match is found, checks `get_safe_zone_keywords()` to determine if the merchant should be considered 'Trusted'.
3.  **AI Fallback:** Remaining transactions are sent to Gemini 1.5 Flash for category proposal.
4.  **Authority Check:** Passes categorized transactions to the `G11_rules_engine` with `is_trusted` context.
5.  **Execution:** Updates the `transactions` table (marking `is_approved=TRUE` if authorized) and upserts to the `merchants` table.

## Dependencies
### Systems
- [S05 Finance System](../../10_Goals/G05_Autonomous-Financial-Command-Center/README.md)
- [S03 Data Layer](../../20_Systems/S03_Data-Layer/README.md)

## Manual Fallback
If categorization is inaccurate:
1.  Use the `%%G05_LOOP%%` section in the Daily Note to provide manual corrections.
2.  Update the regex rules in the script for recurring misclassifications.
