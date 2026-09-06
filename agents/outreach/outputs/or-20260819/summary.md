# TermStack outreach — 2026-08-19 (Wed)

Wednesday is a T1 day, but the queue guard blocked all drafting for the **fourth pass running**. Nothing moves until Rajat clears some of the 6 pending drafts. As of today **all 6** are at or past the 5-day stale line (yesterday only 3 were).

## 🚫 Queue guard tripped (day 4)
6 drafts sit unsent in Gmail = `max_pending_drafts` (6). `slots_available = 0`, so this pass created **no drafts** — no T1s (despite it being a T1 day), no follow-ups. The pipeline is fully stalled on Rajat's send queue. Sending or binning any one of the 6 is the single unblock.

## Reconcile (Gmail = ground truth)
- **Sends detected:** none. All 6 pending drafts still in Drafts, none in Sent. No send since 08-09.
- **Replies:** none new. No tracked thread sits in the inbox (16d inbox is only DMARC aggregate reports + Google Workspace admin notices). mud-wtr's 08-04 reply stays recorded/handled.
- **Bounces:** 0 (no mailer-daemon/postmaster; SPAM folder empty).
- **Control labels:** reject / hold / later all empty (0 threads each) — nothing to mirror.
- **Auto-drops:** none today. No in-sequence prospect has a T3 actually sent, so nothing is at the T3+7d line. (darche/maguire/tony already dropped 08-16; death-wish/ule/valvetronic 08-14.)

## Phase 0 qualify
No not_contacted prospect is unprobed or past the 60-day re-probe window. Re-probed the two standing UNKNOWN_RETRY domains serially — yeti.com and funexpress.com — both still HTTP 403 (transient guard holds, no verdict, files unchanged).

## Pending unsent drafts — waiting on Rajat (6, all stale)
| Prospect | Touch | Drafted | Age (d) |
|---|---|---|---|
| artisaire | T2 | 2026-08-12 | 7 ⚠ stale |
| brooklinen | T3 | 2026-08-13 | 6 ⚠ stale |
| clay-imports | T3 | 2026-08-13 | 6 ⚠ stale |
| geoshield | T3 | 2026-08-14 | 5 ⚠ stale |
| snyder-performance-engineering | T3 | 2026-08-14 | 5 ⚠ stale |
| v-s-barbershop | T3 | 2026-08-14 | 5 ⚠ stale |

## Due but held by the guard (2)
- hydrant — T3 due (t1+9 = 08-14; t2+min_gap = 08-13). Held.
- polyvinyl-records — T3 due (same math). Held.

Both draft the moment a slot frees.

## Pipeline
- In sequence: 8
- Pending unsent drafts: 6
- Closed today: 0
- Eligible pool (qualified, not_contacted): 15 — but all lack a verified named-person contact (enrich to open new T1s; 5 blocked generic-inbox-only/no-contact, the rest unenriched, sweet-water-decor generic alias only)
- Replied: 1 (mud-wtr)

## System
Run ok. 0 bounces. Labels clear. Guard has now blocked drafting four passes running — pipeline is fully stalled on Rajat's send queue, and every pending draft is now stale. Sending or binning any of the 6 pending drafts is the single unblock. Opening new T1s additionally needs an enrich pass (paid Hunter, on-demand).
