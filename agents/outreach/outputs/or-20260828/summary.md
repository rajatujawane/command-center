# TermStack outreach — Fri 28 Aug 2026

## Result
Pass ok. 0 drafted, 0 sent-detected, 0 replies, 0 bounces, 0 auto-drops.

## Phase 0 — qualify
Nothing due. Every `not_contacted` prospect already carries a `qualified` verdict;
pool last probed 08-09 (<60d).

## Phase 1 — reconcile
- Sends: no prospect holds a `pending_draft_id`; nothing to detect.
- Replies: 0 new. `label:outreach/termstack in:inbox newer_than:30d` returned empty.
  (mud-wtr reply from 08-04 already recorded.)
- Control labels reject/hold/later: 0 threads each. Nothing to mirror.
- Auto-drop: none. Finals (artisaire/hydrant/polyvinyl T3 sent 08-24) close 08-31.
- Note: one orphan Gmail draft dated 07-16 exists, not tied to any tracked prospect
  (no prospect references its id); untouched, as in prior runs.

## Phase 2 — pick
Queue guard: 0 pending unsent drafts, 6 slots. Fri = T1 day.
- Follow-ups due: 0. jonathan-adler T2 due 08-31; the three finals already sent.
- New T1s: 0 draft-ready. All qualified-uncontacted prospects fail the research
  60-second guard — Plus unconfirmed for every one (all `plus_verified: null`,
  deep-probed free on 08-27, no Plus evidence; Plus is never public) and/or no
  verified personal contact (only generic inboxes or empty contact fields).
  Nearest: hollis-morris (7), elavi (6), immi (6), nature-s-path (5),
  sweet-water-decor (5) — each gated on contact + Plus.

## Phase 3 — research
No draftable T1 was picked; nothing to verify. 08-27 deep probes are <60d fresh, not
re-run. The gate is Plus confirmation + a direct contact, neither obtainable free.

## Phase 4 — draft
Queue empty. Nothing drafted. Gate respected (drafts only, never send).

## Pipeline
- In sequence: 4 (artisaire, hydrant, polyvinyl-records finals close 08-31;
  jonathan-adler T2 due 08-31).
- Replied: 1 (mud-wtr).
- Qualified uncontacted: 13, all contact/Plus-gated (enrich bottleneck, on-demand only).
- Pool: 85.

## Standing bottleneck
Pool low (draft-ready eligible < 15). The pool is not short of prospects, it is short
of two things a routine run cannot produce: a confirmed Plus signal and a direct
contact. Both need an on-demand `enrich outreach` pass (Hunter, credit-ceiling gated)
plus a human Plus check. Until then every T1 day drafts 0.
