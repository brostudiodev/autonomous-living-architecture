---
title: "SOP: Digital Twin Memory Management"
type: "sop"
status: "active"
owner: "Michal"
updated: "2026-03-02"
---

# SOP: Digital Twin Memory Management

## 📝 Purpose
Standard procedure for managing the strategic and personal memory of the Digital Twin (`digital_twin_michal`). This ensures the Twin remains strategically aligned and can scale to other family members.

## 🛠️ Prerequisites
- Access to PostgreSQL (`digital_twin_michal` database).

## 🚀 Procedure

### 1. Viewing Recent Advice
To see what the Twin has recently suggested and the context it used:
```sql
SELECT created_at, content, context_snapshot->'health'->'biometrics'->>'readiness_score' as readiness
FROM strategic_memory 
ORDER BY created_at DESC LIMIT 10;
```

### 2. Updating Person Attributes
To update persistent facts about a person (e.g., North Star or specific constraints):
```sql
INSERT INTO person_attributes (attr_key, attr_value) 
VALUES ('primary_focus', 'Q1 Foundation Completion')
ON CONFLICT (attr_key) DO UPDATE SET attr_value = EXCLUDED.attr_value;
```

### 3. Clearing Memory (Reset)
If the Twin is providing repetitive or outdated guidance, you can clear its memory:
```bash
# Clear strategic advice only
psql -d digital_twin_michal -c "TRUNCATE strategic_memory;"
```

### 4. Scaling to Family Members
To add a new family member, follow the same database creation pattern (`digital_twin_firstname`) and update the `DigitalTwinEngine` initialization to point to the relevant DB based on the Person UUID.

## ⚠️ Troubleshooting
| Issue | Cause | Resolution |
|---|---|---|
| Memory not persisting | DB Write Error | Check `G04_digital_twin_engine.py` logs for `psycopg2` errors. |
| Stale Guidance | Lack of memory variety | Ensure `save_to_memory` is called with distinct `memory_type` labels. |
| Context Snapshot Empty | State Init Error | Verify other databases (Finance, Health) are online during Twin init. |
