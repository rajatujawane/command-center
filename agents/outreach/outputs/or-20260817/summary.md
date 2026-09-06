# TermStack outreach — 2026-08-17 (Mon)

Monday: not a T1 day (T1s run Tue–Fri). Follow-ups allowed, but the queue guard blocked all drafting for the second day running.

## 🚫 Queue guard tripped (day 2)
6 drafts sit unsent in Gmail = `max_pending_drafts` (6). `slots_available = 0`, so this pass created **no drafts** — no follow-ups, no T1s. Nothing in the pipeline moves until Rajat sends (or bins) some of the 6 pending drafts. The oldest (artisaire T2) is now 5 days old, at the `draft_stale_days` line.

## Reconcile (Gmail = ground truth)
- **Sends detected:** none. Sent folder empty for 5 days; all 6 pending drafts still in Drafts, none moved to Sent.
- **Replies:** none new. No tracked thread sits in the inbox (`label:outreach/termstack in:inbox` empty). mud-wtr's 08-04 reply stays recorded/handled.
- **Bounces:** 0.
- **Control labels:** reject / hold / later all empty — nothing to mirror.
- **Auto-drops:** none today (no prospect has a T3 sent, so nothing is at the T3+7d line).

## Phase 0 qualify
- All not_contacted prospects already carry a `qualified` verdict inside the 60-day window — nothing new to probe.
- Re-probed the two `UNKNOWN_RETRY` holdouts serially (yeti.com, funexpress.com). Both still return **HTTP 403** (bot-walled) — verdict unchanged, no file writes. They stay parked as qualified=false pending a future re-probe or a manual check.

## Pending unsent drafts — waiting on Rajat (6)
| Prospect | Touch | Drafted | Age (d) |
|---|---|---|---|
| artisaire | T2 | 2026-08-12 | 5 ⚠ at stale line |
| brooklinen | T3 | 2026-08-13 | 4 |
| clay-imports | T3 | 2026-08-13 | 4 |
| geoshield | T3 | 2026-08-14 | 3 |
| snyder-performance-engineering | T3 | 2026-08-14 | 3 |
| v-s-barbershop | T3 | 2026-08-14 | 3 |

## Due but held by the guard (2)
- hydrant — T3 due (t1+9 = 08-14; t2+min_gap = 08-13). Held.
- polyvinyl-records — T3 due (same math). Held.

Both draft the moment a slot frees.

## Pipeline
- In sequence: 8
- Pending unsent drafts: 6
- Closed today: 0
- Eligible pool (qualified, not_contacted): 15 (at the pool-low floor)
- Replied: 1 (mud-wtr)

## System
Run ok. 0 bounces. Labels clear. Guard has now blocked drafting two passes running — pipeline is fully stalled on Rajat's send queue.
