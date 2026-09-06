# TermStack outreach — 2026-08-18 (Tue)

Tuesday is a T1 day, but the queue guard blocked all drafting for the **third pass running**. Nothing moves until Rajat clears some of the 6 pending drafts.

## 🚫 Queue guard tripped (day 3)
6 drafts sit unsent in Gmail = `max_pending_drafts` (6). `slots_available = 0`, so this pass created **no drafts** — no T1s (despite it being a T1 day), no follow-ups. The pipeline is fully stalled on Rajat's send queue. Three of the six are now past the 5-day `draft_stale_days` line.

## Reconcile (Gmail = ground truth)
- **Sends detected:** none. All 6 pending drafts still in Drafts, none in Sent. No send since 08-09.
- **Replies:** none new. No tracked thread sits in the inbox (`label:outreach/termstack in:inbox` empty, 21d). mud-wtr's 08-04 reply stays recorded/handled.
- **Bounces:** 0 (mailer-daemon/postmaster search empty; SPAM folder empty).
- **Control labels:** reject / hold / later all empty — nothing to mirror.
- **Auto-drops:** none today (no in-sequence prospect has a T3 sent, so nothing is at the T3+7d line).

## Phase 0 qualify
All not_contacted prospects already carry a `qualified` verdict inside the 60-day window — nothing to probe this pass.

## Pending unsent drafts — waiting on Rajat (6)
| Prospect | Touch | Drafted | Age (d) |
|---|---|---|---|
| artisaire | T2 | 2026-08-12 | 6 ⚠ stale |
| brooklinen | T3 | 2026-08-13 | 5 ⚠ stale |
| clay-imports | T3 | 2026-08-13 | 5 ⚠ stale |
| geoshield | T3 | 2026-08-14 | 4 |
| snyder-performance-engineering | T3 | 2026-08-14 | 4 |
| v-s-barbershop | T3 | 2026-08-14 | 4 |

## Due but held by the guard (2)
- hydrant — T3 due (t1+9 = 08-14; t2+min_gap = 08-13). Held.
- polyvinyl-records — T3 due (same math). Held.

Both draft the moment a slot frees.

## Pipeline
- In sequence: 8
- Pending unsent drafts: 6
- Closed today: 0
- Eligible pool (qualified, not_contacted): 15 — but ~10 need a verified named-person contact (enrich to open new T1s); 5 blocked on generic-inbox-only
- Replied: 1 (mud-wtr)

## System
Run ok. 0 bounces. Labels clear. Guard has now blocked drafting three passes running — pipeline is fully stalled on Rajat's send queue. Sending or binning any of the 6 pending drafts is the single unblock.
