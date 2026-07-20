# Shopify Scripts Stopped Running: How to Restore B2B Payment Terms Logic with Functions

If you woke up this week and found your B2B payment terms not applying at checkout, Scripts is probably why. Shopify Scripts were officially retired on June 30, 2026. As of July 1, they don't run.

If your store had any active Scripts in the Script Editor, they stopped executing. If you used Scripts to influence payment behavior at checkout, that logic is gone.

This post covers what happened, what you can actually restore, and what path gets your B2B payment terms working again.

## What stopped and what didn't

First, the distinction that matters: Shopify Scripts could hide, rename, or reorder payment methods at checkout. They could not set B2B payment terms like Net 30 or require a deposit.

So if your Scripts were handling payment method display (showing only "Pay later" for certain buyers, hiding certain options), that stopped on July 1.

If your B2B payment terms (Net 30, Net 60, deposits) were set natively in Shopify at the company location level, those are still working. Native terms are stored on the company location record and don't depend on Scripts at all.

What actually stopped:
- Any Scripts in the Script Editor Payments tab
- Any checkout customization logic in those Scripts
- Any payment method filtering, ordering, or renaming that Scripts handled

What kept working:
- Native B2B payment terms assigned to company locations in Shopify admin
- Any existing Shopify Function-based payment customization apps
- Shopify's built-in payment method display

## Why Scripts couldn't handle real B2B terms

This is worth understanding before rebuilding, because some merchants patched Scripts together to approximate payment policy.

Scripts ran in Ruby in Shopify's checkout pipeline. They had access to the cart and some buyer properties. But they had a hard limit: they couldn't write to B2B payment terms fields. The only things they could do was control which payment methods appeared and in what order.

To actually set Net 30, require a deposit, or apply Due on Fulfillment at checkout, you needed the Payment Customization Function API. That's a different system entirely, and it has always been Function-based.

If you were using Scripts to hide "Pay now" for certain buyers and then sending them invoices manually, that's the workflow that just broke. The manual invoicing still works, but the Scripts-based filtering doesn't.

## The Function replacement for payment method logic

For merchants whose Scripts were hiding or reordering payment methods, the direct replacement is a Payment Customization Function. The API target is `cart.payment-methods.transform.run`. It runs at checkout as a WebAssembly module, receives the cart and buyer context, and returns payment method modifications.

This is what TermStack uses for B2B payment terms. The Function has access to B2B context that Scripts never had: company, company location, buyer role, cart total, order history, and buyer tags.

Building a custom Function requires Rust or JavaScript compiled to WASM, Shopify CLI for testing, and a Shopify app to host the Function on your store. That's a development project, not an afternoon fix.

## The faster path: a no-code rules engine

If you need to restore dynamic B2B payment behavior quickly and don't have a development team ready, a Payment Customization Function app is the right path.

<a href="https://apps.shopify.com/termstack" style={{textDecoration: 'underline'}}>TermStack</a> ships a Payment Customization Function to your store and gives you a no-code rules engine to configure the logic. You define conditions and outcomes in the Shopify admin. The Function evaluates them at checkout.

What you can configure:
- Apply Net 30, Net 60, or any other payment terms based on order total, buyer tags, company identity, or order history
- Require a deposit (fixed amount or percentage) for new buyers or large orders
- Apply different terms for specific company locations or collections in the cart
- Set a fallback term when no rule matches

<div style={{backgroundColor: '#f5f3ff', border: '1px solid #c4b5fd', borderLeft: '4px solid #7C3AED', borderRadius: '8px', padding: '1rem 1.25rem', margin: '1.5rem 0'}}>
  <strong style={{color: '#5b21b6'}}>Restore your B2B payment logic without rebuilding from scratch.</strong><br/>
  <span style={{color: '#374151', fontSize: '0.95rem'}}><a href="https://apps.shopify.com/termstack" style={{color: '#7C3AED', fontWeight: '600', textDecoration: 'underline'}}>TermStack</a> installs in minutes, ships the Payment Customization Function to your store, and gives you a rules UI to define your logic without writing code. Start your 14-day trial and get your terms working again today.</span>
</div>

## What the migration looks like step by step

### Step 1: Audit what Scripts were doing

Go to **Apps > Script Editor** in your Shopify admin. Check the Payments tab. If you see active Scripts, note what each one was doing. Most will be hiding or reordering payment methods for specific buyers or cart conditions.

### Step 2: Decide what to rebuild

Not everything Scripts did is worth recreating. Some of that logic was working around the lack of native B2B payment terms. Now that Functions give you direct control over payment terms, you may be able to replace a complex Scripts workaround with a cleaner terms-based rule.

For example, if your Script hid "Pay later" for new buyers (because you didn't trust them with credit), you can now just configure Net 7 or Due on Fulfillment for buyers with fewer than 2 previous orders. Same outcome, cleaner setup.

### Step 3: Install a Payment Customization Function app or build your own

If you're rebuilding with a no-code app, install <a href="https://apps.shopify.com/termstack" style={{textDecoration: 'underline'}}>TermStack</a> and go through the onboarding flow. It creates the Payment Customization in your store and activates the Function.

If you're building custom, use Shopify CLI (`shopify app function run`) to build and test locally before deploying. The [migration guide from Scripts to Functions](/blog/migrating-b2b-payment-terms-shopify-scripts-to-functions) covers the technical path in detail.

### Step 4: Rebuild your rules

Map each Script behavior to a Function-based rule. For payment terms specifically:
- Scripts that hid "Pay later" → a rule that applies Due on Fulfillment for that buyer segment
- Scripts that filtered to invoice-only → a rule that applies Net 30 or Net 60 for established accounts
- Scripts that required upfront payment → a rule that applies no terms (requiring checkout payment) for new buyers

### Step 5: Test before going live

Use the TermStack simulator to test each rule against different buyer profiles before publishing. The simulator lets you input a company, location, order total, and buyer tags and shows you which rule would match. For a DIY Function, use `shopify app function run` with a test input JSON.

## Frequently Asked Questions

**Why did Shopify retire Scripts?**
Shopify Scripts were Ruby-based, ran in a legacy pipeline, and had limited access to B2B context. Shopify Functions are more capable (B2B context, better performance, more configuration options), run as WebAssembly for speed, and can be tested locally before deploying.

**Do I need Shopify Plus to use Payment Customization Functions?**
Yes. The Payment Customization Function API is a Shopify Plus feature. If you're on Plus, you can install a Payment Customization Function app or build your own Function.

**What happens if I don't rebuild?**
Your Scripts no longer run. Payment method behavior will revert to Shopify's defaults. If you relied on Scripts to filter payment methods, buyers may now see options you didn't intend to offer.

**Can I reactivate or restore a Script?**
No. Scripts are permanently retired. The Script Editor may still show them, but they no longer execute.

**Is there a way to migrate my Script logic directly to a Function?**
Not automatically. You need to understand what the Script was doing and rewrite the equivalent logic as a Function. A no-code app like TermStack handles the common cases (payment terms, deposits) without requiring you to write Function code.

**What's the difference between a Payment Customization Function and a Discount Function?**
Payment Customization Functions (`cart.payment-methods.transform.run`) control payment method visibility and B2B payment terms. Discount Functions control pricing and discount logic. They are separate Function targets with separate APIs.

**Will TermStack replace everything Scripts could do?**
TermStack handles B2B payment terms and deposits at checkout via a Payment Customization Function. If your Scripts were also doing non-payment things (order routing, line item adjustments), those need separate Function apps.

**How long does it take to set up TermStack?**
Installation takes a few minutes. The onboarding flow creates the Payment Customization in your store and activates the Function. From there, defining your rules in the UI takes as long as your policy is complex. Most merchants have their first ruleset published within an hour.

## Summary

Shopify Scripts stopped running on July 1, 2026. If your B2B checkout behavior has changed, check the Script Editor and identify what those Scripts were doing. Native payment terms in Shopify admin weren't affected.

To restore dynamic payment logic, you need a Payment Customization Function. The fastest path without a dev team is <a href="https://apps.shopify.com/termstack" style={{textDecoration: 'underline'}}>TermStack</a>, which ships the Function and gives you a rules engine to configure your policy.

For the technical migration path, see [migrating B2B payment terms from Shopify Scripts to Functions](/blog/migrating-b2b-payment-terms-shopify-scripts-to-functions).

<div style={{textAlign: 'center', marginTop: '2rem'}}>
  <a href="https://apps.shopify.com/termstack" style={{display: 'inline-block', padding: '0.75rem 2rem', backgroundColor: '#0f172a', color: 'white', borderRadius: '9999px', fontWeight: 700, fontSize: '0.875rem', textDecoration: 'none'}}>Try TermStack free for 14 days →</a>
</div>
