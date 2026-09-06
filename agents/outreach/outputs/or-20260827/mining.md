# Mining pass — 2026-08-27 (on demand, free, 0 Hunter quota)

## Veins worked and their yield

| Vein | Names found | Already in pool | Net new | Usable |
|---|---|---|---|---|
| Onboard B2B app reviews (all 13) | 13 | 12 | hy-gain | 0 |
| IWD "8 Real Shopify B2B Implementations" | 8 | 5 | Gymshark, Allbirds, TRUFF | 0 |
| Other B2B listicles | ~6 | 4 | Teapigs, Kulani Kinis, Andar | 1 |
| AReceivables reviews (competitor vein, NEW) | 6 | 0 | all 6 | 1 |

## Probe results (qualify.sh, serial)
- truff.com          NO_B2B_CHANNEL (no public wholesale surface)
- allbirds.com       NO_B2B_CHANNEL, but PLUS high (checkout.allbirds.com). B2B not publicly linked.
- gymshark.com       NO_B2B_CHANNEL
- hy-gain.com        NO_B2B_CHANNEL (Onboard B2B reviewer, so B2B exists somewhere off the root domain)
- teapigs.co.uk      NOT_SHOPIFY
- andar.com          UNKNOWN_RETRY (HTTP 403) — RE-PROBE SERIALLY, not a verdict
- kulanikinis.com    REVIEW, /pages/wholesale, no Plus evidence
- kaatsu.com         NO_B2B_CHANNEL
- maxxonoutfitters.com REVIEW, no wholesale path found, no Plus evidence
- ttseeds.com        NO_B2B_CHANNEL + wildcard DNS (subdomain signals void)
- maverickofficesupplies.com NOT_SHOPIFY

## Conclusion
The free veins that built the current pool of 85 are exhausted. Public listicles and the
Onboard B2B review list recycle the same brands, and 12 of 13 Onboard reviewers were
already imported. Net new usable prospects from a full pass: 2, neither Plus-verified.

Scaling past this needs a store-tech dataset (Storeleads / BuiltWith / Shopify Plus partner
directory) filtered on Shopify Plus + B2B, not more web search.

## Qualification change required (see the correction note on jonathan-adler.json)
B2B company accounts and net terms are now available on Basic, Grow, Advanced and Plus.
A native-B2B portal is therefore NOT a Plus signal. Plus-exclusive B2B features are
deposit requirements, partial payments, payment requests per fulfillment, direct company
catalogs, contextual experiences. Valid free Plus signals remain: expansion store
(separate shopId on a B2B subdomain), legacy checkout.<domain>, Plus-only apps.
