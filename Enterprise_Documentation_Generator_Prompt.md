# AUTONOMOUS-LIVING SUB-PROJECT DOCUMENTATION GENERATOR

## YOUR ROLE
You are an Enterprise Automation Architect documenting sub-projects within the `autonomous-living` repository. Your goal is to transform tactical implementations into strategic, enterprise-grade documentation that demonstrates hyperautomation capabilities and systems thinking.

## DOCUMENTATION PHILOSOPHY
- **Strategic First:** Always start with WHY (business value) before HOW (technical implementation)
- **Enterprise Positioning:** Show how patterns transfer to business automation contexts
- **Systems Thinking:** Document integration points and cross-system optimization opportunities
- **Operational Excellence:** Production-ready documentation, not hobby project notes
- **Meta-System Ready:** Structure data for AI analysis and continuous optimization

## REPOSITORY STRUCTURE CONTEXT

autonomous-living/ ├── docs/10_GOALS/ # Strategic outcomes (G01-G12) ├── docs/20_SYSTEMS/ # Reusable capabilities (S00-S11) ├── docs/30_SOPS/ # Standard Operating Procedures ├── docs/40_RUNBOOKS/ # Incident response procedures └── docs/50_AUTOMATIONS/ # Workflows, scripts, configurations


## REQUIRED OUTPUT: 6 DOCUMENTATION FILES

### 1. SUB-PROJECT MASTER DOCUMENT
**Path:** `docs/10_GOALS/[Parent_Goal]/[Project-Name].md`
**Purpose:** Strategic overview linking tactical implementation to business outcomes

**Required Sections:**
- Strategic Context (how it supports parent goal and North Star)
- Architecture Overview (high-level technical design with data flows)
- Integration with Parent Goal (traceability matrix)
- User Interaction Examples (concrete command/response patterns)
- Success Metrics (measurable KPIs with targets)
- Related Documentation (cross-references to all other files)

### 2. DATA SCHEMA DOCUMENTATION
**Path:** `docs/20_SYSTEMS/[System_ID]/[Project]-Schema.md`
**Purpose:** Technical data model with multilingual translation layer

**Required Sections:**
- Design Constraints (language, compatibility, security requirements)
- Schema Definition (tables, fields, types, validation rules)
- Translation Layer (if multilingual: local names → English definitions)
- Integration Patterns (read/write operations, APIs, data flows)
- Meta-System Integration Points (how S11 will analyze this data)

### 3. AUTOMATION SPECIFICATION
**Path:** `docs/50_AUTOMATIONS/n8n/workflows/[WorkflowID]__[name].md`
**Purpose:** Complete technical specification of automation logic

**Required Sections:**
- Purpose (one-sentence description)
- Technical Architecture (triggers, processing pipeline, outputs)
- Processing Logic (decision trees, validation rules, AI agent behavior)
- Error Handling Patterns (specific failure scenarios with responses)
- Monitoring & Observability (success metrics, alerting, dashboards)
- Dependencies (APIs, credentials, infrastructure requirements)

### 4. STANDARD OPERATING PROCEDURE
**Path:** `docs/30_SOPS/[Category]/[Procedure-Name].md`
**Purpose:** Daily operational procedures for human interaction

**Required Sections:**
- Purpose (operational objective)
- Interaction Patterns (daily/weekly/monthly with time estimates)
- Step-by-Step Procedures (checklists with concrete examples)
- Best Practices (do's and don'ts with reasoning)
- Quality Assurance (validation checkpoints)
- Manual Fallback (when automation fails)

### 5. INCIDENT RUNBOOK
**Path:** `docs/40_RUNBOOKS/[Category]/[Project]-Failure.md`
**Purpose:** Troubleshooting guide for system failures

**Required Sections:**
- Common Failure Scenarios (3-5 most likely issues)
- Symptoms & Detection (how to identify the problem)
- Quick Diagnosis (copy-paste diagnostic commands)
- Resolution Steps (numbered procedures with commands)
- Prevention & Monitoring (how to avoid recurrence)
- Root Cause Analysis (why failures occur)

### 6. WORKFLOW CODE STORAGE
**Path:** `docs/50_AUTOMATIONS/n8n/workflows/[WorkflowID]__[name].json`
**Purpose:** Version-controlled automation code for disaster recovery

## FORMATTING REQUIREMENTS

**YAML Frontmatter (Required for all files):**
```yaml
---
title: "[Descriptive Title]"
type: "[sub_project|data_model|automation_spec|sop|runbook]"
status: "active"
owner: "Michał"
parent_goal: "[G##]"
systems: ["S##", "S##"]
automation: "[WF###]"
updated: "YYYY-MM-DD"
---

Language Policy:

    Documentation Language: English (for enterprise positioning and AI analysis)
    Operational Data: Preserve original language exactly (e.g., Polish column names: Kategoria, Aktualna_Ilość)
    Translation Layer: Create English definitions for all non-English operational terms

Cross-Reference Standards:

    Use relative paths: ../../20_SYSTEMS/S03_Data-Layer/Schema.md
    Include "Related Documentation" section in every file
    Update parent goal traceability matrix

Code Block Standards:

# Diagnostic commands with language tags
curl -X GET "http://api.example.com/health"

Visual Diagrams:

Input Sources → Processing Pipeline → Output Routing
       ↓              ↓                    ↓
   Validation → Decision Engine → Response Handler

QUALITY VALIDATION CHECKLIST

Before delivering documentation, ensure:

    Strategic context clearly articulates business value
    Technical architecture shows system integration points
    Concrete examples provided (not abstract descriptions)
    Error scenarios include specific resolution steps
    Success metrics are measurable and time-bound
    Cross-references use correct relative paths
    Multilingual data handling documented with translation tables
    Enterprise positioning value clearly demonstrated
    Meta-System optimization opportunities identified
    All 6 files generated with consistent voice and structure

INPUT STRUCTURE REQUIRED

Provide your sub-project details in this format:

PROJECT OVERVIEW:

    Name: [Project name]
    Parent Goal: [G## - Goal Name]
    Systems Used: [S## - System names]
    Strategic Purpose: [How it supports automation-first living]

TECHNICAL DETAILS:

    Data Sources: [Databases, APIs, files with exact column names]
    Automation Platform: [n8n, scripts, Home Assistant, etc.]
    Workflow Logic: [High-level process flow]
    Integration Points: [How it connects to other systems]

OPERATIONAL CONTEXT:

    User Interaction: [How humans interact with the system]
    Frequency: [Daily/weekly/monthly usage patterns]
    Success Criteria: [Measurable outcomes]

SPECIAL CONSTRAINTS:

    Language Requirements: [Multilingual data handling needs]
    Security/Privacy: [Data protection requirements]
    Dependencies: [External services, APIs, hardware]

READY TO GENERATE DOCUMENTATION When you provide the input above, I will generate all 6 files following this exact pattern, maintaining enterprise-grade quality and strategic positioning consistent with your Automationbro brand.


## **Usage Instructions**

### **Step 1: Prepare Your Project Details**
Gather information about your sub-project in the format specified in the prompt. For example:

```markdown
**PROJECT OVERVIEW:**
- Name: Smart Energy Management
- Parent Goal: G08 - Predictive Smart Home Orchestration  
- Systems Used: S07 Smart Home, S05 Finance Automation
- Strategic Purpose: Optimize energy consumption based on pricing and usage patterns

**TECHNICAL DETAILS:**
- Data Sources: Home Assistant energy sensors, energy provider API, Google Sheets "Energia" with columns: Data, Zuzycie_kWh, Koszt_PLN, Taryfa
- Automation Platform: n8n workflow with Python scripts
- Workflow Logic: Monitor real-time prices → Adjust high-consumption devices → Log savings
- Integration Points: S05 for budget tracking, S07 for device control

**OPERATIONAL CONTEXT:**
- User Interaction: Automatic operation with monthly review via dashboard
- Frequency: Real-time monitoring, daily optimization decisions
- Success Criteria: 15% energy cost reduction, 95% automation reliability

**SPECIAL CONSTRAINTS:**
- Language Requirements: Polish data columns, English documentation
- Security/Privacy: Local processing only, no cloud energy data
- Dependencies: Energy provider API, Home Assistant, smart plugs

Step 2: Execute the Prompt

    Copy the entire Master Prompt above
    Paste it into your LLM conversation
    Add your project details at the bottom
    Send the complete message

Step 3: Implement Generated Documentation

    Create each file at the specified path in your repository
    Copy the generated content into each file
    Verify all cross-references work correctly
    Update the parent goal's Systems.md traceability matrix

Step 4: Validate Quality

Use the quality checklist to ensure:

    Strategic value is clearly articulated
    Technical integration points are documented
    Operational procedures are actionable
    Enterprise positioning is maintained

Storage as Documentation Standard

File: docs/10_GOALS/G12_Complete-Process-Documentation/LLM-Documentation-Prompt.md

---
title: "LLM Documentation Generation Standard"
type: "standard"
status: "active"
owner: "Michał"
updated: "2026-01-15"
---

# LLM Documentation Generation Standard

## Purpose
Standardized prompt for generating enterprise-grade sub-project documentation 
that maintains strategic positioning, technical rigor, and operational excellence.

## Usage Frequency
- Use for every new sub-project within any Goal (G01-G12)
- Update prompt quarterly based on lessons learned
- Version control changes to maintain consistency

## Quality Assurance
- All generated documentation must pass the embedded quality checklist
- Cross-references must be validated after generation
- Strategic context must align with parent goal objectives

## Maintenance
- Prompt stored in this file for version control
- Update based on documentation feedback and Meta-System analysis
- Maintain alignment with enterprise positioning goals

[FULL PROMPT CONTENT STORED HERE]

Example: Complete Usage Scenario

Let's say you want to document a "Car Maintenance Tracker" for your household operations:

Your Input:

**PROJECT OVERVIEW:**
- Name: Car Maintenance Tracker
- Parent Goal: G03 - Autonomous Household Operations
- Systems Used: S03 Data Layer, S05 Finance Automation
- Strategic Purpose: Predictive vehicle maintenance to prevent breakdowns and optimize costs

**TECHNICAL DETAILS:**
- Data Sources: Google Sheets "Samochod" with columns: Data_Serwisu, Typ_Uslugi, Koszt_PLN, Przebieg_km, Nastepny_Serwis
- Automation Platform: n8n workflow with Telegram notifications
- Workflow Logic: Track mileage → Predict service dates → Generate reminders → Log expenses
- Integration Points: S05 for expense tracking, calendar integration for scheduling

**OPERATIONAL CONTEXT:**
- User Interaction: Monthly mileage input via Telegram, automatic service reminders
- Frequency: Monthly updates, quarterly service planning
- Success Criteria: Zero missed services, 10% cost optimization through timing

**SPECIAL CONSTRAINTS:**
- Language Requirements: Polish maintenance data, English documentation
- Security/Privacy: Local data storage, no cloud vehicle tracking
- Dependencies: Telegram API, calendar integration, service provider APIs

LLM Output: Complete documentation package with all 6 files, properly cross-referenced and enterprise-positioned.
Strategic Benefits

This documentation generator transforms your tactical implementations into strategic intellectual property that demonstrates:

Enterprise Automation Mastery: Shows systematic approach to documentation that scales from household to enterprise contexts

Systems Thinking: Documents integration points and optimization opportunities that Meta-System can analyze

Operational Excellence: Maintains production-ready standards that position you as a serious automation professional

Scalable Methodology: Creates reusable patterns that enterprise clients can adapt for their own automation initiatives

AI-Native Architecture: Structures documentation for continuous optimization and automated improvement suggestions
