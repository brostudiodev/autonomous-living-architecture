---
title: "05: Troubleshooting"
type: "guide"
status: "active"
owner: "Michal"
updated: "2026-02-28"
---

# 🛠 Troubleshooting: Common Issues & Solutions

## 🤖 Digital Twin (G04) Issues

### Telegram bot is not responding
- **Check:** Is the `digital-twin-api` container running? (`docker ps`)
- **Action:** Restart the container: `docker restart digital-twin-api`.
- **Verify:** Send `/status` to the bot and check for a response.

### AI suggestions seem "hallucinated" or incorrect
- **Cause:** Usually due to stale context in the database.
- **Action:** Run a manual sync: `python3 scripts/G11_global_sync.py`.

---

## 🔄 Data Sync Issues

### Stale metrics in Grafana dashboards
- **Check:** Look for error logs in n8n (`http://localhost:5678`).
- **Cause:** Likely an expired API token (Withings, Google).
- **Action:** Re-run the authentication script: `python3 scripts/G07_auth_helper.py`.

### Database connection errors (5432)
- **Cause:** PostgreSQL container might be down or resource-starved.
- **Action:** Check Docker logs: `docker logs postgres-db`.

---

## 📓 Obsidian (Second Brain) Issues

### Broken Dataview queries in Daily Notes
- **Cause:** Dataview plugin is disabled or out of date.
- **Action:** Check Settings > Community Plugins and ensure Dataview is "ON."

### Daily Note is not pre-filling with missions
- **Check:** Ensure the `autonomous_daily_manager.py` script ran today.
- **Action:** Run it manually: `python3 scripts/autonomous_daily_manager.py`.

---

## 🆘 Still Stuck?
1. Check the specific **Runbook** for the affected goal: `docs/40_Runbooks/`.
2. Run the system-wide audit:
   ```bash
   python3 scripts/G11_system_audit.py
   ```
3. If the error persists, open a technical issue in the private repository.
