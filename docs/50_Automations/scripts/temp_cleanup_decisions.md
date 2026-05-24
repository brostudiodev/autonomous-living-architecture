---
title: "Archived Automation Spec: temp_cleanup_decisions"
type: "automation_spec"
status: "archived"
owner: "Michał"
updated: "2026-05-23"
---

# Archived Automation Spec: temp_cleanup_decisions

## Purpose
Preserves the historical documentation record for `temp_cleanup_decisions` after no matching active Python script was found in `scripts/` or `modules/<domain>/scripts/`.

## Scope
### In Scope
- Records that this automation spec is archived and is not part of the active production script surface.
- Provides a stable name for historical cross-references and migration review.

### Out of Scope
- Runtime behavior, scheduler configuration, and operational ownership for a live script.
- New production changes or active automation guarantees.

## Inputs/Outputs
### Inputs
- Historical references to `temp_cleanup_decisions` in older documentation or migration notes.

### Outputs
- Archived documentation status only. No active runtime output is expected from this record.

## Dependencies
- No active script dependency is currently registered for this documentation file.
- If this automation is restored, create or identify the active script and regenerate the spec with `G12_auto_documenter.py`.

## Procedure
1. Search for an active implementation before using this document operationally.
2. If no script exists, keep this file archived.
3. If a script is restored, update `status` to `active`, add `script_hash`, and regenerate the spec.
4. Re-run `.venv/bin/python modules/docs/scripts/G12_documentation_audit.py`.

## Failure Modes
| Scenario | Detection | Response |
|---|---|---|
| Archived doc is mistaken for an active automation | No matching script exists in the active script directories | Locate or recreate the script before scheduling or invoking it. |
| Historical link points here | Link resolves to an archived spec | Use the archive status to decide whether to update or remove the reference. |
| Automation is restored | New script appears with this stem | Regenerate this spec as active documentation with a current `script_hash`. |

## Security Notes
- Do not add secrets, raw tokens, passwords, or internal infrastructure addresses to archived documentation.
- Use placeholders such as `[API_KEY]`, `{{DB_PASSWORD}}`, and `{{INTERNAL_IP}}` for any historical configuration notes.

## Owner + Review Cadence
- Owner: Michał
- Review cadence: Quarterly archive review, or immediately if a matching script is restored.
