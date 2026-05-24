---
title: "Adr-0022: Environment-Aware Tool Execution"
type: "adr"
status: "accepted"
owner: "Michał"
updated: "2026-04-30"
goal_id: "goal-g11"
---

# Adr-0022: Environment-Aware Tool Execution

## Status
Accepted (2026-04-30)

## Context
The "Autonomous Living" system runs in a hybrid environment where scripts may be executed directly on the host machine or within a Docker container (`digital-twin-api`). 

A recurring failure mode (Exit Code 127: Command Not Found) was identified when the API attempted to execute G-series tools. This was caused by hardcoded paths to the Python virtual environment (`.venv/bin/python3`) which exist on the host but not at the same location within the container. Additionally, orchestrator scripts like `autonomous_daily_manager.py` were using hardcoded relative paths to find their sub-scripts, leading to execution failures in the containerized `/app` structure.

## Decision
We will implement a dynamic, environment-aware tool execution strategy across the entire script ecosystem:

1.  **VENV_PYTHON Protocol:** All orchestrator scripts and the API ToolRegistry will prioritize the `VENV_PYTHON` environment variable for determining the Python interpreter path.
2.  **API Auto-Healing:** The `ToolRegistry` in `G04_digital_twin_api.py` will:
    *   Detect Docker environments (via `/.dockerenv`).
    *   Inject the correct `VENV_PYTHON` path into the environment of all executed tools.
    *   Implement an "Active Retry" mechanism that catches exit code 127 and attempts a fallback to the system python (`/usr/bin/python3`) if a venv mismatch is detected.
3.  **Path Neutrality:** Scripts will use `os.path.dirname(os.path.abspath(__file__))` (aliased as `SCRIPT_DIR`) to locate sibling scripts, ensuring they work whether mapped to `/home/{{USER}}/.../scripts` or `/app/`.

## Consequences
*   **Portability:** The system can now be migrated between host and containerized execution without manual path reconfiguration.
*   **Resilience:** The "Daily Note" dashboard and other multi-script orchestrators are protected against "Command Not Found" errors.
*   **Complexity:** Slight increase in script boilerplate to handle path detection, though this has been standardized via a batch refactor.
*   **Observability:** Exit code 127 is now explicitly handled and logged as a recoverable system event.

## References
- [G04: Digital Twin API](../20_Systems/S04_Digital-Twin/API-Specification.md)
- [G11: Meta-System Integration](../20_Systems/README.md)
