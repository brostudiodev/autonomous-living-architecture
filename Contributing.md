---
title: "Contributing"
type: "process"
status: "active"
updated: "2026-01-15"
---

# Contributing

## Why this exists
This repo is meant to be **maintainable by future-you and AI**. That means predictable structure, explicit scope, and change hygiene.

## Basic workflow
1. Make a small change.
2. Create a PR (even if you are the only contributor).
3. Link the change to a **Goal** and/or **System**.
4. Update docs + automation together.

## Required for any automation change
- Docs: purpose, inputs/outputs, dependencies, failure modes, rollback
- Observability: where logs go, how failure is detected
- Safety: no secrets committed, credentials referenced via secret manager or env vars

