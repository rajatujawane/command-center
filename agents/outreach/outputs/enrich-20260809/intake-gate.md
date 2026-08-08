# Intake gate installed — 2026-08-09

Fixes the root cause behind the 08-08/09 findings: prospects were entering the pool on
unverified evidence, and the cost only surfaced later as wasted searches and wasted emails.

## What changed
- **`agents/outreach/qualify.sh <domain>`** — free, deterministic probe. No API, no quota.
  Emits a JSON verdict: DEAD / CLOSED / NOT_SHOPIFY / OFF_PLATFORM_B2B / NO_B2B_CHANNEL / REVIEW.
- **`agents/outreach/skills/qualify.md`** — the gate spec, with why each check exists and
  which real prospect it caught.
- **`pick.md`** — new FIRST hard exclusion: never queue a prospect whose `qualified` is not
  `true`. Not-yet-probed is not eligible.
- **`run.md`** — new Phase 0, capped at 10 prospects per pass, auto gate, read-only HTTP.
- **`enrich.md`** — never spend a search on an unqualified prospect; check
  `contact.email_domain` before any Hunter call.

## The whole not_contacted pool is now probed — 0 quota spent
32 prospects, every one carrying `qualified` + `qualify_verdict`.

| verdict | count | outcome |
|---|---|---|
| REVIEW | 15 | qualified, eligible for pick |
| NO_B2B_CHANNEL | 12 | fit capped at 3 |
| NOT_SHOPIFY | 6 | disqualified |
| OFF_PLATFORM_B2B | 4 | fit capped at 4 |
| CLOSED / DEAD | 4 | disqualified |
| UNPROBEABLE | 2 | no website on file |

Disqualified went 10 -> 18. Notable: **yeti, kraft-heinz, life-fitness, carrier,
industry-west, fun-express are not on Shopify at all**. **benchmade** (fit 8, one of the
three highest in the pool) runs wholesale on **ExpertVoice**, off-platform — it was gated
behind a "Shero-partnership warm approach" that would have gone nowhere.

## The probe beat the human pass
`qualify.sh` found `/pages/wholesale` live on **hormbles-chormbles**, which yesterday's
manual sweep had downgraded to fit 3 for "no wholesale signal" — the homepage nav link
never matched the href regex. Corrected to fit 6. This is exactly why the path and
subdomain probes exist and why homepage-link inspection alone is not the gate.

Also recovered **hollis-morris**, which had a null fit and was invisible to every
fit-ordered query: live Shopify with `/pages/trade` AND `customer_authentication`, a
login-gated trade portal. Now fit 7, third in the pool.

## Real pool, ranked
1. jonathan-adler (8) — multi-segment trade, terms unpublished
2. fsaproshop (8) — native B2B confirmed; Hunter has no data, LinkedIn only
3. konner-sohnen (7) — dealer program; **search dimaxgroup.com, not the store domain**
4. hollis-morris (7) — login-gated trade portal
5. quad-lock, immi, hormbles-chormbles, elavi, bequet-confections (6)
then the-somewhere-co, sweet-water-decor, nature-s-path, fellow (5), mejuri,
goulet-pen-company (4).

15 qualified, of which 9 are fit >= 6. That is the honest size of the T1 lane.

## Cost
0 Hunter quota. Still 18 searches / 36 verifications, reset 2026-08-15.
