---
title: "WF005: Price Scouter AI"
type: "automation_spec"
status: "active"
automation_id: "WF005__price-scouter-ai"
goal_id: "goal-g03"
systems: ["S08", "S04", "S03"]
owner: "Michal"
updated: "2026-03-09"
---

# WF005: Price Scouter AI

## Purpose
Autonomously scrapes major retailer aggregators (Biedronka, Lidl, Dino, Auchan) to find current prices and promotions for items on the shopping list, enabling the "Cheapest Basket" strategy.

## Triggers
- **Schedule:** Runs weekly on Monday and Thursday mornings (new promotion cycles).
- **On-Demand:** Telegram command `/scout`.
- **Event:** Triggered when `G03_cart_aggregator` identifies more than 5 urgent items.

## Inputs
- **Shopping List:** `GET /shopping_list` from Digital Twin API.
- **Retailer Aggregators:** `Blix.pl`, `DlaHandlu.pl`, `Auchan.pl`.

## Processing Logic
1. **Fetch List:** Retrieves the current consolidated shopping cart from G04 API.
2. **Browser Scraping (Playwright/n8n Node):**
    - Navigates to price aggregator sites.
    - Searches for each item category.
    - Extracts price, store name, and promo validity dates.
3. **AI Comparison:**
    - LLM Agent compares prices across Lidl, Biedronka, and Dino.
    - Matches generic items (e.g., "Butter") with specific store brand equivalents.
    - Calculates total basket cost for each retailer.
4. **Optimization:** Identifies the "Price Leader" for the current list.

## Outputs
- **Telegram Recommendation:** *"🛒 Strategy: Biedronka is your best bet today. 12/15 items found. Savings: ~22 PLN vs Lidl."*
- **Obsidian Note:** Updated list with estimated prices in `00_Inbox/Shopping-List.md`.

## Dependencies
### Systems
- [S08 Automation Orchestrator](../../../20_Systems/S08_Automation-Orchestrator/README.md)
- [S04 Digital Twin Hub](../../../20_Systems/S04_Digital-Twin/README.md)

### External Services
- n8n Browser Node (headless chromium)
- Retailer Websites/Aggregators

## Error Handling
| Failure Scenario | Detection | Response | Alert |
|---|---|---|---|
| Site Blocked | 403 / Captcha | Switch to different aggregator | Log warning |
| No match found | AI fails to match item | Skip item, log to report | None |
| API Offline | G04 API 500 | Retry in 10 mins | Telegram alert |

## Monitoring
- **Success metric:** Price Leader identified for >80% of items.
- **ROI Tracking:** Logs 10 minutes saved per successful scout.

## Manual Fallback
If scraping fails, the system provides a raw shopping list without price comparisons, and Michal must refer to manual flyers (Blix app).

---
*Related Documentation:*
- [G03_cart_aggregator.py](../../scripts/G03_cart_aggregator.md)
- [G04_digital_twin_api.py](../../scripts/G04_digital_twin_api.md)
