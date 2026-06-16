# How to set up dynamic payment terms and deposits on Shopify Plus

> Meta description: Shopify Plus lets you set static B2B payment terms per company location. This guide explains how to add dynamic rules and deposits so the right terms apply at every checkout automatically.

Shopify Plus gives you B2B payment terms. What it doesn't give you is any flexibility in how those terms are applied.

You set Net 30 on a company location, every order from that buyer gets Net 30. $500 reorder? Net 30. $200,000 first purchase? Also Net 30. A buyer who's 90 days past due on their last invoice? Net 30 again.

That's the gap this post covers: what dynamic payment terms actually means on Shopify Plus, how deposits work, and how to set up rules so the right terms apply at every checkout without manual intervention.

## What Shopify Plus gives you natively

Shopify's native B2B handles the basics. You set payment terms per company location, and buyers see those terms at checkout. Net 7, Net 15, Net 30, Net 45, Net 60, Net 90, Due on fulfillment, or no payment terms (pay at checkout). Each company location gets one setting.

To set it up: **Customers → Companies → [Company] → [Location] → Edit payment terms**.

That covers the simple case: one buyer, one agreement, consistent terms on every order. For many merchants starting with B2B, this is enough.

Here's where it breaks down:

- **Static per location.** You can't vary terms by order size, product type, or buyer behavior. Every order from a location gets the same terms.
- **No conditional deposits.** Shopify doesn't let you say "require a 25% deposit on orders above $50,000." You can set a deposit percentage on a location, but it applies to every order equally.
- **No enforcement logic.** A buyer who's overdue on a previous invoice can still place another order at Net 60.
- **No audit trail.** When someone changes a buyer's terms from Net 30 to Net 60, there's no record of who did it or why.

## What dynamic payment terms means

Dynamic payment terms means rules replace manual decisions. Instead of assigning a fixed term to a company location and hoping it's always the right call, you define conditions and outcomes. The right terms apply at checkout automatically, based on what's actually true about that order.

The condition types you can work with in a rules engine like TermStack:

- **Order total** (GTE, LTE, BETWEEN, etc.) — different terms for different order sizes
- **Customer tags** (ANY_OF, NONE_OF) — VIP buyers, high-risk flags, wholesale tiers
- **Company or company location** (ANY_OF, NONE_OF) — specific accounts with custom agreements
- **First order** — new buyers who haven't established payment history
- **Total order count** — buyers who've proven they pay on time
- **Product collections** — custom or made-to-order products that warrant deposits
- **Buyer's existing payment terms** — buyers who already have Net 45 at the location level get matched against that

Rules evaluate top-down. First match wins. All conditions in a rule must match (AND semantics). Disabled rules are skipped. If nothing matches, you can configure a default: either keep whatever Shopify's location-level terms are, or apply a specific fallback.

A few concrete examples of what this looks like in practice:

**By order value:**
- Orders under $5,000: Net 30
- Orders $5,000–$50,000: Net 30 with 25% deposit
- Orders above $50,000: Net 45 with 50% deposit

**By buyer profile:**
- Customer tagged `vip`: Net 60
- Customer tagged `high-risk` or `overdue`: Due on fulfillment
- First-time buyer: payment required at checkout

**By what's in the cart:**
- Cart contains items from a custom-manufacturing collection: 50% deposit required
- Standard stock only: Net 30

**By company or location:**
- Specific company (e.g. Acme Corp): custom negotiated terms applied at the location level, everything else follows standard rules

## How deposits work

Deposits on Shopify Plus exist but are limited. Natively, you can set a deposit percentage on a company location, and buyers pay that percentage at checkout with the remainder due on the normal terms. The limitation: one deposit percentage, applied to every order.

In a rules engine, deposits become an outcome you can attach to any rule. Two formats:

- **DEPOSIT_PERCENT**: A percentage of order total (0–99%, where 0 means no deposit)
- **DEPOSIT_FIXED**: A fixed dollar amount

The deposit outcome is separate from your payment terms outcome. A rule can apply Net 30 with a 25% deposit, Net 45 with a 50% deposit, or no deposit at all depending on conditions.

One thing to be clear about: the deposit Shopify collects at checkout and the payment terms that govern the balance are two different things. A buyer paying a 25% deposit upfront on a Net 30 order pays 25% immediately and the remaining 75% within 30 days. The 30 days starts from when the order is placed.

### Why deposits matter more at scale

At 20 B2B accounts, you know your buyers. You know who pays on time and who needs a deposit to feel commitment to an order. At 200 accounts, you can't hold that knowledge manually.

Deposits serve two functions beyond cash flow: they filter out speculative orders from buyers who aren't serious, and they give you partial coverage on large orders before you've invested in fulfillment. A 25% deposit on a $100,000 order is $25,000 in your account before you ship a single item.

A rules engine lets you set deposit thresholds you'd apply manually anyway, and then remove yourself from the decision entirely.

## Setting up a dynamic rules engine

TermStack is built on Shopify Functions, using the `cart.payment-methods.transform.run` target. The function evaluates rules at checkout in under 5ms, with no external API calls. The ruleset is stored in a metafield on the payment customization object, compiled to a compact JSON format the WASM function reads directly.

The setup process:

### Step 1: Install and onboard

Install <a href="https://apps.shopify.com/termstack" style={{textDecoration: 'underline'}}>TermStack</a> from the Shopify App Store. The onboarding wizard creates the payment customization function and activates it in your store. Your store can have up to 25 payment customizations active; TermStack uses one for the entire ruleset.

Plans start at free (up to 10 stored rules, but no publishing), CORE at $99/month (15 active rules), GROWTH at $149/month (40 active rules), and SCALE at $299/month (75 active rules). All paid plans include a 14-day trial.

### Step 2: Create your first rule

Go to the **Rules** tab. Click **New rule**. Give the rule a name you'll recognize when looking at an audit log.

Add conditions using the Condition Builder. Each condition has a type (order total, customer tag, company, etc.), an operator (GTE, ANY_OF, BETWEEN, etc.), and a value.

All conditions in a rule must match for the rule to fire (AND semantics). If you need OR logic, create separate rules at consecutive priority levels.

### Step 3: Set the outcome

In the Outcome Builder, choose a payment terms type:

- **NO_PAYMENT_TERMS**: No specific terms (buyer pays normally)
- **NET_DAYS**: Net X days. Enter the number — 7, 15, 30, 45, 60, 90, or a custom value.
- **DUE_ON_FULFILLMENT**: Payment due when the order is fulfilled
- **DUE_ON_FULFILLMENT_CREATED**: Payment due when fulfillment is created
- **DUE_ON_INVOICE_SENT**: Payment due when invoice is sent

Then optionally add a deposit: percentage or fixed amount.

### Step 4: Set rule priority

Drag rules into priority order. Rules evaluate top-down, first match wins. General rules should sit below specific ones. Your "first-time buyer" rule should sit above your "order total above $5,000" rule if you want first-time buyers to always require full payment regardless of order size.

### Step 5: Test in the simulator

Before publishing, use the Simulator to test rules against checkout contexts. Select a company and location, enter an order total, add tags, and see which rule fires and what terms get applied. You can simulate against either draft or published versions. GROWTH and SCALE plans also unlock simulation history so you can replay past checkout contexts.

### Step 6: Publish

Click **Publish**. The ruleset compiles to the WASM-ready format and distributes to the payment customization metafield. If the compiled rules exceed 4KB, the system chunks them across multiple metafields and the function reassembles them at checkout.

Published rulesets create immutable version snapshots. You can roll back to previous versions in one click — CORE plans retain the last version, GROWTH retains 20, SCALE retains 90.

## When native Shopify isn't enough

<div style={{backgroundColor: '#f5f3ff', border: '1px solid #c4b5fd', borderLeft: '4px solid #7C3AED', borderRadius: '8px', padding: '1rem 1.25rem', margin: '1.5rem 0'}}>
  <strong style={{color: '#5b21b6'}}>Running B2B on Shopify Plus and finding that one payment terms setting per company location isn't cutting it?</strong><br/>
  <span style={{color: '#374151', fontSize: '0.95rem'}}><a href="https://apps.shopify.com/termstack" style={{color: '#7C3AED', fontWeight: '600', textDecoration: 'underline'}}>TermStack</a> is a rules engine built on Shopify Functions that applies the right payment terms and deposit at checkout automatically, based on conditions you define. Try it free for 14 days.</span>
</div>

The PAYMENT_TERMS condition type is worth a closer look if your policy depends on what terms a buyer already has at the location level. You can define a rule that fires only when a buyer's location has Net 45 assigned in Shopify, and then apply different deposit logic on top. TermStack keeps each location's payment terms in sync via a metafield it writes directly on the CompanyLocation object. The Shopify Function reads this at checkout without any external API calls. Shopify Functions can't make external calls at runtime; all data has to be pre-positioned in the cart input or metafields.

If you use the PAYMENT_TERMS condition and then add or update company locations later, TermStack's webhook listener (`company_location/create` and `company_location/update`) keeps the metafield in sync automatically.

## Common mistakes with B2B payment terms

**Setting and forgetting.** Payment terms are a policy. Policies need review. A buyer who earned Net 60 terms two years ago based on consistent high-volume orders might have become a slow-paying account. Without a rules review cadence, you won't catch this until finance flags a problem.

**No default behavior set.** If none of your rules match, what happens? In TermStack, the default is configurable: either NO_CHANGE (keep whatever Shopify's location-level terms are) or DEFAULT_OUTCOME (apply a specific fallback you define). If you don't set a sensible default, edge cases fall through to whatever Shopify does natively.

**Publishing without testing.** The simulator exists for a reason. A misconfigured condition operator (using GT instead of GTE on an order total threshold) means some orders fall into the wrong rule. Test every rule you publish.

**Too many rules without priority clarity.** When you have 30+ rules, priority order becomes hard to reason about. Keep a naming convention that reflects priority (e.g., "P1 - First order", "P2 - High risk", "P3 - VIP tier") and review priority order whenever you add a rule.

## Frequently Asked Questions

<BlogFaq>
  <BlogFaqItem q="What's the difference between static and dynamic payment terms on Shopify Plus?">
    Static terms are set per company location and apply equally to every order from that buyer. Dynamic terms use a rules engine to evaluate conditions at checkout and apply different terms based on order value, buyer profile, product mix, or other factors. Shopify Plus supports static terms natively; dynamic terms require Shopify Functions (via the Payment Customization API) or an app like TermStack.
  </BlogFaqItem>

  <BlogFaqItem q="Can I require a deposit on some B2B orders but not others on Shopify Plus?">
    Not natively. Shopify Plus lets you set one deposit percentage per company location, and it applies to every order from that location. For conditional deposits (e.g., 25% deposit on orders above $50,000, no deposit below), you need a rules engine. TermStack supports both percentage deposits (DEPOSIT_PERCENT, 0–99%) and fixed-amount deposits (DEPOSIT_FIXED) as rule outcomes.
  </BlogFaqItem>

  <BlogFaqItem q="How does a Shopify Function apply payment terms at checkout?">
    Shopify Functions run server-side inside Shopify's infrastructure at checkout. The payment customization function reads a compiled ruleset from a metafield on the PaymentCustomization object, evaluates rules against the current cart (buyer identity, order total, tags, etc.), and returns the matched payment terms. The whole evaluation runs in under 5ms with no external API calls. If anything goes wrong, the function returns NO_CHANGE so checkout is never blocked.
  </BlogFaqItem>

  <BlogFaqItem q="What payment terms types does Shopify support for B2B?">
    Shopify B2B supports Net 7, Net 15, Net 30, Net 45, Net 60, Net 90, Due on fulfillment, Due on fulfillment created, Due on invoice sent, and no payment terms (pay at checkout). The Payment Customization API lets you apply any of these programmatically. TermStack's outcome types map to these directly: NO_PAYMENT_TERMS, NET_DAYS (any number), DUE_ON_FULFILLMENT, DUE_ON_FULFILLMENT_CREATED, and DUE_ON_INVOICE_SENT.
  </BlogFaqItem>

  <BlogFaqItem q="How many rules can I have active on Shopify Plus with TermStack?">
    It depends on your plan. CORE ($99/mo) allows 15 active published rules. GROWTH ($149/mo) allows 40. SCALE ($299/mo) allows 75. You can store more rules than you publish: CORE stores up to 90, GROWTH and SCALE up to 100 each. The free plan lets you store up to 10 rules but cannot publish any.
  </BlogFaqItem>

  <BlogFaqItem q="What happens if no payment term rule matches at checkout?">
    The fallback behavior is configurable. The default is NO_CHANGE, meaning the checkout proceeds with whatever payment terms are set at the company location level in Shopify. You can alternatively set a DEFAULT_OUTCOME so a specific term applies whenever no rule matches. TermStack also has a fail-safe mode: if the function encounters an error reading or evaluating the ruleset, it returns NO_CHANGE and never blocks checkout.
  </BlogFaqItem>

  <BlogFaqItem q="Can I apply different payment terms to different locations within the same B2B company?">
    Yes. Rules can target specific company locations using the COMPANY_LOCATION condition type. You can also combine this with other conditions: for example, a rule that fires only when the order is from a specific location AND exceeds a certain order total. Shopify assigns payment terms at the location level natively, so you already have per-location control; rules let you layer dynamic logic on top.
  </BlogFaqItem>

  <BlogFaqItem q="Will dynamic payment term rules slow down my checkout?">
    No. TermStack's Shopify Function evaluates rules at checkout in under 5ms, server-side inside Shopify's own infrastructure. There's no external API call at runtime — the ruleset is pre-positioned in a metafield that the function reads directly. Your B2B buyers won't see any difference in checkout speed.
  </BlogFaqItem>
</BlogFaq>

## Summary

Shopify Plus gives you the foundation for B2B payment terms, but the native setup is one term per company location. That works until you need terms to reflect order size, buyer risk, product mix, or any other variable that changes order to order.

Dynamic payment terms replace the per-location assignment with a rules engine that evaluates conditions at checkout and applies the right terms automatically. Deposits become a conditional outcome you attach to specific rules, not a blanket setting on a location. The audit trail that native Shopify is missing becomes part of every rule creation, edit, and publish. If you're scaling B2B and finding that manual exceptions are eating into your finance team's time, <a href="https://apps.shopify.com/termstack" style={{textDecoration: 'underline'}}>TermStack</a> is the straightforward fix.

<div style={{textAlign: 'center', marginTop: '2rem'}}>
  <a href="https://apps.shopify.com/termstack" style={{display: 'inline-block', padding: '0.75rem 2rem', backgroundColor: '#0f172a', color: 'white', borderRadius: '9999px', fontWeight: 700, fontSize: '0.875rem', textDecoration: 'none'}}>Try TermStack free for 14 days →</a>
</div>
