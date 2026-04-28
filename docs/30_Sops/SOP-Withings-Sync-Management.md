---
title: "SOP: Withings Weight Sync Management"
type: "sop"
status: "active"
owner: "Michał"
updated: "2026-03-03"
---

# SOP: Withings Weight Sync Management

## Purpose
To ensure 100% availability and accuracy of weight and biometric data flow from Withings to Google Sheets.

## Scope
- Maintenance of OAuth2 tokens.
- Validation of Google Sheet structure.
- Troubleshooting synchronization failures.

---

## 🛠️ Routine Maintenance

### 1. Daily Health Check
- **Monitor:** Check the "System Connectivity" dashboard in the Obsidian Daily Note.
- **Success:** `Health: ✅ Fresh`.
- **Warning:** `Health: ⚠️ Stale`. This indicates the daily manager used cached database data because the Withings API or Google Sheets sync failed.

---

## 🆘 Troubleshooting Procedures

### Scenario A: Re-Authorization Required
If the refresh token expires or is revoked, the automated sync will fail.
1. **Access Terminal:** Log into the host machine.
2. **Navigate to Scripts:** `cd {{ROOT_LOCATION}}/autonomous-living/scripts`
3. **Execute Manually:** `.venv/bin/python3 withings_to_sheets.py`
4. **Follow Link:** A browser window will open (or a link will appear). 
5. **Authorize:** Log in to Withings and approve access.
6. **Verify:** The script should output `Authentication successful` and sync data.

### Scenario B: Google Sheet Access Error
If the script reports `SpreadsheetNotFound` or `APIError [403]`:
1. **Check Sharing:** Open the `Training_Journal` Google Sheet.
2. **Verify Email:** Ensure `{{EMAIL}}` is added as an **Editor**.
3. **Check Worksheet:** Ensure a worksheet named `Withings_API` exists (or let the script create it).

### Scenario C: Incorrect Column Data
If the data looks shifted or headers are wrong:
1. **The script is "Full Refresh":** It clears everything from A1. 
2. **Corrective Action:** Simply delete the `Withings_API` worksheet entirely and run the script again. It will recreate the sheet with the correct 7-column structure.

---

## 🗄️ Database Integration
After the data is synced to Google Sheets, it must be pushed to the `autonomous_health` database.
- **Manual DB Push:** `.venv/bin/python3 G07_weight_sync.py`
- **Verification:** Check the `biometrics` table for updated `weight_kg` and `body_fat_pct` columns.
- **Merge Logic:** The database sync uses `ON CONFLICT (measurement_date) DO UPDATE`, meaning it will not overwrite Sleep or HRV data collected via Zepp for the same day.

---

## 📋 Technical Reference

### Data Structure (7 Columns)
1. **Date:** YYYY-MM-DD HH:MM:SS
2. **Weight (kg):** Precise to 3 decimal places
3. **Fat mass (kg):** Bioimpedance data
4. **Bone mass (kg):** Bioimpedance data
5. **Muscle mass (kg):** Bioimpedance data
6. **Hydration (kg):** Water content
7. **Comments:** Placeholder for manual notes

### Key Files
- **Script (API -> Sheet):** `scripts/withings_to_sheets.py`
- **Script (Sheet -> DB):** `scripts/G07_weight_sync.py`
- **Tokens:** `scripts/withings_tokens.json`
- **Log:** `scripts/withings.log` (if redirected)

---
*Created by Gemini CLI*  
*Related Automation Spec: [withings-to-sheets](../50_Automations/scripts/withings_to_sheets.md)*
