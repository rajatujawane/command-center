# Fact check — cb-20260718-graduate-b2b-terms-by-order-count

Sources: `knowledge/termstack/prd.md`, `knowledge/termstack/briefs/graduate-b2b-terms-by-order-count.md`,
plus slug verification against `src/content/blog/` in the site repo.

## Verified

| Claim in draft | Source | Verdict |
|---|---|---|
| Shopify's native B2B payment terms are static per company location | PRD § 1 Problem Statement | OK |
| Order-count graduation needs a Payment Customization Function, Plus only | PRD § 9 (API target `cart.payment-methods.transform.run`), § 11.1 | OK |
| Order-count condition counts *previous* orders, not the current one | PRD § 5.1, `TOTAL_ORDERS_COUNT` = "Total number of previous orders" | OK — this is the off-by-one the post warns about |
| Greater-than-or-equal, less-than and between comparisons available on order count | PRD § 5.1 operator table (GTE, GT, LTE, LT, BETWEEN) | OK |
| Rules evaluate top down, first match wins | PRD § 5.2 | OK |
| Conditions inside one rule combine with AND; no OR groups | PRD § 5.2, § 15 roadmap item 3 | OK |
| Rules require at least one condition (no catch-all rule) | PRD § 12, "Match-all rules (zero conditions) — Not implemented" | OK |
| Store-level behaviour when nothing matches (leave untouched, or default outcome) | PRD § 5.7 Default Payment Terms | OK |
| DTC checkout unaffected when there is no purchasing company | PRD § 5.2 B2B gating, § 9 execution flow step 3 | OK |
| Publish creates a version; one-click rollback to a previous version | PRD § 5.3 | OK |
| Audit trail records actor, action and before/after changes | PRD § 5.6 | OK |
| Simulator with test contexts and debug output showing the matched rule | PRD § 5.5 | OK |
| Deposit percentage outcomes (50%, 25%) | PRD § 5.1 Deposit Support; outcome deposit range 0–99 | OK |
| No external API calls at checkout; runs inside Shopify's Function budget | PRD § 11.3, § 11.4 | OK |
| Conditions named in the post: order count, order total, customer tag, company location, buyer's Shopify-assigned terms | PRD § 5.1 condition table | OK |
| 14-day trial | PRD § 4 Trial Handling | OK |
| Internal link slugs all resolve to published posts | `src/content/blog/` listing | OK (4/4) |

## Softened or removed

1. **"Every merchant I've talked to who says they do this monthly actually did it twice and then stopped."**
   Unverifiable universal from anecdote. Rewritten to "Most merchants who tell you they review terms monthly
   are describing an intention, not a habit."
2. **"There's no report that says 'these eleven buyers have earned better terms this month'."**
   The specific number was invented. Rewritten without a fabricated figure.
3. **"Off-by-one here is the single most common mistake"** (body) and **"the most common setup mistake with
   order-count rules"** (FAQ). Unverifiable superlatives. Softened to "easy to miss" / "an easy mistake to make".
4. **"Every setup mistake I've seen in this pattern is either..."** Rewritten to "The two failure modes to
   watch for are...", which describes the failure modes without claiming an exhaustive personal survey.

## Deliberately kept generic

- Per-plan feature differences (version-history depth, audit retention, rule limits) are in the PRD but are
  intentionally not in the post, per the site's blog-ready rule against per-plan feature diffs.
- Internal identifiers (`TOTAL_ORDERS_COUNT`, `GTE`, `NO_CHANGE`, `DEFAULT_OUTCOME`, `DEPOSIT_PERCENT`) are
  described in plain English only.

No core claim of the post is unverifiable. Nothing blocked.
