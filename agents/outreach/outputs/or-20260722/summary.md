# TermStack outreach — Wed 22 Jul 2026

## Gate status
Drafts only. Nothing was sent. 5 new Gmail drafts created today; **10 drafts now
sit unsent awaiting your review** (yesterday's 5 + today's 5).

## Phase 1 — reconcile (Gmail is ground truth)
Read Sent, Inbox, Spam, and all three control labels. **No prospect state changed.**

- **0 replies.** Nothing inbound from any tracked thread. Inbox holds only a DMARC
  aggregate report and two Google sign-in alerts.
- 0 bounces, 0 spam hits, 0 auto-replies.
- Control labels (reject / hold / later): all empty.
- Yesterday's 5 drafts (4 T3 + Filtrous T2) confirmed still present and unsent, ids
  matching. Nothing was sent overnight.

## Phase 2 — pick
Wed is a T1 day: 3 slots reserved for new T1s, leaving 5 of the 8 hard-ceiling
slots for follow-ups. **8 T2 follow-ups were due** (the 8 carried from yesterday),
so 5 were drafted and 3 carry to tomorrow.

Selection oldest-due first, then fit, then earliest actual send timestamp:
- 07-19 due (all three): CarBahn, memobottle, Cocofloss.
- 07-20 due (top 2 by fit=10): Russell Hendrix, Future Glass.
- Carried: Allied Medical (9), Pittsburgh Spray (9), Hiut Denim (8).

Queue guard: 5 pending drafts < 6 at pick time, so it passed. But see T1 note.

## Phase 3 — research / T1s
**No T1s. Pool is still contact-blocked, unchanged since yesterday's full sweep.**
No not_contacted prospect has a verified direct contact; the one all-guards-pass
candidate, ULE Group, still publishes only a generic inbox and stays held while
domain reputation recovers. No new inputs arrived overnight, so re-running the same
web research would only reproduce yesterday's result. The 3 reserved T1 slots were
left unused, not padded.

## Phase 4 — draft (5 created, 0 sent)
All are replies inside the existing thread, zero links, playbook voice, T2 shape
(three tiered rules + the 90-second-walkthrough / free-setup offer).

| Prospect | Touch | Rules angle | Window |
|---|---|---|---|
| CarBahn | T2 | dealer tiers: new / approved Net 30 / volume >$5k Net 60 + deposit | US 6:30-9:30pm IST |
| memobottle | T2 | boutique wholesale + international accounts (AUD) | AU 6-8am IST |
| Cocofloss | T2 | dental office tiers, reorders keep their terms | US 6:30-9:30pm IST |
| Russell Hendrix | T2 | order-value tiers, restaurant groups + institutional | CA 6:30-9:30pm IST |
| Future Glass | T2 | trade/contractor tiers, no post-order invoicing | US 6:30-9:30pm IST |

## Deliverability — still the real blocker (read before sending any of these)
SPF and DMARC are live and verified (checked again by yesterday's pass). The one
outstanding item is the **seed test to confirm inbox placement, which still has not
been run.** Every prior send went out before SPF/DMARC were fixed, and the
0-replies-across-13-threads result is consistent with spam filtering. Four of the
pending drafts are final T3 touches, spending them on a possibly-filtered domain
burns the prospect.

Recommendation: run the seed test to rajatserver29@gmail.com, confirm SPF/DKIM/DMARC
all PASS in "Show original", then work down the 10 drafts. Until then the pipeline
is stalled on your side, and follow-up drafts will keep accumulating (by design,
in-sequence prospects are not abandoned) each daily pass.

## System
- Untracked stale draft in Gmail from Jul 16 ("TermStack Cold Outreach – Email #1
  (Template)", Russell Hendrix content) — not created by this system, left untouched.
- Saddleback (disqualified 07-20, entered administration) still carries the tracking
  label on its sent T1 thread; expected, not a queue member.
- Pool depth fine; contact coverage remains the bottleneck, not list size.
