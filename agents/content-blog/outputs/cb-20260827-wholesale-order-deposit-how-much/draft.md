---
title: "How Much Deposit Should You Require on Wholesale Orders?"
date: "2026-09-17"
description: "A practical guide to wholesale deposit percentages: 20-30% on large orders, 50% on first orders, 30-50% on made-to-order, and how to enforce them by order size and history on Shopify Plus."
coverImage: "/blog/33-hero-wholesale-order-deposit.svg"
tags: ["Shopify Plus", "B2B", "Payment Terms", "Deposits", "Wholesale"]
author: "Varr Labs"
tldr:
  - "There's no single right deposit. Price it to the risk: bigger orders, new accounts, and custom goods each justify more upfront."
  - "Common norms: 20-30% on large stock orders, 50% on a new account's first order, and 30-50% on made-to-order or custom work."
  - "100% upfront isn't a deposit, it's prepayment. That's the right call for brand-new accounts and one-off custom runs, and overkill for a proven buyer."
  - "Shopify Plus only does one static deposit percentage per company location. Charging different deposits by order size, history, or product mix needs a rules engine."
  - "TermStack sets deposits as a conditional outcome at Shopify's native B2B checkout, keyed to order total, first order, order count, and cart contents, tested in a simulator before you publish."
faq:
  - q: "What is a normal deposit percentage on a wholesale order?"
    a: "It depends on the risk, but the common ranges are 20-30% on large stock orders, around 50% on a new account's first order, and 30-50% on made-to-order or custom goods. Reorders from a proven account often carry no deposit at all. Treat the deposit as risk pricing rather than a single house number, so a small reorder from a trusted buyer and a large first order from a stranger aren't charged the same way."
  - q: "Should I require a 50% deposit on first wholesale orders?"
    a: "For a new account with no payment history, 50% upfront is a reasonable default, and full prepayment is defensible if the order is large or custom. The point is to collect before you've extended any credit to a buyer you can't yet judge. Once that account has paid a few orders on time, you can drop the first-order deposit and move them onto net terms, which is easier if the deposit is tied to order history instead of set by hand."
  - q: "Is asking for 100% upfront the same as a deposit?"
    a: "No. 100% upfront is prepayment, not a deposit. A deposit collects part of the order and puts the balance on terms; prepayment collects the whole thing before you ship. Prepayment is the right call for a first order from an unknown buyer or a one-off custom run, and it's overkill for an established account, where it just adds friction and signals you don't trust them."
  - q: "How do I decide the deposit for a made-to-order or custom order?"
    a: "Cover your committed cost. A deposit on custom work should at least cover the materials and production time you can't resell if the buyer walks, which usually lands between 30% and 50%. If a custom run commits you to non-recoverable spend before you ship, lean toward the higher end or full prepayment on the custom portion."
  - q: "Can Shopify Plus charge different deposits on different orders?"
    a: "Not natively. Shopify Plus lets you set one deposit percentage per company location, and it applies to every order from that location regardless of size, product, or history. To charge 30% on large orders, 50% on first orders, and nothing on small reorders, you need a Payment Customization Function or an app like TermStack that evaluates the cart at checkout and applies the right deposit per order."
  - q: "Does a deposit requirement work on Shopify plans below Plus?"
    a: "No. B2B companies, company locations, and payment terms are Shopify Plus features, and Payment Customization Functions are Plus only. On a lower plan there's no B2B checkout context for a rule to read, so conditional deposits aren't available."
---

If you sell wholesale on Shopify Plus, at some point a buyer places an order big enough that shipping it on open terms feels like a bet. So you ask for a deposit. The question is how much.

There's no single right number, and anyone who gives you one is guessing. The deposit that fits a $2,000 reorder from a buyer who's paid you ten times isn't the deposit that fits a $60,000 first order from a company you found last week.

This post covers how to size a deposit to the actual risk, the percentages most wholesalers land on by scenario, and how to charge different deposits on different orders when Shopify only lets you set one.

## Think of a deposit as risk pricing

A deposit isn't a formality. It's you deciding how much of an order you're willing to ship before the money clears. The right size falls out of three questions.

**New account risk.** How much do you know about this buyer? A company with a payment history has earned trust you can price in. A first-time buyer hasn't, so you collect more upfront until they prove they pay.

**Order size risk.** How much are you exposed if this one goes bad? A small order you can eat. A large order ties up inventory and cash you can't easily recover, so the deposit scales with the number.

**Product risk.** Can you resell the goods if the buyer walks? Stock you can put back on the shelf is low risk. Made-to-order and custom goods are the opposite: you've committed materials and production time to something only that buyer wants, so the deposit has to cover what you can't recover.

Most orders sit on one or two of these. A large first order for custom goods hits all three, and that's exactly the one you prepay.

> Size the deposit to what you'd lose if the order fell through, not to a house number you apply to everyone.

## The percentages wholesalers actually use

Once you're pricing risk instead of picking a flat number, the common ranges make sense.

| Scenario | Typical deposit | Why |
|---|---|---|
| **Large stock order** | 20-30% | Covers your exposure on volume you can otherwise resell |
| **New account, first order** | 50% (or 100%) | No history yet, so you collect before extending credit |
| **Made-to-order / custom** | 30-50% | Covers committed materials and production you can't resell |
| **Small reorder, proven account** | 0% | History earned the terms; a deposit just adds friction |

**20-30% on large orders.** Once an order crosses a threshold that matters to your cashflow, a deposit in this range pulls enough cash forward to cover your working capital without scaring off a good buyer. Where you set the threshold depends on your margins and order sizes. The [payment terms by order value post](/blog/b2b-payment-terms-by-order-value) covers how to pick those lines.

**50% on first orders.** A new account is the riskiest credit you extend, because you have nothing to go on. Half upfront is a reasonable default, and it drops away on its own once the buyer has a track record. The reasoning behind prepaying unknown buyers is in the [first-time buyer prepayment post](/blog/require-prepayment-first-time-b2b-buyers-shopify).

**30-50% on made-to-order.** Custom work is different because the downside isn't a delayed payment, it's a total loss. If you cut, print, or build something to spec and the buyer disappears, you can't resell it. The deposit should at least cover your non-recoverable cost, which usually lands in this range and sometimes higher.

## When 100% upfront is the right answer

Full prepayment gets a bad reputation because people treat it as the nuclear option. It isn't. It's just the honest terms for a specific situation.

A first order from a buyer you can't verify, or a one-off custom run you'll never resell, is a case where the deposit should be the whole thing. You're not being difficult. You're declining to lend money to someone who hasn't given you a reason to.

The mistake is applying prepayment where it doesn't belong. Asking an established account that's paid you on time for two years to prepay in full is friction with no upside. It signals you don't trust them, and it pushes a good buyer toward a competitor who does. Prepayment is for risk you can't price any other way, not a default.

> 100% upfront isn't a deposit, it's prepayment. Right for a first order or a custom one-off, wrong for a buyer who's already earned terms.

## The enforcement problem

Here's where it gets practical. You've decided a large order takes 30%, a first order takes 50%, and a small reorder takes nothing. Now you have to make Shopify actually do that.

Shopify Plus supports deposits natively, but only one way: a single deposit percentage set on a company location. Go to **Customers → Companies → [Company] → Location**, set a deposit, and every order from that location gets it. Same percentage on a $500 reorder and a $50,000 first order, until someone edits the company by hand.

That static model can't express any of the framework above. You can't say "30% over $25,000" or "50% on the first order, nothing after that" or "a deposit on custom collections but not on stock." It's one number per buyer, applied to everything.

So merchants improvise. They set a high deposit and annoy their good accounts, or a low one and under-collect on the risky orders, or they drop to draft orders and invoice deposits by hand. All three are the same problem: the deposit is static, and risk isn't.

## Making deposits conditional

To charge the right deposit per order, the deposit has to be decided at checkout, when the order total, the buyer's history, and the cart contents are all known. That's what a Payment Customization Function does: it evaluates the cart and applies an outcome, including a deposit, based on conditions you set.

Here's a starting rule stack. Rules evaluate top down and the first match wins, so order matters.

1. **First order, require full prepayment.** A brand-new account pays in full before anything ships, whatever's in the cart. This is your new-account protection.
2. **Cart contains custom or made-to-order products, require a 50% deposit.** Keyed to a collection, so any cart with custom goods collects half upfront to cover committed production. Below the first-order rule, so a new account's first custom order still prepays in full.
3. **Order total at or above $25,000, require a 30% deposit.** Large stock orders from established accounts pull cash forward without blocking the sale.
4. **Everything else, no deposit.** Small reorders from proven accounts ship clean on their existing terms.

A first-time buyer hits rule one and prepays. An established account ordering custom goods hits rule two and puts down 50%. That same account placing a large stock order hits rule three at 30%, and a small reorder falls through to rule four with nothing down. One policy, four orders, four different deposits, all decided automatically.

Both percentage and fixed-amount deposits work as outcomes, and the deposit is set independently of the payment term, so you can pair a 30% deposit with Net 30 on the balance. The [dynamic deposits post](/blog/dynamic-payment-terms-deposits-shopify-plus) walks through the mechanics, and the [conditional deposits guide](/blog/how-to-require-deposits-on-b2b-orders-shopify-plus) covers the setup in more detail.

<div style={{backgroundColor: '#f5f3ff', border: '1px solid #c4b5fd', borderLeft: '4px solid #7C3AED', borderRadius: '8px', padding: '1rem 1.25rem', margin: '1.5rem 0'}}>
  <strong style={{color: '#5b21b6'}}>Charge the right deposit on every order, automatically, at Shopify's native B2B checkout.</strong><br/>
  <span style={{color: '#374151', fontSize: '0.95rem'}}><a href="https://apps.shopify.com/termstack" style={{color: '#7C3AED', fontWeight: '600', textDecoration: 'underline'}}>TermStack</a> reads order total, first order, order history, and cart contents at checkout and applies the deposit you set for that case, with a simulator to test each rule and one-click rollback if it's wrong. <a href="https://apps.shopify.com/termstack" style={{color: '#7C3AED', fontWeight: '600', textDecoration: 'underline'}}>Try TermStack free for 14 days →</a></span>
</div>

## A quick sizing checklist

Before you set a deposit on the next order, run it against three questions:

- **Do I know this buyer?** No history means collect more upfront. A solid history means you can ease off.
- **What do I lose if it falls through?** Bigger exposure means a bigger deposit. Scale it to the number, not a flat rate.
- **Can I resell the goods?** Stock is low risk. Custom is a potential total loss, so cover your committed cost.

If you can answer those, you have your deposit. The hard part isn't deciding the number, it's making Shopify apply the right one per order instead of the same one to everybody.

## Frequently asked questions

<BlogFaq>

<BlogFaqItem question="What is a normal deposit percentage on a wholesale order?">
It depends on the risk, but the common ranges are 20-30% on large stock orders, around 50% on a new account's first order, and 30-50% on made-to-order or custom goods. Reorders from a proven account often carry no deposit at all. Treat the deposit as risk pricing rather than a single house number, so a small reorder from a trusted buyer and a large first order from a stranger aren't charged the same way.
</BlogFaqItem>

<BlogFaqItem question="Should I require a 50% deposit on first wholesale orders?">
For a new account with no payment history, 50% upfront is a reasonable default, and full prepayment is defensible if the order is large or custom. The point is to collect before you've extended any credit to a buyer you can't yet judge. Once that account has paid a few orders on time, you can drop the first-order deposit and move them onto net terms, which is easier if the deposit is tied to order history instead of set by hand.
</BlogFaqItem>

<BlogFaqItem question="Is asking for 100% upfront the same as a deposit?">
No. 100% upfront is prepayment, not a deposit. A deposit collects part of the order and puts the balance on terms; prepayment collects the whole thing before you ship. Prepayment is the right call for a first order from an unknown buyer or a one-off custom run, and it's overkill for an established account, where it just adds friction and signals you don't trust them.
</BlogFaqItem>

<BlogFaqItem question="How do I decide the deposit for a made-to-order or custom order?">
Cover your committed cost. A deposit on custom work should at least cover the materials and production time you can't resell if the buyer walks, which usually lands between 30% and 50%. If a custom run commits you to non-recoverable spend before you ship, lean toward the higher end or full prepayment on the custom portion.
</BlogFaqItem>

<BlogFaqItem question="Can Shopify Plus charge different deposits on different orders?">
Not natively. Shopify Plus lets you set one deposit percentage per company location, and it applies to every order from that location regardless of size, product, or history. To charge 30% on large orders, 50% on first orders, and nothing on small reorders, you need a Payment Customization Function or an app like <a href="https://apps.shopify.com/termstack" style={{textDecoration: 'underline'}}>TermStack</a> that evaluates the cart at checkout and applies the right deposit per order.
</BlogFaqItem>

<BlogFaqItem question="Does a deposit requirement work on Shopify plans below Plus?">
No. B2B companies, company locations, and payment terms are Shopify Plus features, and Payment Customization Functions are Plus only. On a lower plan there's no B2B checkout context for a rule to read, so conditional deposits aren't available.
</BlogFaqItem>

</BlogFaq>

## Summary

A wholesale deposit is a price you put on risk. New accounts, large orders, and custom goods each push it up; a proven buyer placing a small reorder pushes it to zero. The common landing spots are 20-30% on large stock orders, 50% on first orders, and 30-50% on made-to-order, with full prepayment reserved for the cases you genuinely can't price any other way.

The catch is enforcement. Shopify Plus gives you one static deposit per company location, which can't tell a first order from a reorder or a $500 cart from a $50,000 one. Making the deposit match the risk means deciding it at checkout, per order, from conditions you set.

- **[Try the live demo store →](https://termstack-demo-store.myshopify.com)** to see deposit rules applying at a real B2B checkout.
- **Want help setting up your first rules?** I'll do it with you on a free 30-minute call: your deposit policy, live at checkout, before the call ends. Email termstack@varrlabs.com.

<a href="https://apps.shopify.com/termstack" style={{textDecoration: 'underline'}}>TermStack</a> gives you the conditions, the simulator, and the version history to run that policy at Shopify's native checkout, so the deposit on every order reflects the risk instead of a number someone set on the company once and forgot.

<div style={{textAlign: 'center', marginTop: '2rem'}}>
  <a href="https://apps.shopify.com/termstack" style={{display: 'inline-block', padding: '0.75rem 2rem', backgroundColor: '#0f172a', color: 'white', borderRadius: '9999px', fontWeight: 700, fontSize: '0.875rem', textDecoration: 'none'}}>Try TermStack free for 14 days →</a>
</div>
