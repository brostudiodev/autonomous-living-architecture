# S11: Meta Kernel & SDK

## Purpose
The Autonomous Kernel provides a standardized, modular environment for the execution, discovery, and management of all life-automation domains. It decouples core system services (Kernel) from domain-specific logic (Userland/Modules) and provides a tiered execution engine (Orchestrator).

## Scope
- **In Scope:** Module discovery, tiered sync orchestration, standardized SDK (DB, Events, Logging, Stability), API routing isolation, Shadow Mode protection, Module generation.
- **Out of Scope:** Domain-specific business logic (e.g., how to calculate body fat).

## Inputs/Outputs
- **Inputs:** `manifest.yaml` for each module, environment variables (`MODULES_ENABLED`, `SHADOW_MODE`).
- **Outputs:** Tiered execution flow, standardized REST API endpoints (`/api/v1/`), system activity logs, life events (RabbitMQ).

## SDK Core Components
- **`config`**: Unified access to paths and DB configs.
- **`logger`**: Structured JSON logging.
- **`events`**: RabbitMQ emission.
- **`db`**: Shadow-Mode-aware database access.
- **`circuit_breaker`**: Cascading failure protection.

## Orchestration Flow
1. **Discovery**: Kernel scans `modules/` for manifests.
2. **Validation**: Dependency resolver verifies cross-module requirements.
3. **Tiered Execution**:
   - **Tier 0**: Infrastructure & External Sync.
   - **Tier 1**: Domain Analysis & Triage.
   - **Tier 2**: Intelligence & Content Generation.

## Dependencies
- **Systems:** [S03 Data Layer](../../README.md) (Postgres/RabbitMQ).
- **Services:** FastAPI (API), PyYAML (Manifests), Jinja2 (Generator).
- **Credentials:** Domain-specific (stored in `config/auth`).

## Procedure
- **Daily:** Verify kernel health via `/health/live` or `/system/capabilities`.
- **New Module:** Use `/api/v1/generate/module` or `core/module_generator.py`.
- **Manual Sync:** Run `python3 modules/meta/scripts/G11_global_sync.py` or the proxy `python3 modules/meta/scripts/G11_global_sync.py`.

## Failure Modes
| Scenario | Detection | Response |
|----------|-----------|----------|
| Module Load Failure | Registry logs ERROR on startup | Check manifest syntax and `module.py` imports. |
| Dependency Loop | Registry raises RecursionError | Audit `depends_on` fields in manifests. |
| Circuit Open | SDK logs "Circuit for X is OPEN" | Check domain logs; circuit auto-resets after 60s. |
| Proxy Failure | Crontab log shows ImportError | Ensure `PYTHONPATH` includes `scripts/` and project root. |

## Structural Standards (Adr-0032)
The system follows a strict **Kernel/Userland** separation:
- **Kernel (`core/`):** Engine, Registry, Orchestrator, Notifier, API.
- **SDK (`autonomous_sdk/`):** Standardized interfaces for all modules.
- **Userland (`modules/`):** Domain-specific logic, manifests, and scripts.
- **Proxy Layer (`scripts/`):** Lightweight wrappers for backward compatibility with crontab and n8n.

## Security Notes
- **Shadow Mode:** Mandatory for all new/untested modules.
- **Enforcement:** `SECURITY_ENFORCE=True` in `.env` enables API key validation.

## Owner + Review Cadence
- **Owner:** Michał
- **Review:** Monthly (Architecture stability).
