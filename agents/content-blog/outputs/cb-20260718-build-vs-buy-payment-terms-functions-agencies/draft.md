# Build vs Buy: Shopify Payment Function for Agencies

Should your agency build a custom Shopify payment customization function for a client's B2B terms, or buy an app? The first version is a day of work; the system your client's finance team asks for in month two is the real cost.

If you run a Plus agency, you can write a Payment Customization Function that applies Net 30 to B2B buyers in an afternoon. Sidekick can now scaffold simple custom apps too, so the barrier to "version one" has never been lower. That part is genuinely easy, and any developer who tells you otherwise is padding the estimate.

The trap is thinking version one is the job. The job is the simulator your client wants before they trust a rule with real invoices, the versioning and rollback for when a rule misfires mid-quarter, and the audit log finance asks for the first time an order gets terms nobody can explain. This post is the honest build-vs-buy breakdown for agencies, with the cost math and the cases where building really is the right call.

## What the Function API genuinely makes easy

Credit where it's due. Shopify Functions removed most of the pain that Scripts used to cause. For B2B payment terms you target `cart.payment-methods.transform.run`, receive the cart context, and return modified payment methods. You can write it in JavaScript, TypeScript, or Rust, and it compiles to WebAssembly.

The runtime is generous enough for the job. The Function executes in under 5ms, runs in a sandbox, and fails safe: if it errors, Shopify returns no change and checkout keeps working. For a single static rule, this is a clean, well-documented path.

So if your client's requirement is "always apply Net 30 to companies," you can ship that quickly and it will hold up. No app fee, you own the code, done. If that were the whole requirement, I'd tell you to build it and move on.

It rarely is. For the broader build-or-buy tradeoff aimed at merchants rather than agencies, the [payment customization function vs. app breakdown](/blog/payment-customization-function-vs-app) covers the merchant's side of this decision.

## The hidden 80%: everything around the Function

The Function is the 20%. Here's the part that eats months.

**A place for rules to live.** A Function has no storage. It reads the cart context plus whatever you pre-loaded into metafields on the Payment Customization object. Hardcode the rules and every change is a code deploy. Your client's ops team will not file a pull request to change a threshold, so now you're building an admin UI. That's an app, not a Function.

**Testing before publish.** A bad ruleset doesn't throw a red error. It quietly returns no change or applies the wrong terms, and you find out when a buyer complains. Without a simulator that runs a draft ruleset against a real checkout context, your client is publishing blind to their live checkout. Building that simulator is its own project.

**Safe rollout and rollback.** When a rule misfires in the middle of a quarter, "we'll push a fix in the next deploy" is not an answer finance accepts. You need immutable ruleset snapshots, a pointer to the live version, and one-click rollback that doesn't require a code deployment. That means version storage and a publish workflow.

**An audit trail.** The first time an order lands with terms nobody expected, finance asks who changed what and when. You need an immutable log of every rule change, the actor, and the before and after state. This is unglamorous work that someone has to build and maintain for the life of the client relationship.

**Maintenance across API version bumps.** Shopify Functions are versioned. When Shopify moves the API version, your Function needs re-testing and sometimes changes. Anyone who lived through Scripts being sunset knows the platform doesn't stand still. Whatever you build, you own that maintenance for as long as the client is on it. On an agency retainer, that's billable time that could go to actual product work.

Here's a concrete example of the logic clients actually ask for, and why one rule is never enough:

- **Rule 1.** First order from a new company: require a 50% deposit at checkout.
- **Rule 2.** Company tagged `wholesale-gold` with an order over $25,000: Net 60.
- **Rule 3.** Everyone else with a prior order: Net 30.

Three rules, evaluated top to bottom, first match wins. Now add the requirement to test that priority order before publishing, roll back if rule 2 fires on the wrong accounts, and show finance why a given order got Net 60. That's the 80%, and none of it is the Function.

## The Sidekick reality check

Sidekick is genuinely useful. For a CSV importer, a one-off data cleanup, an internal report, a quick metafield editor, it can scaffold something usable fast, and that's a real shift in what a small team can ship.

Checkout payment logic is the worst possible place for "generated code you don't maintain." This is money and credit, evaluated on every B2B checkout, with a finance team downstream who needs to trust and explain the output. Generated code with no simulator, no version history, and no audit trail isn't a time-saver here. It's a liability you inherit the moment the client asks a question you can't answer from the code.

Use Sidekick for the throwaway tools. Don't let it talk you into hand-owning the checkout logic your client's cashflow depends on.

## The cost math

Run the numbers honestly. Agency day rates land somewhere between $800 and $1,500. Version one of the Function is a day or two, so on paper building looks cheap.

The production system is the real line item. A solo developer moving fast can put together a basic version in 6 to 8 weeks. A production-quality system with the simulator, versioning, audit trail, data sync, and the edge cases operations teams actually hit is closer to 4 to 6 months of real work. Then it never stops, because you own maintenance and API-version upkeep for the life of the client.

| Path | Upfront | Ongoing | Who maintains it |
|------|---------|---------|------------------|
| Build version one only | 1-2 days | Grows fast | You, forever |
| Build the full system | 4-6 months | Continuous | You, forever |
| Buy an app | Hours to configure | ~$99 to $300 / mo | The vendor |

For most clients, months of build plus indefinite maintenance is a worse deal than a category app in the $99 to $300 a month range that already ships the simulator, versioning, and audit trail. The app fee is the client's, not yours, and your developers stay on work that actually differentiates the client.

## When building is the right call

Buying isn't always the answer, and I won't pretend it is.

Build it if the logic is genuinely unique, something no app on the market covers, and it's core enough to the client's business to justify owning. Build it if the client has an in-house dev team that will maintain it after you hand it off, so the upkeep doesn't fall back on your retainer. Build it if compliance or security requires the code to live in the client's own account under their control.

If none of those are true, and it usually isn't for standard B2B terms, you're rebuilding a category app on the client's dime. That's hard to justify once they see the maintenance bill.

## Where an app earns its keep

Standard B2B payment terms logic is a solved problem. The parts that take months to build well are exactly the parts a mature app already ships.

<div style={{backgroundColor: '#f5f3ff', border: '1px solid #c4b5fd', borderLeft: '4px solid #7C3AED', borderRadius: '8px', padding: '1rem 1.25rem', margin: '1.5rem 0'}}>
  <strong style={{color: '#5b21b6'}}>Ship your client's B2B terms logic without owning the maintenance.</strong><br/>
  <span style={{color: '#374151', fontSize: '0.95rem'}}><a href="https://apps.shopify.com/termstack" style={{color: '#7C3AED', fontWeight: '600', textDecoration: 'underline'}}>TermStack</a> is a Shopify-native rules engine for B2B payment terms with a simulator, version history, one-click rollback, and an audit trail built in. You configure the rules; you don't build or maintain the plumbing. <a href="https://apps.shopify.com/termstack" style={{color: '#7C3AED', fontWeight: '600', textDecoration: 'underline'}}>Try TermStack free for 14 days →</a></span>
</div>

<a href="https://apps.shopify.com/termstack" style={{textDecoration: 'underline'}}>TermStack</a> uses the same Payment Customization Function API you'd reach for if you built it yourself, so you keep the sub-5ms, no-external-call performance. On top of it you get the rules UI, the simulator, version history with rollback, and the immutable audit trail, plus the location data sync that pre-loads buyer terms into checkout. That's the 80% you'd otherwise be building and maintaining.

For agencies, that changes the delivery. You install it free on a client's development store to test the setup end to end before anything touches production, run through the [complete guide to B2B payment terms](/blog/b2b-payment-terms-complete-guide) with them to map the rules, and hand over a system finance already trusts. The client owns the subscription; you stay on the work that actually moves their business.

## Frequently Asked Questions

<BlogFaq>

<BlogFaqItem question="Can I build a Shopify payment customization function for B2B terms myself?">
Yes. Targeting `cart.payment-methods.transform.run`, a single static rule like "apply Net 30 to B2B companies" is an afternoon of work in JavaScript, TypeScript, or Rust. The build gets expensive when you need to change rules without a deploy, test them before publishing, roll back a bad one, and show finance an audit trail. That surrounding system is the real project.
</BlogFaqItem>

<BlogFaqItem question="Can Sidekick generate a custom app for B2B payment logic?">
Sidekick can scaffold simple custom apps and one-off tools quickly, and that's genuinely useful for things like CSV importers or internal utilities. Checkout payment logic is the worst place for generated code you have to maintain, because it runs on every B2B checkout, handles credit, and has a finance team downstream who needs it to be testable, versioned, and auditable. Use Sidekick for throwaway tools, not the logic your client's cashflow depends on.
</BlogFaqItem>

<BlogFaqItem question="What does it actually cost to build a B2B payment terms system in-house?">
Version one of the Function is a day or two. A basic full system runs 6 to 8 weeks for a solo developer, and a production-quality one with a simulator, versioning, audit trail, and data sync is closer to 4 to 6 months. Then you own ongoing maintenance and Shopify API-version upkeep for as long as the client uses it. Compare that to a category app in the $99 to $300 a month range.
</BlogFaqItem>

<BlogFaqItem question="Why isn't a single Payment Customization Function enough?">
A Function has no storage, no admin UI, no testing tool, and no history. It reads the cart context and metafields and returns a result. Real B2B clients need to change rules without a deploy, test before publishing, roll back mistakes, and audit changes, none of which the Function itself provides. Building those pieces is where the 80 percent of the effort lives.
</BlogFaqItem>

<BlogFaqItem question="What happens when Shopify bumps the Functions API version?">
Your Function needs re-testing and sometimes code changes to stay compatible. The platform doesn't stand still, as anyone who migrated off Scripts knows. Whatever you build in-house, you own that upkeep for the life of the client. An app like TermStack absorbs API-version maintenance on its side, so it isn't billable time on your retainer.
</BlogFaqItem>

<BlogFaqItem question="When does it make sense to build instead of buy?">
Build when the logic is genuinely unique and no app covers it, when the client has an in-house team to maintain it after handoff, or when compliance requires the code to live in their own account. For standard B2B terms, buying is almost always the better deal because you'd otherwise be rebuilding a category app on the client's dime.
</BlogFaqItem>

<BlogFaqItem question="Can an agency test TermStack before deploying it for a client?">
Yes. You can install TermStack free on a client's Shopify development store and build the full ruleset there, then use the simulator to confirm each rule fires against realistic checkout scenarios before anything reaches production. The client keeps the subscription once it goes live, and your team stays off long-term maintenance.
</BlogFaqItem>

<BlogFaqItem question="Does buying an app mean giving up the performance of a custom Function?">
No. TermStack runs on the same Payment Customization Function API you'd use if you built it yourself, so you keep the sub-5ms evaluation with no external API calls at checkout. The difference is you get the rules UI, simulator, versioning, and audit trail on top, instead of building and maintaining them yourself.
</BlogFaqItem>

</BlogFaq>

## Summary

Writing a Payment Customization Function is easy, and Sidekick makes version one easier still. That's not the decision. The decision is who builds and maintains the simulator, the versioning, the rollback, and the audit trail your client's finance team will ask for by month two.

For genuinely unique logic with an in-house team to own it, build. For standard B2B payment terms, buying is the better deal for your client and keeps your developers on work that differentiates them. <a href="https://apps.shopify.com/termstack" style={{textDecoration: 'underline'}}>TermStack</a> ships the whole surrounding system on the same Function API, so you configure rules instead of maintaining plumbing.

<div style={{textAlign: 'center', marginTop: '2rem'}}>
  <a href="https://apps.shopify.com/termstack" style={{display: 'inline-block', padding: '0.75rem 2rem', backgroundColor: '#0f172a', color: 'white', borderRadius: '9999px', fontWeight: 700, fontSize: '0.875rem', textDecoration: 'none'}}>Try TermStack free for 14 days →</a>
</div>
