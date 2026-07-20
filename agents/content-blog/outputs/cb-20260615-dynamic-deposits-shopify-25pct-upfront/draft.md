# Dynamic deposits on Shopify: collect 25% upfront on large B2B orders

Meta description: Learn how to require a 25% deposit on large B2B orders in Shopify Plus using a rules engine, without charging deposits on every order or every buyer.

Most B2B merchants I talk to have one of two deposit setups: they collect deposits on everything, or they collect deposits on nothing. Neither is right.

Deposits on everything creates friction for your best buyers who've already earned trust. No deposits on anything means you're fully exposed on $150,000 orders from buyers you've never worked with. The sensible policy is somewhere in between: require a deposit when the order size or buyer profile warrants it.

Shopify Plus doesn't support that natively. But you can build it with a rules engine. Here's how.

## Why Shopify's native deposit setup falls short

Shopify Plus lets you set a deposit percentage on a company location. Go to **Customers → Companies → [Company] → [Location] → Edit payment terms**, and you'll see a deposit percentage field alongside the terms type.

That deposit applies to every order from that location. No exceptions, no thresholds, no conditions. If you set 25% on a buyer, every $500 reorder from them requires a $125 deposit, which is pointless. And if you don't set one, every $200,000 first-time purchase from them goes through with no money down.

The native setup is fine if you have a few accounts with negotiated, unchanging terms. Once you're managing a real B2B catalog with buyers at different risk levels and order sizes, you need something more granular.

## What a conditional deposit rule looks like

A rules engine lets you define the exact conditions that trigger a deposit requirement.

The most common setup I see: no deposit on small orders, a 25% deposit on large ones.

In practice:
- **Order total below $10,000.** Net 30, no deposit.
- **Order total $10,000–$50,000.** Net 30 with 10% deposit.
- **Order total above $50,000.** Net 45 with 25% deposit.

You could also layer in buyer-level signals:
- **First-time buyer, any order size.** Payment required at checkout.
- **Customer tagged `high-risk`.** Due on fulfillment, no extended terms.
- **Customer tagged `vip` or `wholesale-gold`.** Net 60, no deposit regardless of order size.

The key is that the deposit becomes an outcome attached to specific conditions, not a blunt setting on a company location.

## How the rules evaluate at checkout

Rules evaluate top-down, first match wins. All conditions in a rule must match (AND semantics). If nothing matches, you configure a fallback: either keep whatever Shopify has set at the company location level, or apply a specific default term.

So if you want VIP buyers to never hit a deposit rule even on large orders, put the VIP rule above the order-total thresholds. The first match wins and the engine stops there.

This is intentional design. You can construct fairly complex policy logic without building complex rules: you just think about the order in which rules should be checked.

## Supported deposit types

Two formats:

- **Percentage deposit.** A percentage of the order total. A 25% deposit on a $100,000 order means the buyer pays $25,000 at checkout and $75,000 on the terms due date.
- **Fixed-amount deposit.** A fixed dollar amount regardless of order size. Less common, but useful for scenarios like "always collect $5,000 on custom manufacturing orders."

The deposit and the payment terms are separate outcomes. A rule can apply Net 45 with a 25% deposit. A different rule can apply Net 30 with no deposit. You can mix and match however your credit policy calls for.

## Setting this up with TermStack

<a href="https://apps.shopify.com/termstack" style={{textDecoration: 'underline'}}>TermStack</a> is a rules engine built on Shopify Functions. It evaluates your rules at checkout in under 5ms, server-side inside Shopify's own infrastructure, with no external API calls. Here's the setup flow.

### Step 1: Install and activate

Install TermStack from the Shopify App Store. The onboarding wizard handles activating the payment customization function in your store. You don't need a developer for this.

Paid plans start at $99/month and include a 14-day trial. The free plan lets you store up to 10 rules but can't publish any.

### Step 2: Create the high-order-value rule

In the **Rules** tab, click **New rule**. Name it something descriptive: "Large order deposit — $50K+".

Add one condition: **Order total** is **greater than or equal to** `$50,000`.

In the Outcome Builder:
- Payment terms: **Net 45** (or whatever your standard large-order terms are)
- Deposit: **25%**

Save.

### Step 3: Create your mid-tier rule (optional)

If you want a tiered deposit structure, add another rule: "Mid-size order deposit — $10K–$50K".

Conditions: **Order total** is **between** `$10,000` and `$50,000`.

Outcome: Net 30, 10% deposit.

### Step 4: Create your baseline rule

A catch-all for smaller orders: "Standard — under $10K". Order total less than $10,000. Net 30, no deposit.

### Step 5: Set priority order

The large-order rule should sit above the mid-tier rule, which sits above the baseline. Drag them into that order. Rules evaluate top-down, so the first match determines the outcome.

If you have buyer-level rules (VIP, high-risk, first order), put those above the order-total rules so they take precedence.

### Step 6: Test in the simulator

Before publishing, open the **Simulator**. Select a company and location, set an order total above $50,000, and confirm the right rule fires and the 25% deposit shows up in the output. Do the same for a $5,000 order to confirm no deposit applies.

### Step 7: Publish

Click **Publish**. The ruleset compiles and goes live immediately. Every publish creates a versioned snapshot, so if something looks wrong you can roll back to the previous version in one click.

## When native Shopify isn't enough

<div style={{backgroundColor: '#f5f3ff', border: '1px solid #c4b5fd', borderLeft: '4px solid #7C3AED', borderRadius: '8px', padding: '1rem 1.25rem', margin: '1.5rem 0'}}>
  <strong style={{color: '#5b21b6'}}>Need deposits on large B2B orders without charging deposits on everything?</strong><br/>
  <span style={{color: '#374151', fontSize: '0.95rem'}}><a href="https://apps.shopify.com/termstack" style={{color: '#7C3AED', fontWeight: '600', textDecoration: 'underline'}}>TermStack</a> lets you set deposit rules by order size, buyer tier, or product type. The right deposit applies at checkout automatically. Try it free for 14 days.</span>
</div>

One thing worth noting: TermStack keeps each company location's payment terms in sync automatically. If a buyer's Shopify-assigned payment terms change, any rule that targets their terms template gets the updated value without any manual work.

## Common mistakes to avoid

**Putting the deposit threshold too low.** A 25% deposit on $2,000 orders annoys buyers without meaningful risk protection. Set thresholds where the order size actually warrants the extra friction.

**Forgetting buyer-level exceptions.** If you have long-term accounts that should never hit a deposit requirement, create a VIP or whitelist rule with a customer tag condition and put it at the top of your priority list. Don't assume the order-total rules will just work for everyone.

**Not testing before publishing.** The simulator shows you exactly which rule fires for a given checkout context. Use it before publishing, especially when you first set up tiered rules with overlapping order total ranges.

**No fallback configured.** If none of your rules match (for example, a B2B buyer you haven't tagged yet places a small order), what happens? Configure your fallback behavior explicitly. Either let Shopify's location-level terms apply, or set a specific default. Don't leave it ambiguous.

## Frequently Asked Questions

<BlogFaq>
  <BlogFaqItem question="Can I require a 25% deposit only on large B2B orders, not on smaller ones?">
    Yes. A rules engine lets you define an order total condition that triggers a deposit only above a certain threshold. Orders below that threshold can have a different deposit (or none at all). Shopify's native setup doesn't support this; it applies one deposit percentage to every order from a company location.
  </BlogFaqItem>

  <BlogFaqItem question="Does Shopify Plus support conditional deposits natively?">
    No. Shopify Plus lets you set a deposit percentage per company location, and that percentage applies to every order from that location regardless of size, product, or buyer history. Conditional deposits require a rules engine built on Shopify Functions.
  </BlogFaqItem>

  <BlogFaqItem question="What's the difference between a percentage deposit and a fixed-amount deposit?">
    A percentage deposit charges a fraction of the order total at checkout (for example, 25% of $100,000 is $25,000 upfront). A fixed-amount deposit charges a set dollar amount regardless of order size (for example, $5,000 on every custom manufacturing order). Both are supported as rule outcomes in TermStack.
  </BlogFaqItem>

  <BlogFaqItem question="Can I combine a deposit requirement with specific payment terms in the same rule?">
    Yes. A rule's outcome has two components: the payment terms type (Net 30, Net 45, Due on fulfillment, and so on) and an optional deposit. You can apply Net 45 with a 25% deposit, Net 30 with no deposit, or any other combination. The deposit and the payment terms are set independently on the same rule.
  </BlogFaqItem>

  <BlogFaqItem question="What happens if a buyer's order falls between two threshold rules?">
    Rules evaluate top-down, first match wins. If your rule conditions are set correctly with BETWEEN or GTE/LTE operators, every order should match exactly one rule. Use the TermStack simulator to test edge cases before publishing to confirm orders land in the right rule.
  </BlogFaqItem>

  <BlogFaqItem question="Can I exempt specific buyers from deposit requirements?">
    Yes. Create a rule with a customer tag condition (for example, `vip` or `no-deposit`) and set it to apply your standard terms with no deposit. Place that rule above your order-total deposit rules in priority order. When the tag matches, the deposit rules below it are never evaluated.
  </BlogFaqItem>

  <BlogFaqItem question="Will adding deposit rules affect my regular DTC checkout?">
    No. TermStack's Shopify Function only evaluates rules when a B2B buyer is at checkout (a buyer linked to a company). If the checkout has no B2B context, the function returns without changes. Your DTC checkout is unaffected.
  </BlogFaqItem>

  <BlogFaqItem question="How quickly do deposit rules take effect after publishing?">
    Immediately. When you publish a ruleset in TermStack, the compiled rules go live for the next checkout. There's no cache delay, no deployment wait. You can also roll back to any previous version in one click if you need to revert a change.
  </BlogFaqItem>
</BlogFaq>

## Summary

Shopify Plus gives you deposit support but not deposit logic. You get one percentage per company location, applied to every order. That's not a policy; it's a blunt setting.

A rules engine built on Shopify Functions lets you define the deposit you'd actually want: 25% on orders above $50,000, nothing below, with buyer-level exceptions for your best accounts. The evaluation happens at checkout in milliseconds, with no manual intervention from your team. If you're scaling B2B and need your deposit policy to actually reflect your credit agreements, <a href="https://apps.shopify.com/termstack" style={{textDecoration: 'underline'}}>TermStack</a> is the direct path there.

<div style={{textAlign: 'center', marginTop: '2rem'}}>
  <a href="https://apps.shopify.com/termstack" style={{display: 'inline-block', padding: '0.75rem 2rem', backgroundColor: '#0f172a', color: 'white', borderRadius: '9999px', fontWeight: 700, fontSize: '0.875rem', textDecoration: 'none'}}>Try TermStack free for 14 days →</a>
</div>
