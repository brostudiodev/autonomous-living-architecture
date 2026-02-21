# Adr-0011: Hardcoded User ID for Initial Router Security

- **Status**: Active
- **Date**: 2026-02-12
- **DECIDERS**: {{OWNER_NAME}}

## Context and Problem Statement

The central Intelligence Hub workflow (WF001) has multiple entry points, including a public-facing Telegram endpoint. To prevent unauthorized access and resource consumption while in the initial development phase, a simple and immediate security mechanism was required. The primary concern was to ensure that only the system owner could interact with the bot without building a complex user management system prematurely.

## Decision Drivers

-   **Speed of Implementation**: A simple authorization check was needed immediately to secure the endpoint.
-   **Simplicity**: Avoid the overhead of setting up a database, user service, or external configuration management for a single-user system.
-   **Low Initial Scale**: The system is currently intended for a single user, making a simple allowlist sufficient.
-   **Control**: A hardcoded value provides a deterministic and easily verifiable security check.

## Considered Options

1.  **No Authorization**: Leave the Telegram endpoint completely open. This was rejected due to the risk of spam, abuse, and resource consumption (e.g., triggering expensive AI analysis).
2.  **Dynamic Configuration (e.g., Environment Variable)**: Store the allowed user ID in an environment variable within the n8n instance. This is a better practice but still requires managing configuration outside the workflow.
3.  **User Database/Service**: A full-fledged user management system. This was considered overkill for the initial phase of a single-user project.
4.  **Hardcoded User ID in Workflow**: Embed the allowed user ID directly into a node within the n8n workflow.

## Decision Outcome

**Chosen Option:** #4, Hardcoded User ID.

A new `If` node (`Authorized1`) was added directly after the Telegram trigger. This node compares the incoming `user_id` from the Telegram message with a hardcoded string (`"7689674321"`).

-   If the ID matches, the workflow continues.
-   If it does not match, the workflow is routed to a `Telegram` node (`Unauthorized Reply`) that sends an "Unauthorized access" message and then stops.

This approach was chosen for its immediacy and simplicity, providing an effective "good enough" security layer for the current project stage.

### Positive Consequences

-   The Telegram endpoint is secured from unauthorized use instantly.
-   No external dependencies (database, config files) were needed.
-   The logic is extremely simple to understand and debug.

### Negative Consequences

-   **High Technical Debt**: This is a clear anti-pattern for any multi-user or production system.
-   **Inflexible**: To change the user or add another, the workflow itself must be edited and redeployed.
-   **Security Risk**: The user ID is stored in plain text within the workflow's JSON definition, which is checked into version control. While the risk is low for a Telegram user ID, it is a poor security practice.

## Future Evolution

This implementation is explicitly considered **temporary**. The plan is to address this technical debt by migrating to a more robust solution as the system matures. The recommended path is:

1.  **Near-Term**: Move the hardcoded ID to an n8n environment variable. This removes the ID from version control and allows for easier updates without redeploying the entire workflow.
2.  **Long-Term**: Implement a simple user service or a database lookup (e.g., using a local SQLite database or a key-value store) to manage a list of authorized users. This will be necessary if the system needs to support more users or more granular permissions.

## Linkages

-   **Workflow**: `WF001_Agent_Router`
-   **Node**: `Authorized1`
