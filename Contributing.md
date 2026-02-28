---
title: "Contributing"
type: "process"
status: "active"
updated: "2026-02-28"
---

# Contributing to Autonomous Living Architecture

## 🏛️ Why this exists
This repository documents architectural patterns and design decisions for autonomous living systems. It serves as a reference architecture and educational resource. My goal is to provide a maintainable framework for both humans and AI, emphasizing predictable structure, explicit scope, and change hygiene.

## 🚀 Basic Workflow
1.  **Make a small change.** Focus on incremental improvements.
2.  **Create a PR** (even if I am the only contributor).
3.  **Link the change** to a specific **Goal** and/or **System**.
4.  **Update docs + automation together.** Documentation is considered part of the "source code."

## 📝 How to Contribute

### 🤔 Architectural Questions & Discussions
- **Questions About Design:** Open issues with the `question` label. Reference specific patterns or ADRs. Explain your context and what you're trying to understand.
- **Alternative Approaches:** Share your architectural approach with rationale and lessons learned using the `discussion` label. Explain trade-offs and lessons learned from your implementation.

### 📝 Documentation Improvements
- **Clarity & Corrections:** Flag unclear explanations or technical errors with file paths and suggested improvements.
- **Additional Context:** Share implementation experiences or suggest pattern improvements based on real-world usage. Contribute lessons learned without revealing personal data.

### 🚫 Contribution Boundaries
- **What I don't accept:** Complete production-ready implementations, requests for specific personal configuration help ("how do I configure X"), or basic tool tutorials.
- **Privacy:** Personal data or production secrets must **never** be submitted.

## 🛠️ Required for any Automation Change
- **Documentation:** Purpose, inputs/outputs, dependencies, failure modes, and rollback procedures.
- **Observability:** Explicitly state where logs go and how failure is detected.
- **Safety:** No secrets committed; credentials must be referenced via secret managers or environment variables.

## 📖 Documentation Standards
- **Architectural Focus:** Explain the "why" behind decisions, not just implementation details. Include alternatives considered and trade-offs made.
- **Consistency:** Follow existing documentation structure and terminology. Maintain an appropriate level of abstraction.
- **Traceability:** Every automation traces through `Automation → System → Goal`.
- **Relative Links:** Use relative paths for all internal references.

## ⏳ Response Expectations
This is a personal architectural documentation project. Expect responses within 1-2 weeks, though often faster. Most contributions will be discussed in issues before any documentation changes.

## 🤝 Code of Conduct
- **Be Respectful:** Critique ideas, not people. Assume good intent.
- **Be Constructive:** Provide specific suggestions and share your reasoning.
- **Be Patient:** Architectural discussions take time to develop properly.

---
*Questions about contributing? Open an issue asking - better to clarify expectations than spend time on something that doesn't fit the repository's mission.*
