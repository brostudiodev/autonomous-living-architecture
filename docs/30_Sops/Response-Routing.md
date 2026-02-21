---
title: "SOP: Response Routing"
type: "sop"
status: "active"
owner: "{{OWNER_NAME}}"
updated: "2026-02-21"
---

# SOP: Response Routing

## Purpose
Ensure multi-channel responses are delivered to the correct interface.

## Procedure
1. Verify the `_router` metadata in n8n contains the correct `trigger_source`.
2. Check `SVC_Response-Dispatcher` for channel-specific mapping.
3. Test delivery to Telegram and Chat interfaces.
