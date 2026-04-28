---
title: "G03: Price Scouter v2"
type: "automation_spec"
status: "active"
automation_id: "G03_price_scouter_v2"
goal_id: "goal-g03"
systems: ["S03"]
owner: "Michał"
updated: "2026-04-28"
---

# G03: Price Scouter v2

## Purpose
Optimizes grocery procurement by automatically comparing pantry needs against real-world promotion data from Biedronka, Lidl, and Dino.

## Triggers
- Triggered weekly on Thursdays (when new promotional flyers are released).

## Inputs
- Database: `pantry_inventory` (Low stock items).
- External: Scraped promo data (via blix.pl or similar aggregator).

## Processing Logic
1. **Fetch Needs:** Identify all items with `current_quantity <= critical_threshold`.
2. **Match Promos:** Fuzzy-match pantry items against current store promotions.
3. **Optimize:** Calculate the "Cheapest Basket" across stores.
4. **Report:** Generate a "Shopping Strategy" report for the Daily Note and Telegram.

## Outputs
- "Best Store" recommendation in `G03_cart_aggregator`.
- Updated price data in `pantry_prices` table.
