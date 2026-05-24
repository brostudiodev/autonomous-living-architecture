---
title: "Standard: Modular Script Logging"
type: "standard"
status: "active"
owner: "Michał"
updated: "2026-05-20"
---

# Standard: Modular Script Logging

## Purpose
To ensure 100% operational visibility across the autonomous life engine by standardizing how modular scripts report their success, failure, and telemetry to the Digital Twin.

## Scope
- **Applies to:** All Python scripts located in `modules/*/scripts/`.
- **Requirement:** Every script must report its final execution status to the `system_activity_log`.

## Implementation Pattern

### 1. SDK Imports
All modular scripts must use the centralized `autonomous_sdk` for logging.

```python
from autonomous_sdk.db_config import setup_logger
from autonomous_sdk.log import log_activity

# Initialize the structured logger
logger = setup_logger(__file__)
```

### 2. Standard Main Block
The execution must be wrapped in a try-except block to capture and log any unhandled exceptions.

```python
if __name__ == "__main__":
    script_name = "GXX_your_script_name" # Use the filename without .py
    try:
        # Core logic execution
        result = main() 
        
        # Log success
        log_activity(
            script_name, 
            "SUCCESS", 
            items=1, # Number of items processed if applicable
            details="Describe the primary outcome briefly"
        )
    except Exception as e:
        # Log failure with full error details
        logger.error(f"❌ {script_name} failed: {e}", exc_info=True)
        log_activity(script_name, "FAILURE", details=str(e))
```

## Traceability
Logs generated via `log_activity` are consumed by:
1. **Connectivity Map (`/map`):** Colors nodes green (Success) or red (Failure).
2. **Reliability Auditor:** Calculates success rates and MTBF (Mean Time Between Failures).
3. **Director's Briefing:** High-signal failures are surfaced in the morning mission briefing.

## Verification
1. Run the script.
2. Check the `system_activity_log` table in the `digital_twin_michal` database.
3. Verify the node status on the Connectivity Map.

---
*Created: 2026-05-20 by Gemini CLI Assistant*
