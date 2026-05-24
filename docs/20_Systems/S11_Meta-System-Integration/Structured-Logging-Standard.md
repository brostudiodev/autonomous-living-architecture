---
title: "S11: Structured Logging Standard"
type: "standard"
status: "active"
owner: "Michał"
updated: "2026-05-09"
---

# Structured Logging Standard (G11)

## Purpose
To ensure all autonomous scripts emit logs that are machine-readable, searchable, and correlatable across the distributed ecosystem.

## Status (May 2026 Update)
- **Migration Fully Complete:** A system-wide decommissioning pass was completed on 2026-05-12, refactoring 281 scripts to eliminate all legacy `print()` statements in favor of structured logging.
- **Coverage:** 360+ scripts in the ecosystem are now clean of `print()` calls and integrated with this standard via `db_config.py`.
- **Enforcement:** The G11 Security and Stability auditors now flag any raw `print()` statements in production scripts as technical debt.

## Key Features
- **JSON Format:** All logs are output as single-line JSON objects.
- **Correlation IDs:** Unique 8-character IDs to track logs across a single execution or thread.
- **Service Metadata:** Hostname, module, function, and line number included in every log.
- **Extensibility:** Supports passing arbitrary `extra_data` dictionaries (e.g., `count`, `duration_s`, `is_fresh`).

## Log Schema
| Field | Type | Description |
|-------|------|-------------|
| `timestamp` | ISO8601 | UTC timestamp with millisecond precision (`YYYY-MM-DDTHH:MM:SS.mmmZ`). |
| `level` | Enum | `DEBUG`, `INFO`, `WARNING`, `ERROR`, `CRITICAL`. |
| `name` | String | The name of the script or logger. |
| `message` | String | The human-readable log message. |
| `correlation_id` | String | Unique ID for the current execution context. |
| `hostname` | String | The machine/container where the script is running. |
| `module` | String | Python module name. |
| `func` | String | Function name where the log originated. |
| `line` | Integer | Line number in the source code. |
| `...` | Mixed | Any keys passed via `extra_data` appear as top-level fields in the JSON. |

## Implementation (Python)

### 1. Basic Usage
```python
from db_config import setup_logger

logger = setup_logger("my_script")
logger.info("Process started")
```

### 2. Structured Data (Advanced)
```python
logger.info("Transaction processed", extra_data={"amount": 500, "currency": "USD"})
```

### 3. Correlation Tracking
The `setup_logger` automatically initializes a correlation ID. To manually set or retrieve it:
```python
from db_config import set_correlation_id, get_correlation_id

set_correlation_id("JOB-123")
logger.info("Specific job started") # correlation_id will be "JOB-123"
```

## Storage & Aggregation
- **Local Logs:** `{{ROOT_LOCATION}}/autonomous-living/scripts/logs/structured/*.json.log`
- **Aggregation:** Targeted for future ELK (Elasticsearch/Logstash/Kibana) or Grafana Loki integration.

## References
- `scripts/db_config.py`
- `scripts/utils/structured_logger.py`
