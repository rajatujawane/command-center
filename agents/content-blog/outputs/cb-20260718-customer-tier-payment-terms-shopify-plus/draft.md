# Customer-tier payment terms on Shopify Plus

> Meta description: How to automatically give Gold buyers Net 60, Silver Net 30, and new accounts prepayment on Shopify Plus using customer tags and a rules engine.

Your Gold buyers earned better terms. Your new accounts haven't. Shopify Plus doesn't care — it assigns one payment term per company location and applies it to every order from that buyer, forever.

If you've been manually adjusting terms as customers move between tiers, or you're running a blanket Net 30 for everyone because it's the only way to stay consistent, that's the problem.

This post explains how to build customer-tier payment terms on Shopify Plus using customer tags and a rules engine that runs at checkout automatically.

## What "tiers" actually mean

Tier-based payment terms are just: different buyers get different terms based on how you've categorized them.

In practice that looks like:

- **Gold** buyers — your highest-volume, lowest-risk accounts — get Net 60 or Net 90
- **Silver** buyers — established but not your top — get Net 30
- **New** or unverified buyers get payment on fulfillment, or a deposit upfront

The categorization usually lives in customer tags. You tag a company buyer as `gold`, `silver`, or `new`, and the rules engine at checkout reads that tag and applies the right terms.

Tags are flexible. You can set them manually, apply them automatically via Shopify Flow when a buyer hits a spend milestone, or sync them from an ERP that already tracks account tiers.

## Why Shopify's native terms don't work for this

Shopify Plus assigns payment terms at the company location level. One company location, one payment term. That term applies to every B2B checkout from that buyer, regardless of any other factor.

The problem starts when buyers change tiers. A new account graduates to Silver after their second order. A Silver account hits $100k in annual purchases and earns Gold. In Shopify's native model, you have to manually go into each company location and update the terms. Nobody does this consistently. The result is terms that drift from your actual credit policy.

Worse, there's no way to apply different terms within the same tier based on order size, product category, or payment history. You're back to the same all-or-nothing setup.

At 10 companies, manual management is annoying. At 50, it's broken. At 200, it's a liability.

## The tag-based rule pattern

Customer tags are available as a condition in Shopify Functions via Payment Customization. A rules engine like TermStack reads the `CUSTOMER_TAG` condition at checkout and applies the first matching rule.

Here's a three-tier setup:

**Rule 1: Gold — Net 60**

Condition: CUSTOMER_TAG ANY_OF [`gold`]
Outcome: NET_DAYS 60

**Rule 2: Silver — Net 30**

Condition: CUSTOMER_TAG ANY_OF [`silver`]
Outcome: NET_DAYS 30

**Rule 3: No tier — pay on fulfillment**

Condition: CUSTOMER_TAG NONE_OF [`gold`, `silver`]
Outcome: DUE_ON_FULFILLMENT

Rules evaluate top-down — first match wins. Gold buyers hit Rule 1 and stop there. Silver buyers miss Rule 1, hit Rule 2. Everyone else falls through to Rule 3.

This means you can run thousands of companies on three rules. Add a new Gold buyer? Tag them `gold` and the rule kicks in at their next checkout. No settings to update per company, no manual review.

## How customer tags get set

Tags don't update themselves, so it's worth thinking about the mechanism:

**Manual tagging.** Go into Shopify admin, find the customer, add the tag. Works fine at small scale, becomes a maintenance burden past 50 companies.

**Shopify Flow.** Flow lets you set tags based on events. When a buyer places their second order, or when their total spend crosses $50k, Flow runs automatically and applies the tag. This is the most common approach for merchants who want tiering without ERP integration.

**ERP sync.** If your ERP already has account tiers — A, B, C accounts, or Gold/Silver/Bronze — you can sync those tags into Shopify via your integration. The rules engine reads whatever tags are on the customer at checkout time.

Whatever the source, the tag just needs to exist on the customer when they check out. TermStack's `CUSTOMER_TAG ANY_OF` condition does a set intersection — if the buyer has any of the listed tags, the condition matches.

## Adding deposits and combining conditions

Tags are one condition. You can combine them with others to get more specific.

**Gold buyer, but first order — require a deposit:**

Conditions: CUSTOMER_TAG ANY_OF [`gold`] AND FIRST_ORDER EQUALS true
Outcome: NET_DAYS 60 + DEPOSIT_PERCENT 25

Put this rule above the plain Gold rule. New Gold accounts get the deposit on their first order. On subsequent orders they fall through to the no-deposit Net 60.

**Silver buyer, large order — Net 30 with deposit:**

Conditions: CUSTOMER_TAG ANY_OF [`silver`] AND ORDER_TOTAL GTE $10,000
Outcome: NET_DAYS 30 + DEPOSIT_PERCENT 20

You can combine CUSTOMER_TAG with ORDER_TOTAL, TOTAL_ORDERS_COUNT, COMPANY, FIRST_ORDER, COLLECTION, and other conditions. All conditions in a rule use AND semantics — all must match for the rule to fire.

## Setting this up in TermStack

Here's how to build tier rules in TermStack:

**Go to Rules, click New rule.** Give it a clear name — "Gold: Net 60" or "Silver: Net 30". You'll see this name in the audit log.

**Add the CUSTOMER_TAG condition.** Click Add condition, select Customer tag, choose ANY_OF, then type the tag. You can add multiple tags to the same condition if Gold buyers have multiple tag variants.

**Set the outcome.** Pick the payment terms type. For Net 60, select NET_DAYS and enter 60. For no-tier buyers, select DUE_ON_FULFILLMENT. If you want a deposit, toggle it on and enter the percentage.

**Save and create all three rules.** Then drag them into priority order: Gold at the top, Silver in the middle, no-tier at the bottom.

**Test in the Simulator before publishing.** The Simulator lets you pick a buyer and see which rule matches. Enter a Gold-tagged buyer, confirm Rule 1 fires. Enter an untagged buyer, confirm they hit Rule 3. You can see the full evaluation trace — which conditions matched, which rules were skipped.

**Publish the ruleset.** Once it looks right, publish. Rules compile and deploy to Shopify's checkout infrastructure. From that point forward, tag changes take effect at the next checkout with no additional action.

## Plan limits

| Plan | Active published rules | Stored rules |
|------|----------------------|--------------|
| FREE | 0 (cannot publish) | 10 |
| CORE ($99/mo) | 15 | 90 |
| GROWTH ($149/mo) | 40 | 100 |
| SCALE ($299/mo) | 75 | 100 |

A three-tier tag setup uses 3 active rules. Add deposit variants for first orders and you're at 5 or 6. CORE covers this comfortably.

## When does this not work on Shopify Plus?

This approach requires Shopify Plus. The `cart.payment-methods.transform` API used by Payment Customization Functions is Plus-only. Non-Plus stores can't apply dynamic payment terms at checkout.

Draft orders are also separate from the B2B checkout flow. Rules that fire at checkout don't apply to draft orders created manually in the admin. If your team uses draft orders for wholesale, you'll need to set terms manually on those.

## Frequently Asked Questions

<BlogFaq>
  <BlogFaqItem q="Can Shopify Plus give different payment terms to different customer tiers?">
    Not natively. Shopify Plus assigns one payment term per company location and it applies to every order. To vary terms by customer tier — Gold gets Net 60, Silver gets Net 30, new accounts pay on fulfillment — you need a Payment Customization Function that reads customer tags at checkout. TermStack does this with a rules engine where you define the tag conditions and outcomes.
  </BlogFaqItem>

  <BlogFaqItem q="What if a buyer has both a Gold and a Silver tag?">
    Rules evaluate top-down by priority. If a buyer has both tags and you have a Gold rule above a Silver rule, they match Gold and stop there. The first matching rule wins, and evaluation doesn't continue. If you want a specific outcome for buyers with both tags, create a rule with CUSTOMER_TAG ANY_OF [`gold`, `silver`] above your individual tier rules.
  </BlogFaqItem>

  <BlogFaqItem q="Do customer-tag rules work on draft orders?">
    No. Shopify Payment Customization Functions only run at B2B checkout, not on draft orders created in the Shopify admin. If your sales team creates draft orders manually, they'll need to set payment terms on those orders by hand.
  </BlogFaqItem>

  <BlogFaqItem q="How do tags get updated when a buyer moves from Silver to Gold?">
    That's a separate process from the rules engine. You can update tags manually in Shopify admin, automate it with Shopify Flow (e.g., when lifetime spend crosses a threshold), or sync from an ERP. Once the tag is updated on the customer, the new rule takes effect at their next checkout automatically.
  </BlogFaqItem>

  <BlogFaqItem q="Can I require a deposit for new-tier buyers but not established ones?">
    Yes. Create a rule that combines CUSTOMER_TAG ANY_OF [`gold`] with FIRST_ORDER EQUALS true, and set an outcome with a deposit percentage. Put it above your plain Gold rule. New Gold buyers hit the deposit rule on their first order; returning Gold buyers fall through to the no-deposit rule.
  </BlogFaqItem>

  <BlogFaqItem q="Is this available on non-Plus plans?">
    No. Payment Customization Functions — the Shopify API that powers dynamic terms at checkout — is a Shopify Plus-only feature. Non-Plus merchants can't apply or modify payment terms at checkout.
  </BlogFaqItem>
</BlogFaq>

If you're managing payment terms across more than a dozen companies, the manual approach breaks down fast. Customer tags plus a rules engine means one rule can serve a thousand Gold buyers, and you only update a tag when someone's tier changes.

<div style={{backgroundColor: '#f5f3ff', border: '1px solid #c4b5fd', borderLeft: '4px solid #7C3AED', borderRadius: '8px', padding: '1rem 1.25rem', margin: '1.5rem 0'}}>
  <strong style={{color: '#5b21b6'}}>Tier-based payment terms, without the manual work.</strong><br/>
  <span style={{color: '#374151', fontSize: '0.95rem'}}><a href="https://apps.shopify.com/termstack" style={{color: '#7C3AED', fontWeight: '600', textDecoration: 'underline'}}>TermStack</a> is a rules engine for Shopify Plus B2B that reads customer tags and seven other condition types at checkout, applies the right terms automatically, and keeps an immutable audit trail of every policy change. <a href="https://apps.shopify.com/termstack" style={{color: '#7C3AED', fontWeight: '600', textDecoration: 'underline'}}>Try it free for 14 days →</a></span>
</div>

<div style={{textAlign: 'center', marginTop: '2rem'}}>
  <a href="https://apps.shopify.com/termstack" style={{display: 'inline-block', padding: '0.75rem 2rem', backgroundColor: '#0f172a', color: 'white', borderRadius: '9999px', fontWeight: 700, fontSize: '0.875rem', textDecoration: 'none'}}>Try TermStack free for 14 days →</a>
</div>
