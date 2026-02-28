---
title: "G09: Career Intelligence Dashboard"
type: "dashboard"
goal_id: "goal-g09"
status: "active"
updated: "2026-02-25"
---

# 💼 Career Intelligence & Readiness

## 🎯 Certification Progress (G06)
```dataviewjs
const response = await fetch("http://localhost:5677/status");
const data = await response.json();
const learning = data.state.learning.progress || {};

dv.table(["Subject", "Current Hours", "Target", "Progress"], 
  Object.entries(learning).map(([sub, hours]) => {
    const targets = { "AWS Solution Architect": 120, "AI/ML Foundation": 80 };
    const target = targets[sub] || 100;
    const pct = ((hours / target) * 100).toFixed(1) + "%";
    return [sub, hours + "h", target + "h", pct];
  })
);
```

## 📈 Public Brand (G02)
- **Substack Subscribers:** `$= await fetch("http://localhost:5677/status").then(r => r.json()).then(d => d.state.brand.substack_subscribers)`
- **Total Content Views:** `$= await fetch("http://localhost:5677/status").then(r => r.json()).then(d => d.state.brand.substack_views)`

## 🔍 Skill Gap Analysis
> [!info] **Strategic Advice**
> ```dataviewjs
> const response = await fetch("http://localhost:5677/os?format=text");
> const data = await response.json();
> const lines = data.response_text.split("
");
> const careerLines = lines.filter(l => l.includes("Career Risk") || l.includes("Learning Stagnation"));
> dv.paragraph(careerLines.join("
") || "✅ Career progression is on track.");
> ```

---
## 🚀 Career Roadmap (Q2)
```tasks
not done
path includes G09
priority is high
```

---
*Powered by Digital Twin API v1.2.0*
