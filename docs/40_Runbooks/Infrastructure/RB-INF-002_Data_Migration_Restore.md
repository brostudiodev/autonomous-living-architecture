---
title: "RB-INF-002: Data Migration & Restoration"
type: "runbook"
status: "active"
owner: "Michał"
updated: "2026-05-05"
---

# RB-INF-002: Data Migration & Restoration

## Purpose
This runbook provides the procedure for migrating data from Docker named volumes to local bind mounts and restoring data in case of path/volume clashing.

## Scope
- Core infrastructure services (Postgres, n8n, Qdrant, Ollama, Monitoring).
- Local bind mounts under the `infrastructure/` directory.

## Procedure: Named Volume to Local Bind Migration

### 1. Identify Source & Create Destination
```bash
# List legacy volumes
docker volume ls | grep local-ai-packaged

# Create local directories
mkdir -p infrastructure/n8n/n8n_data \
         infrastructure/database/postgres_data \
         infrastructure/qdrant/qdrant_data \
         infrastructure/ollama/ollama_data
```

### 2. Copy Data using Temporary Container
```bash
# Example for n8n
docker run --rm -v local-ai-packaged_n8n_storage:/from -v $(pwd)/infrastructure/n8n/n8n_data:/to alpine cp -av /from/. /to/

# Example for Postgres
docker run --rm -v local-ai-packaged_postgres_storage:/from -v $(pwd)/infrastructure/database/postgres_data:/to alpine cp -av /from/. /to/
```

### 3. Update docker-compose.yml
Replace named volumes with direct host paths:
```yaml
    volumes:
      - ./infrastructure/n8n/n8n_data:/home/node/.n8n
```

### 4. Apply and Verify
```bash
docker compose down && docker compose up -d
docker logs n8n --tail 50
```

## Failure Modes & Response

| Scenario | Detection | Response |
|----------|-----------|----------|
| Empty n8n Workflows | Workflow list is empty in UI | Check `docker inspect n8n` for correct mount source. Ensure legacy volume was copied correctly. |
| Postgres "Too Many Clients" | n8n logs show DB connection error | Increase `max_connections` in `infrastructure/database/postgres_data/postgresql.conf`. |
| Prometheus Sequential Segment Error | Prometheus logs show "segments are not sequential" | Clear the local data directory: `rm -rf infrastructure/prometheus/prometheus_data/*` and restart. |
| Permission Denied on Host | Service fails to start or log | Ensure directories have correct PUID:PGID (typically 1000:1000). |

## Security Notes
- Data is now visible on the host filesystem. Ensure full-disk encryption and strict folder permissions (`700` or `755`).

## Procedure: Adding Flexible OAuth Redirects
If n8n OAuth fails with a "Redirect URI mismatch" error after switching proxies:

### 1. Update Authentik Database Directly
```bash
docker exec postgres psql -U root -d authentik -c "UPDATE authentik_providers_oauth2_oauth2provider SET _redirect_uris = '[{\"url\": \"https://[YOUR_URL]/rest/oauth2-callback\", \"matching_mode\": \"strict\"}, {\"url\": \"http://localhost:5678/rest/oauth2-callback\", \"matching_mode\": \"strict\"}]' WHERE provider_ptr_id = (SELECT provider_id FROM authentik_core_application WHERE slug = 'n8n');"
```

### 2. Verify n8n Proxy Trust
Ensure your `docker-compose.yml` includes:
```yaml
environment:
  - N8N_TRUST_PROXY=true
```
