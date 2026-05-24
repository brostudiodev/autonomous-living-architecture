// ============================================
// HANDLE: /help command (Total Autonomy Edition v4.0)
// ============================================

const items = $input.all();
const item = items[0];
const data = item.json;

item.json = {
  ...data,
  response_text: `\U0001f4da *Digital Twin Command Directory*

*System & Sync:*
/start - Welcome message
/status - Full system summary (Health, Finance, Home)
/sync - \U0001f504 Force global data sync
/health_sync - \U0001f9ec Manual Zepp/Amazfit extraction
/scale_sync - \u2696\ufe0f Manual Withings weight sync
/audit - \U0001f6e1\ufe0f Self-healing documentation check
/map - G11 Connectivity matrix
/help - This directory

*Life Dashboards:*
/suggested - \U0001f9e0 *Autonomous Intelligence Report*
/morning_briefing - \U0001f305 Daily Morning Briefing & Priorities
/today - \U0001f4f1 Today's Mobile Dashboard (Obsidian Live)
/tomorrow - \U0001f319 Tomorrow's Mission Briefing
/todos - \U0001f4c5 Unified Agenda (Today/7 Days)
/tasks - \U0001f4cb Dynamic Task Synthesis (Recommendations)
/tasks_sync - \u26a1 "Assume & Act" Task Injection
/vision - \U0001f3af North Star & Power Goals
/report - \U0001f4c8 Monthly strategic summary

*Smart Home (G08):*
/home_status - \U0001f3e0 Environmental & device health
/home_security - \U0001f6e1\ufe0f Security hub (Alarm/Motion/Cams)
/home_lights - \U0001f4a1 Active lighting report

*Intelligence & Strategy:*
/os - \U0001f9e0 Personal Meta-Optimization (Director's Advice)
/memory - \U0001f9e0 Strategic advice history (Contextual Memory)
/predict - \U0001f52e AI Readiness & Energy prediction
/roi - Autonomy ROI (Total Time Saved stats)

*Execution & Domain:*
/forecast - \U0001f4c5 30-day financial outflow projection (G05)
/career - \U0001f4c8 Skill gaps & Career metrics (G09)
/pantry - \U0001f6d2 Low stock & Expiry alerts (G03)
/budget - \U0001f4b8 Expense calendar forecasting (n8n)
/finance - Budget status & alert reconciliation
/workout log - Smart workout logging flow
/log (GID) (Did) - \u26a1 Quick log a "Win" to any goal
/harvest - \U0001f916 Content idea generation
/substack sync - Sync posts to Obsidian
/coffee - \u2615 Support the architecture

*Prefixes:*
\u2022 note: - Save to Obsidian Inbox
\u2022 task: - Create a Google Task
\u2022 idea: - Capture a strategic idea
\u2022 log: - Add entry to activity log

_Or just send content to capture!_`,
  execution_time_ms:
    Date.now() - new Date(data._router?.timestamp || Date.now()).getTime(),
};

return items;