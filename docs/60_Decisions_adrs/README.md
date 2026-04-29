---
title: "Architecture Decision Records (ADR)"
type: "documentation"
status: "active"
owner: "Michał"
updated: "2026-04-12"
---

# Architecture Decision Records (ADRs)

## Overview

This directory contains Architecture Decision Records (ADRs) that document important architectural decisions made during the development of the autonomous-living ecosystem. Each ADR follows the MADR (Markdown Architecture Decision Record) format.

## ADR Index

### **Strategic Architecture Decisions**
- [Adr-0001](./Adr-0001-Repo-Structure.md) - Repository Structure & Organization
- [Adr-0002](./Adr-0002-Pantry-Polish-Schema.md) - Pantry Polish Language Schema
- [Adr-0003](./Adr-0003-Technology-Stack-Selection.md) - Technology Stack Selection
- [Adr-0004](./Adr-0004-Digital-Twin-Architecture.md) - Digital Twin as Central Hub
- [Adr-0005](./Adr-0005-Foundation-First-Strategy.md) - Foundation-First Goal Strategy
- [Adr-0006](./Adr-0006-PostgreSQL-Partitioning-Strategy.md) - PostgreSQL Partitioning Strategy
- [Adr-0007](./Adr-0007-Multi-Channel-Data-Ingestion.md) - Multi-Channel Data Ingestion
- [Adr-0015](./Adr-0015-Level-5-Autonomy-Implementation.md) - Level 5 Autonomy Implementation (Zero-Click Loop)
- [Adr-0016](./Adr-0016-Event-Driven-Architecture.md) - Event-Driven Architecture (LISTEN/NOTIFY)
- [Adr-0017](./Adr-0017-Decision-Authority-Framework.md) - Decision Authority Framework (Rules Engine)
- [Adr-0018](./Adr-0018-Standardized-Timeouts.md) - Standardized Timeouts and Syntax Hardening
- [Adr-0019](./Adr-0019-Silent-Mode-and-Recursion-Prevention.md) - Silent Mode and Sync Recursion Prevention
- [Adr-0009](./Adr-0009-Centralized-Observability-Stack.md) - Centralized Observability Stack

### **Data & Metrics Decisions**
- [Adr-0008](./Adr-0008-Real-Savings-Rate-Calculation.md) - Real Savings Rate Calculation
- [Adr-0014](./Adr-0014-Centralized-System-Observability-and-ROI.md) - Centralized System Observability and ROI

### **Integration & Routing Decisions**
- [Adr-0010](./Adr-0010-Hub-and-Spoke-Integration.md) - Hub-and-Spoke Integration Pattern
- [Adr-0011](./Adr-0011-Hardcoded-User-ID-in-Router.md) - Hardcoded User ID in Router (Technical Debt)
- [Adr-0012](./Adr-0012-Rule-Based-Intent-Classification.md) - Rule-Based Intent Classification

### **Security & Hardening Decisions**
- [Adr-0013](./Adr-0013-Security-Hardening-and-Secrets-Management.md) - Security Hardening and Secrets Management

## Templates & Governance
See [Documentation Standard](../10_Goals/Documentation-Standard.md) for ADR creation rules.

---
*Last updated: 2026-04-12*
---

## ☕ Fuel the Architecture

Building and maintaining this level of technical rigor is a massive investment. If this blueprint helps your own engineering journey, I would be grateful for your support.

<a href='https://ko-fi.com/michalnowakowski' target='_blank'><img height='60' style='border:0px;height:60px;' src='https://storage.ko-fi.com/cdn/kofi3.png?v=3' border='0' alt='Buy Me a Coffee at ko-fi.com' /></a>

**Support my hard work in engineering a fully autonomous life.** Every coffee fuels another line of code, another automated insight, and another step toward the 2026 North Star. Your contributions help maintain the infrastructure and research shared in this open-source blueprint.
