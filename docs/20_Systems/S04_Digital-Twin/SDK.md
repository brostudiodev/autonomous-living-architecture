# Autonomous Living SDK

## Overview
The Autonomous Living SDK provides a standardized set of services and interfaces for building modular life-automation components. It ensures consistency in database access, event emission, logging, and stability patterns across the entire ecosystem.

## Core Components

### 1. BaseModule (`autonomous_sdk.module`)
Every module must extend `BaseModule`.
```python
from autonomous_sdk.module import BaseModule

class Module(BaseModule):
    def on_startup(self):
        # Initialize resources
        pass

    def sync(self):
        # Main execution logic
        pass
```

### 2. Database Layer (`autonomous_sdk.db`)
Safe, Shadow-Mode-aware database access.
- `get_connection(domain)`: Returns a psycopg2 connection.
- `get_cursor(conn, logger, shadow_mode)`: Returns either a real or `ShadowCursor`.

### 3. Events (`autonomous_sdk.events`)
System-wide event emission via RabbitMQ.
- `emit(domain, action, payload, severity)`: Publishes to the `life.events` exchange.

### 4. Stability (`autonomous_sdk.circuit_breaker`)
Prevents cascading failures.
```python
from autonomous_sdk.circuit_breaker import CircuitBreaker

breaker = CircuitBreaker(failure_threshold=5)

@breaker
def volatile_service():
    # ...
```

### 5. Config & Paths (`autonomous_sdk.config`)
Standardized access to environment variables and system paths.

## Module Manifest (`manifest.yaml`)
Required for every module for discovery and validation.
```yaml
name: example
version: 1
description: "Brief description of module purpose"
core: false
sync_tier: 1 # 0: Infrastructure, 1: Domain Sync, 2: Intelligence/Content
databases: [autonomous_example]
depends_on: [postgres]
env_vars: 
  - EXAMPLE_API_KEY
api_routes:
  - /api/v1/example
capabilities:
  - name: "example_capability"
    description: "Does something useful"
    api_endpoints: ["/api/v1/example/do"]
    events_emitted: ["example_event"]
```

## Security: Shadow Mode
The SDK enforces **Shadow Mode** logic. When enabled (`SHADOW_MODE=True`), all database write operations via `get_cursor` are intercepted and logged without being executed, allowing for safe production verification of new code.
