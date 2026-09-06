# Net 30 vs Net 60: Which Should You Offer Wholesale Buyers?

Meta description: Net 30 vs Net 60 for wholesale buyers, with the cash conversion math, when Net 60 pays off, and how to enforce whichever you pick at checkout on Shopify Plus.

A buyer asks for Net 60. Your competitor is offering it. Do you match, or hold the line at Net 30?

That question comes up in almost every wholesale deal of any size, and most merchants answer it by gut feel. The extra 30 days sounds small until you work out what it costs you across every account that gets it.

This post is the head-to-head: what Net 30 and Net 60 actually mean for your cash, when the longer term is worth it, when it's just margin leaking out the door, and how to enforce whichever policy you land on without editing accounts by hand.

## What Net 30 and Net 60 actually mean

Both are net terms. The number is how many days the buyer has to pay after you invoice.

- **Net 30.** Full payment due 30 days after the invoice date.
- **Net 60.** Full payment due 60 days after the invoice date.

The difference isn't 30 days of paperwork. It's 30 extra days where you've shipped the goods, covered the cost of making or sourcing them, and haven't been paid. That gap is the whole decision.

## The cash conversion math

The cleanest way to see the cost is your cash conversion cycle: how long a dollar is tied up between paying for inventory and collecting from the buyer. Payment terms move one part of that directly. Net 30 adds about 30 days of receivables. Net 60 adds about 60.

Here's a worked example. Say a buyer places a $20,000 order every month and your cost of goods is 40%, so each order costs you $8,000 to fulfill.

On Net 30, you typically have one order outstanding at any time. That's roughly $8,000 of your own cash deployed before payment lands.

On Net 60, you have two orders outstanding at once: this month's shipment and last month's invoice still running toward its due date. That's about $16,000 tied up, all the time, per account.

So moving one account from Net 30 to Net 60 costs you roughly $8,000 in additional working capital that stays locked up for as long as the relationship lasts. Multiply that across ten accounts and Net 60 is quietly financing $80,000 of someone else's business.

A quick heuristic: **average order value × months outstanding × COGS percentage** gives you the capital deployed per account. Net 30 is one month, Net 60 is two. Run that number before you agree to the longer term.

None of this makes Net 60 wrong. It makes it a cost you should price in on purpose instead of absorbing by default.

## When Net 60 is worth it

Net 60 earns its cost in a few specific situations.

**Large, committed buyers.** A buyer placing $200,000 a year earns more flexibility than one placing $8,000. When the account is big enough, the carry cost is a reasonable price for keeping the relationship and the volume.

**Enterprise accounts with fixed procurement cycles.** Large retail chains, hospital systems, and government suppliers often have Net 60 baked into their AP process. They're not asking a favor, they're telling you how they pay. If the account is worth it, you offer the terms and build the timeline into your cash flow planning.

**Competitive pressure on a deal you want.** If a comparable supplier offers Net 60 and you're at Net 30, terms can be the thing that loses you the order. On a strategic account, matching can be the right call.

**Proven buyers with a clean history.** A buyer who's ordered for 12+ months and never paid late has given you the data to extend more credit. The risk is low because you can see it.

For the deeper version of this decision, including how to gate eligibility and downgrade slow payers, see the [full guide to Net 60 on Shopify Plus](/blog/net-60-payment-terms-shopify-plus).

## When Net 60 is just margin leakage

The same term is a mistake in the wrong place.

**First orders from unproven buyers.** You have no payment history. Net 60 on a first order finances a stranger for two months with nothing to go on. Payment on fulfillment or a deposit is the right default until they've cleared an order or two.

**Small accounts.** The carry cost is fixed overhead per account. On an $8,000-a-year buyer, 60 days of unsecured credit isn't buying you loyalty worth having. Net 30 is plenty.

**Buyers who already pay late.** If an account routinely pays on day 70, formalizing Net 60 just tells them day 90 is fine. Tighten, don't extend.

**A blanket policy.** The most expensive version of Net 60 is giving it to everyone because it's easier than deciding case by case. That's how a term meant for your top accounts ends up subsidizing your smallest and riskiest ones.

## The hybrid approach beats picking one

The real answer is usually not Net 30 *or* Net 60. It's both, applied by condition.

The problem is that Shopify's native payment terms can't do conditional. On Shopify Plus you set one static term per company location, and it applies to every order from that account regardless of size, history, or how this particular order looks. It's Net 30 for that buyer, or Net 60, forever, until someone edits the account by hand.

That's fine for a handful of accounts that all get the same treatment. It breaks the moment your policy has any nuance. A few hybrid rules that native terms can't express:

- **Net 60 only above an order threshold.** Small orders get Net 30, large committed orders get Net 60, because that's where the longer term actually buys you something.
- **Net 60 only for buyers with 10+ orders.** New accounts start tighter and graduate as they prove out, so credit tracks behavior instead of whatever got typed into a form on day one. That's the [order-count graduation ladder](/blog/graduate-b2b-payment-terms-by-order-count).
- **Net 60 by tier, with a ceiling.** Gold accounts get Net 60, but any single order over $25,000 requires a deposit regardless of tier.
- **Automatic downgrade on slow pay.** An account tagged slow-pay reverts to Net 30 at checkout, no matter what their normal term would be.

None of these are exotic. They're what a credit manager at any traditional distributor does in their head. The issue is doing them reliably at checkout, on every order, without anyone remembering to.

## Enforcing whichever policy you pick

Once you've decided who gets Net 30 and who gets Net 60, the terms have to apply themselves. Manually setting them per account is where good policies quietly rot: someone forgets, an account that earned Net 60 never gets it, a slow payer never gets downgraded.

The conditional logic runs on Shopify's Payment Customization Functions. You can build a custom Function if you have a developer, or use a rules engine on top of it.

That's what I built TermStack for. You write the policy as ordered rules: Net 60 for Gold-tier buyers, a deposit on orders over $25,000, Net 30 for everyone else, payment on fulfillment for first orders. Rules evaluate top down and the first match wins, so a big order from a trusted buyer hits the ceiling rule while a routine reorder falls through to their normal term. It runs at checkout on every B2B order, and it leaves your direct-to-consumer checkout untouched.

You can test each rule against a sample order in a simulator before publishing, so you catch the boundary cases (a buyer landing exactly on your order-count threshold) before a real checkout does. Every publish is versioned with one-click rollback if a policy turns out too generous, and there's an audit trail of what changed and who changed it.

The point isn't the tool. It's that "Net 30 vs Net 60" stops being a per-deal argument and becomes a written policy that enforces itself.

## Quick reference

| | Net 30 | Net 60 |
|---|---|---|
| Cash tied up (per $20k order, 40% COGS) | ~$8,000 | ~$16,000 |
| Best for | Standard wholesale accounts | Large, committed, or enterprise buyers |
| Risk on first orders | Still too loose for unproven buyers | Never offer on a first order |
| Native Shopify Plus support | One static term per company location | One static term per company location |
| Conditional by size, tier, or history | Needs a Payment Customization Function | Needs a Payment Customization Function |

## Frequently asked questions

**Is Net 30 or Net 60 better for wholesale buyers?**
Neither is better on its own. Net 30 is the right default for standard wholesale accounts because it collects cash twice as fast as Net 60. Net 60 is worth its higher carrying cost for large, committed, or enterprise buyers who justify the extra 30 days of credit or expect it from their procurement process. The strongest policy uses both, applied by order size, buyer tier, and payment history rather than one flat term for everyone.

**How much does Net 60 actually cost compared to Net 30?**
Net 60 roughly doubles the working capital you have tied up in an account versus Net 30. Use average order value times months outstanding times your COGS percentage. A buyer placing $20,000 monthly orders at 40% COGS ties up about $8,000 on Net 30 and about $16,000 on Net 60, and that gap stays locked up for the life of the relationship.

**When should I offer a wholesale buyer Net 60 instead of Net 30?**
Offer Net 60 to established buyers with a clean 12-month payment history, enterprise accounts where Net 60 is contractually required, and large recurring accounts where the volume justifies the carry cost. Keep new, small, or slow-paying accounts on Net 30 or tighter until they've earned more.

**Can Shopify Plus set Net 30 or Net 60 automatically based on order size or history?**
Not natively. Shopify Plus stores one static payment term per company location and applies it to every order until someone edits it by hand. To vary between Net 30 and Net 60 by order size, buyer tier, or order count, you need a Payment Customization Function or a rules app like TermStack that evaluates the conditions at checkout.

**Can I offer Net 60 only above a certain order value?**
Yes, but not with native Shopify settings. With a rules engine you write a rule that grants Net 60 only when the order total is above your threshold and keeps smaller orders on Net 30. Because rules evaluate top down and the first match wins, you place the Net 60 rule above the Net 30 fallback and each order gets the right term automatically.

**Does changing B2B payment terms affect my regular consumer checkout?**
No. A Payment Customization Function checks whether the cart belongs to a B2B company and returns no change when it doesn't. Your direct-to-consumer checkout runs exactly as before, and the payment term rules only ever apply to B2B orders from company accounts.

## Summary

Net 30 collects your cash twice as fast. Net 60 wins and keeps large or enterprise accounts that expect it. The mistake is treating it as one choice for the whole book of business.

Decide it deliberately: Net 30 as the default, Net 60 earned by size, tier, or proven history, with a deposit ceiling on oversized orders and an automatic downgrade for slow payers. Then write it as rules that apply themselves at checkout instead of settings someone has to remember to change. That's the setup TermStack gives you on Shopify Plus, with a simulator to test each boundary and version history to roll back if a policy runs too loose.
