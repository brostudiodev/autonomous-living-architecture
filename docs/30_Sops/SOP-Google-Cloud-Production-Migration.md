---
title: "SOP: Moving Google Cloud Projects to Production"
type: "sop"
status: "active"
owner: "Michal"
updated: "2026-03-02"
---

# SOP: Moving Google Cloud Projects to Production

## 📝 Purpose
To prevent Google OAuth2 tokens from expiring every 7 days due to the "Testing" status of Google Cloud projects.

## 🚀 Procedure

### 1. Google Cloud Console Configuration
1.  Navigate to [Google Cloud Console](https://console.cloud.google.com/).
2.  Select the relevant project.
3.  Go to **APIs & Services > OAuth consent screen**.
4.  Click **PUBLISH APP** and confirm.
5.  Ensure the **User Type** is set to **External** (if using a personal gmail.com account).

### 2. n8n Credential Update
1.  Open n8n and go to **Settings > Credentials**.
2.  Find the credential tied to the updated project.
3.  Click **Reconnect** or **Sign in with Google**.
4.  If a "Google hasn't verified this app" screen appears:
    - Click **Advanced**.
    - Click **Go to [Project Name] (unsafe)**.
5.  Complete the OAuth flow.

## ⚠️ Notes
- **Verification:** You do NOT need to complete the official Google Verification process if you are the only user of the app.
- **Refresh Tokens:** Once in production, refresh tokens remain valid until they are manually revoked or the user password changes.

## 📋 Projects to Check
- [ ] Google Sheets (Financials)
- [ ] Google Tasks (Logistics)
- [ ] Google Calendar (Productivity)
