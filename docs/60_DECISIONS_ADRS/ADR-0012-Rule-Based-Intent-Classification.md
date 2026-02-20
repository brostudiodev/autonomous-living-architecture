# ADR-0012: Rule-Based Intent Classification in Agent Router

- **Status**: Active
- **Date**: 2026-02-12
- **DECIDERS**: {{OWNER_NAME}}

## Context and Problem Statement

The Intelligence Hub (WF001) needs to understand the user's intent to route incoming requests correctly (e.g., is this a command, a question, or something to be captured?). A mechanism was needed to classify raw text inputs into predefined categories like `command`, `question`, `capture`, `calendar`, etc. The solution had to be fast, deterministic, and capable of handling specific linguistic nuances, including Polish language patterns.

## Decision Drivers

-   **Determinism & Control**: For a personal automation system, predictable behavior is paramount. A rule-based system offers complete control over the classification logic.
-   **Performance**: The classification step should be fast to ensure a responsive user experience. LLM calls can introduce significant latency.
-   **Cost-Effectiveness**: Using a local code node avoids API calls to expensive LLM services for every single message.
-   **Specificity**: The system required highly specific pattern matching for commands (`/command`) and nuanced keywords, especially for Polish calendar queries (`spotkanie`, `jutro o 15:00`, `w poniedziałek`). Regex and string matching are exceptionally well-suited for this.
-   **Bootstrapping**: A rule-based system is easier to build and iterate on initially without needing a large dataset for training a model.

## Considered Options

1.  **LLM-based Semantic Classification**: Use a powerful LLM (like Gemini) to classify the intent based on semantic understanding. This would be more flexible and handle a wider range of natural language, but at the cost of latency, expense, and non-determinism.
2.  **Lightweight NLP Library**: Use a library like `compromise` or a small, locally-run classification model. This offers a middle ground but adds a dependency and may not be as precise for the specific Polish-language rules required.
3.  **Keyword Matching**: A simple lookup of keywords. This is too simplistic and would fail to handle sentence structure, negation, or the combination of keywords required for calendar intent.
4.  **Rule-Based Hierarchical Classifier**: A code-based solution using a series of `if/else` statements and regular expressions to create a priority-ordered classification engine.

## Decision Outcome

**Chosen Option:** #4, Rule-Based Hierarchical Classifier.

A JavaScript `Code` node (`Stage3 Classify`) was implemented within the n8n workflow. This node executes a series of checks in a specific order of priority:

1.  **Callback**: Checks for button presses first.
2.  **Command**: Looks for the `/` prefix.
3.  **Calendar**: Uses a complex set of regex patterns to detect calendar-related keywords and temporal phrases, with strong support for Polish grammar and inflections (e.g., `spotkan|spotkani|wizyt`).
4.  **Explicit Capture**: Matches keywords like `note:` or `zapisz`.
5.  **Implicit Capture**: Infers intent from the format detected in the previous stage (e.g., a PDF is likely for `capture`).
6.  **Question/Task/Greeting**: Uses simpler regex to catch common patterns.
7.  **Fallback**: Defaults to `conversation` or `implicit_question`.

This approach provides the required control and performance while being highly effective for the well-defined intents of the system.

### Positive Consequences

-   **High Accuracy for Defined Intents**: The classifier is extremely accurate for commands and the specific calendar queries it was designed for.
-   **Fast and Free**: Execution is nearly instantaneous and incurs no API costs.
-   **Full Control**: The logic is explicit and easy to modify to handle new, specific rules.
-   **Excellent Polish Language Handling**: The custom regex successfully handles many cases of Polish inflection and phrasing that a generic model might miss without specific fine-tuning.

### Negative Consequences

-   **Maintenance Burden**: The code block is complex and long. Adding new intents or modifying the logic requires careful coding and testing. The regex for Polish is particularly dense and hard to read.
-   **Brittle**: The classifier can only handle patterns it is explicitly programmed to recognize. It is not flexible with novel phrasing.
-   **Scalability Issues**: As the number of intents and rules grows, the code will become increasingly unwieldy and difficult to manage.

## Future Evolution

This rule-based system is a pragmatic starting point, but it represents significant **technical debt**. The strategic plan is to evolve towards a hybrid approach.

1.  **Near-Term**: The current system will be maintained for high-priority, deterministic intents like commands and callbacks.
2.  **Mid-Term**: A **semantic routing layer** using a lightweight, locally-hosted, or very fast/cheap LLM will be introduced. The rule-based classifier will act as a "guard" or pre-filter.
    -   If a high-confidence match is found by the rules (e.g., a `/command`), it will be routed immediately.
    -   If not, the text will be passed to the semantic router for more flexible, AI-driven classification.
3.  **Long-Term**: As the semantic router proves reliable, more of the complex regex logic (especially for general questions and captures) can be deprecated in favor of the AI-based approach, simplifying the codebase.

## Linkages

-   **Workflow**: `WF001_Agent_Router`
-   **Node**: `Stage3 Classify`
-   **Architectural Documentation**: `docs/20_SYSTEMS/S11_Intelligence_Router/README.md`
