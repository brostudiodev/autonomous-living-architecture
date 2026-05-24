---
title: "Adr-0032: Modular Kernel Reorganization"
type: "adr"
status: "accepted"
owner: "Michał"
updated: "2026-05-14"
---

# Adr-0032: Modular Kernel Reorganization

## Status
Accepted

## Context
Following the completion of the Modular SDK migration, the system architecture reached a point where legacy "G-scripts" co-existed with new modular class-based logic. The root `scripts/` directory remained cluttered with core engine components and domain scripts, creating ambiguity in the system's entry points and making navigation difficult for both humans and AI agents.

## Decision
1. **Core Kernel Migration:** Relocate core system components from `scripts/` to a dedicated `core/` directory.
   - `G04_digital_twin_engine.py` -> `core/engine.py`
   - `G04_agent_zero_core.py` -> `core/agent.py`
   - `G04_digital_twin_api.py` -> `core/api.py`
   - `G04_domain_isolator.py` -> `core/isolator.py`
2. **Modular Script Reorganization:** Distribute remaining functional G-scripts into domain-specific `scripts/` folders within each module (e.g., `modules/finance/scripts/`).
3. **Unified Entry Point:** Establish `main.py` at the project root as the primary gateway for the Digital Twin API.
4. **Hardened Configuration Validation:** Implement automated environment variable validation in the Kernel Registry to ensure all modules have their required secrets before loading.

## Consequences
- **Improved Maintainability:** Core logic is strictly separated from userland modules.
- **Enhanced AI Navigation:** AI agents can now discover scripts via the modular directory structure rather than scanning a flat list of 100+ files.
- **Bootstrapping Safety:** Modules will fail fast if required environment variables are missing, preventing runtime errors.
- **Portability:** The system is now 100% ready for containerized deployment with a clear `PYTHONPATH`.
