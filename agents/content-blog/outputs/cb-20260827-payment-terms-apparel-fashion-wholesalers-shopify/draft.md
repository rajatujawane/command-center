---
title: "Payment Terms for Apparel and Fashion Wholesalers on Shopify"
date: "2026-09-03"
description: "How apparel and fashion wholesalers structure pre-book deposits, seasonal net terms, and first-order prepayment at Shopify Plus B2B checkout without eating the dilution."
coverImage: "/blog/31-hero-apparel-fashion-wholesalers-payment-terms.svg"
tags: ["Shopify Plus", "B2B", "Payment Terms", "Wholesale", "Apparel & Fashion"]
author: "Varr Labs"
tldr:
  - "Apparel wholesale runs on two order types at once: pre-book orders placed a season ahead, and immediates shipped from stock, and they should not carry the same terms."
  - "Four rules cover most of the vertical: prepay on first orders, a deposit on pre-book collections, Net 60 for established accounts, and Net 30 for everyone else."
  - "Pre-book deposits exist because you cut and buy fabric against those orders months before delivery, so a deposit funds production and screens out cancellations."
  - "Chargebacks and markdown deductions quietly dilute what a net invoice actually collects, which is why deposits and first-order prepayment matter more here than the headline terms suggest."
  - "TermStack applies these rules at Shopify's native B2B checkout, keyed to first order, collection, and order history, with a simulator to test each one before market week."
faq:
  - q: "What payment terms do apparel and fashion wholesalers usually offer?"
    a: "Established stockists trade on Net 30, and some larger accounts on Net 60. The vertical's defining split is pre-book versus immediates: pre-book orders placed a season ahead usually carry a deposit of around 30% at order with the balance due on delivery, while in-stock immediates ship on standard net terms. New accounts are typically asked to prepay their first order until they have a payment history."
  - q: "Why do fashion wholesalers take a deposit on pre-orders?"
    a: "Because you commit real money to production before the order ships. A pre-book order placed at market is a promise you act on by cutting and buying fabric months ahead of delivery. A deposit of around 30% funds that production run and screens out the retailer who books wide and cancels half of it later. It converts a soft commitment into a real one."
  - q: "Can Shopify charge a deposit on pre-order collections automatically?"
    a: "Not natively. Shopify Plus payment terms are static per company location, so they cannot tell a pre-book cart apart from an immediates cart. A Payment Customization Function can check what collection the cart items belong to at checkout and apply a deposit only to pre-book products. TermStack does this with a rule, so the same account gets a deposit on pre-book and net terms on immediates."
  - q: "How do you give better terms to established apparel accounts on Shopify?"
    a: "Key the terms to order history, not a static setting. A rule that checks how many previous orders an account has placed can apply Net 60 once a stockist has proven itself over a few seasons, while newer accounts stay on Net 30. It graduates automatically at checkout, so nobody has to re-set terms company by company as accounts mature."
  - q: "What is dilution in fashion wholesale and how do terms affect it?"
    a: "Dilution is the gap between what you invoice and what you actually collect, once chargebacks, compliance deductions, and markdown allowances come off the top. Net terms give the retailer time and leverage to take those deductions. Deposits and first-order prepayment pull some of the cash forward before it can be diluted, which is why they matter more in apparel than the headline net terms suggest."
  - q: "Is dynamic payment terms setup available on Shopify plans below Plus?"
    a: "No. B2B companies, company locations, and payment terms are Shopify Plus features, and Payment Customization Functions are Plus only. On a lower plan there is no B2B checkout context for a rule to evaluate, so the whole approach needs Plus."
  - q: "How do I test payment terms rules before market week without breaking checkout?"
    a: "Use a simulator. In TermStack you build a test order for each scenario, a new account, a pre-book cart, an established stockist on immediates, and confirm which rule fires before you publish. Every change is versioned with one-click rollback, so if a rule is too generous you revert it and the old policy is live again at the next checkout."
---

Apparel and fashion wholesale runs on two clocks at once. There's the pre-book order a buyer writes at market for a season that ships months from now, and there's the immediate a stockist places to refill something that's selling today. Same account, same store, two completely different risk profiles.

If you sell apparel wholesale on Shopify Plus, the mistake is giving both the same payment terms. A pre-book order you'll cut fabric against in spring for autumn delivery is not the same promise as a box shipping from stock this week, and your terms shouldn't pretend it is.

This post covers the term structures that fit apparel and fashion wholesale, a four-rule recipe you can copy with real numbers, and how the same handful of rules handles pre-book and immediates at Shopify's native B2B checkout.

## What makes apparel and fashion wholesale different

Most B2B payment advice assumes one kind of order: a buyer restocks, you invoice, they pay. Fashion has at least two, and they collide on the same account.

**Pre-book and immediates.** The season is sold twice. Buyers commit to pre-book (or pre-order) ranges at market weeks and trade shows, often two seasons ahead for SS and AW deliveries. Then they place immediates against your in-stock inventory to chase what's actually selling. Pre-book funds your production; immediates are lower risk because the goods already exist.

**Deposits fund the cut.** Because a pre-book order commits you to buying fabric and booking factory time long before anything ships, a deposit at order is standard. It's not a trust signal, it's working capital. It also screens out the buyer who books wide across every brand at market and quietly cancels half of it when their open-to-buy tightens.

**Dilution is real.** Apparel has a deduction culture. Compliance chargebacks, markdown allowances, and returns come off invoices as a matter of routine, so the amount you collect on a net order is reliably less than the amount you billed. Longer terms give the retailer more time and more leverage to take those deductions.

**New accounts every season.** Independent boutiques and multi-brand stores turn over constantly, and a first order to a store with no history is the riskiest credit you extend, especially if that first order is a large pre-book.

Put those together and terms in this vertical have to do three jobs at once: fund production on pre-book, protect against dilution on everything, and stay generous enough on immediates to keep good stockists reordering.

## The term structures that fit the vertical

Four structures cover almost everything apparel and fashion wholesalers actually do.

| Structure | What it means | Where it fits |
|---|---|---|
| **First-order prepay** | Full prepayment or a large deposit on a buyer's first order | New stockists with no history |
| **Pre-book deposit** | A deposit at order, balance on delivery | Season-ahead pre-orders that fund production |
| **Standard Net 30** | Full payment 30 days after invoice | Established accounts on immediates |
| **Extended Net 60** | Full payment 60 days after invoice | Proven accounts you want to reward |

The art is in when each one fires. A new account's first pre-book should hit prepay, not the pre-book deposit rule. An established account's immediates should get clean Net 30, but that same account's pre-book order should still carry a deposit because it still funds production. You can't express that with one static term per company, which is where rule order comes in.

## The four-rule recipe, with actual numbers

Here's a starting recipe. Adjust the thresholds to your margins and your production cycle, but keep the order, because rules evaluate top down and the first match wins.

![Four prioritized B2B payment terms rules for an apparel and fashion wholesaler: first order prepay, pre-book collection deposit, Net 60 for established accounts, and standard Net 30 for everyone else](/blog/31a-apparel-rules-recipe.svg)

1. **First order, require full prepayment.** The buyer's first order is paid before anything ships, no matter what's in it. This is your new-account protection, and it catches a large first pre-book that would otherwise commit you to production for a store you've never collected from. For the reasoning behind prepaying unknown buyers, the [first-time buyer prepayment post](/blog/require-prepayment-first-time-b2b-buyers-shopify) goes deeper.
2. **Cart contains pre-book products, apply a 30% deposit.** Your pre-order ranges live in a pre-book collection, and any cart with those products takes a deposit at order with the balance due on delivery. Put it below the first-order rule so a brand-new account still prepays its first pre-book in full.
3. **Account has at least 4 previous orders, apply Net 60.** Proven stockists who've ordered across a few seasons earn extended terms on their immediates. This graduates automatically from order history instead of you re-setting terms account by account. The [order-count graduation ladder](/blog/graduate-b2b-payment-terms-by-order-count) covers how to structure the rungs.
4. **Account has at least one previous order, apply Net 30.** The catch-all for established accounts placing normal immediates. A rule needs at least one condition, so this leans on a real signal, an account with a prior order, rather than an empty fallback. If you'd rather not write it as a rule at all, set Net 30 as your store-level default term and let anything that matches nothing land there.

A first-time buyer hits rule one and prepays, pre-book or not. An established account ordering a pre-book range hits rule two and puts down a deposit. That same account refilling from stock falls to rule three or four and gets Net 60 or Net 30. Four rules, one policy, both order types handled.

## Pre-book deposits without a separate checkout

Here's the part native Shopify can't do on its own: charge a deposit on pre-book but not on immediates, for the same account, in the same session.

A Shopify Function evaluates the cart at checkout, so the signal you drive the deposit from has to be in the cart. You have two clean options:

- **A pre-book collection.** Put your season-ahead ranges in a collection and write the deposit rule against it. Any cart containing those products takes the deposit; a cart of pure immediates doesn't. This is the cleanest match for how buyers actually shop a line.
- **A customer tag.** If pre-book is sold through a separate buying appointment rather than product-by-product, tag the accounts in that program and key the deposit to the tag for the duration of the pre-book window.

Both are honest about what Shopify can and can't do. The rule evaluates at checkout in under 5 milliseconds with no external lookup, so it holds up through a market-week ordering spike.

## Terms as a dilution defense

It's worth being blunt about why deposits and prepayment matter more in apparel than the net terms alone suggest.

You invoice a number. You collect a smaller one. Compliance chargebacks, markdown money, and returns come off the top, and longer terms hand the retailer more room to take those deductions before they pay. That gap is dilution, and in fashion it's structural, not an exception.

Deposits and first-order prepayment are the counterweight. They pull real cash forward, before the season's deductions can chip at it, and before a new account has any leverage to negotiate them. The deeper mechanics of collecting money up front are in the [dynamic deposits post](/blog/dynamic-payment-terms-deposits-shopify-plus), and if you want terms scaled to order size on top of this, the [payment terms by order value post](/blog/b2b-payment-terms-by-order-value) covers where to set those lines.

## How you'd do this natively, and where it breaks

Shopify Plus lets you assign a payment term per company location. Go to **Customers → Companies → [Company] → Location**, pick a template like Net 30 or Net 60, optionally set a deposit percentage, and save. That's the whole native feature, and it's a static assignment that applies to every order from that location until a person changes it.

For a single-order-type business, that's fine. For apparel, it breaks in three places:

- **Pre-book versus immediates.** A static company term can't tell the two carts apart. Set the location to a deposit and every immediate reorder also gets held up for a deposit; set it to Net 30 and your pre-book ships to production with nothing down.
- **First orders.** Nothing checks whether it's an account's first order, so a new store gets whatever the location was set to when it was created. Prepaying new accounts means remembering to set tight terms on every new company and loosen them later.
- **Graduating good accounts.** Moving a proven stockist from Net 30 to Net 60 means editing that company location by hand, and remembering which accounts have earned it. Across a growing base that's a standing chore nobody owns.

The [native versus app comparison](/blog/shopify-b2b-payment-terms-native-vs-app) walks through the full boundary of what Shopify does on its own.

## Common mistakes to avoid

A few things worth getting right before your next market week.

**Ordering the rules wrong.** First match wins, so a Net 30 rule above your deposit rule will ship a pre-book order to production with nothing down. Prepay on top, pre-book deposit next, net terms below.

**One term for both order types.** The most common apparel mistake is a single company-level term that treats a season-ahead pre-book like a stock refill. They carry different risk and should carry different terms.

**Ignoring dilution when you set terms.** If you price your terms as though a net invoice collects in full, you're lending more than you think. Assume deductions and let deposits carry the load.

**Testing in production.** These rules touch checkout during your highest-volume window. Test each scenario in a simulator before you publish, not on a live market-week order.

## When native Shopify isn't enough

Everything above, first-order prepay, pre-book deposits, graduated terms for proven accounts, is something a static per-company term structurally can't do. There's no evaluation step in native terms, so there's nothing to attach a condition to. You change the stored value or you don't.

<div style={{backgroundColor: '#f5f3ff', border: '1px solid #c4b5fd', borderLeft: '4px solid #7C3AED', borderRadius: '8px', padding: '1rem 1.25rem', margin: '1.5rem 0'}}>
  <strong style={{color: '#5b21b6'}}>Charge a deposit on pre-book and net terms on immediates, for the same account, automatically.</strong><br/>
  <span style={{color: '#374151', fontSize: '0.95rem'}}><a href="https://apps.shopify.com/termstack" style={{color: '#7C3AED', fontWeight: '600', textDecoration: 'underline'}}>TermStack</a> checks first order, collection, and order history at checkout and applies the right term or deposit without anyone touching the account, with a simulator to test each rule and one-click rollback if it's too generous. <a href="https://apps.shopify.com/termstack" style={{color: '#7C3AED', fontWeight: '600', textDecoration: 'underline'}}>Try TermStack free for 14 days →</a></span>
</div>

A Payment Customization Function adds the evaluation step native terms are missing. It runs at checkout, inside Shopify's own performance budget, with no external API call. First order, collection, order total, customer tag, order history, and the buyer's existing Shopify-assigned terms are all available as conditions, and you combine them into the policy you actually run.

## Quick reference

| Rule (in order) | Condition | Applied term |
|---|---|---|
| 1 | First order | Full prepayment |
| 2 | Cart contains pre-book collection | 30% deposit |
| 3 | Has at least 4 previous orders | Net 60 |
| 4 | Has at least 1 previous order (or store default) | Net 30 |

## Frequently asked questions

<BlogFaq>

<BlogFaqItem question="What payment terms do apparel and fashion wholesalers usually offer?">
Established stockists trade on Net 30, and some larger accounts on Net 60. The vertical's defining split is pre-book versus immediates: pre-book orders placed a season ahead usually carry a deposit of around 30% at order with the balance due on delivery, while in-stock immediates ship on standard net terms. New accounts are typically asked to prepay their first order until they have a payment history.
</BlogFaqItem>

<BlogFaqItem question="Why do fashion wholesalers take a deposit on pre-orders?">
Because you commit real money to production before the order ships. A pre-book order placed at market is a promise you act on by cutting and buying fabric months ahead of delivery. A deposit of around 30% funds that production run and screens out the retailer who books wide and cancels half of it later. It converts a soft commitment into a real one.
</BlogFaqItem>

<BlogFaqItem question="Can Shopify charge a deposit on pre-order collections automatically?">
Not natively. Shopify Plus payment terms are static per company location, so they cannot tell a pre-book cart apart from an immediates cart. A Payment Customization Function can check what collection the cart items belong to at checkout and apply a deposit only to pre-book products. <a href="https://apps.shopify.com/termstack" style={{textDecoration: 'underline'}}>TermStack</a> does this with a rule, so the same account gets a deposit on pre-book and net terms on immediates.
</BlogFaqItem>

<BlogFaqItem question="How do you give better terms to established apparel accounts on Shopify?">
Key the terms to order history, not a static setting. A rule that checks how many previous orders an account has placed can apply Net 60 once a stockist has proven itself over a few seasons, while newer accounts stay on Net 30. It graduates automatically at checkout, so nobody has to re-set terms company by company as accounts mature.
</BlogFaqItem>

<BlogFaqItem question="What is dilution in fashion wholesale and how do terms affect it?">
Dilution is the gap between what you invoice and what you actually collect, once chargebacks, compliance deductions, and markdown allowances come off the top. Net terms give the retailer time and leverage to take those deductions. Deposits and first-order prepayment pull some of the cash forward before it can be diluted, which is why they matter more in apparel than the headline net terms suggest.
</BlogFaqItem>

<BlogFaqItem question="Is dynamic payment terms setup available on Shopify plans below Plus?">
No. B2B companies, company locations, and payment terms are Shopify Plus features, and Payment Customization Functions are Plus only. On a lower plan there is no B2B checkout context for a rule to evaluate, so the whole approach needs Plus.
</BlogFaqItem>

<BlogFaqItem question="How do I test payment terms rules before market week without breaking checkout?">
Use a simulator. In TermStack you build a test order for each scenario, a new account, a pre-book cart, an established stockist on immediates, and confirm which rule fires before you publish. Every change is versioned with one-click rollback, so if a rule is too generous you revert it and the old policy is live again at the next checkout.
</BlogFaqItem>

</BlogFaq>

## Summary

Apparel wholesale is really two businesses sharing an account: a pre-book business that funds your production, and an immediates business that refills what sells. A single static term per company can only ever serve one of them well, and it leaves dilution and new-account risk unmanaged on both.

Four rules cover most of it: prepay the first order, take a deposit on the pre-book collection, extend Net 60 to accounts that have proven themselves, and drop everyone else onto Net 30. Order them prepay first, deposit next, net terms below, and test each one in a simulator before market week.

<a href="https://apps.shopify.com/termstack" style={{textDecoration: 'underline'}}>TermStack</a> gives you those conditions, the simulator, the version history, and the audit trail in one place, so the policy that funds your season is something you can defend rather than something living in a spreadsheet. If you're heading into a buying market, this is the setup to have in place before the orders start landing.

<div style={{textAlign: 'center', marginTop: '2rem'}}>
  <a href="https://apps.shopify.com/termstack" style={{display: 'inline-block', padding: '0.75rem 2rem', backgroundColor: '#0f172a', color: 'white', borderRadius: '9999px', fontWeight: 700, fontSize: '0.875rem', textDecoration: 'none'}}>Try TermStack free for 14 days →</a>
</div>
