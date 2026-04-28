---
title: "G13: Roadmap"
type: "goal_roadmap"
status: "active"
owner: "Michał"
updated: "2026-04-21"
goal_id: "goal-g13"
---

# Roadmap (2026)

## Q2 (Apr–Jun)
- [x] Initial Content Harvesting Pipeline established.
- [x] LinkedIn and Substack draft generators deployed to `scripts/archive/`.
- [ ] **Unified Content Draft Agent:** Merge individual generators into `G13_content_draft_agent.py`.
- [ ] **Sanity Checker:** Improve the `SANITY_CHECK` logic for the scheduler.
- [ ] **Inbox Cleanup:** Automatically archive drafts older than 14 days if not published.

## Q3 (Jul–Sep)
- [ ] **Multi-modal Support:** Generate image prompts for drafts using Imagen/DALL-E.
- [ ] **Engagement Feedback Loop:** Feed LinkedIn/Substack analytics back into the generator to improve tone/topic selection.

## Q4 (Oct–Dec)
- [ ] **Level 5 Autonomy:** Auto-publish approved drafts based on a pre-set calendar without manual copy-pasting.
