---
title: "SVC: Pantry Expiration Alerts"
type: "automation_spec"
status: "planning"
owner: "Michał"
goal_id: "goal-g03"
systems: ["S03", "S08"]
automation_id: "SVC_Pantry-Expiration-Alerts"
updated: "2026-02-09"
---

# SVC: Pantry Expiration Alerts

## 1. Purpose
This service proactively monitors the `Najblizsa_Waznosc` (Nearest Expiration Date) of pantry items in the `Spizarka` sheet. It generates and sends timely alerts to the user for items nearing expiration or already expired, reducing waste and ensuring optimal stock rotation.

## 2. Service Contract
This service will follow the standard SVC contract defined in the `WF105: Pantry Management AI Agent` documentation. It will be a scheduled, batch-oriented service.

- **Trigger:** Scheduled (e.g., daily at 7:00 AM).
- **Input:** Reads data from the `Spizarka` sheet.
- **Output:** Sends alert messages to the user (e.g., via Telegram).

## 3. Alert Logic
The service will execute the following logic daily:

1.  **Load Data:** Fetch all items from the `Spizarka` sheet.
2.  **Categorize Items:** For each item, compare `Najblizsa_Waznosc` with the current date:
    *   **Expired:** `Najblizsa_Waznosc` is before `current_date`.
    *   **Expiring Soon (Critical):** `Najblizsa_Waznosc` is within the next 7 days.
    *   **Expiring Soon (Warning):** `Najblizsa_Waznosc` is within the next 30 days but outside the 7-day critical window.
3.  **Generate Alert Message:** Construct a concise message summarizing the expiring/expired items, grouped by category and urgency. Include item name, quantity, and expiration date.
4.  **Send Alert:** Send the generated message to the primary user notification channel (e.g., Telegram).

## 4. Integration with WF105
- **`WF105` Responsibility:** The `WF105` workflow must ensure that `Najblizsa_Waznosc` is accurately recorded when items are added or updated, especially when natural language commands include expiration date information (e.g., "dodaj 1 tuńczyk ważny do 2026-06-15").

## 5. Future Enhancements
-   Allow user-defined alert thresholds (e.g., "alert me 14 days before milk expires").
-   Suggest recipes for expiring ingredients.
-   Integrate with shopping list automation to prioritize purchase of items that replace expired stock.

## 6. Related Documentation
- [Automation Spec: WF105 Pantry Management](./WF105__pantry-management.md)
- [Data Schema: S03 Pantry](../../20_SYSTEMS/S03_Data-Layer/Pantry-Schema.md)
- [Sub-Project Master: Pantry Management System](../../10_GOALS/G03_Autonomous-Household-Operations/Pantry-Management-System.md)
