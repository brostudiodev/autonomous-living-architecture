---
title: "Personal OS: Command Center"
type: "dashboard"
goal_id: "goal-g11"
status: "active"
updated: "2026-02-25"
---

# 🤖 Personal OS: Command Center

> [!abstract] **Meta-Optimization Advice**
> ```dataviewjs
> const response = await fetch("http://localhost:5677/os?format=text");
> const data = await response.json();
> dv.paragraph(data.response_text);
> ```

---

## 💹 Live Vitals
| System | Status | Metric |
| :--- | :--- | :--- |
| **Finance** | `$= await fetch("http://localhost:5677/finance").then(r => r.json()).then(d => d.mtd_net)` PLN | `$= await fetch("http://localhost:5677/finance").then(r => r.json()).then(d => d.active_budget_alerts)` Alerts |
| **Health** | `$= await fetch("http://localhost:5677/health").then(r => r.json()).then(d => d.bodyfat_pct)`% BF | `$= await fetch("http://localhost:5677/health").then(r => r.json()).then(d => d.days_since_workout)` Days Rest |
| **Pantry** | `$= await fetch("http://localhost:5677/status").then(r => r.json()).then(d => d.state.pantry.low_stock_count)` Low | `$= await fetch("http://localhost:5677/status").then(r => r.json()).then(d => d.state.pantry.low_stock_items[0])`... |

---

## 🎯 Strategic Missions
```tasks
not done
path includes 10_Goals
priority is high
limit 5
```

---

## 🛠️ System Controls
- [Force Global Sync](shell-command:G04-sync)
- [List All Tasks](shell-command:G04-tasks)
- [Open Roadmap Matrix](G11_System_Connectivity_Map.md)

---
*Command Center auto-refreshes via Digital Twin API (v1.2.0).*
