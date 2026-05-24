# ADR-0034: Modular Migration Completion & Script Deprecation

*   **Status:** Proposed
*   **Owner:** Michal
*   **Decided by:** Gemini CLI
*   **Date:** 2026-05-20

## Context
Since the introduction of the **Modular SDK (v2.0)** in May 2026, the system has transitioned from a flat, procedural script architecture to a tiered, object-oriented modular architecture. 

Historically, all automation logic resided in the root `/scripts` folder. This led to:
1.  **Path Fragility:** Scripts relied on fragile relative paths to find the project root or each other.
2.  **Import Chaos:** Circular dependencies and redundant database connection logic were common.
3.  **Audit Gaps:** The Digital Twin map often showed "Unknown" status because scripts lacked a standardized logging lifecycle.

## Decision
We formally declare the **Modular Migration complete**. 

1.  **Modular Standard:** All production logic MUST reside within a module in the `/modules` directory.
2.  **Kernel/Userland Split:**
    *   `core/`: Contains the Kernel (FastAPI, Registry, Orchestrator, Engine).
    *   `modules/`: Contains Domain Modules (Health, Finance, Productivity, etc.).
    *   `autonomous_sdk/`: Contains the Shared Library for all modules.
3.  **Deprecation of `/scripts`:** 
    *   The root `/scripts` folder is now considered **Legacy**. 
    *   Production automation MUST NOT run logic directly from `/scripts`.
    *   Existing files in `/scripts` are either proxies (wrappers for modular code) or utilities awaiting modularization.
    *   The `/scripts` folder will eventually be archived.
4.  **Lifecycle Requirements:** Every modular script MUST implement `STARTED`, `SUCCESS`, and `FAILURE` logs via the `autonomous_sdk.log` service to ensure visibility on the Digital Twin map.

## Consequences
*   **Next LLM Guidance:** Any future agent or developer reviewing this project must treat `/modules` as the "Source of Truth" for automation logic.
*   **System Integrity:** Standardized path resolution via the SDK ensures the system runs consistently across Host and Docker environments.
*   **Visibility:** 100% operational transparency on the `/map` endpoint.
*   **Legacy Cleanup:** New features must never be added to `/scripts`. Existing scripts in `/scripts` should be treated as candidates for migration to `/modules`.
