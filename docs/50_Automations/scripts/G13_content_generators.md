---
title: "G13 Content Auto-Generators"
type: automation_spec
status: active
date: "2026-03-26"
goal_id: goal-g13
owner: "Michał"
tags: [automation, content, linkedin, substack, ideas]
---

# G13: Content Auto-Generators

## Overview

Automated content generation pipeline that harvests achievements from goal activity logs and generates ready-to-refine drafts for LinkedIn and Substack.

## Scripts

### 1. G13_content_idea_generator.py

**Purpose:** Harvest achievements from the last 7 days of goal activity logs and generate content ideas.

**Input:**
- All `Activity-log.md` files in `/docs/10_Goals/*/`
- Last 7 days of activity

**Output:**
- `Obsidian Vault/00_Inbox/Content Ideas/YYYY-MM-DD - Content Harvest.md`

**Features:**
- Parses activity logs for "Action:" entries
- Maps entries to goal names (G01-G12)
- Generates 1-4 content ideas based on patterns
- Includes raw success log + AI-powered draft suggestions

### 2. G13_linkedin_draft_generator.py

**Purpose:** Generate polished LinkedIn post drafts from content ideas.

**Input:**
- Latest file in `Obsidian Vault/00_Inbox/Content Ideas/`

**Output:**
- `Obsidian Vault/00_Inbox/LinkedIn Drafts/YYYY-MM-DD_LinkedIn_*.md`

**Features:**
- Processes LinkedIn-specific and "Both" typed ideas
- Multiple post templates (personal story, how-to, numbers, opinion)
- Includes checklist for final polish
- Ready-to-copy post format

### 3. G13_substack_draft_generator.py

**Purpose:** Generate newsletter-ready Substack articles from content ideas.

**Input:**
- Latest file in `Obsidian Vault/00_Inbox/Content Ideas/`

**Output:**
- `Obsidian Vault/00_Inbox/Substack Drafts/YYYY-MM-DD_Substack_*.md`

**Features:**
- Processes Substack-specific and "Both" typed ideas
- Newsletter article structure with intro, body, takeaways
- Includes CTA and subscription prompt
- SEO-friendly formatting

### 4. G13_run_content_pipeline.py (Wrapper)

**Purpose:** Run all three generators in sequence.

**Location:** Obsidian Vault/99_System/scripts/

**Usage:**
```bash
python3 99_System/scripts/G13_run_content_pipeline.py
```

## Workflow

```
┌─────────────────────────────────────────────────────────────┐
│  1. G13_content_idea_generator.py                          │
│     └─> Harvests 7 days of activity logs                   │
│     └─> Generates Content Ideas file                       │
└─────────────────────────────────────────────────────────────┘
                              │
                              ▼
┌─────────────────────────────────────────────────────────────┐
│  2. G13_linkedin_draft_generator.py                        │
│     └─> Reads latest Content Ideas                         │
│     └─> Generates LinkedIn Drafts                          │
└─────────────────────────────────────────────────────────────┘
                              │
                              ▼
┌─────────────────────────────────────────────────────────────┐
│  3. G13_substack_draft_generator.py                        │
│     └─> Reads latest Content Ideas                         │
│     └─> Generates Substack Drafts                          │
└─────────────────────────────────────────────────────────────┘
                              │
                              ▼
                    📂 Obsidian Vault
                    ├── Content Ideas/    (input)
                    ├── LinkedIn Drafts/  (output)
                    └── Substack Drafts/ (output)
```

## Output Locations

| Script | Output Folder | File Pattern |
|--------|--------------|--------------|
| Idea Generator | `00_Inbox/Content Ideas/` | `YYYY-MM-DD - Content Harvest.md` |
| LinkedIn Generator | `00_Inbox/LinkedIn Drafts/` | `YYYY-MM-DD_LinkedIn_*.md` |
| Substack Generator | `00_Inbox/Substack Drafts/` | `YYYY-MM-DD_Substack_*.md` |

## Usage

### Run Full Pipeline
```bash
python3 {{ROOT_LOCATION}}/autonomous-living/scripts/G13_content_idea_generator.py
python3 {{ROOT_LOCATION}}/autonomous-living/scripts/G13_linkedin_draft_generator.py
python3 {{ROOT_LOCATION}}/autonomous-living/scripts/G13_substack_draft_generator.py
```

### Or Use Wrapper (from Obsidian Vault)
```bash
cd {{ROOT_LOCATION}}/Obsidian\ Vault
python3 99_System/scripts/G13_run_content_pipeline.py
```

### Recommended Schedule
- **Frequency:** Weekly (every Sunday)
- **Best Time:** After CEO Weekly Briefing
- **Output:** Ready-to-publish drafts by Monday morning

## Not Auto-Publishing

⚠️ **Important:** These scripts generate drafts only. They do NOT auto-publish to LinkedIn or Substack.

**Manual Steps Required:**
1. Review generated drafts
2. Edit for personal voice and accuracy
3. Add images/media
4. Publish via LinkedIn/Substack interfaces

## Dependencies

- Python 3.x
- PyYAML (for frontmatter)
- Access to autonomous-living Activity-log.md files
- Obsidian Vault structure with Content Ideas folder

## Related Goals

- [G02](G02 Automationbro Recognition.md) - Building personal brand
- [G11](G11 Meta-System Integration.md) - Automation infrastructure

## Changelog

| Date | Change |
|------|--------|
| 2026-03-26 | Initial implementation |
