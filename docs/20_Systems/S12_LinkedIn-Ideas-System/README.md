---
title: "LinkedIn Ideas System"
type: "system"
status: "active"
owner: "Michal"
updated: "2026-03-17"
goal_id: "goal-g02"
systems: ["S04", "S08"]
---

# LinkedIn Ideas System

## Purpose
Automated generation and management of LinkedIn post ideas extracted from daily notes, Q2 Content Calendar, and system wins. Provides a curated backlog of content ideas with pre-written drafts that focus on universal benefits anyone can achieve.

## Intent
Enable consistent LinkedIn content creation (3x/week) with minimal effort by:
- Automatically extracting ideas from existing data sources
- Following a specific "benefits for everyone" draft philosophy
- Maintaining a persistent Ideas Basket for long-term planning

---

## Scope

### In Scope
- Idea generation from: Daily Notes, Q2 Calendar, System Wins
- Pre-written drafts with "benefits for everyone" angle
- Persistent storage in Obsidian Vault
- Manual approval workflow (human in the loop)
- Date tracking and source linking

### Out of Scope
- Automated publishing (human always clicks Publish)
- Substack content generation
- YouTube/video content ideas
- Analytics tracking (future phase)

---

## Data Flow

```
┌─────────────────┐     ┌──────────────────┐     ┌─────────────────────┐
│  Data Sources   │────▶│   Idea Generator │────▶│  Ideas Basket       │
│                 │     │   (This System)  │     │  (Obsidian Vault)  │
├─────────────────┤     ├──────────────────┤     ├─────────────────────┤
│ • Daily Notes   │     │ • Extract wins   │     │ • IDEA-*.md files  │
│ • Q2 Calendar   │     │ • Match topics  │     │ • README index     │
│ • System Wins   │     │ • Generate draft│     │ • Status tracking  │
└─────────────────┘     └──────────────────┘     └─────────────────────┘
                              │
                              ▼
                    ┌──────────────────┐
                    │  Human Review    │
                    │  (Approval Loop) │
                    └──────────────────┘
```

---

## Inputs

| Source | Description | Frequency |
|--------|-------------|-----------|
| **Daily Notes** | automation_win, director_insight, system_status | Daily (when filled) |
| **Q2 Content Calendar** | 20 planned topics for Apr-Jun 2026 | One-time + updates |
| **System Wins** | Time saved, automation achievements | From daily notes |
| **Manual Input** | Human-added ideas | On-demand |

---

## Outputs

| Output | Location | Description |
|--------|----------|-------------|
| **Ideas Basket** | `Obsidian Vault/02_Projects/LinkedIn Ideas Basket/` | Folder with all idea files |
| **Index README** | `LinkedIn Ideas Basket/README.md` | Master list of all ideas |
| **Individual IDEA-*.md** | Each idea as separate file | Full idea + draft |

---

## Idea Structure

Each idea file contains:

```markdown
---
title: "[IDEA] Idea Title"
date_created: YYYY-MM-DD
date_source: YYYY-MM-DD
source_type: (Daily Note / Q2 Calendar / System Win / AI Generated)
source_link: [[link to source]]
status: 🆕 New / 👀 Reviewed / 🔄 In Progress / ✅ Published / ⏸️ Paused
linkedin_format: (Short story / Technical deep dive / Personal story)
tags: []
---

# Idea: Title

## Hook
Opening line that anyone can relate to (NOT about being technical)

## Key Points
- Benefit 1
- Benefit 2
- Benefit 3

## Source
Where this idea came from

## Why This Works
- Universal appeal
- Anyone can do this
- Real everyday benefits

## Potential CTA
Action for readers to take

---

## 📝 Draft (Editable)
[Pre-written post - user can edit before publishing]
```

---

## Draft Philosophy (REQUIRED)

**Every LinkedIn post MUST follow these rules:**

### 1. NOT About "How Smart I Am"
- ❌ "Look what I built"
- ✅ "Here's what you can do too"

### 2. Focus on Real Benefits
- ❌ Technical jargon
- ✅ Time saved, money saved, stress reduced

### 3. "Anyone Can Do This"
- ❌ Exclusive/elitist tone
- ✅ Inclusive, encouraging
- Use phrases like:
  - "You don't need to be technical"
  - "Free tools"
  - "Start small"
  - "Anyone can do this"

### 4. Action-Oriented CTA
- Always end with question or call-to-action
- Examples:
  - "What's one thing you could automate?"
  - "Comment START if interested"
  - "Check your phone today"

---

## Draft Templates

### Short Story (100-150 words)
```
[HOOK - Relatable problem]
[1-2 sentences about transformation]
[BENEFIT - What reader gets]
[HOW - Simple steps]
[CTA - Question or action]
```

### Personal Story + Technical (200-300 words)
```
[HOOK - Attention-grabbing result]
[STORY - What happened]
[INSIGHT - What I learned]
[APPLICATION - How anyone can apply]
[CTA - Next step for reader]
```

### Deep Dive (300-500 words)
```
[HOOK - Provocative statement]
[PROBLEM - Everyone faces this]
[STORY - My experience]
[SYSTEM - How it works (simple)]
[BENEFIT - For reader]
[CTA - Continue conversation]
```

---

## Ideas Basket Folder Structure

```
Obsidian Vault/
└── 02_Projects/
    └── LinkedIn Ideas Basket/
        ├── README.md                    # Index + instructions
        ├── IDEA-Morning-Routine-Automated.md
        ├── IDEA-How-I-Built-My-Digital-Twin.md
        ├── IDEA-Reclaimed-298-Minutes.md
        ├── IDEA-Predictive-Health-AI-Monitors-Body.md
        └── IDEA-Financial-Freedom-Through-Automation.md
```

---

## Procedure

### Daily (Optional)
1. Check daily notes for `automation_win` or system achievements
2. If significant → Create new idea file
3. Update README index

### Weekly (Content Planning)
1. Review Ideas Basket
2. Pick 3 ideas for the week
3. Message assistant: "Let's work on [idea name]"
4. Assistant generates refined draft
5. User edits → Publish

### Monthly (Idea Generation)
1. Scan recent daily notes for wins
2. Check Q2 Calendar for upcoming topics
3. Generate 3-5 new ideas
4. Add to Ideas Basket with status "🆕 New"

---

## Dependencies

### Systems
- **S04 Digital Twin** - For extracting insights from daily notes
- **S08 Automation Orchestrator** - For scheduled idea generation (future)

### External
- Obsidian Vault (storage)
- Git (sync to autonomous-living)

### Credentials
- None required (text-based system)

---

## Failure Modes

| Scenario | Detection | Response |
|----------|-----------|----------|
| No daily notes with wins | Empty automation_win field | Skip idea generation |
| Ideas Basket not synced | Git conflict / missing files | Manual check, resolve |
| Draft quality poor | User feedback | Regenerate with new prompt |
| Source link broken | 404 in Obsidian | Update to working link |

---

## Ownership & Review

- **Owner:** Michal
- **Review Cadence:** Monthly
- **Last Updated:** 2026-03-17

---

## Key Links

- Q2 Content Calendar: [[docs/10_Goals/G02_Automationbro-Recognition/Q2-Content-Calendar|Q2 Content Calendar]]
- G02 Goal: [[docs/10_Goals/G02_Automationbro-Recognition/README.md|G02 README]]
- Ideas Basket: [[Obsidian Vault/02_Projects/LinkedIn Ideas Basket/README|Ideas Basket]]

---

## Future Enhancements

- [ ] Automated weekly idea generation script
- [ ] Integration with G02_substack_sync for article→LinkedIn repurposing
- [ ] Analytics tracking (views, engagement)
- [ ] YouTube Ideas Basket (separate system)
- [ ] Automated LinkedIn draft generation with LLM

---

*Last Updated: 2026-03-17*
