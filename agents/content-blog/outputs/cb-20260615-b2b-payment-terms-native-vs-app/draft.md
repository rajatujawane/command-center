# Shopify B2B payment terms: what's native vs. what needs an app (2026)

**Meta description:** Shopify Plus gives you static B2B payment terms out of the box. Here's exactly where native ends and where you need an app to do anything dynamic.

---

I get this question a lot from B2B merchants evaluating Shopify Plus: "Can I just set Net 30 for my wholesale customers natively?" Yes. "Can I give new customers different terms than established ones, or change terms based on order size?" No — not without an app.

Here's a clear breakdown of what Shopify handles natively and where the wall is.

## What Shopify does natively

Shopify Plus gives you B2B payment terms at the **company location level**. You assign a payment terms template — Net 7, Net 15, Net 30, Net 45, Net 60, Net 90, Due on Fulfillment, or no terms — directly to each company location in the admin. Those terms then surface at checkout for that buyer automatically.

That's it. It works well if:
- All orders from a given location get the same terms
- Your terms don't change based on order size, purchase history, or product mix
- You're fine managing terms manually per location

For a lot of B2B setups, this is sufficient. A company with 50 accounts, each with a consistent agreed-upon term, doesn't need anything more.

## Where native breaks down

The moment you want **dynamic** terms — terms that vary based on context at the time of checkout — you're outside what Shopify can do natively. Specifically, you can't natively:

- Give a new customer different terms than a repeat buyer
- Tighten terms (require a deposit, shorten net days) when an order exceeds a threshold
- Apply different terms based on what's in the cart — certain product categories, collections, or high-risk items
- Automatically enforce stricter terms after a location accumulates late payments or a high order count
- Set a default deposit requirement for first-time B2B orders

Every one of these requires reading checkout context — order total, buyer history, cart contents, company ID — and acting on it in real time. Shopify's native terms are static assignments. They don't evaluate conditions.

## What an app adds

Shopify Functions let third-party apps intercept checkout and modify payment methods before they're presented to the buyer. A payment terms app uses this to run a rules engine at checkout time.

The way Term Stack does it: you define ordered rules with conditions (order total is above $5,000, customer tag is "new-account", company is in a specific list, etc.) and an outcome (Net 15, Due on Fulfillment, 20% deposit + Net 30). At checkout, the Function evaluates rules top-down and applies the first match.

This means you can build logic like:

- First-time buyer? Require 25% deposit.
- Order under $500? No terms, pay now.
- Order over $10,000 from an established account? Net 60.
- Cart contains any item from the "high-risk" collection? Net 7.

None of that is possible natively. You're layering a rules engine on top of Shopify's payment customization API — which is the only way to do this inside the checkout, without draft orders or manual sales ops intervention.

## What you still can't do with an app

Worth being honest about limits. Even with a Shopify Function-based app:

- **No external API calls at runtime.** The Function runs in ~5ms with no network access. Any buyer data that needs to influence terms — like a live credit check or ERP balance — has to be pre-synced to Shopify as a metafield before checkout. You can sync it via webhooks and background jobs, but there's a window where the data can be stale.
- **No payment method shaping.** You can apply terms, but you can't (in the current Term Stack implementation) hide or rename payment methods on the checkout page. That's a separate Function target.
- **No OR logic between conditions.** Within a single rule, all conditions are AND. To get OR behavior, you write two separate rules.
- **Plus-only.** B2B payment terms customization via Functions is a Shopify Plus feature. Not available on standard plans.

## The practical decision

If your B2B operation is simple — a fixed term per account, managed manually — use Shopify native. It's one less app to manage, and you don't need the overhead.

If you have more than one payment policy, or if your terms depend on anything that changes order to order (size, history, product type, buyer tier), native won't cut it. You need a Function-based app to do this at checkout without manual workarounds.

The main advantage of doing it at checkout via a Function rather than through draft orders or post-purchase invoicing: it's enforced automatically, every time, without your sales team touching it.
