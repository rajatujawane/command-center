# Shopify Summer 2026: B2B Payment Terms Native vs. App

Shopify's Summer 2026 Edition is a good moment to take stock. Scripts are officially gone as of July 1. Functions are the standard. And a lot of merchants I talk to are still unclear on exactly what Shopify does natively for B2B payment terms, and where you still need an app to fill the gaps.

The answer hasn't changed much at the core, but the context has. Every merchant who relied on Scripts for any checkout logic is rebuilding right now. If that includes your payment terms, you need to know what you're working with.

This post covers the current state: what Shopify handles natively for B2B payment terms on Plus, and where native Shopify still falls short.

## What Shopify does natively in 2026

Shopify Plus gives you B2B payment terms at the **company location** level. You assign a payment terms template directly to each company location in the Shopify admin under **Customers > Companies > [Company] > [Location]**. Those terms surface at checkout automatically for that buyer.

The eight templates available natively are:

| Template | Payment due |
|----------|------------|
| Net 7 | 7 days after the order date |
| Net 15 | 15 days after the order date |
| Net 30 | 30 days after the order date |
| Net 45 | 45 days after the order date |
| Net 60 | 60 days after the order date |
| Net 90 | 90 days after the order date |
| Due on Fulfillment | When the order ships |
| No terms | No terms applied |

This is a static assignment. You pick a template, attach it to a location, and every order from that buyer gets those terms. Shopify doesn't read the cart at checkout and decide. It reads the location record.

Deposits work similarly. You can configure a percentage deposit at the company location level in Shopify admin. Every order from that location requires that deposit at checkout. There's no logic involved: it's flat, static, and location-level.

This is genuinely useful when your terms are straightforward and consistent per account. If you have 20 wholesale accounts and each one has agreed to a fixed arrangement, native Shopify handles it cleanly. One less thing to maintain.

## Where native Shopify still falls short

The moment you want payment terms that respond to something in the cart or the buyer's history, you're past what native Shopify can do.

Specifically, you cannot natively:

- Apply stricter terms or require a larger deposit on orders above a threshold
- Give a first-time buyer different terms than an established account
- Adjust terms based on which products or collections are in the cart
- Enforce credit policy by company or company location at checkout
- Apply terms based on the buyer's existing payment terms template (for instance, tightening Net 60 buyers to Net 30 on large orders)

All of these require reading checkout context at the moment of purchase: cart total, buyer history, company identity, what's in the cart. Shopify's native terms don't do this. They're set on the location and don't change order to order.

The result for merchants who need dynamic terms is manual workarounds: sales team reviews, draft orders, post-purchase invoicing. None of those scale well as order volume grows.

## What changed with Scripts going away

Before July 1, some merchants used Scripts to approximate dynamic payment logic. Scripts could modify which payment methods appeared at checkout based on cart or buyer properties. That was a workaround, not a solution for B2B terms specifically, since Scripts couldn't actually set Net 30 or require a deposit at the checkout level.

With Scripts retired, merchants who built on them need to rebuild. The replacement is Shopify Functions, specifically the Payment Customization Function, which runs at checkout and has access to B2B context that Scripts never had: company, company location, buyer role, and the full cart.

For merchants who want to build custom Functions, the API target is `cart.payment-methods.transform.run`. For merchants who want a no-code rules engine, a Payment Customization Function app is the faster path.

## When you still need an app

A Shopify Function app fills the gap between Shopify's static assignment and a real dynamic terms policy. The conditions you can work with at checkout depend on what the Function can read from the cart input.

Current conditions that a rules engine like <a href="https://apps.shopify.com/termstack" style={{textDecoration: 'underline'}}>TermStack</a> supports at checkout:

- Order total (above, below, or between thresholds)
- Customer tags
- Company and company location identity
- Whether this is the buyer's first order
- Total number of previous orders
- Collections in the cart
- The payment terms already assigned to the company location

You define rules in priority order. The first rule that matches applies its outcome (payment terms type + optional deposit). If nothing matches, the fallback is configurable.

<div style={{backgroundColor: '#f5f3ff', border: '1px solid #c4b5fd', borderLeft: '4px solid #7C3AED', borderRadius: '8px', padding: '1rem 1.25rem', margin: '1.5rem 0'}}>
  <strong style={{color: '#5b21b6'}}>Need dynamic B2B payment terms without writing custom Functions code?</strong><br/>
  <span style={{color: '#374151', fontSize: '0.95rem'}}><a href="https://apps.shopify.com/termstack" style={{color: '#7C3AED', fontWeight: '600', textDecoration: 'underline'}}>TermStack</a> ships a Payment Customization Function to your store and gives you a no-code rules engine in the Shopify admin. You define conditions and outcomes; the Function handles the rest at checkout.</span>
</div>

## The practical decision

Use native Shopify terms when:
- Your terms are static per account and don't change order to order
- You have a manageable number of accounts and can update terms manually when needed
- Every order from a given location gets identical treatment

Add a rules engine app when:
- You need to adjust terms based on order size, buyer history, or product mix
- You have a formal credit policy you want enforced automatically at checkout
- You previously relied on Scripts for any payment logic and need to rebuild that logic properly

The distinction is straightforward. Native Shopify gives you the infrastructure. A rules engine gives you the policy layer.

## Frequently Asked Questions

**What B2B payment terms does Shopify Plus support natively in 2026?**
Shopify Plus lets you assign one of eight payment terms templates to each company location: Net 7, Net 15, Net 30, Net 45, Net 60, Net 90, Due on Fulfillment, or no terms. These are static, set at the company location level, and apply to every order from that buyer.

**Did Shopify add dynamic payment terms in the Summer 2026 Edition?**
Native Shopify B2B payment terms remain static and location-level. Shopify has not added native conditional logic that evaluates cart contents or buyer history at checkout. Dynamic terms still require a Payment Customization Function, either custom-built or via an app.

**What happened to Shopify Scripts for payment logic?**
Scripts were retired on June 30, 2026 and stopped running on July 1. Merchants who used Scripts to modify payment methods at checkout need to rebuild with Shopify Functions. Scripts could not set B2B payment terms (Net 30, deposits, etc.) directly, but many merchants used them to approximate payment policy.

**Do I need Shopify Plus to use B2B payment terms?**
Yes. B2B company locations, payment terms templates, and the Payment Customization Function API are all Shopify Plus features. They are not available on standard Shopify plans.

**Can a Shopify Function make external API calls at checkout to check credit status?**
No. Shopify Functions run in a sandboxed environment with no network access at checkout. Any data that should influence terms, such as the buyer's credit limit or account balance, must be pre-synced to Shopify as a metafield before the order is placed.

**What conditions can I use in a rules engine app for B2B payment terms?**
With <a href="https://apps.shopify.com/termstack" style={{textDecoration: 'underline'}}>TermStack</a> you can set conditions based on: order total, customer tags, company or company location identity, whether this is the buyer's first order, total number of previous orders, cart collections, and the payment terms already assigned to the company location. You can combine conditions with AND logic within a rule.

**What happens at checkout if no rule matches?**
The fallback is configurable. By default, TermStack keeps whatever terms are already assigned to the company location in Shopify. You can also configure a specific default term to apply when nothing matches. If the Function encounters an error, it falls back to no change and never blocks checkout.

**Does running a Payment Customization Function slow down checkout?**
No. Functions run server-side inside Shopify's infrastructure in under 5ms with no external API calls. The ruleset is pre-compiled and read from a metafield at checkout. Buyers see no difference in checkout speed.

## Summary

Shopify's native B2B payment terms give you static, per-location templates: Net 7 through Net 90, Due on Fulfillment, or nothing. That handles a lot of straightforward wholesale relationships.

Dynamic terms, where the terms depend on what's in the cart, who the buyer is, or how much they've ordered, require a Shopify Function. As of Summer 2026, the cleanest path to that is a no-code rules engine like <a href="https://apps.shopify.com/termstack" style={{textDecoration: 'underline'}}>TermStack</a> that ships the Function and gives you a rules UI in the Shopify admin.

If you were on Scripts before July 1 and haven't migrated yet, the migration guide on [moving from Shopify Scripts to Functions for B2B payment terms](/blog/migrating-b2b-payment-terms-shopify-scripts-to-functions) covers the step-by-step path.

<div style={{textAlign: 'center', marginTop: '2rem'}}>
  <a href="https://apps.shopify.com/termstack" style={{display: 'inline-block', padding: '0.75rem 2rem', backgroundColor: '#0f172a', color: 'white', borderRadius: '9999px', fontWeight: 700, fontSize: '0.875rem', textDecoration: 'none'}}>Try TermStack free for 14 days →</a>
</div>
