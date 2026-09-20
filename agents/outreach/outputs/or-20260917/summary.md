# TermStack Outreach — 2026-09-17 (Thu)

## Pass result
Queue empty. 0 drafted, 0 sent-detected, 0 replies, 0 bounces, 0 auto-drops.

## Reconcile (Gmail = ground truth)
- jonathan-adler thread `1a043787f61d84bb`: 2 messages, both SENT (T1 08-27, T2 08-31). No reply from abubbs@.
- T3 draft `r3652318537400479914` still UNSENT (created 09-04, ~13d old, past 5d stale) → waiting on Rajat. Auto-drop does NOT fire (rule needs t3.sent; T3 never sent). No T4 ever.
- Control labels reject/hold/later = 0 threads each. SPAM/TRASH = 0. `in:inbox newer_than:10d` empty (no reply/bounce/OOO).

## Pick (Thu = T1 day)
- Queue guard: 1/6 pending, 5 slots.
- T1 reserve = min(3, 5) = 3, but 0 draft-ready T1 targets. All 13 qualified-uncontacted are contact_needed / blocked (no_contact | generic_inbox_only) / Plus-unverified.
- sweet-water-decor = only qualified prospect with an email, but generic wholesale@ + Plus unverified → fails research 60-second guard.
- Unused reserve returned to follow-ups; none due (JAdler already at final T3, idempotent).
- Pool low (<15 eligible-with-contact). Enrich (Hunter, on-demand) is the long pole — needs Rajat to run "enrich outreach" with a credit ceiling.

## Phase 0 qualify
Nothing due — earliest pool probe 08-09 = 39d ago (<60d). No re-probe.

## Gate
No sends, no posts. Only pending draft is JAdler T3, awaiting Rajat.

## Pipeline
1 in sequence (jonathan-adler) · 13 qualified but need contact/Plus · 85 in pool.
