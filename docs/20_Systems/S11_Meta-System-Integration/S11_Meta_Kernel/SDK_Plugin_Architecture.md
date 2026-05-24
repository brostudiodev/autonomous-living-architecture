---
title: "Kernel-Userland Architecture & Plugin System"
type: "system_specification"
status: "active"
owner: "Michał"
updated: "2026-05-13"
goal_id: "goal-g11"
---

# Kernel-Userland Architecture (G11-MSM)

## Purpose
Transition the system from a flat, high-dependency script collection into a modular **Kernel-Userland** architecture. This enables domain isolation, "Shadow Mode" validation, and zero-downtime feature deployment.

## System Overview
The architecture is split into two primary layers:
1.  **The Kernel (Core):** A stable, minimal hub providing essential services (Registry, Event Bus, Connection Pooling).
2.  **The Userland (Modules):** Domain-specific plugins (Health, Finance, Pantry) that utilize the Kernel's SDK.

## Core Components

### 1. The Autonomous SDK (`autonomous_sdk/`)
The interface between Modules and the Kernel.
-   **`BaseModule`:** Lifecycle hooks (`on_startup`), standard execution (`sync`), and automatic API routing.
-   **`Shadow Mode`:** A safety layer in the SDK that intercepts and logs all database writes instead of executing them.
-   **Service Wrappers:** Standardized access to PostgreSQL (`db.py`) and RabbitMQ (`events.py`).

### 2. The Module Registry (`core/registry.py`)
The "Brain" of the Kernel responsible for:
-   **Discovery:** Scanning `modules/*/manifest.yaml` for module metadata.
-   **Loading:** Dynamically importing custom `Module` classes and `APIRouter` instances.
-   **Mounting:** Automatically injecting module endpoints into the main Digital Twin API.

### 3. The Unified Runner (`run.py`)
A single entry point for all system tasks.
-   **Format:** `python3 run.py <module>:<action> [--shadow]`
-   Handles path resolution and environment setup before executing module logic.

## Operational Standards

### Module Structure
```
modules/<domain>/
├── manifest.yaml  # Metadata, dependencies, and route definitions
├── module.py      # Main logic class (inherits from BaseModule)
├── api.py         # FastAPI routes for the domain
└── tests/         # Domain-specific validation
```

### The Shadow Mode Workflow
To ensure system stability, every new module or logic change follows this path:
1.  **Shadow Run:** `python3 run.py <module>:sync --shadow`.
2.  **Kernel Audit:** Verify in logs that blocked writes match expected output.
3.  **Activation:** Set `SHADOW_MODE=false` once validated.

## Failure Modes
-   **Import Failure:** If a module is broken, the Kernel skips it and keeps the core API alive.
-   **Collision:** Registry detects overlapping API prefixes and prevents mounting.

## References
-   [Implementation Plan: Modular SDK](../../../10_Goals/G11_Meta-System-Integration-Optimization/IMPL_SDK_Module_System.md)
-   [Adr-0031: Life Nervous System](../../../60_Decisions_adrs/Adr-0031-Life-Nervous-System-Architecture.md)
