# Payment Customization Function vs. App: Build or Buy for B2B Terms

_Meta description: Should you build your own Shopify Payment Customization Function for B2B terms, or use an app? Here's a straight answer based on what the Function API can and can't do._

If you sell B2B on Shopify Plus and you've outgrown Shopify's static payment terms, you've probably hit the same fork: build something custom, or install an app. Shopify Functions make building feel more accessible than it used to be when everything ran through Scripts. But accessible isn't the same as simple.

This post walks through what it actually takes to build a Payment Customization Function for B2B payment terms, where it gets complicated fast, and when an app is the more sensible choice.

## What a Payment Customization Function can do

A Shopify Payment Customization Function runs at checkout with a single job: receive the cart context and return modified payment methods. For B2B payment terms, you'd use the `cart.payment-methods.transform.run` API target.

At its most basic, a Function can do things like:

- Show or hide certain payment methods based on who's checking out
- Apply different net-day terms based on buyer tags or order size
- Block specific payment options for B2B company accounts

The Function runs in under 5ms, executes in a WebAssembly sandbox, and makes no external API calls. Those constraints are the same for everyone — there's no getting around them.

The appeal is real: you own the logic, you control the deployment, and you're not paying a monthly app fee. If your rules are static and simple, a custom Function is a reasonable choice.

## Where it gets complicated

The Function itself is not the hard part. What's hard is everything around it.

**The rules have to live somewhere.** A Function has no built-in storage. It reads input from the cart context and whatever you've pre-loaded into metafields on the Payment Customization object. If your rules are hardcoded into the Rust or JavaScript source, every rule change is a code deploy. For most B2B operations teams, that's not workable.

So you need an admin interface where someone can manage the rules without touching code. Now you're building a Shopify app, not just a Function.

**Metafield size limits.** The Payment Customization metafield caps at roughly 4KB. If your ruleset grows — and B2B rule sets do grow as you add customer segments, order tiers, and product-based conditions — you'll need to chunk the payload across multiple metafields and reassemble it inside the Function. That's logic you have to write, test, and maintain.

**Per-buyer runtime data.** Say you want to match a rule based on a buyer's existing payment terms template on their Shopify company location (whether they're currently on Net 30, Net 45, etc.). The Function can't look that up at runtime because it can't make external calls. You have to pre-sync that data into a metafield on the CompanyLocation before checkout runs.

That means building a webhook listener for `company_location/create` and `company_location/update`, a queue to buffer those events, a consumer to write the metafield, and a backfill job to handle the initial data load and reinstall scenarios. If the sync fails, conditions that depend on it silently don't match.

**Testing before you publish.** A broken ruleset doesn't throw a visible error — it just returns no change or applies wrong terms. Without a simulator that lets you test a draft ruleset against a real checkout context before you publish, you're flying blind. Building that is another significant project.

**Version history and rollback.** If you publish a bad ruleset and need to revert, you need something to revert to. That means storing immutable ruleset snapshots, tracking which version is live, and being able to roll back without a code deployment.

**Audit trail.** Finance teams often need to answer "why did this order get these terms?" after the fact. Building an immutable log of every rule change, who made it, and what the state was before and after is not complex software, but it's real work that someone has to do.

## The honest build estimate

If you're starting from a blank Shopify app and want to build what a production B2B payment terms engine actually requires, you're looking at:

- A Shopify embedded app (Next.js or Remix) with an admin UI for rule management
- A backend to persist rules, handle publishing, and enforce plan-based limits
- A Shopify Function in Rust or JavaScript for checkout evaluation
- Metafield chunking for large rule payloads
- A webhook pipeline for per-location data sync
- A rule simulator against draft and published versions
- Version history with rollback
- An audit trail
- Billing if you ever want to offer it to other merchants

None of these are insurmountable. But they add up. A solo developer moving fast could put together a basic version in 6-8 weeks. A production-quality system with the error handling, edge cases, and UX that operations teams actually need is closer to 4-6 months of real effort.

That's not an argument against building. If your B2B setup is genuinely one-of-a-kind and an off-the-shelf app can't handle it, building may be the right call.

## When to build vs. when to use an app

**Build your own Function if:**

- Your rules are static or change infrequently and code deploys are part of your normal workflow
- You have developer capacity and the custom logic is genuinely outside what any app covers
- You need to own the code for compliance or security reasons
- You're a Shopify agency building a bespoke solution for a single client with an unusual requirement

**Use an app if:**

- Your ops or finance team needs to change rules without engineering involvement
- You want a simulator to test rules before they go live
- You need an audit trail that answers "why did this order get these terms?"
- You want rollback when something goes wrong
- You're spending developer hours on infrastructure instead of your actual product

## When native isn't enough

Shopify's default B2B payment terms are set at the company level in the admin. They're static, they don't respond to order size or buyer behavior, and they can't be tested before they go live.

<div style={{backgroundColor: '#f5f3ff', border: '1px solid #c4b5fd', borderLeft: '4px solid #7C3AED', borderRadius: '8px', padding: '1rem 1.25rem', margin: '1.5rem 0'}}>
  <strong style={{color: '#5b21b6'}}>Define your terms logic once, and let it run automatically at checkout.</strong><br/>
  <span style={{color: '#374151', fontSize: '0.95rem'}}><a href="https://apps.shopify.com/termstack" style={{color: '#7C3AED', fontWeight: '600', textDecoration: 'underline'}}>TermStack</a> is a Shopify-native rules engine for B2B payment terms. Build conditional rules in the admin, test them with the simulator, publish with one click, and roll back if anything goes wrong. Try TermStack free for 14 days →</span>
</div>

<a href="https://apps.shopify.com/termstack" style={{textDecoration: 'underline'}}>TermStack</a> handles the infrastructure — the Function, the metafield distribution, the location sync pipeline, the version history, and the audit trail — so you're managing business logic, not plumbing.

## Frequently Asked Questions

### Can I write my own Shopify Payment Customization Function without coding a full app?

Yes, if your rules are simple and static. A standalone Function works fine for fixed logic like "always show net 30 for B2B buyers." The moment you need to change rules without a code deploy or test them before going live, you'll need an admin interface, which means building an app.

### What language do I need to write a Payment Customization Function?

Shopify Functions currently support JavaScript/TypeScript and Rust. Both compile to WebAssembly. Rust gives you smaller binary sizes (important given the 256KB limit) and faster execution, but most teams find JavaScript easier to work with unless they already have Rust experience.

### How do Shopify Functions handle data that isn't in the cart?

They don't access it at runtime. Any data the Function needs has to be pre-loaded into the cart input through metafields. For B2B payment terms, that means syncing buyer data, company terms, and any other context into metafields before checkout runs. This is one of the more complex parts of building a production system.

### What happens if a Payment Customization Function fails at checkout?

Shopify returns no change by default — the Function fails safe. Your checkout doesn't break, but the buyer may see wrong terms or no terms customization at all. Without monitoring and an audit trail, you won't know until a buyer or ops team member flags it.

### Is there a size limit on Payment Customization rule sets?

The metafield that holds your compiled rules caps at roughly 4KB per metafield. For small rule sets this is fine. For complex B2B setups with many conditions, you'll need to chunk the payload across multiple metafields and reassemble it in the Function.

### How does TermStack compare to a custom-built Payment Customization Function?

<a href="https://apps.shopify.com/termstack" style={{textDecoration: 'underline'}}>TermStack</a> uses a Shopify Function under the hood — the same API target you'd use if you built it yourself. The difference is that TermStack ships the admin UI, the simulator, the version history, the audit trail, and the location sync pipeline on top of it. You get the same Function-level performance without building the surrounding system.

### Do I need Shopify Plus to use Payment Customization Functions?

Yes. Payment Customization Functions are only available on Shopify Plus. The B2B company and location features they typically depend on are also Plus-only.

### Can TermStack handle payment terms that vary by company location?

Yes. TermStack can match rules against a buyer's existing payment terms template on their Shopify company location, order totals, customer tags, company ID, collection membership, and order history. Rules evaluate top-down and the first match wins — you set the priority.

## Summary

Building a Payment Customization Function is not hard. Building the system around it — rule management, simulation, versioning, auditing, and buyer data sync — is where the real effort lives. If you have straightforward rules and a developer who can maintain them, building makes sense. If your ops team needs to manage and test rules independently, <a href="https://apps.shopify.com/termstack" style={{textDecoration: 'underline'}}>TermStack</a> gets you to the same outcome without the infrastructure work.

<div style={{textAlign: 'center', marginTop: '2rem'}}>
  <a href="https://apps.shopify.com/termstack" style={{display: 'inline-block', padding: '0.75rem 2rem', backgroundColor: '#0f172a', color: 'white', borderRadius: '9999px', fontWeight: 700, fontSize: '0.875rem', textDecoration: 'none'}}>Try TermStack free for 14 days →</a>
</div>
