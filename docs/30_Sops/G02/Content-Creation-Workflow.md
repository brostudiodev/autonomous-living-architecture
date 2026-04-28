# SOP: G02-001 - Content Creation Workflow

## 1. Purpose
To define a standardized, repeatable process for creating and publishing high-quality technical articles for Substack and promoting them on social platforms like LinkedIn. The goal is to establish thought leadership with a consistent publishing cadence.

## 2. Scope
This SOP covers the entire content lifecycle, from the initial idea to post-publication promotion.

## 3. Roles & Responsibilities
- **Author/Owner:** Michał - Responsible for idea generation, final review, approval, and manual publishing steps.
- **AI Assistant (LLM):** A Mixture of Agents (e.g., Genspark) responsible for initial drafting, grammar/spelling checks, content suggestions, and creating promotional summaries.

## 4. Tools
- **Primary Writing & Publishing Platform:** Substack
- **AI-Assisted Content Generation:** LLM (Mixture of Agents)

## 5. Procedure

This procedure is divided into four distinct phases.

### Phase 1: Ideation & Initial Draft
1.  **Idea Generation:** The Author formulates a core idea, a surprising truth, or a painful lesson related to home automation, AI, robotics, or infrastructure.
2.  **Initial AI Prompting:** The Author sends the idea to the AI Assistant. The prompt should encourage a "Mixture of Agents" approach to generate a comprehensive and multi-faceted initial response.
3.  **Iterative Drafting:** The Author engages in a dialogue with the LLM, refining the content, checking facts, and fixing inaccuracies. This cycle continues until a satisfactory first draft that aligns with the article template is created.

### Phase 2: Technical Review & Editing
1.  **Platform Transfer:** The first draft is moved into Substack.
2.  **Author Review:** The Author conducts a thorough technical review of the content within the Substack editor, focusing on the accuracy of the "Failure/Risk" and "Lesson" sections.
3.  **AI-Assisted Editing:** The updated text is sent back to the LLM with a prompt to check for and fix grammar and spelling errors.
4.  **Content Enhancement (Optional):** The Author may ask the LLM to add specific details, provide alternative phrasings, or expand on certain sections to improve clarity.
5.  **Final Polish:** The Author reviews the AI's suggestions and makes the final edits in Substack.

### Phase 3: Publishing
1.  **Final Review:** The Author performs a final read-through of the complete article in the Substack preview.
2.  **Manual Publish:** The Author manually publishes the article. This is a deliberate control step to ensure final quality and ownership of the content.

### Phase 4: Promotion
1.  **Summary Generation:** The Author prompts the LLM to create a short, engaging summary of the published article, specifically tailored for a platform like LinkedIn. The prompt should request a hook and a call-to-action to read the full article.
2.  **Author Review:** The Author reviews the generated summary, editing it for tone, voice, and accuracy.
3.  **Final AI Review:** The edited summary is sent back to the LLM for a final grammar and spelling check.
4.  **Manual Promotion:** The Author manually posts the promotional content on LinkedIn and other target social media platforms.

## 6. Article Template

This template must be used as the foundational structure for all articles.

---

### [Title]
*Short, concrete, a bit provocative if possible.*

### Hook (1 paragraph)
*[1–2 sentences: what’s the surprising or painful truth?]*

### The Setup (2–3 paragraphs)
*   **Where:** home / RPA / AI / robotics / infra
*   **What were you trying to achieve?**
*   **What did you expect to happen? What were your assumptions?**

### The Failure / Risk (2–3 paragraphs)
*   **What went wrong, or what you realized could go wrong?**
*   **Concrete examples of failure modes.**
*   **Which assumptions turned out to be wrong / incomplete?**

### The Lesson (2-3 paragraphs)
*   **What you’ll do differently from now on.**
*   **General principle that applies beyond this one case.**
*   **Better pattern / architecture / best practice.**

### Closing (1 paragraph)
*   **Why this matters to anyone building automations.**
*   **How this mindset improves robustness / safety / ROI.**

---

## 7. Future State & Automation Goals (Ultimate Goal)

The target is to evolve this workflow towards a higher degree of automation, minimizing manual steps while retaining authorial control.

-   **Target Cadence:** Publish one article every 4 days (minimum of one per week).
-   **Automated Content Pipeline:** The workflow should become a highly automated pipeline where the Author's primary role shifts from writer to editor-in-chief.
    1.  **Idea Input:** The Author provides an idea.
    2.  **AI Generation:** The AI autonomously generates a full draft, a promotional summary, and related assets (e.g., custom images, voice-over audio).
    3.  **Approval Gateway:** The Author reviews the complete "publication package" and either approves it or sends it back for specific revisions.
    4.  **Automated Distribution:** Upon approval, the system automatically publishes the article to Substack and all designated social channels.
