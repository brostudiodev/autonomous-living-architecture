---
title: "Automation Spec: withings_to_sheets.py"
type: "automation_spec"
status: "legacy"
created: "2026-03-05"
updated: "2026-04-15"
---

# 🤖 Automation Spec: withings_to_sheets.py (LEGACY)

## 📝 Overview
**Purpose:** Synchronizes Withings Health data to a Google Sheet for human-readable review and historical backup.
**Goal Alignment:** G07 Predictive Health Management

> [!warning] ⚠️ **Status: LEGACY / SECONDARY**
> This script is no longer the primary data path for the Digital Twin. It has been replaced by [G07_withings_direct_sync.md](./G07_withings_direct_sync.md) for automated database ingestion.
> 
> **Retained for:**
> 1. Human-readable backup in Google Sheets (`Training_Journal` → `Withings_API`).
> 2. Primary OAuth2 authentication (contains the browser-based authorization flow).

## ⚡ Technical Details
- **Language:** Python
- **Triggers:** Manual Execution (required when refresh tokens expire)
- **Databases:** None
- **Dependencies:** `urllib.parse, dotenv, webbrowser, google.oauth2.service_account, requests, gspread, json, os, http.server, datetime`

## 🛠️ Logic Flow
1. Performs OAuth2 browser-based login if tokens are missing or invalid.
2. Fetches the last 365 days of measurement groups from Withings.
3. Clears and repopulates the `Withings_API` worksheet in the `Training_Journal` spreadsheet.

## 📤 Outputs
- **Google Sheet:** `Withings_API` worksheet populated with history.
- **Tokens:** Updates `withings_tokens.json`.

## ⚠️ Known Issues / Maintenance
- Requires manual interaction for the browser login.
- Should only be run when the Google Sheet backup is specifically needed or when re-authentication is required for the direct sync.
