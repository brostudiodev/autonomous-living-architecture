---
title: "G05_net_worth_snapshot: Wealth & FIRE Automation"
type: "automation_spec"
status: "active"
automation_id: "G05_net_worth_snapshot"
goal_id: "goal-g05"
systems: ["S05"]
owner: "Michał"
updated: "2026-04-28"
---

# G05: Net Worth Snapshot

## Purpose
Automates the calculation and historical tracking of Net Worth and "Years of Freedom" (FIRE progress). This removes the manual effort of aggregating account balances and projecting financial independence milestones at month-end.

## Triggers
- **Scheduled:** Integrated into `G11_global_sync.py`. Auto-executes on the 1st of each month.
- **Manual:** `python scripts/G05_net_worth_snapshot.py`

## Inputs
- **Google Sheet**: "Wealth FIRE" tab for asset inventory and "FIRE Constants" for target metrics.
- **Database**: `v_month_end_projection` (for current burn rate).

## Processing Logic
1. **Infrastructure Check**: Creates the `wealth_assets`, `fire_configuration`, and `net_worth_history` tables if they do not exist.
2. **Sheet Sync**: Synchronizes the "Wealth FIRE" tab from Google Sheets.
    - **Cleaning**: Deletes existing `wealth_assets` rows before sync to ensure 100% parity with the sheet.
    - **Normalization**: Normalizes all values to PLN using the provided `Exchange_Rate`.
3. **Configuration Sync**: Pulls `target_monthly_spend` and `safe_withdrawal_rate` from the "FIRE Constants" sheet.
4. **Calculations**:
    - **True Net Worth**: Sum of all assets normalized to PLN.
    - **FIRE Fund**: Sum of assets where `include_in_fire` is TRUE and `ownership` is 'Michal' or 'Shared'.
    - **FIRE Progress**: `(FIRE Fund / (target_monthly_spend * 12 / swr)) * 100`.
    - **Survival Runway**: `FIRE Fund / current_monthly_burn`.
5. **Persistence**: Updates the `net_worth_history` table with detailed metrics for historical trend analysis.

## Outputs
- **Database**: New row in `net_worth_history`.
- **Console**: Log of the calculated Net Worth and freedom years.

## Dependencies
- **System**: [S05 Observability Dashboards](../../20_Systems/S05_Observability-Dashboards/README.md)
- **Database**: `autonomous_finance` (PostgreSQL)

## Monitoring
- **Success Metric**: Monthly snapshot present in the financial dashboard by the 2nd of each month.

---
*Related Documentation:*
- [G05_finance_sync.md](G05_finance_sync.md)
- [G05_budget_rebalancer.md](G05_budget_rebalancer.md)
