---
title: "Automation Spec: G05_ollama_wrapper.py"
type: "automation_spec"
status: "active"
automation_id: "G05_ollama_wrapper"
goal_id: "goal-g05"
systems: ["S03", "S05"]
owner: "Michal"
updated: "2026-03-27"
---

# G05_ollama_wrapper.py

## Purpose

Unified LLM wrapper that provides toggle between local Ollama models and cloud Gemini API for financial queries. Designed to reduce API costs and improve privacy by running smaller models locally.

## ⚠️ Status: DISABLED

This automation is currently **DISABLED** due to hardware limitations. The current PC does not have sufficient resources to run LLMs efficiently (see [Hardware Limitations](../infrastructure/architecture/README.md#hardware-limitations)).

To enable: set `OLLAMA_ENABLED=true` in `.env` file.

## Triggers

- **Manual**: Execute via `python3 scripts/G05_ollama_wrapper.py --test`
- **Programmatic**: Import and call `call_llm(prompt, context)` from other scripts

## Inputs

- **Environment Variables**:
  - `OLLAMA_ENABLED=true/false` (default: false)
  - `OLLAMA_MODEL=llama3.1/phi3/deepseek-r1` (default: llama3.1)
  - `GEMINI_API_KEY` (for fallback)
- **Arguments**:
  - `--test`: Run basic connectivity test
  - `--enable`: Show enabling instructions
  - `--quick`: Quick 2+2 test

## Processing Logic

1. Check `OLLAMA_ENABLED` environment variable
2. If enabled: Route to local Ollama at `http://localhost:11434`
3. If disabled: Route to Gemini API (cloud)
4. Format prompt with optional context data
5. Return response (or fallback)

## Outputs

- **Direct**: LLM response string
- **Status**: Provider and model configuration via `status()` function

## Dependencies

### Systems
- [S03 Data Layer](../../20_Systems/S03_Data-Layer/README.md)
- [S05 Finance System](../../20_Systems/S04_Digital-Twin/README.md)

### External Services
- Ollama Docker container (localhost:11434)
- Gemini API (cloud fallback)

### Credentials
- `GEMINI_API_KEY` in `.env` (for fallback mode)
- No credentials needed for Ollama (local)

## Hardware Requirements

| Model | RAM Needed | PC Status |
|-------|-----------|-----------|
| Phi-3 | ~4GB | ✅ Works (slow ~60s) |
| Llama 3.1 (8B) | ~8GB | ❌ Too slow |
| DeepSeek R1 (14B) | ~16GB | ❌ Cannot run |

**Current PC**: 29GB total, only ~3.6GB free during testing. Insufficient for larger models.

See: [Hardware Limitations](../infrastructure/architecture/README.md#hardware-limitations)

## Error Handling

| Failure Scenario | Detection | Response | Alert |
|---|---|---|---|
| Ollama not running | Connection refused | Fall back to Gemini | None |
| Model timeout | >120s | Return timeout error | None |
| Out of memory | OOM killed | Fall back to Gemini | Log warning |
| Invalid model | 404 from Ollama | Return error | None |

## Monitoring

- **Success metric**: LLM response returned within timeout
- **Alert on**: 3 consecutive failures
- **Dashboard**: N/A (manual testing)

## Manual Fallback

If Ollama wrapper fails:

```bash
# Test Ollama directly
curl http://localhost:11434/api/tags

# Check running models
docker exec ollama ollama list

# Enable Gemini fallback (default)
# Ensure GEMINI_API_KEY is set in .env
grep GEMINI_API_KEY .env
```

## Usage Examples

```python
# Basic usage
from G05_ollama_wrapper import call_llm
result = call_llm("What is my savings rate?")

# With context
context = {"savings_rate": 35, "monthly_income": 10000}
result = call_llm("Is 35% savings rate good?", context=context)

# Check status
from G05_ollama_wrapper import status
print(status())  # {"ollama_enabled": False, "model": "gemini-1.5-flash", ...}
```

## Related Documentation

- [G05 Roadmap - Ollama item](../../10_Goals/G05_Autonomous-Financial-Command-Center/Roadmap.md)
- [Ollama Docker Setup](../infrastructure/architecture/Docker-Setup.md)
- [Python Environments](../infrastructure/architecture/Python-Environments.md)
