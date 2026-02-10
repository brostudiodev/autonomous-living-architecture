---
title: "SVC: Pantry Predictive Restocking"
type: "automation_spec"
status: "planning"
owner: "Michał"
goal_id: "goal-g03"
systems: ["S03", "S08"]
automation_id: "SVC_Pantry-Predictive-Restocking"
updated: "2026-02-09"
---

# SVC: Pantry Predictive Restocking

## 1. Purpose
This service analyzes historical consumption data from the pantry to predict future restocking needs. It proactively adds items to the automated shopping list *before* they hit their critical threshold, ensuring a just-in-time and efficient household supply chain. This service is a key component of G03's goal to move from reactive to predictive household operations.

## 2. Service Contract
This service will follow the standard SVC contract defined in the `WF105: Pantry Management AI Agent` documentation. It will be a scheduled, batch-oriented service rather than a real-time one.

- **Trigger:** Scheduled (e.g., every Sunday at 8:00 PM).
- **Input:** Reads data from the `Spizarka` and a new `Transaction_Log` sheet.
- **Output:** Appends items to the `Lista_Zakupów` sheet.

## 3. Data Requirements: Transaction Log
To enable predictive analysis, a new sheet named `Transaction_Log` must be created in the `Magazynek_domowy` Google Sheet. The `WF105` workflow must be updated to log every inventory change to this sheet.

#### `Transaction_Log` Sheet Schema
| Column | Description | Data Type | Example |
|---|---|---|---|
| `Timestamp` | The exact time of the transaction. | ISO 8601 | `2026-02-15T12:30:15Z` |
| `Produkt` | The name of the product being changed. | Text | `Mleko` |
| `Zmiana_Ilości` | The change in quantity. Negative for consumption, positive for restocking. | Number | `-1` |
| `Nowa_Ilość` | The new quantity after the change. | Number | `2` |
| `Źródło` | The source of the change. | Text | `Telegram` |

## 4. Predictive Logic (V1)
The service will execute the following logic weekly:

1.  **Load Data:** Fetch all data from the `Transaction_Log` for the last 90 days.
2.  **Calculate Consumption Rate:** For each product, calculate the average daily consumption.
    - `total_consumed = sum(abs(Zmiana_Ilości))` where `Zmiana_Ilości` is negative.
    - `daily_rate = total_consumed / 90`
3.  **Project Depletion Date:** For each product in `Spizarka`:
    - `days_remaining = Aktualna_Ilość / daily_rate`
    - `predicted_depletion_date = current_date + days_remaining`
4.  **Check Restock Trigger:** An item should be added to the shopping list if its `predicted_depletion_date` is within a certain window (e.g., 7 days).
5.  **Append to Shopping List:** If the restock trigger is met, append the item to the `Lista_Zakupów` sheet with a status of `Do_Kupienia_Prognoza` (To Buy - Forecast). This distinguishes it from items that have hit their hard critical threshold.

## 5. Integration with WF105
- **`WF105` Responsibility:** After every successful `update_inventory` or `add_product` action, the `WF105` workflow must be modified to append a corresponding entry to the `Transaction_Log` sheet.
- **`SVC_Pantry-Predictive-Restocking` Responsibility:** This service runs independently on a schedule, reading the data produced by `WF105` and adding items to the `Lista_Zakupów`.

## 6. Future Enhancements
-   Incorporate seasonality (e.g., higher consumption of certain items in winter).
-   Use more advanced forecasting models (e.g., ARIMA) instead of simple linear regression.
-   Factor in `Najblizsa_Waznosc` (Expiration Date) to prioritize consumption of items nearing their expiry.
-   Dynamically adjust the "restock window" based on external factors (e.g., planned holidays).

## 7. Related Documentation
- [Automation Spec: WF105 Pantry Management](./WF105__pantry-management.md)
- [Data Schema: S03 Pantry](../../20_SYSTEMS/S03_Data-Layer/Pantry-Schema.md)
- [Sub-Project Master: Pantry Management System](../../10_GOALS/G03_Autonomous-Household-Operations/Pantry-Management-System.md)
