# outreach — daily pass (one routine run)

"start outreach" runs THIS, daily at 03:00. One full pass, then exit.

Outreach holds no long-lived task files. The state IS the prospect files:
`projects/<project>/prospects/*.json` — one file per prospect, full history inside.
Each run's artifacts go to `outputs/or-<YYYYMMDD>/` (queue.json, drafts.json, summary.md).
Every prospect write: temp file + atomic rename. Never edit two prospects in one write.

For EACH folder in `projects/*` (today: termstack), load its `config.json` and
`playbook.md`, then run the five phases in order. All caps/days/labels come from
config.json — never hardcode them.

## Phase 1 — reconcile (skills/reconcile.md)
Read Gmail (sent, inbox, labels) and sync every tracked prospect's state:
real send dates, replies, control labels (reject / hold / later), auto-drops.
This phase only reads Gmail and writes prospect files. Gate: auto.

## Phase 2 — pick (skills/pick.md)
Compute today's queue: due follow-ups first (all of them), then new T1s if today
is in `t1_send_days` and the queue guard allows. Write `outputs/or-<date>/queue.json`.
Gate: auto.

## Phase 3 — research (skills/research.md)
Only for picked NEW targets missing a verified contact or Plus confirmation.
Verifiable -> fill contact. Not verifiable -> drop from today's queue, mark the
prospect `flags: ["contact_needed"]`, surface in summary. Gate: auto (read-only web).

## Phase 4 — draft (skills/draft.md)
Create Gmail DRAFTS for everything left in the queue. T1 = new thread. T2/T3 =
reply draft in the prospect's existing thread. Apply the tracking label. Record
draft ids in the prospect file and `outputs/or-<date>/drafts.json`.
Gate: GATE — drafts only. NEVER send. (CLAUDE.md hard rule.)

## Phase 5 — summarize
Write `outputs/or-<date>/summary.md`, then send the condensed version to iMessage:

```
engine/imessage/send.sh "Command Center" "<summary>"
```

Summary shape — iMessage renders PLAIN TEXT ONLY (no markdown, no tables, no
bold), so structure comes from emoji, numbering, and short lines (~38 chars max,
phone width). Keep to one screen. Omit any section that would say "none":

```
📬 TermStack Outreach
Tue 21 Jul
━━━━━━━━━━━━━━

⚡ REPLIED — Brand
"one line gist of what they said"
(this block FIRST, only when a reply exists)

✉️ Ready to send (8)
1️⃣ AmHosp Supply 🏁T3 · US 7pm
2️⃣ Elite Truck 🏁T3 · US 7pm
3️⃣ WBC 🏁T3 · UK 1:30pm
4️⃣ CarBahn ↩️T2 · US 7pm
5️⃣ Memobottle ↩️T2 · AU 6am
6️⃣ Filtrous 🆕T1 · US 7pm

⏭ Tomorrow (5)
Allied · FutureGlass · Hiut ·
PittsSpray · RussellH

⏳ Waiting on you
2 drafts older than 5 days

📊 Pipeline
13 in sequence · 4 need contact
58 in pool

🛠 System
run ok · 0 bounces · labels clear
```

Legend (use consistently): 🆕 T1 new thread · ↩️ T2 follow-up · 🏁 T3 final touch ·
country as plain text, never flag emoji (US 6:30-9:30pm, UK/EU 1:30-3pm,
AU 6-8am, all IST) ·
⚡ reply (always the top block) · 🚫 blocked/queue-guard warnings go under 🛠.
Number the send list with 1️⃣-9️⃣ keycap emoji in send-priority order (follow-ups
before T1s, oldest due first). Brand names may be shortened to keep one line each.

Replies are urgent: if Phase 1 found any reply, the ⚡ block leads the message.
Reply drafting is ON DEMAND only — never pre-draft a reply unless Rajat asks
(via iMessage or a session).

## Close out
- Append one line to `tasks/log.md`: `<date> pass ok · drafted N · sent-detected N · replies N`.
- Append one row to `state/heartbeat.json`: `{agent:"outreach", ts, tasks_touched:<drafts created>, ok:true}`.
- If any phase failed, still send the summary with a SYSTEM line saying what failed.
