# Require Prepayment or Deposits from First-Time B2B Buyers on Shopify

Shopify can't natively distinguish a company's first order from its fiftieth. Payment terms and deposits are static per location, applied equally to every order regardless of whether it's a trusted account of five years or a brand new wholesale customer you've never worked with.

That asymmetry is a real problem. When you extend Net 30 to an unproven buyer, you're offering unsecured credit to someone you know nothing about. If they don't pay, you've shipped the goods and you're chasing an invoice. Most merchants accept this risk silently and call it "the cost of doing business."

This post covers how to fix that. Specifically: how to require full prepayment or a deposit on first-time B2B orders at checkout, and then automatically relax to standard terms from order two onward, without any manual intervention.

## Why first-order credit risk is different

There's a sensible industry norm that almost no Shopify merchant actually enforces: first order prepaid (or with a significant deposit), terms extended only after that.

The logic is straightforward. You don't know the buyer yet. No payment history, no relationship, no data. Extending Net 30 immediately is a bet that they'll pay. A lot of the time they do. But when they don't, you have no leverage, and your payment processor can't help you.

Requiring payment upfront or a 50% deposit on order one costs you almost nothing if the buyer is legitimate. It protects you significantly if they're not. Most serious B2B buyers expect this, especially when dealing with a new supplier. It's standard practice. The friction of a deposit doesn't kill deals; it filters out buyers who were never going to pay anyway.

The problem isn't that merchants don't believe in the policy. It's that enforcing it consistently by hand is a nightmare. Someone has to track which customers are new, remember to flag those orders, and manually adjust terms before checkout. That's the kind of process that works until it doesn't, and then it fails exactly when you need it most.

## What Shopify Plus gives you natively

Shopify Plus lets you set payment terms per company location. You go to **Customers → Companies → [Company] → Location** and assign a term: Net 30, Net 60, Due on Fulfillment, or several others. You can also add a deposit percentage, so the buyer pays a percentage upfront at checkout and the rest is due later according to the payment terms.

This works well once you've decided what terms a buyer should have. The gap is that you have to decide upfront and set it statically. There's no logic to say "if this is their first order, require 100% payment; if it's their second or later, apply Net 30." Every order from a company location gets the same terms, every time.

So you're back to manual intervention. Either you set every new buyer to pay now and remember to update them after order one, or you extend terms immediately and accept the risk. Neither option is clean.

For more on what Shopify does natively for B2B payments, the [complete guide to B2B payment terms on Shopify Plus](/blog/b2b-payment-terms-complete-guide) covers the full picture.

## The rule: first order gets a deposit, second order gets terms

The cleanest solution is two rules running in priority order.

**Rule 1 (higher priority): First order.**
Condition: this is the buyer's first order.
Outcome: payment due at checkout (or 50% deposit if you prefer partial upfront).

**Rule 2 (lower priority): Returning buyer.**
Condition: any other condition that identifies your standard wholesale accounts (tag, company, order count greater than or equal to 1).
Outcome: Net 30 (or whatever your standard terms are).

When a buyer reaches checkout, the rules evaluate top to bottom. If it's their first order, rule one fires and they pay upfront. If it's their second or later, rule one doesn't match, rule two fires, and they get terms.

That's it. No manual tracking, no per-account flags, no ops team remembering to update records. From order two, terms apply automatically.

The first-order condition matches against whether the buying company has any prior completed orders on your store. It's a binary: either they have one, or they don't. The evaluation happens at checkout, in real time, using the buyer's company identity.

## What "first order" actually means

There are a few edge cases worth thinking through before you set this up.

**Per company vs. per location.** Shopify B2B assigns payment terms at the company location level, not the company level. A large company might have multiple locations (subsidiaries, warehouses, regional offices). The first-order condition checks based on the company context at checkout, not the individual location. So if a company has ordered before from location A, and now location B is placing their first order, this depends on how your data is structured. Test your specific setup using the Simulator before publishing.

**Reorders after a long gap.** A customer who last ordered three years ago technically has prior orders. They're not a first-time buyer by the condition's definition even though from a credit risk perspective they might feel like one. If you want to handle long-gap reorders differently, you'd add an order count rule: "order count equals 1" or combine conditions.

**Order count as an alternative.** The first-order condition is the cleanest way to handle this. But if you want more granularity, you can use total order count instead. A rule like "order count less than 3, require deposit" lets you hold new accounts to a deposit requirement through their first two or three orders, not just the first.

## Setting it up

In TermStack, you'd build this as follows:

For rule 1, create a new rule, add a condition for "First order equals true," and set the outcome to "No payment terms" (pay at checkout) or a deposit percentage if you want them to pay partially upfront. Set the priority to 1 (highest).

For rule 2, create a second rule that matches your returning accounts. If you're tagging accounts (which you should be), add a condition like "Customer tag includes wholesale." Set the outcome to Net 30 or your standard terms. Priority 2.

Publish the ruleset. From that point, every B2B checkout evaluates both rules in order. First-time buyers hit rule 1 and pay at checkout. Everyone else flows through to rule 2.

Before publishing, run a few Simulator scenarios. Pick a company with no prior orders, set an order total, and confirm rule 1 fires. Then pick a company with prior orders and confirm it falls through to rule 2. A misconfigured priority order is the most common setup mistake.

## When native Shopify isn't enough

This is exactly the scenario that Shopify's native tools weren't built for. The native payment terms system is per-location, per-setting, static. It's designed for "this buyer gets Net 30," not "this buyer gets Net 30 after their first order."

<div style={{backgroundColor: '#f5f3ff', border: '1px solid #c4b5fd', borderLeft: '4px solid #7C3AED', borderRadius: '8px', padding: '1rem 1.25rem', margin: '1.5rem 0'}}>
  <strong style={{color: '#5b21b6'}}>First-order deposit enforcement without manual ops work.</strong><br/>
  <span style={{color: '#374151', fontSize: '0.95rem'}}><a href="https://apps.shopify.com/termstack" style={{color: '#7C3AED', fontWeight: '600', textDecoration: 'underline'}}>TermStack</a> evaluates your payment terms rules at checkout automatically, so first-time buyers get a deposit requirement and returning accounts get terms — no per-account settings to manage. <a href="https://apps.shopify.com/termstack" style={{color: '#7C3AED', fontWeight: '600', textDecoration: 'underline'}}>Try TermStack free for 14 days →</a></span>
</div>

This is one of the clearest use cases for Payment Customization Functions: logic that depends on buyer-specific state (order history) evaluated at runtime. The function runs at checkout, checks the condition, and applies the right outcome. No external API call, no manual flag, no ops step between "new buyer" and "terms extended."

## Frequently Asked Questions

<BlogFaq>

<BlogFaqItem question="Can Shopify Plus require a deposit only for first-time B2B buyers?">
Not natively. Shopify Plus lets you set a deposit percentage per company location, but it applies to every order from that location equally. To require a deposit only on a buyer's first order and then remove it automatically from the second order onward, you need a rules engine that evaluates order history at checkout. That's what TermStack's first-order condition does.
</BlogFaqItem>

<BlogFaqItem question="What happens to a buyer's terms after their first order?">
With a two-rule setup, the first-order rule only fires when the buyer has no prior orders. Once they complete their first order, that condition no longer matches at checkout, and your second rule (returning accounts, standard terms) takes over automatically. No manual update needed.
</BlogFaqItem>

<BlogFaqItem question="Does the first-order condition check per company or per location?">
The condition checks against the purchasing company at checkout. If the company has prior orders on your store, the condition doesn't match. This is company-level, not per-location. If a company has multiple locations and one has ordered before, test your specific setup in the Simulator to confirm the behavior.
</BlogFaqItem>

<BlogFaqItem question="Can I require full payment instead of a deposit for first-time buyers?">
Yes. You can set the outcome to require payment at checkout (no payment terms applied), which means the buyer pays the full order total immediately. Or you can set a deposit percentage (e.g. 50%) so they pay half upfront and the rest according to your terms. The right choice depends on your risk tolerance and average order size.
</BlogFaqItem>

<BlogFaqItem question="What if a first-time buyer abandons checkout because of the prepayment requirement?">
Some will. But a buyer who abandons over a prepayment requirement on order one is also a buyer who might have abandoned an invoice 60 days later. The deposit filters for intent. If your average B2B order is over $10,000, a deposit requirement on order one is standard practice. Most legitimate wholesale buyers expect it from a new supplier.
</BlogFaqItem>

<BlogFaqItem question="How do I handle long-gap reorders from accounts that haven't bought in years?">
The first-order condition checks whether any prior order exists, not whether it was recent. A buyer with a two-year gap still has prior order history, so they'd get your standard terms. If you want to treat long-gap accounts differently, use a total order count condition combined with a time-based tag (e.g., an "inactive" tag applied by your CRM) to target them with a separate rule.
</BlogFaqItem>

<BlogFaqItem question="Can I combine the first-order condition with other conditions?">
Yes. You can add AND conditions to the same rule. For example: first order AND order total greater than $5,000. That way, small first orders under $5,000 flow through to standard terms, but larger first orders require a deposit. This is useful for high-volume wholesale accounts where small restock orders aren't the credit risk.
</BlogFaqItem>

<BlogFaqItem question="How do I test the setup before going live?">
Use the Simulator in TermStack. Pick a company with no prior orders and set a realistic order total to confirm the first-order rule fires. Then pick a company with prior orders and confirm they get standard terms. Check the priority order: rule 1 (first order) must evaluate before rule 2 (returning accounts). Publish only after both scenarios pass.
</BlogFaqItem>

</BlogFaq>

## Summary

The standard wholesale credit policy is: first order prepaid or with a deposit, terms after. The problem is enforcing it consistently at scale without ops overhead.

A Payment Customization Function solves this cleanly. Two rules, ordered by priority. First-order buyers hit the deposit requirement at checkout. Returning accounts flow through to standard terms automatically. No per-account flags, no manual updates, no missed cases when things get busy.

<a href="https://apps.shopify.com/termstack" style={{textDecoration: 'underline'}}>TermStack</a> handles the rule evaluation, Simulator testing, version history, and publish/rollback workflow. If you're extending B2B credit on Shopify Plus and doing it manually right now, this is the highest-leverage place to start.

<div style={{textAlign: 'center', marginTop: '2rem'}}>
  <a href="https://apps.shopify.com/termstack" style={{display: 'inline-block', padding: '0.75rem 2rem', backgroundColor: '#0f172a', color: 'white', borderRadius: '9999px', fontWeight: 700, fontSize: '0.875rem', textDecoration: 'none'}}>Try TermStack free for 14 days →</a>
</div>
