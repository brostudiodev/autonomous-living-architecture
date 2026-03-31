---
title: "WF: G11 Autonomy Promotion Agent"
type: "automation_spec"
status: "active"
automation_id: "G11_autonomy_promoter"
goal_id: "goal-g11"
systems: ["S11"]
owner: "Michal"
updated: "2026-03-28"
---

# G11: Autonomy Promotion Agent

## Purpose
A self-evolving meta-system that monitors user decision patterns and autonomously upgrades system authority. It implements an "Earned Trust" model by promoting policies from `limited` to `full` autonomy after a proven track record of successful human approvals.

## Triggers
- **Scheduled:** Daily as part of `G11_global_sync.py`.
- **Manual:** `python scripts/G11_autonomy_promoter.py`

## Inputs
- **Database:** `digital_twin_michal.decision_requests` (Historical resolutions).
- **Policy Config:** `scripts/autonomy_policies.yaml`.

## Processing Logic
1. **Approval Audit:** Queries the last 20 resolved requests for each unique policy in the database.
2. **Trust Evaluation:** Checks if all 20 consecutive resolutions were `APPROVED` and resulted in `SUCCESS`.
3. **Authority Upgrade:** If the trust threshold (20) is met and the current level is `limited`, it programmatically updates `autonomy_policies.yaml` to `authority_level: full`.
4. **Notification:** Sends a Telegram "Promotion Alert" detailing which policy has gained autonomous authority.

## Outputs
- **Configuration:** Updated `autonomy_policies.yaml`.
- **Telegram:** Achievement notification for the user.
- **Log:** Entry in `system_activity_log`.

## Dependencies
### Systems
- [S11 Meta-System Integration](../../20_Systems/S11_Meta-System-Integration/README.md)

### Scripts
- `G04_digital_twin_notifier.py` (Telegram alerts)

## Monitoring
- **Success metric:** System authority levels align with real-world human trust data.
- **Alert on:** YAML write failures or DB connectivity issues.

## Manual Fallback
If automatic promotion is not desired, the user can manually revert the `authority_level` in `autonomy_policies.yaml` or increase the `TRUST_THRESHOLD` in the script.
