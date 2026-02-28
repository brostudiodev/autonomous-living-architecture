---
title: "G12_auto_documenter.py: AI Documentation Generator"
type: "automation_spec"
status: "active"
automation_id: "g12-auto-documenter"
goal_id: "goal-g12"
systems: ["S12"]
owner: "Michal"
updated: "2026-02-27"
---

# G12_auto_documenter.py

## Purpose
A meta-automation tool that uses the Google Gemini 1.5 Pro model to automatically generate standard-compliant Markdown documentation from source code (Python) or configuration files (n8n JSON). This ensures the codebase remains documented without manual effort.

## Triggers
- **Manual:** Executed by the developer when new code is committed or modified.
- **CI/CD:** Potential for future integration into GitHub Actions to enforce documentation on PRs.

## Inputs
- **Source File:** Path to a `.py` (Python) or `.json` (n8n workflow) file.
- **Goal Documentation Standard:** Reads `docs/10_Goals/Documentation-Standard.md` to use as the base prompt for the AI.
- **Environment Variables:** `GEMINI_API_KEY` for AI processing.

## Processing Logic
1.  **Context Aggregation:** Reads the target source file and the project's documentation standard.
2.  **Prompt Engineering:** Constructs a detailed prompt for Gemini 1.5 Pro, instructing it to extract tactical details (Triggers, Inputs, Logic, etc.) and format them into the project's specific Markdown template.
3.  **AI Analysis:** The LLM analyzes the code structure and intent to generate the documentation content.
4.  **Output Routing:**
    - Python files are documented in `docs/50_Automations/scripts/`.
    - JSON files are documented in `docs/50_Automations/n8n/services/`.
    - Automatically creates missing directories if needed.

## Outputs
- **Markdown Specification File:** A `.md` file containing the complete technical specification of the target code.
- **Console Log:** Status updates on analysis and file generation.

## Dependencies
### Systems
- [S12 Complete Process Documentation](../../20_Systems/S12_Complete-Process-Documentation/README.md) - Parent system.

### External Services
- **Google Gemini API (1.5 Pro):** AI reasoning engine for code analysis.
- **google-generativeai:** Official Python SDK for Gemini.

## Error Handling
| Failure Scenario | Detection | Response | Alert |
|---|---|---|---|
| API Key Missing | `if not api_key` check | Exit with error message | Console |
| File Not Found | `os.path.exists()` check | Print "❌ File not found" and exit | Console |
| AI Generation Error | `try/except` block | Log exception and exit | Console |

## Security Notes
- **API Security:** `GEMINI_API_KEY` is loaded from a restricted `.env` file.
- **Privacy:** Source code is sent to Google's Gemini API for processing. Avoid documenting files with hardcoded secrets.

## Manual Fallback
Technical documentation can be manually written using the templates provided in `docs/10_Goals/Documentation-Standard.md`.

## Related Documentation
- [Goal: G12 Complete Process Documentation](../../10_Goals/G12_Complete-Process-Documentation/README.md)
- [Standard: Goal Documentation Standard](../../10_Goals/Documentation-Standard.md)
