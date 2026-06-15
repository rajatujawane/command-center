---
title: "Past-Due Invoices on Shopify B2B: A Practical Collections Workflow"
date: "2026-06-14"
description: "A practical collections workflow for Shopify Plus B2B merchants dealing with past-due invoices — from first reminder to final escalation, without burning customer relationships."
coverImage: "/blog/20-hero-past-due-invoices-b2b.svg"
tags: ["Shopify Plus", "B2B", "Payment Terms", "Wholesale", "Cash Flow", "Collections"]
author: "Varr Labs"
tldr:
  - "Most Shopify Plus merchants have no real collections process — they send one reminder email and hope. That is not a workflow; it is optimism."
  - "A structured cadence (reminder at day 5, firm at day 15, escalation at day 30, hold at day 45) catches most late invoices before they become write-offs."
  - "The root problem is usually structural: static Shopify payment terms with no way to tighten conditions for late-paying accounts automatically."
  - "TermStack lets you tag slow-paying accounts and apply stricter terms — shorter net periods, required deposits — at checkout automatically, so collections becomes the last resort rather than the default process."
faq:
  - q: "How should a Shopify Plus B2B merchant handle a past-due invoice?"
    a: "Start with a friendly reminder at day 5 past due. Move to a direct payment request at day 15. Escalate to a hold on new orders at day 30 to 45. Only move to formal collections or write-off after 60 to 90 days depending on your margin structure and relationship value."
  - q: "When should a B2B merchant put a customer on order hold for non-payment?"
    a: "A soft hold — not processing new orders until the past-due invoice is resolved — is reasonable by day 30 to 45. Many merchants wait too long because they fear the relationship cost. The reality is that buyers who are told clearly that terms are suspended typically pay faster than those who receive a second reminder email."
  - q: "How can Shopify Plus automatically tighten terms for late-paying B2B customers?"
    a: "Shopify Plus has no native conditional terms logic. Tightening terms for a specific account requires either manually updating the company location settings or using a Payment Customization Function. TermStack provides a no-code rules engine that can evaluate customer tags at checkout and apply stricter terms — such as a deposit requirement or a shorter net period — automatically."
  - q: "What customer tags should I use to manage B2B collections on Shopify Plus?"
    a: "Tag slow-paying accounts in Shopify with something like slow-pay or past-due. A Payment Customization Function can then evaluate the tag at checkout and either require a deposit, reduce the net period, or require payment in full before fulfillment. Remove the tag once the account is current."
  - q: "Should I offer a payment plan for a past-due B2B invoice?"
    a: "Yes, for larger balances from buyers who have otherwise paid reliably. A payment plan keeps the relationship, recovers the debt over time, and avoids the cost of formal collections. Get the plan in writing, require an initial payment to start it, and document the agreed schedule. Oral payment plans rarely hold."
  - q: "What is the right time to write off a past-due B2B invoice?"
    a: "Most merchants write off after 90 to 120 days of non-response, depending on invoice size and cost of continued pursuit. Before writing off, check whether the amount justifies small claims court (typically under $10,000 to $25,000 depending on jurisdiction). For larger balances, a collections agency or attorney is worth the contingency fee."
  - q: "How do I prevent past-due invoices from recurring for the same B2B account?"
    a: "The most effective prevention is structural: require a deposit on the first order, shorten the net period until the account establishes a clean track record, and use a Payment Customization Function to enforce those rules automatically. Reactive collections is a symptom; the fix is terms logic applied before checkout."
  - q: "Does a hold on new orders actually work to collect on past-due B2B invoices?"
    a: "Yes, more reliably than additional reminder emails. A buyer who has been receiving your product and now cannot place a new order has a concrete business reason to resolve the past-due balance. The hold is not punitive; it is a natural consequence of terms not being met. Most buyers who hit a hold resolve it within a week."
---

# Past-Due Invoices on Shopify B2B: A Practical Collections Workflow

*A practical collections workflow for Shopify Plus B2B merchants dealing with past-due invoices — from first reminder to final escalation, without burning customer relationships.*

One of your wholesale buyers just went 30 days past due. You've sent one reminder. You're wondering whether to send another one or just wait.

Most Shopify Plus merchants stay in that loop for weeks. Another reminder. Another week. Another email to the AR spreadsheet. By the time they actually escalate, the invoice is 75 days old, the buyer knows they can delay indefinitely, and the pattern is set.

This post is about breaking that pattern. A collections workflow is not about being aggressive — it's about being consistent. Buyers pay the creditors who have a clear process before they pay the ones who are just hoping. For the bigger picture on how payment terms work on Shopify Plus, the [complete guide to B2B payment terms](/blog/b2b-payment-terms-complete-guide) covers the full framework.

## Why most Shopify merchants don't have a real collections process

The honest reason is that Shopify's B2B tools make it easy to extend terms and hard to enforce them.

You can set Net 30 for a company location in 30 seconds. There is no equivalent tool that alerts you when day 31 arrives, applies a hold, or tightens terms for accounts that have paid late before. The enforcement side is entirely manual.

So merchants build informal processes. One reminder email. Maybe a phone call. A vague sense that you'll "follow up" if it goes another two weeks. That's not a workflow — it's avoidance with extra steps.

The result is predictable: late invoices accumulate, the AR aging report gets worse each quarter, and writing things off becomes the de facto resolution for anything over 90 days.

A structured cadence fixes most of this without requiring new software. It just requires deciding in advance what you will do at each stage.

## The four-stage collections cadence

Here's the workflow I'd use for a Shopify Plus B2B merchant:

**Stage 1 — Day 5 past due: Friendly reminder**

Send a short, direct email. Don't apologize for sending it. The message is simple: the invoice is past due, here's a link to pay, let me know if there's a question on your end. Keep it under 150 words.

The goal at this stage is to catch invoices that slipped through someone's AP queue, or where there's a genuine question about the invoice. Most late payments at this stage are not intentional — they're operational. A single clear reminder resolves them.

Don't wait until day 30 to send this. Day 5 is fast enough that it doesn't feel aggressive, and early enough to intercept honest mistakes before they become habits.

**Stage 2 — Day 15 past due: Direct payment request**

If stage 1 produced no payment and no response, send a second message that is noticeably more direct. Name the invoice amount, name the due date it was late from, and ask for a specific response: either payment by a specific date, or a reason why it hasn't cleared.

This is also the right moment to get on the phone if the account is meaningful enough. An email can be ignored indefinitely. A brief call is harder to defer. You're not threatening anything yet — you're asking for confirmation of what's happening.

**Stage 3 — Day 30 to 45 past due: Soft hold on new orders**

If you've received no payment and no credible explanation after two follow-ups, pause new order processing until the outstanding balance is resolved.

This is the step most merchants skip because they're afraid of the relationship cost. The actual relationship cost of a clear hold is much lower than they expect — and much lower than the cost of processing more orders for an account that isn't paying for the ones they already have.

When you communicate the hold, be matter-of-fact. "We've paused new orders for your account while invoice [X] is outstanding. Once that's resolved, we're happy to process [their pending order] immediately." That's the whole message. Don't apologize. Don't hedge. The hold is a reasonable business response to unpaid terms.

Most buyers who hit a hold resolve it within five to seven days. They have a new order they actually need.

**Stage 4 — Day 45 to 60+: Escalate or negotiate**

By day 45 to 60, you're dealing with one of three situations: a buyer in genuine financial difficulty, a buyer who has decided not to pay, or a buyer who is disputing something about the invoice or the product.

Each requires a different response. A buyer in difficulty might warrant a payment plan if the relationship is valuable. Get the plan in writing, require an immediate partial payment to start it, and document the schedule clearly. A buyer who is unresponsive after repeated contact is heading toward formal collections or write-off. A buyer with a dispute needs that dispute resolved before anything else — not more collection pressure.

At this point, assess whether the outstanding balance justifies the cost of pursuing it. If it's under $5,000 and the buyer is unresponsive, the math on a collections agency is often questionable. If it's $15,000 or more, a contingency-fee attorney or collections agency typically earns their cut.

For amounts under your jurisdiction's small claims limit (often $10,000 to $25,000), small claims court is a real option. It's faster than you expect, costs very little to file, and the judgment record is often enough to motivate payment.

![Collections workflow timeline showing the four stages from day 5 reminder through escalation](/blog/20a-collections-workflow-timeline.svg)

## The structural problem: Shopify's static terms can't enforce themselves

A collections cadence handles accounts that have already gone past due. The bigger opportunity is preventing the same accounts from repeating the cycle.

Shopify Plus lets you set one payment term per company location. Net 30, Net 60, whatever you agreed to. That term doesn't change based on whether the buyer has paid on time before. If an account pays late three quarters in a row, they still get Net 30 on their next order — unless someone manually goes into the company location settings and changes it.

Nobody does that manually. So the same slow-paying accounts keep getting Net 30, keep paying at day 45, and the pattern compounds.

The fix is to encode terms logic that responds to behavior. The mechanic is customer tags.

## Using customer tags to automate tighter terms

Shopify's customer tagging system is simple and available across B2B. When an account goes past due, tag them — something like `slow-pay` or `past-due`. When they clear the balance and pay on time for a couple of cycles, remove the tag.

On its own, tagging does nothing. But combined with a Payment Customization Function, that tag becomes a checkout signal.

This is where Term Stack fits naturally. Term Stack is a rules engine that evaluates conditions at B2B checkout and applies the payment terms your rules specify. One of those conditions is a customer tag.

The rule looks something like this: if a buyer has the `slow-pay` tag, require a 30% deposit before the order processes, and reduce the net period from 30 days to 15. The rule runs automatically at checkout — no manual intervention, no remembering to update the company location settings.

When the account clears their past-due balance and comes back current, you remove the tag. The next order goes through at standard terms. The whole thing is self-correcting once you set it up.

![Past-due account rules engine flow showing tag-based checkout conditions and outcomes](/blog/20b-past-due-account-rules-flow.svg)

## What to stop doing

A few things that feel like collections process but aren't:

**Sending a third reminder email before calling.** Email is low-friction to ignore. If two emails haven't produced a payment or a response, a third one won't either. Call instead.

**Waiting until 60 days to put an account on hold.** By day 60, you've usually processed more orders for the account while the original invoice sat unpaid. You've increased your exposure and trained the buyer that your terms are soft. Day 30 to 45 is the right trigger for a hold.

**Customizing each follow-up.** Bespoke messaging per late account sounds relationship-forward but it's actually a way to defer the discomfort. Templated messages at set intervals are faster for you and clearer to the buyer. The clarity is part of what makes them effective.

**Accepting vague payment commitments.** "I'll look into it next week" is not a payment commitment. "I'll pay the $4,200 balance by June 20th" is. Press for specifics, and follow up if the specific date passes without payment.

## Preventing repeat past-dues: first-order deposits and graduated terms

The best collections process is one you rarely have to run. Two structural moves reduce late invoices significantly:

**Require a deposit on the first order.** A buyer who puts 30 to 50% down before their first order ships has demonstrated they can transact. A buyer who balks at a deposit before you've extended them any credit is giving you information worth having. First-order deposits also improve cash flow before fulfillment, reducing your exposure from day one.

**Earn-in to full terms.** Start new B2B accounts on Net 15 or Net 7 with a deposit. Move them to Net 30 after two or three invoices paid on time. This graduated approach matches the credit risk you're carrying at each stage of the relationship. Buyers who have demonstrated good payment behavior get better terms — that's the right incentive structure.

With Term Stack, these rules are checkout conditions. First order? Require a deposit and shorten the net period. Total orders greater than three and no past-due history? Apply standard Net 30 automatically. The logic runs at checkout and adjusts as the account's history changes.

## The right framing

Collections is uncomfortable because it feels like confrontation. It doesn't have to be.

A consistent, structured process signals to buyers that you take your payment terms seriously — and buyers who take their own commitments seriously respond well to that. The accounts that will be troubled by a clear process and a firm hold are the accounts you don't want on Net 30 anyway.

Tighten the terms structure, build a clear cadence, and enforce it consistently. That's not aggressive collections. That's running a business.
