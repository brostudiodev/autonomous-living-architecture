---
title: "S04: Tool Mapping & Agent Access Control"
type: "system_spec"
status: "active"
system_id: "S04"
goal_id: "goal-g04"
version: "1.1"
owner: "Michal"
updated: "2026-04-12"
---

# S04: Tool Mapping & Agent Access Control

## Overview
This specification defines how specialized sub-agents are granted access to system tools. It ensures that the **Council of Specialists** operates within secure boundaries while maintaining master oversight via **Agent Zero**.

## 🛡️ The Scoped Access Model
Access is granted based on the `domain` property defined in each tool entry within the `G04_tool_manifest.json`.

| Agent | Domain Tag(s) | Authorized Tool Pattern |
| :--- | :--- | :--- |
| **Agent Zero** | `admin`, `meta`, `all`, `*` | Any tool in the manifest. |
| **Finance Agent** | `finance` | `G05_*` |
| **Health Agent** | `health` | `G01_*`, `G07_*` |
| **Inventory Agent** | `household` | `G03_*` |
| **Productivity Agent**| `productivity` | `G10_*`, `G11_task_*` |
| **Career Agent** | `career`, `learning` | `G09_*`, `G06_*`, `G13_*` |
| **Logistics Agent** | `logistics` | `G04_life_*`, `G04_relationship_*`, `G08_*` |
| **System Agents** | `meta`, `documentation` | `G11_*`, `G12_*` |

## ⚙️ Enforcement Logic (n8n / API)
When an agent (specialist) requests a tool execution via the Digital Twin API:
1. **Identity Verification:** The request must include the `agent_id`.
2. **Manifest Lookup:** The API retrieves the tool definition from `G04_tool_manifest.json`.
3. **Domain Validation:**
   - If `agent_id` is `agent_zero`, execution is ALWAYS authorized.
   - For all other agents, the tool's `domain` MUST be present in the agent's authorized list (see table above).
4. **Execution:** If valid, the script is executed; otherwise, a `403 Forbidden` is returned.

## 📓 Audit & Logging
- **Success:** Every authorized tool execution is logged in `system_activity_log` with the `agent_id` field populated.
- **Violation:** Unauthorized attempts trigger a `SECURITY_AUDIT` entry and a high-priority Telegram alert to Michal.

## 📝 Maintenance
- **New Tools:** When adding a script to `scripts/`, it MUST be registered in the manifest with a domain tag.
- **Domain Mismatch:** If a tool spans multiple domains (e.g., Finance analysis of Health data), it should be tagged as `meta` and delegated by Agent Zero.

---
*Standard v1.1 | April 2026 | Part of G04 Digital Twin Ecosystem*
