# TermStack enrich — 2026-08-08 (first live run)

## Ceilings
1 search, 1 verification. Both fully used. Nothing exceeded.

## Spend (measured from account deltas, not inferred)
- searches: 31 -> 32 (1 used, 18 left, resets 2026-08-15)
- verifications: 63 -> 64 (1 used, 36 left)

## Result: 0 emails found, 4 prospect records corrected
No T1-eligible contact produced. The value of this run was free research killing bad
targets before they cost anything — 3 of the 4 highest-fit candidates failed on
evidence that was already wrong in their files.

### Disqualified
- **uncle-jack** (was fit 8, Tier A) — unclejack.com.au 301s to unclejackwatches.com,
  which 404s "This store is unavailable". Store closed, business appears dead.
  fit 8 -> 0, status disqualified. 0 quota.

### Downgraded (evidence in file was wrong)
- **le-toy-van** (fit 8 -> 4) — live Shopify, but wholesale runs on the Wholesale Gorilla
  app, not native B2B. Wholesale Gorilla runs on non-Plus plans. Settles the old
  "native-vs-app unconfirmed" note. 0 quota.
- **goulet-pen-company** (fit 7 -> 4) — the "dedicated wholesale section" claim is false.
  /pages/wholesale, /pages/wholesale-login and wholesale.gouletpens.com all 404.
  No B2B app present. 0 quota.

### Confirmed good, contact still missing
- **fsaproshop** (fit 8, Tier A) — B2B CONFIRMED: wholesale.fsaproshop.com is a live
  Shopify store with customer_authentication and 20 b2b refs (native Shopify B2B).
  Hunter has NO data on this domain: 0 personal emails on a tight filter AND on a
  loosened one, pattern null, accept_all false (not catch-all).
  wholesale@fsaproshop.com verified INVALID / undeliverable.
  Cost 1 search + 1 verification. Independently confirms Rajat's 2026-08-03 manual
  finding. Next step is manual LinkedIn for the ecommerce/B2B lead — Hunter cannot help.

## Two bugs found and fixed during the run
1. jq `//` treats `false` as empty, so `accept_all: false` was cached as `null` — the
   catch-all parking logic reads that field, so "known not catch-all" was being
   recorded as "unknown". Now null-checked explicitly.
2. Cost was being INFERRED from the response body. Hunter's docs say a zero-result
   domain-search is not counted; the account counter proved otherwise (31 -> 32 on two
   zero-result searches). Metering now MEASURES the account-counter delta around every
   call. Also corrected: free plan has two separate quotas (50 searches / 100
   verifications), not one 0.5-credit pool.

## Read-across for the pipeline
3 of 4 top-fit prospects had materially wrong evidence in their files. The fit scores in
the not_contacted pool are not trustworthy without a live check. Free research should
run over the rest of the pool before any more quota is spent — it costs nothing and it
is currently finding a ~75% error rate.

## System
Run ok · ceilings honoured · 0 drafts · 0 sends · 4 prospect files updated (atomic).
