# Shopify B2B payment terms by order value: rules, examples, and setup

> Meta description: How to automatically apply different B2B payment terms based on order size on Shopify Plus, using a rules engine with ORDER_TOTAL conditions.

Most Shopify Plus merchants I talk to want the same thing: stricter terms on small orders, more flexibility on large ones. Net 30 on a $500 test order makes no sense. But demanding full payment upfront on a $50,000 wholesale order is a deal-killer.

The problem is Shopify assigns one payment term per company location. It doesn't know if the order is $200 or $200,000. The same Net 30 applies to both, and you're stuck managing the exceptions manually.

This post explains how to set payment terms by order value on Shopify Plus, what that looks like in practice, and how to set it up.

## Why static payment terms break at scale

Shopify's native B2B payment terms are configured per company location. Every order from that buyer — regardless of size, product mix, or payment history — gets the same terms.

That's fine when you're starting out. But once you have buyers ordering at different volumes, static terms create real problems.

A new wholesale account placing a $300 test order probably shouldn't get Net 60. That's a lot of risk on an unproven relationship. On the other hand, your top account placing a $75,000 annual restocking order probably should get generous terms. They've earned it, and you want to make it easy for them to buy.

With static terms, you either set the policy loose for everyone (more risk) or tight for everyone (more friction). Neither is right.

The only way to handle this natively is through draft orders or manual overrides — someone on your team reviewing each order and adjusting terms by hand. That doesn't scale.

## How payment terms by order value work

Order-value-based terms use a rules engine that evaluates the ORDER_TOTAL condition at checkout. You define thresholds, and the engine applies the right terms automatically based on what's in the cart.

The evaluation is deterministic: same inputs, same output. No manual review, no policy drift. The rules run inside a Shopify Function at checkout, server-side, in under 5ms, with no external API calls.

The basic pattern looks like this:

- **Orders under $2,000**: require payment on fulfillment or a deposit upfront
- **Orders $2,000–$20,000**: Net 30
- **Orders above $20,000**: Net 60

You can layer in other conditions too. Maybe large-order Net 60 only applies to buyers who have at least one previous order. Or maybe you require a 25% deposit on orders above $50,000 for new accounts. The rules engine supports all of this.

## The ORDER_TOTAL condition

ORDER_TOTAL compares the cart total against a threshold you define. The available operators are:

- **GTE** — greater than or equal to
- **GT** — greater than
- **LTE** — less than or equal to
- **LT** — less than
- **BETWEEN** — within a range (inclusive)
- **EQUALS** — exact match
- **NOT_EQUALS** — anything except

For order-value tiering, you'll usually use BETWEEN to define ranges, GTE for "above X", and LT or LTE for "below X".

Rules evaluate top-down — first match wins. That means rule order matters. Put your most specific or most restrictive rules first, with a broader fallback at the bottom.

## A real example: three-tier terms by order size

Here's how a typical merchant would structure order-value-based terms:

**Rule 1: Small orders — pay on fulfillment**

Condition: ORDER_TOTAL LT $2,000
Outcome: DUE_ON_FULFILLMENT

This catches test orders and small replenishments. Payment is due when you ship, not 30 or 60 days later.

**Rule 2: Mid-size orders — Net 30**

Condition: ORDER_TOTAL BETWEEN $2,000 and $20,000
Outcome: NET_DAYS 30

Standard terms for the bulk of your wholesale volume.

**Rule 3: Large orders — Net 60**

Condition: ORDER_TOTAL GTE $20,000
Outcome: NET_DAYS 60

Your biggest accounts get the flexibility they expect.

If no rule matches (which shouldn't happen with this setup, but is configurable), you can set a default fallback. The default can be NO_CHANGE (use whatever Shopify has at the location level) or a specific term you define.

## Adding deposits on top of terms

Order-value conditions can also trigger deposit requirements. Maybe you're comfortable with Net 60 for large orders, but you still want 25% upfront to reduce risk.

You can add a deposit to any rule outcome:

**Rule: Large order — Net 60 with 25% deposit**

Condition: ORDER_TOTAL GTE $20,000
Outcome: NET_DAYS 60 + DEPOSIT_PERCENT 25

Deposits can be percentage-based (DEPOSIT_PERCENT, 0–100%) or a fixed amount (DEPOSIT_FIXED). The deposit is collected at checkout; the balance follows the payment terms.

## Combining with other conditions

ORDER_TOTAL is one condition. Rules support multiple conditions with AND semantics — all conditions must match for a rule to fire.

Some useful combinations:

**Large order, but new account**: Require a deposit even on Net 60.

Conditions: ORDER_TOTAL GTE $20,000 AND TOTAL_ORDERS_COUNT LT 1
Outcome: NET_DAYS 60 + DEPOSIT_PERCENT 25

**VIP buyer, any order size**: Bypass the tiers entirely.

Conditions: CUSTOMER_TAG ANY_OF [vip, gold-tier]
Outcome: NET_DAYS 60

Put this rule above the ORDER_TOTAL rules, and it fires first for those buyers.

**Specific company, large order**: Custom terms for your best account.

Conditions: COMPANY ANY_OF [acme-inc] AND ORDER_TOTAL GTE $10,000
Outcome: NET_DAYS 90

Rules evaluate in priority order. The first match wins. You can layer company-specific rules above the order-total tiers, and the tiers serve as a general policy for everyone else.

## When native Shopify isn't enough

Shopify Plus sets one payment term per company location. There's no built-in way to vary terms by order size, combine multiple conditions, or require conditional deposits.

<div style={{backgroundColor: '#f5f3ff', border: '1px solid #c4b5fd', borderLeft: '4px solid #7C3AED', borderRadius: '8px', padding: '1rem 1.25rem', margin: '1.5rem 0'}}>
  <strong style={{color: '#5b21b6'}}>Order-value tiering, deposits, and multi-condition rules — all without custom code.</strong><br/>
  <span style={{color: '#374151', fontSize: '0.95rem'}}><a href="https://apps.shopify.com/termstack" style={{color: '#7C3AED', fontWeight: '600', textDecoration: 'underline'}}>TermStack</a> is a rules engine for Shopify Plus B2B that evaluates ORDER_TOTAL and seven other condition types at checkout, applies the right terms automatically, and keeps an immutable audit trail of every change. <a href="https://apps.shopify.com/termstack" style={{color: '#7C3AED', fontWeight: '600', textDecoration: 'underline'}}>Try it free for 14 days →</a></span>
</div>

<a href="https://apps.shopify.com/termstack" style={{textDecoration: 'underline'}}>TermStack</a> runs as a Shopify Function, which means the rules evaluate at checkout inside Shopify's own infrastructure. No external API calls, no checkout slowdown.

## Setting this up in TermStack

Here's how to build order-value rules in TermStack:

**Navigate to Rules.** In the TermStack admin, go to **Rules** and click **New rule**.

**Name your rule.** Give it something descriptive: "Small order, pay on fulfillment" or "Large order, Net 60". You'll see this in the audit log.

**Add the ORDER_TOTAL condition.** Click **Add condition**, select **Order total**, then choose your operator (LT, GTE, BETWEEN, etc.) and enter the threshold.

**Set the outcome.** In the Outcome section, pick the payment terms type and duration. For NET_DAYS, enter the number of days. If you want a deposit, toggle it on and enter the percentage or fixed amount.

**Save and repeat** for each tier. Then drag the rules into the correct priority order — most specific at the top, broadest fallback at the bottom.

**Test before publishing.** Use the Simulator to verify each tier fires correctly. You can enter a manual order total, pick a buyer, and see exactly which rule matches and what terms would be applied.

**Publish.** When the ruleset looks right, click **Publish**. The rules compile and deploy to Shopify's Function infrastructure. From that point on, every B2B checkout automatically gets the right terms based on order size.

## How many rules can you have?

Rule limits depend on your plan:

| Plan | Active published rules | Stored rules |
|------|----------------------|--------------|
| FREE | 0 (cannot publish) | 10 |
| CORE ($99/mo) | 15 | 90 |
| GROWTH ($149/mo) | 40 | 100 |
| SCALE ($299/mo) | 75 | 100 |

For a three-tier order-value setup, you're using 3 active rules. The CORE plan is enough. If you layer in company-specific overrides and tag-based exceptions, you'll use more — but most merchants running order-value tiering stay within 10–15 active rules.

## Frequently Asked Questions

<BlogFaq>
  <BlogFaqItem q="Can Shopify Plus apply different payment terms based on order size?">
    Not natively. Shopify Plus sets one payment term per company location, and it applies to every order from that buyer regardless of the cart total. To vary terms by order value, you need a rules engine like TermStack that evaluates an ORDER_TOTAL condition at checkout and applies the matching terms automatically.
  </BlogFaqItem>

  <BlogFaqItem q="What operators are available for the ORDER_TOTAL condition?">
    ORDER_TOTAL supports GTE (greater than or equal), GT (greater than), LTE (less than or equal), LT (less than), BETWEEN (a range, inclusive), EQUALS, and NOT_EQUALS. For tiered pricing, BETWEEN is the most common for mid-range tiers, GTE for your top tier, and LT or LTE for your smallest tier.
  </BlogFaqItem>

  <BlogFaqItem q="How does first-match-wins evaluation work with order-value rules?">
    Rules evaluate top-down by priority order. The first rule whose conditions all match is applied, and evaluation stops. So if you have a VIP customer rule above your order-value tiers, VIP buyers get their rule regardless of order size. Order-value tiers serve as the fallback for everyone else. Rule order is drag-and-drop in TermStack's admin.
  </BlogFaqItem>

  <BlogFaqItem q="Can I require a deposit on large orders while still offering Net 60?">
    Yes. An outcome can include both payment terms and a deposit. You set NET_DAYS 60 as the terms and add a DEPOSIT_PERCENT (0–100%) or DEPOSIT_FIXED amount on the same rule. The deposit is collected at checkout; the balance is due per the Net 60 schedule.
  </BlogFaqItem>

  <BlogFaqItem q="Can I combine ORDER_TOTAL with other conditions like customer tags or order history?">
    Yes. Rules support multiple conditions with AND semantics — all conditions must match for the rule to fire. You can combine ORDER_TOTAL with CUSTOMER_TAG, COMPANY, TOTAL_ORDERS_COUNT, FIRST_ORDER, COLLECTION, COMPANY_LOCATION, or PAYMENT_TERMS. For example: require a deposit only on large orders from buyers with fewer than 2 previous orders.
  </BlogFaqItem>

  <BlogFaqItem q="What happens if no order-value rule matches a B2B checkout?">
    The fallback behavior is configurable in TermStack settings. The default is NO_CHANGE, meaning checkout uses whatever payment terms are set at the company location level in Shopify. You can also configure a DEFAULT_OUTCOME to apply a specific term when no rule matches. The Function also has a fail-safe: if it errors reading or evaluating the ruleset, it returns NO_CHANGE and never blocks checkout.
  </BlogFaqItem>

  <BlogFaqItem q="Does evaluating ORDER_TOTAL rules slow down B2B checkout?">
    No. TermStack's Shopify Function evaluates rules at checkout in under 5ms, server-side inside Shopify's infrastructure. The ruleset is pre-compiled and stored in a metafield the Function reads directly — no external API calls at runtime. B2B buyers don't see any difference in checkout speed.
  </BlogFaqItem>

  <BlogFaqItem q="How many order-value tiers can I have?">
    As many as your plan allows for active published rules. CORE ($99/mo) supports 15 active rules, GROWTH ($149/mo) supports 40, and SCALE ($299/mo) supports 75. A three-tier order-value setup uses 3 rules. Most merchants running order-value tiering with a few company-specific overrides stay under 15 active rules, so CORE covers them.
  </BlogFaqItem>
</BlogFaq>

## Summary

Shopify Plus can't vary payment terms by order size on its own. You get one term per company location, and it applies to every order.

If that's creating exceptions, manual overrides, or terms that don't reflect your actual credit policy, order-value rules are the fix. You define the thresholds, set the terms for each tier, and the rules engine handles the rest at checkout — automatically, consistently, with a full audit trail.

<a href="https://apps.shopify.com/termstack" style={{textDecoration: 'underline'}}>TermStack</a> makes this configurable without code. Three tiers, deposits, multi-condition exceptions — you can set it up in an afternoon and publish when it looks right.

<div style={{textAlign: 'center', marginTop: '2rem'}}>
  <a href="https://apps.shopify.com/termstack" style={{display: 'inline-block', padding: '0.75rem 2rem', backgroundColor: '#0f172a', color: 'white', borderRadius: '9999px', fontWeight: 700, fontSize: '0.875rem', textDecoration: 'none'}}>Try TermStack free for 14 days →</a>
</div>
