---
title: "Checkout Blocks and B2B Payment Terms: What Each Controls"
date: "2026-08-11"
description: "Checkout Blocks controls which payment methods show at checkout and how it looks. It doesn't set B2B payment terms or deposits. Here's the line between the two."
coverImage: "/blog/checkout-blocks-vs-termstack-hero.svg"
tags: ["Shopify Plus", "B2B", "Payment Terms", "Checkout"]
author: "Varr Labs"
tldr:
  - "Checkout Blocks controls which payment methods appear at checkout, their order and labels, plus checkout content and layout. It does not set payment terms or deposits."
  - "Setting the terms themselves, Net 30, Net 60, a required deposit, conditional on who the buyer is, is a different job that Checkout Blocks doesn't do."
  - "Both run as payment customizations on the same checkout, so a Plus B2B store can use Checkout Blocks and TermStack together without conflict."
  - "TermStack sets the payment terms; Checkout Blocks shapes what the buyer sees. Use both when you need full control of the B2B checkout."
faq:
  - q: "Can Checkout Blocks set net payment terms like Net 30 or Net 60?"
    a: "No. Checkout Blocks controls which payment methods show at checkout, their order, and their labels, along with checkout content and layout. It does not assign net terms or deposits to a buyer. Setting the terms themselves is a separate job handled by a B2B payment terms tool like TermStack."
  - q: "What is the difference between Checkout Blocks and payment customization?"
    a: "Checkout Blocks is a checkout editor that includes payment method customization: hide, rename, and reorder the methods a buyer sees. Payment customization in the B2B terms sense means deciding the terms attached to the order, such as Net 30 or a deposit. The first controls the buyer's checkout view, the second controls how and when they pay."
  - q: "Do Checkout Blocks and TermStack conflict if I run both?"
    a: "No. Both run as payment customizations on the same Shopify Plus checkout, and Plus stores can activate multiple payment customizations at once. Checkout Blocks handles method visibility and layout, TermStack applies the terms. They do different jobs on the same checkout, so they coexist."
  - q: "Can Checkout Blocks hide a payment method for certain B2B companies?"
    a: "Yes, method visibility is exactly what Checkout Blocks is for. You can hide, rename, or reorder payment methods based on conditions like the customer or cart. What it can't do is decide the payment terms behind that method, such as putting a tagged company on Net 45 with a deposit."
  - q: "Do I need Shopify Plus for either of these?"
    a: "Yes. Checkout customization at this level and B2B payment terms are both Shopify Plus features. The B2B company and location model that terms depend on is Plus-only, and so is the checkout customization surface."
  - q: "Which one sets a required deposit on a B2B order?"
    a: "Neither Checkout Blocks nor Shopify's static B2B settings apply a conditional deposit tied to buyer or order rules. TermStack does. You define a rule such as 'first order over $10,000 requires a 20% deposit,' and it applies at checkout automatically."
  - q: "Can TermStack change how payment methods look at checkout?"
    a: "No, and it isn't meant to. TermStack sets the payment terms, the Net days and deposits, based on rules you define. If you also want to hide a credit card option or reorder methods for certain buyers, that's what Checkout Blocks is for. Run both and each does its part."
---

If you sell B2B on Shopify Plus, you've probably looked at Checkout Blocks and wondered whether it also handles payment terms. It's a fair question. Checkout Blocks touches the payment section of checkout, so it feels like it should be able to put a buyer on Net 30.

It can't. Checkout Blocks and B2B payment terms are two different jobs, and mixing them up leads to a checkout that looks right but bills wrong.

This post draws the line clearly: what Checkout Blocks controls, what it doesn't, where a payment terms tool like TermStack picks up, and how the two work together on the same checkout.

## What Checkout Blocks actually controls at checkout

Checkout Blocks is a checkout editor. It lets you customize what the buyer sees and how checkout is laid out without writing code. On the payment side specifically, it controls the payment methods surface.

That means Checkout Blocks can:

- **Hide a payment method.** Remove credit card, or a specific gateway, from checkout for certain buyers.
- **Rename a method.** Change the label a buyer sees on a payment option.
- **Reorder methods.** Push one payment option above another in the list.
- **Shape the rest of checkout.** Add content, custom fields, and layout changes around the payment step.

All of that is about presentation and availability. It decides which options appear and in what order. It's genuinely useful, and for a lot of stores it's the missing piece that Shopify's default checkout doesn't give you.

But notice what's not on that list: the actual terms of payment.

## What TermStack controls: the payment terms themselves

Payment terms are a different layer. They're not about which method shows up. They're about the deal attached to the order: when the buyer pays, and how much upfront.

Setting terms means answering questions like:

- Does this buyer get Net 30, Net 60, or pay on fulfillment?
- Does this order need a deposit before it ships?
- Do the terms change based on who the buyer is, how big the order is, or how many orders they've placed?

Shopify's native B2B terms can assign a single static term at the company level. They can't make that decision conditional. Checkout Blocks doesn't touch this layer at all. This is the job [TermStack](https://apps.shopify.com/termstack) exists for: a rules engine that decides the terms at checkout based on conditions you define. For the broader picture of how native terms compare to a rules engine, the [native vs. app breakdown](/blog/shopify-b2b-payment-terms-native-vs-app) covers it.

So the split is clean. Checkout Blocks shapes the buyer's view of the payment step. TermStack sets the terms behind it.

![Side-by-side of which jobs Checkout Blocks owns versus which jobs TermStack owns at B2B checkout](/blog/checkout-blocks-vs-termstack-jobs.svg)

## Which app owns which job

Here's the same thing as a table you can point a teammate at.

| The job | Checkout Blocks | TermStack |
|---------|----------------|-----------|
| Hide a payment method | Yes | No |
| Rename a payment method | Yes | No |
| Reorder payment methods | Yes | No |
| Change checkout content and layout | Yes | No |
| Assign Net 30 / Net 60 terms | No | Yes |
| Require a deposit on an order | No | Yes |
| Make terms conditional on the buyer | No | Yes |
| Change terms by order size or history | No | Yes |

If you find yourself wanting a row from both halves of that table, that's your signal you need both tools, not one doing a job it wasn't built for.

## A combined recipe: hide a method and apply the terms

The two working together is where the full B2B checkout comes into focus. Take a common setup for a tagged wholesale company.

You want approved wholesale accounts to skip credit card entirely and get invoiced on Net 30. That's two jobs:

1. **Checkout Blocks** hides the credit card option for the tagged company, so their checkout only shows the invoice or terms-based path.
2. **TermStack** applies Net 30 to that same buyer, because a rule matches their customer tag and sets the term.

Both run as payment customizations on the same checkout. Shopify Plus lets a store activate more than one payment customization at a time, so there's no conflict. Checkout Blocks handles the visibility, TermStack handles the term. The buyer sees a clean checkout with the right option, and the order carries the right terms.

If deposits are part of your setup, the same pattern holds: Checkout Blocks controls what shows, and TermStack decides the deposit. The [dynamic deposits guide](/blog/dynamic-payment-terms-deposits-shopify-plus) walks through the deposit rules in more detail.

## When Checkout Blocks isn't enough for terms

If you've been trying to solve payment terms inside Checkout Blocks, you've hit its edge. It was never built to set terms, and no amount of hiding or reordering methods changes when a buyer pays.

<div style={{backgroundColor: '#f5f3ff', border: '1px solid #c4b5fd', borderLeft: '4px solid #7C3AED', borderRadius: '8px', padding: '1rem 1.25rem', margin: '1.5rem 0'}}>
  <strong style={{color: '#5b21b6'}}>Set the terms, not just the layout.</strong><br/>
  <span style={{color: '#374151', fontSize: '0.95rem'}}><a href="https://apps.shopify.com/termstack" style={{color: '#7C3AED', fontWeight: '600', textDecoration: 'underline'}}>TermStack</a> is a Shopify-native rules engine for B2B payment terms. Assign Net 30, Net 60, or a required deposit based on the buyer, the order size, or order history, test it before it goes live, and roll back if anything looks off. <a href="https://apps.shopify.com/termstack" style={{color: '#7C3AED', fontWeight: '600', textDecoration: 'underline'}}>Try TermStack free for 14 days →</a></span>
</div>

The reason to keep the two separate is that they change independently. Your checkout layout is a merchandising decision. Your payment terms are a credit and cashflow decision. Keeping the layout in Checkout Blocks and the terms in <a href="https://apps.shopify.com/termstack" style={{textDecoration: 'underline'}}>TermStack</a> means each team owns its own surface without stepping on the other. If you want the mechanics of how a terms engine works next to the raw Function API, the [Function vs. app comparison](/blog/payment-customization-function-vs-app) covers that.

## Frequently Asked Questions

<BlogFaq>
  <BlogFaqItem question="Can Checkout Blocks set net payment terms like Net 30 or Net 60?">
    No. Checkout Blocks controls which payment methods show at checkout, their order, and their labels, along with checkout content and layout. It does not assign net terms or deposits to a buyer. Setting the terms themselves is a separate job handled by a B2B payment terms tool like <a href="https://apps.shopify.com/termstack" style={{textDecoration: 'underline'}}>TermStack</a>.
  </BlogFaqItem>

  <BlogFaqItem question="What is the difference between Checkout Blocks and payment customization?">
    Checkout Blocks is a checkout editor that includes payment method customization: hide, rename, and reorder the methods a buyer sees. Payment customization in the B2B terms sense means deciding the terms attached to the order, such as Net 30 or a deposit. The first controls the buyer's checkout view, the second controls how and when they pay.
  </BlogFaqItem>

  <BlogFaqItem question="Do Checkout Blocks and TermStack conflict if I run both?">
    No. Both run as payment customizations on the same Shopify Plus checkout, and Plus stores can activate multiple payment customizations at once. Checkout Blocks handles method visibility and layout, TermStack applies the terms. They do different jobs on the same checkout, so they coexist.
  </BlogFaqItem>

  <BlogFaqItem question="Can Checkout Blocks hide a payment method for certain B2B companies?">
    Yes, method visibility is exactly what Checkout Blocks is for. You can hide, rename, or reorder payment methods based on conditions like the customer or cart. What it can't do is decide the payment terms behind that method, such as putting a tagged company on Net 45 with a deposit.
  </BlogFaqItem>

  <BlogFaqItem question="Do I need Shopify Plus for either of these?">
    Yes. Checkout customization at this level and B2B payment terms are both Shopify Plus features. The B2B company and location model that terms depend on is Plus-only, and so is the checkout customization surface.
  </BlogFaqItem>

  <BlogFaqItem question="Which one sets a required deposit on a B2B order?">
    Neither Checkout Blocks nor Shopify's static B2B settings apply a conditional deposit tied to buyer or order rules. <a href="https://apps.shopify.com/termstack" style={{textDecoration: 'underline'}}>TermStack</a> does. You define a rule such as "first order over $10,000 requires a 20% deposit," and it applies at checkout automatically.
  </BlogFaqItem>

  <BlogFaqItem question="Can TermStack change how payment methods look at checkout?">
    No, and it isn't meant to. TermStack sets the payment terms, the Net days and deposits, based on rules you define. If you also want to hide a credit card option or reorder methods for certain buyers, that's what Checkout Blocks is for. Run both and each does its part.
  </BlogFaqItem>
</BlogFaq>

## Summary

Checkout Blocks and B2B payment terms solve different problems. Checkout Blocks controls which payment methods appear, their order and labels, and the checkout layout around them. It does not set terms or deposits. Deciding the terms, and making them conditional on the buyer, is what a rules engine like <a href="https://apps.shopify.com/termstack" style={{textDecoration: 'underline'}}>TermStack</a> is for. Most Plus B2B stores that want full checkout control run both: one shapes what the buyer sees, the other sets how they pay.

<div style={{textAlign: 'center', marginTop: '2rem'}}>
  <a href="https://apps.shopify.com/termstack" style={{display: 'inline-block', padding: '0.75rem 2rem', backgroundColor: '#0f172a', color: 'white', borderRadius: '9999px', fontWeight: 700, fontSize: '0.875rem', textDecoration: 'none'}}>Try TermStack free for 14 days →</a>
</div>
