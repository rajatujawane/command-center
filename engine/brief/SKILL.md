---
name: brief
description: Compose and send the daily Morning Brief to the group over iMessage. Reads pipeline status locally, fans out a research sub-agent per digest section, merges, formats for iMessage, and sends. Triggered by the morning-brief routine ("send the brief").
---

# Morning Brief

The system's own routine, daily at 07:15. Two halves: PIPELINE (local, fast) and DIGEST
(live research, fanned out to sub-agents). It does NOT read my replies — the replies routine
(every 30 min) owns that and writes the state this brief reads.

## 1. Scan state (local, no web)

Across every agent in `agents/*`:
- `tasks/active/*.json`   -> current step (first not done), any `blocked_on`, any
                            `go_live` and whether deliver is holding for it. Note each task's
                            `title` (fall back to `topic` if no title) and its `id`.
- `tasks/incoming/*.json` -> queued; flag go_live tasks not yet due.

Then:
- `state/heartbeat.json` -> per agent, flag if the last clean run is older than its schedule
                            (content-blog is daily; no clean run in >36h -> "stale").
- `state/budget.json`    -> today's spend vs caps.
- `state/attention.json` -> when I last replied (informational).

Hold this as the PIPELINE block.

## 2. Digest (fan out one sub-agent per section)

Read `knowledge/brief/interests.md`. For EACH section listed there, spawn a SEPARATE
sub-agent — parallel, isolated context, web search enabled — with this brief:

  "Research the <section> section per its description in knowledge/brief/interests.md.
   LAST 24 HOURS ONLY. Return 2-4 one-line bullets in house voice, each with a trustworthy
   source. For the shopify section, add one extra line tagged 💡 (a gap, pattern, or idea).
   No hype, no filler. First read the last 7 days of logs/brief/*.md and skip anything
    already covered there; report only what's new. Return just the bullets."

Wait for all sub-agents. If one errors or finds nothing, use "— quiet" for that section
rather than blocking the brief. Trim each returned bullet to a single phone-width line.

## 3. Compose

Save the full, untrimmed digest to `logs/brief/<YYYY-MM-DD>.md` for reference. Then build the
CONDENSED iMessage in this exact shape:

```
☀️ Morning Brief · <Day DD Mon>

📋 Pipeline
<one line per item that needs me; if none: "all clear">

🛍️ Shopify
• <bullets>
💡 <the gap / pattern / idea line>

🤖 AI · SaaS · Tech
• <bullets>

🌍 World
• <bullets>

⚙️ <dot> runs <ok|stale> · budget <n>/<cap> · last reply <Xh> ago
```

Pipeline lines are TITLE-FIRST so they're readable at a glance. Format:
  `<icon> "<short title>" — <status>`  and, when vetoable, the kill on its own indented line:
  `    (reply: kill <id>)`
Trim the title to ~6-8 words. Keep the full `id` only in the kill instruction (that's the
handle I type back). Icons: ✅ ready/publishing · ✍️ drafting · ⏳ holding for go-live ·
⛔ blocked. System dot: 🟢 all good · 🟡 something stale or blocked · 🔴 a hard failure.

Surface only what needs me: drafts ready + publish date, vetoable items, blocked tasks,
stale agents, go-live holds. Finished work is a count, not a list. Keep it scannable — one
line per bullet; the long digest lives in the log file.

## 4. Send

```
engine/imessage/send.sh "Command Center" "<the condensed brief>"
```

The group chat is named "Command Center"; the message title is "Morning Brief". This run
pings no external service.