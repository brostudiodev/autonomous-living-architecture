---
title: "Substack Notes Ideas System"
type: "system"
status: "active"
owner: "Michal"
updated: "2026-03-17"
goal_id: "goal-g02"
systems: ["S04", "S08"]
---

# Substack Notes Ideas System

## Purpose
Automated generation and management of Substack Notes (short posts, max 2000 chars) adapted from LinkedIn ideas. Provides a curated backlog of notes that can be published on different days than LinkedIn to maximize reach and engagement.

## Intent
Enable consistent Substack Notes posting (3x/week) by:
- Adapting LinkedIn ideas to Substack format
- Maintaining shorter, more casual tone
- Publishing on different schedule than LinkedIn
- Driving discussion through questions

---

## Scope

### In Scope
- Idea adaptation from LinkedIn posts
- Pre-written drafts optimized for Substack Notes
- Persistent storage in Obsidian Vault
- Manual approval workflow (human in the loop)
- Date tracking (LinkedIn vs Substack dates)
- Cross-reference linking

### Out of Scope
- Automated publishing (human always clicks Publish)
- Long-form Substack Articles
- YouTube/video content ideas
- Analytics tracking (future phase)

---

## Data Flow

```
┌─────────────────┐     ┌──────────────────┐     ┌─────────────────────┐
│  LinkedIn Ideas │────▶│  Adapt to Note   │────▶│  Substack Notes     │
│                 │     │  (This System)   │     │  Basket             │
├─────────────────┤     ├──────────────────┤     ├─────────────────────┤
│ • LinkedIn post │     │ • Shorter format │     │ • SN-*.md files    │
│ • Same message │     │ • Casual tone   │     │ • README index     │
│ • Different day│     │ • Add question  │     │ • Status tracking  │
└─────────────────┘     └──────────────────┘     └─────────────────────┘
        │                       │
        │                       ▼
        │               ┌──────────────────┐
        │               │  Human Review    │
        │               │  (Approval Loop) │
        └───────────────┴──────────────────┘
```

---

## Inputs

| Source | Description | Frequency |
|--------|-------------|-----------|
| **LinkedIn Ideas** | Adapt existing LinkedIn posts to Substack format | Ongoing |
| **Daily Notes** | Automation wins, system achievements | Daily |
| **Q2 Content Calendar** | Topics planned for Apr-Jun 2026 | One-time |
| **Manual Input** | Human-added ideas | On-demand |

---

## Outputs

| Output | Location | Description |
|--------|----------|-------------|
| **Notes Basket** | `Obsidian Vault/02_Projects/Substack Notes Ideas Basket/` | Folder with all note files |
| **Index README** | `Substack Notes Ideas Basket/README.md` | Master list |
| **Individual SN-*.md** | Each note as separate file | Full note + metadata |

---

## Idea Structure

```markdown
---
title: "[SN] Note Title"
date_created: YYYY-MM-DD
date_source: YYYY-MM-DD
source_type: LinkedIn / Daily Note / Q2 Calendar
source_link: [[link to source]]
status: 🆕 New
linkedin_version_date: YYYY-MM-DD
substack_format: Short note (max 2000 chars)
tags:
  - substack
  - idea
---

# Note: Title

## Hook
Opening line (relatable problem)

## Substack Version
[Note content - max 2000 chars]

## Notes
- What's different from LinkedIn version
- Why this works for Substack

## LinkedIn Post Date: YYYY-MM-DD
## Substack Note Date: Schedule for different day
```

---

## Draft Philosophy (REQUIRED)

### Key Differences from LinkedIn

| Aspect | LinkedIn | Substack Notes |
|--------|----------|----------------|
| Length | 100-300 words | Max 2000 chars |
| Tone | Professional, personal | More casual, community-focused |
| Hashtags | Many (#AutomationBro) | Minimal (1-2 max) |
| CTA | Question to reader | Discussion invitation |
| Schedule | Mon/Wed/Fri | Tue/Thu/Sat |

### Rules

1. **Shorter** - Must fit in 2000 chars
2. **More casual** - Community feel, not corporate
3. **End with question** - Drive discussion
4. **Minimal hashtags** - 1-2 max
5. **Different day** - Never same day as LinkedIn

---

## Notes Basket Folder Structure

```
Obsidian Vault/
└── 02_Projects/
    └── Substack Notes Ideas Basket/
        ├── README.md                    (Index + instructions)
        ├── SN-Automation-vs-Life-Admin.md
        ├── SN-Morning-Routine-Automated.md
        ├── SN-Reclaimed-298-Minutes.md
        └── ... (12 notes total)
```

---

## Procedure

### Weekly (Content Planning)
1. Review LinkedIn Ideas Basket
2. Pick 3 ideas to adapt for Substack
3. Convert to Substack format (shorter, more casual)
4. Add to Substack Notes Basket
5. Schedule for different day than LinkedIn

### Publishing Workflow
1. Pick note from basket
2. Edit if needed
3. Publish on Substack (different day than LinkedIn)
4. Update status to "✅ Published"
5. Add link to original LinkedIn post

---

## Publishing Schedule

| LinkedIn Day | Substack Notes Day |
|--------------|-------------------|
| Monday | Tuesday |
| Wednesday | Thursday |
| Friday | Saturday |

---

## Dependencies

### Systems
- **S04 Digital Twin** - For extracting insights from daily notes
- **S08 Automation Orchestrator** - For scheduled note generation (future)

### External
- Substack Notes platform
- Obsidian Vault (storage)
- Git (sync to autonomous-living)

### Credentials
- None required (text-based system)

---

## Failure Modes

| Scenario | Detection | Response |
|----------|-----------|----------|
| No LinkedIn ideas to adapt | Empty source | Generate from daily notes |
| Note too long (>2000 chars) | Character count check | Shorten content |
| Same day as LinkedIn | Date comparison | Reschedule |
| Notes Basket not synced | Git conflict / missing files | Manual check, resolve |

---

## Ownership & Review

- **Owner:** Michal
- **Review Cadence:** Monthly
- **Last Updated:** 2026-03-17

---

## Key Links

- LinkedIn Ideas Basket: [[Obsidian Vault/02_Projects/LinkedIn Ideas Basket|LinkedIn Ideas]]
- Substack Notes Basket: [[Obsidian Vault/02_Projects/Substack Notes Ideas Basket|Substack Notes]]
- G02 Goal: [[docs/10_Goals/G02_Automationbro-Recognition/README.md|G02 README]]

---

## Future Enhancements

- [ ] Automated weekly note generation from LinkedIn ideas
- [ ] Character count validation
- [ ] Schedule conflict detection
- [ ] Analytics tracking
- [ ] Substack recommendation optimization

---

*Last Updated: 2026-03-17*
