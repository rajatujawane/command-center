---
name: brief
description: Compose and send the daily Command Center brief to the group over iMessage. Triggered by the morning-brief routine ("send the brief").
---

# Morning Brief

The system's own routine, daily at 07:15. It only reads state and sends one summary. It
does NOT read my replies — the replies routine (every 30 min) owns that and writes the
state this brief reads.

## 1. Scan state

Across every agent in `agents/*`:
- `tasks/active/*.json`   -> current step (first not done), any `blocked_on`, any
                            `meta.go_live` and whether deliver is holding for it.
- `tasks/incoming/*.json` -> queued; flag go_live tasks not yet due.

Then:
- `state/heartbeat.json` -> per agent, flag if the last clean run is older than its schedule
                            (content-blog is daily; no clean run in >36h -> "stale").
- `state/budget.json`    -> today's spend vs caps.
- `state/attention.json` -> show when I last replied (informational).

## 2. Compose

One screen. One line per item that needs me, then a SYSTEM line:

```
COMMAND CENTER · <Day DD Mon>
────────────────────────────
BLOG     task-012 draft ready, publishes 18 Jun   (reply: kill 012 to stop)
BLOG     task-014 drafting
BLOG     task-020 queued, starts 26 Jun (go-live 30 Jun)
SYSTEM   runs OK · budget 0/1 · last reply 6h ago
```

Surface only what needs me: drafts ready and their publish date, vetoable items, blocked
tasks, stale agents, go-live holds. Finished work is a count, not a list.

## 3. Send

```
engine/imessage/send.sh "Command Center" "<the brief text>"
```

This run pings no external service.