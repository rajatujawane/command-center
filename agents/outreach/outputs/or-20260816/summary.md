# TermStack outreach — 2026-08-16 (Sun)

Sunday: not a T1 day (T1s run Tue–Fri). Follow-ups allowed, but the queue guard blocked all drafting this pass.

## 🚫 Queue guard tripped
6 drafts sit unsent in Gmail, which equals `max_pending_drafts` (6). `slots_available = 0`, so this pass created **no drafts** — no follow-ups, no T1s. Rajat sending (or binning) any of the pending drafts frees slots.

## Reconcile (Gmail = ground truth)
- **Sends detected:** none. All 6 pending drafts still in Drafts, none moved to Sent.
- **Replies:** none new. (mud-wtr's 08-04 reply already recorded/handled; ule-group + russell-hendrix inbox items are old out-of-office auto-replies — ignored, no cadence change.)
- **Bounces:** 0.
- **Control labels:** reject/hold/later all empty — nothing to mirror.
- **Auto-drops (T3 + 7d, no reply):** darche, maguire-shoes, tony-s-chocolonely (all t3 sent 2026-08-08; drop line 08-15 passed). Status → dropped, no 4th touch.

## Pending unsent drafts — waiting on Rajat (6)
| Prospect | Touch | Drafted | Age (d) |
|---|---|---|---|
| artisaire | T2 | 2026-08-12 | 4 |
| brooklinen | T3 | 2026-08-13 | 3 |
| clay-imports | T3 | 2026-08-13 | 3 |
| geoshield | T3 | 2026-08-14 | 2 |
| snyder-performance-engineering | T3 | 2026-08-14 | 2 |
| v-s-barbershop | T3 | 2026-08-14 | 2 |

None past `draft_stale_days` (5) yet.

## Due but held by the guard (2)
- hydrant — T3 due (t1+9 = 08-14; t2+min_gap = 08-13). Held.
- polyvinyl-records — T3 due (same math). Held.

Both draft the moment a slot frees.

## Pipeline
- In sequence: 8
- Pending unsent drafts: 6
- Closed today: 3
- Eligible pool (qualified, not_contacted): 15 (at the pool-low floor)
- Replied: 1 (mud-wtr)

## System
Run ok. 0 bounces. Labels clear. Phase 0 qualify: nothing to probe (all not_contacted prospects already carry a `qualified` verdict, within the 60-day window).
