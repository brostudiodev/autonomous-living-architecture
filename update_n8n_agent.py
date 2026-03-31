import json
import os

file_path = '{{ROOT_LOCATION}}/autonomous-living/infrastructure/n8n/agents/PROJ_Digital-Twin-API-Agent.json'

with open(file_path, 'r') as f:
    data = json.load(f)

# 1. Add Nodes
new_nodes = [
    {
      "parameters": {
        "url": "={{ $json.api_base }}/health/history",
        "sendBody": True,
        "specifyBody": "json",
        "jsonBody": "={\n  \"message\": {\n    \"text\": \"/health/history {{ $fromAI('target_date', 'The date to fetch data for in YYYY-MM-DD format. Calculate relative dates like \\'yesterday\\' or \\'one week ago\\' relative to today.') }}\"\n  }\n}",
        "options": {}
      },
      "type": "n8n-nodes-base.httpRequestTool",
      "typeVersion": 4.4,
      "position": [3872, 624],
      "id": "hist-health-tool-001",
      "name": "GetHistoricalHealth",
      "description": "Returns raw health metrics (sleep, HRV, readiness, steps) for a specific date (YYYY-MM-DD). Use when the user asks about a specific day's health. You MUST calculate the correct YYYY-MM-DD date first."
    },
    {
      "parameters": {
        "url": "={{ $json.api_base }}/query",
        "sendBody": True,
        "specifyBody": "json",
        "jsonBody": "={\n  \"message\": {\n    \"text\": \"/query {{ $fromAI('db_name', 'Choice of twin, health, finance, or training') }} | {{ $fromAI('sql_query', 'The SELECT query to execute') }}\"\n  }\n}",
        "options": {}
      },
      "type": "n8n-nodes-base.httpRequestTool",
      "typeVersion": 4.4,
      "position": [3872, 800],
      "id": "sql-query-tool-001",
      "name": "QueryAutonomousData",
      "description": "Analytical SQL tool for cross-domain queries. Databases: 'twin' (mood/tasks), 'health' (sleep/HRV), 'finance' (transactions), 'training' (workouts). Queries must start with SELECT."
    }
]

# Update System Message with stronger instructions
for node in data['nodes']:
    if node['name'] == 'AI Agent':
        sm = node['parameters']['options']['systemMessage']
        
        # Add date calculation instruction
        if 'DATE CALCULATION' not in sm:
            date_instr = "\n═══════════════════════════════════════════════════════\n📅 DATE CALCULATION PROTOCOL\n═══════════════════════════════════════════════════════\n1. Use Today's Date ({{ $json.session_start.slice(0,10) }}) as reference.\n2. When user says 'last week', 'yesterday', etc., calculate the exact YYYY-MM-DD.\n3. Pass this date to GetHistoricalHealth or use it in your SQL queries.\n"
            sm = sm.replace("═══════════════════════════════════════════════════════\n⚡ RULE #1", date_instr + "═══════════════════════════════════════════════════════\n⚡ RULE #1")
        
        # Ensure tools are in the catalog
        if 'GetHistoricalHealth' not in sm:
            table_row = "| GetHistoricalHealth | /health/history | Fetch raw health metrics for a specific date (YYYY-MM-DD) |\n"
            sm = sm.replace("### CATEGORY 2: DOMAIN TELEMETRY\n| Tool | Endpoint | Use When |\n|------|----------|----------|", 
                            "### CATEGORY 2: DOMAIN TELEMETRY\n| Tool | Endpoint | Use When |\n|------|----------|----------|\n" + table_row)
        
        if 'QueryAutonomousData' not in sm:
            sql_row = "| QueryAutonomousData | /query | Run ad-hoc SQL for correlations (mood vs health, etc.) |\n"
            sm = sm.replace("### CATEGORY 6: ANALYTICS\n| Tool | Endpoint | Use When |\n|------|----------|----------|", 
                            "### CATEGORY 6: ANALYTICS\n| Tool | Endpoint | Use When |\n|------|----------|----------|\n" + sql_row)

        node['parameters']['options']['systemMessage'] = sm

with open(file_path, 'w') as f:
    json.dump(data, f, indent=2)

print("✅ n8n Agent JSON updated successfully.")
