---
title: "SVC: Autonomous Pantry Data Sync"
type: "n8n_workflow"
status: "active"
owner: "Michał"
goal_id: "goal-g03"
updated: "2026-04-16"
---

# SVC: Autonomous Pantry Data Sync

## Purpose

Synchronizes household inventory data from Google Sheets (Magazynek_domowy) to PostgreSQL (autonomous_pantry database) every 6 hours. Maintains accurate, real-time pantry state across all storage locations by reading inventory sheets and the AI dictionary (Slownik).

## Scope

### In Scope
- Scheduled synchronization (every 6 hours)
- Multi-location inventory reading (9 locations)
- AI synonym dictionary (Slownik) sync
- PostgreSQL upsert operations
- Error alerting via email

### Out of Scope
- Manual inventory updates (handled in Google Sheets)
- Shopping list generation (see SVC workflows)
- Expiration predictions (see G03 roadmaps)

## Inputs/Outputs

### Trigger
- **Type:** Schedule Trigger
- **Frequency:** Every 6 hours
- **Times:** 00:00, 06:00, 12:00, 18:00

### Data Sources
| Sheet | Location | Purpose |
|-------|----------|---------|
| Spizarka | Kitchen pantry | Main food inventory |
| Zamrazarka | Freezer | Frozen goods |
| Gabinet | Office | Office supplies |
| Garaz | Garage | Tools, car supplies |
| Pralnia | Laundry | Detergents, supplies |
| Lazienka_gora | Bathroom upstairs | Toiletries |
| Lazienka_dol | Bathroom downstairs | Toiletries |
| Garderoba | Wardrobe | Clothing accessories |
| Strych | Attic | Seasonal items |
| Slownik | Dictionary | AI synonyms, thresholds |

### Database Operations
- `upsert_pantry_item()` - Insert/update inventory items
- `upsert_pantry_dictionary()` - Insert/update AI synonyms

## Dependencies

### Infrastructure
- Google Sheets API
- PostgreSQL `autonomous_pantry` database
- Gmail (for error alerts)

### Credentials
- Google Sheets OAuth2 (`Autonomous Living Google Sheets`)
- PostgreSQL (`autonomous_pantry docker`)
- Gmail (`Gmail account`)

## Procedure

### Execution Flow
1. **Schedule Trigger:** Every 6 hours
2. **Load Locations:** Code node generates 9 location items
3. **Read Sheets:** Parallel read of all inventory sheets
4. **Inject Location:** Tag each row with source location
5. **Transform:** Parse dates, numbers, categories
6. **Upsert DB:** Insert/update PostgreSQL
7. **Read Slownik:** Load AI synonym dictionary
8. **Sync Dictionary:** Update AI synonyms in DB
9. **Merge Results:** Combine inventory + dictionary reports
10. **Error Check:** If errors, send email alert

### Data Transformation
| Source Column | Target Field | Transformation |
|---------------|--------------|----------------|
| Kategoria | category | Trim whitespace |
| Aktualna_Ilość | current_quantity | Parse European format (comma decimal) |
| Jednostka | unit | Default 'szt' |
| Najblizsa_Waznosc | next_expiry | Pass-through date |
| Ostatnia_Aktualizacja | last_updated | Pass-through date |
| Status | status | Default 'OK' |
| Próg_Krytyczny | critical_threshold | Parse number |
| _location | location | From sheet name |

### Monitoring
- Check n8n execution logs for sync statistics
- Monitor autonomous_pantry database for last update timestamps
- Email alerts for sync failures

## Failure Modes

| Scenario | Detection | Response |
|----------|----------|----------|
| Google Sheets unreachable | API timeout | Retry next cycle |
| PostgreSQL connection fail | DB error | Send alert email |
| Invalid data format | Transform error | Skip row, continue |
| Partial sync | Some locations fail | Send partial success alert |

## Security Notes

- Google Sheets credentials stored securely in n8n
- Database credentials use n8n credential store
- No sensitive data in email alerts (statistics only)

## Owner + Review Cadence
- **Owner:** Michał
- **Review:** Monthly (during G03 household audit)
- **Last Updated:** 2026-04-16

## Related Documentation

- [G03 Autonomous Household Operations](../10_Goals/G03_Autonomous-Household-Operations/Roadmap.md)
- [Pantry Management](./WF105__pantry-management.md)
- [Autonomous Pantry Database Schema](../20_Systems/S03_Data-Layer/README.md)
- [Google Sheets Integration SOP](../30_Sops/Pantry-Inventory-Update-SOP.md)
