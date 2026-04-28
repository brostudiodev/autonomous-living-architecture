---
title: "Unified Docker Compose"
type: "documentation"
status: "draft"
owner: "Michał"
updated: "2026-04-21"
---

# Autonomous Living - Unified Docker Compose

> **⚠️ DRAFT** - This file is a proposal for unifying all services into a single docker-compose.yml.
> Not yet applied to production.

## Purpose

Consolidate all Docker services from scattered locations into a single, spawnable package for multi-user deployment.

## Services Overview

| Service | Port | Profile | Description |
|---------|------|---------|-------------|
| postgres | 5432 | always | PostgreSQL with pgvector |
| n8n | 5678 | always | Automation workflow engine |
| qdrant | 6333 | always | Vector database for semantic search |
| ollama | 11434 | cpu (default) | Local LLM inference (CPU) |
| ollama-gpu | 11434 | gpu | Local LLM inference (NVIDIA GPU) |
| open-webui | 3000 | always | Ollama Web UI |
| prometheus | 9090 | always | Metrics collection |
| grafana | 3003 | always | Dashboards and visualization |
| metrics-exporter | 8081 | always | Combined G01 + Goals exporter |
| node-exporter | 9100 | always | System metrics |
| activitywatch | 5600 | always | Productivity time tracking |
| digital-twin-api | 5677 | always | Main REST API for life state |
| obsidian | 3010/3011 | optional | Obsidian Web (notes) |

## Usage

```bash
# Start all default services (CPU mode)
docker-compose up -d

# Start with GPU support
docker-compose --profile gpu up -d

# Start with Obsidian Web
docker-compose --profile obsidian up -d
```

## Port Configuration Reference

| Service | Default Port | Env Variable |
|---------|--------------|--------------|
| PostgreSQL | 5432 | `POSTGRES_PORT` |
| n8n | 5678 | `N8N_PORT` |
| Qdrant | 6333 | `QDRANT_PORT` |
| Ollama | 11434 | `OLLAMA_PORT` |
| Open WebUI | 3000 | `OPEN_WEBUI_PORT` |
| Prometheus | 9090 | `PROMETHEUS_PORT` |
| Grafana | 3003 | `GRAFANA_PORT` |
| Metrics Exporter | 8081 | `METRICS_PORT` |
| Node Exporter | 9100 | `NODE_EXPORTER_PORT` |
| ActivityWatch | 5600 | `ACTIVITYWATCH_PORT` |
| Digital Twin API | 5677 | `DIGITAL_TWIN_PORT` |
| Obsidian HTTP | 3010 | `OBSIDIAN_HTTP_PORT` |
| Obsidian HTTPS | 3011 | `OBSIDIAN_HTTPS_PORT` |

## Profile Usage

| Profile | Services | Use Case |
|---------|----------|----------|
| default (cpu) | postgres, n8n, qdrant, ollama, prometheus, grafana, metrics-exporter, node-exporter, activitywatch, digital-twin-api | Standard deployment |
| gpu | ollama-gpu (replaces ollama) | NVIDIA GPU acceleration |
| obsidian | + obsidian | Include Obsidian Web |

## Migration Notes

### Current → Unified

| Current Location | Unified Location |
|------------------|------------------|
| `/home/{{USER}}/grafana/docker-compose.yml` | Removed - merged |
| `/home/{{USER}}/ai-agents-masterclass/local-ai-packaged/docker-compose.yml` | Removed - merged |
| `{{ROOT_LOCATION}}/autonomous-living/infrastructure/docker-compose.yml` | Removed - merged |

### Consolidations

1. **Exporters**: `g01-exporter` + `goals-exporter` → `metrics-exporter` (port 8081)
2. **Ollama**: Separate CPU/GPU profiles instead of separate compose files
3. **Obsidian**: Optional profile instead of always-on

---

## Owner

- **Owner:** Michał
- **Review Cadence:** Monthly
- **Last Updated:** 2026-04-21
- **Status:** DRAFT - Not applied to production