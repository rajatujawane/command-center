---
title: "Payment Terms for Toy and Gift Wholesalers on Shopify"
date: "2026-08-13"
description: "How toy and gift wholesalers structure net terms, seasonal dating, and deposits at Shopify Plus B2B checkout without carrying more credit risk than they should."
coverImage: "/blog/30-hero-toy-gift-wholesalers-payment-terms.svg"
tags: ["Shopify Plus", "B2B", "Payment Terms", "Wholesale", "Toy & Gift"]
author: "Varr Labs"
tldr:
  - "Toy and gift wholesale runs on seasonal buying: retailers write orders in spring for fall delivery and expect dating, so you carry the credit for months."
  - "Four rules cover most of the vertical: prepay on first orders, a deposit ceiling on very large orders, seasonal Net 60 dating for tagged accounts, and Net 30 for everyone else."
  - "Shopify Plus has no payment term tied to a delivery date, so holiday dating is driven by a customer tag or a seasonal collection, not a calendar."
  - "One set of prioritized rules governs thousands of small retail accounts, evaluated at checkout instead of set by hand per company."
  - "TermStack applies these rules at Shopify's native B2B checkout, with a simulator to test each rule before your spring buy and one-click rollback."
faq:
  - q: "What payment terms do toy and gift wholesalers usually offer?"
    a: "Standard trade is Net 30 for established stockists. The vertical's defining feature is seasonal dating: orders written in spring for fall delivery get extended terms like Net 60 or Net 90 so the retailer pays closer to when they sell. New stockists are usually asked for a deposit or prepayment on their first order until they have built a payment history."
  - q: "Can you offer seasonal holiday dating terms to retailers on Shopify?"
    a: "Yes, but not with a date. Shopify Plus has no payment term that keys off a delivery date, so you drive dating with a customer tag applied to accounts in your spring buy, or with a seasonal collection. A rule then applies Net 60 or Net 90 to any order carrying that tag or those products, evaluated at checkout."
  - q: "How do you handle net terms for thousands of small retail accounts?"
    a: "Not one setting per company. A small set of prioritized rules keyed to conditions like first order, order value, and account tag governs the entire base. The rules evaluate top down at checkout and the first match wins, so thousands of accounts run on a handful of lines of policy instead of a spreadsheet."
  - q: "Can Shopify require a deposit from first-time wholesale buyers automatically?"
    a: "Not natively. Shopify Plus payment terms are static and set once per company location, so a first order gets whatever the account was assigned. A Payment Customization Function can check whether it is the buyer's first order at checkout and apply a deposit. TermStack does this with a rule, so new stockists prepay without anyone flagging the account by hand."
  - q: "Does Shopify have a payment term for a specific delivery date?"
    a: "No. There is no native condition for a delivery or ship date, and a Shopify Function cannot look one up at checkout. Holiday dating is handled by tagging the accounts or products you want to extend terms to, then writing a rule against that tag or collection. It is the honest limitation to design around, not a gap in any app."
  - q: "Is dynamic payment terms setup available on Shopify plans below Plus?"
    a: "No. B2B companies, company locations, and payment terms are Shopify Plus features, and Payment Customization Functions are Plus only. On a lower plan there is no B2B checkout context for a rule to evaluate, so the whole approach needs Plus."
  - q: "How do I test payment terms rules before my spring buy without breaking checkout?"
    a: "Use a simulator. In TermStack you build a test order for each scenario, a new stockist, a large order, a tagged dating account, and confirm which rule fires before you publish. Every change is versioned with one-click rollback, so if a rule is too generous you revert it and the old policy is live again at the next checkout."
---

# Payment Terms for Toy and Gift Wholesalers on Shopify

Toy and gift wholesale runs on seasonal buying cycles. Retailers write their orders deep in spring for fall delivery, they expect dating on those orders, and you carry the credit for months before the goods even ship.

That makes net terms a core part of how the vertical works, not a nice-to-have. If you sell toys and gifts wholesale on Shopify Plus, the question isn't whether to offer terms, it's how to structure them so you protect cash without losing accounts to a competitor who says yes faster.

This post covers the term structures that fit toy and gift wholesale, a four-rule recipe you can copy with real numbers, and how the same handful of rules governs thousands of small retail accounts at Shopify's native B2B checkout.

## What makes toy and gift wholesale different

Most B2B payment advice assumes a steady reorder business: the same buyers, ordering the same volume, month after month. Toy and gift doesn't work like that.

**Seasonal buying.** The calendar is front-loaded. A large share of the year's orders land in a spring buying window for holiday delivery. Retailers commit early, in volume, for stock they won't sell until Q4. Nobody expects to pay for a spring order on spring terms.

**Dating programs.** Because of that gap between order and sell-through, extended dating is the norm. A retailer who orders in March for October delivery might get Net 60 or Net 90 from delivery, so their payment lands closer to when the register rings. Dating is the single biggest reason your credit exposure in this vertical is bigger than your revenue would suggest.

**Thousands of small accounts.** The typical toy and gift wholesaler sells to a long tail of independent shops, museum stores, garden centers, and gift boutiques. That means high account counts and low average order values, which is the exact opposite of a business you can manage account by account.

**New stockists constantly.** Independent retail turns over. You're always onboarding shops with no payment history, and a first order to an unknown store is the riskiest credit you extend all year.

Put those together and you get a business where terms have to be generous enough to win the buy, tight enough to survive the carry, and automatic enough to run across thousands of accounts without a person in the loop.

## The term structures that fit the vertical

Four structures cover almost everything toy and gift wholesalers actually do.

| Structure | What it means | Where it fits |
|---|---|---|
| **First-order prepay** | A deposit or full prepayment on a buyer's first order | New stockists with no history |
| **Standard Net 30** | Full payment 30 days after invoice | Established accounts, in-season reorders |
| **Seasonal dating** | Net 60 or Net 90 on the spring buy | Holiday orders written months before delivery |
| **Large-order deposit** | A deposit on any order above a threshold | One oversized invoice from any account |

The art is in when each one fires. A new stockist placing a huge holiday order should hit the prepay rule, not the dating rule. An established account's normal restock should get Net 30, but the same account's five-times-normal seasonal order should probably carry a deposit. You can't express that with a single static term per company, which is where a rule order comes in.

## The four-rule recipe, with actual numbers

Here's a starting recipe. Adjust the thresholds to your margins and your cash cycle, but keep the order, because rules evaluate top down and the first match wins.

![Four prioritized B2B payment terms rules for a toy and gift wholesaler: first order prepay, large order deposit ceiling, seasonal Net 60 dating for tagged accounts, and standard Net 30 for everyone else](/blog/30a-toy-gift-rules-recipe.svg)

1. **First order, apply a 50% deposit.** The buyer's first order gets a deposit before anything ships. This is your new-stockist protection, and it applies no matter how large or small that first order is. For the reasoning behind prepaying unknown buyers, the [first-time buyer prepayment post](/blog/require-prepayment-first-time-b2b-buyers-shopify) goes deeper.
2. **Order total is $25,000 or more, apply a 50% deposit.** A ceiling that catches any unusually large order, even from a trusted account. One order that's five times a buyer's normal size is a different risk than their weekly restock, and it should be treated like one. The [payment terms by order value post](/blog/b2b-payment-terms-by-order-value) covers where to set this line.
3. **Account is tagged for seasonal dating, apply Net 60.** Your spring-buy accounts carry a dating tag, and this rule gives them extended terms on the holiday order. Put it below the deposit rules so a first order or an oversized order still gets a deposit even during dating season.
4. **Account has at least one previous order, apply Net 30.** The catch-all for established accounts placing normal in-season orders. A rule needs at least one condition, so this leans on a real signal, an account with a prior order, rather than an empty fallback. If you'd rather not write it as a rule at all, set Net 30 as your store-level default term and let any order that matches nothing land there.

A first-time buyer hits rule one and stops. A trusted account placing a $40,000 holiday order hits rule two and puts down a deposit. A tagged account placing a normal spring order falls to rule three and gets Net 60 dating. Everybody else lands on Net 30. Four rules, thousands of accounts, no manual sorting.

If you want terms that climb as an account proves itself across seasons, you can layer an [order-count graduation ladder](/blog/graduate-b2b-payment-terms-by-order-count) on top, or split your base by [customer tier](/blog/b2b-payment-terms-by-customer-tier-shopify-plus) for accounts that have negotiated their own terms.

## Seasonal dating without a delivery date

Here's the honest limitation to design around: Shopify Plus has no payment term that keys off a delivery or ship date. A Shopify Function evaluates the cart at checkout, and there's no native condition for "deliver in October, pay in December."

So you don't drive dating with a date. You drive it two ways:

- **A customer tag.** Tag the accounts in your spring buy with something like `holiday-dating-2026`. The rule applies Net 60 to any order carrying that tag. When the dating window closes, you remove the tag and those accounts fall back to Net 30 on their next order.
- **A seasonal collection.** If your holiday range is a distinct set of products, put them in a collection and write the rule against that collection. Any cart with those products gets the extended terms.

Both are cleaner than they sound, and both are honest about what Shopify can and can't do. The rule evaluates at checkout in under 5 milliseconds with no external lookup, so it holds up under a spring-buy traffic spike.

## How this looks across thousands of accounts

The reason this works is that the policy is expressed once, not per company.

A US toy and gift wholesaler we work with sells to thousands of independent and specialty retailers on Shopify Plus native B2B. They don't have a payment term set on each company. They have a small set of prioritized rules, keyed to conditions like first order, order value, and account tag, and those rules govern the entire base. The full story is in the [toy and gift wholesaler case study](/blog/b2b-payment-terms-case-study-toy-gift-wholesaler), including what they replaced to get there.

That's the shift. Native Shopify wants one static term per company location. A rules engine lets you write policy the way you actually think about it, in a handful of lines, and apply it to every buyer at checkout.

## How you'd do this natively, and where it breaks

Shopify Plus lets you assign a payment term per company location. Go to **Customers → Companies → [Company] → Location**, pick a template like Net 30 or Net 60, optionally set a deposit percentage, and save. That's the whole native feature, and it's a static assignment that applies to every order from that location until a person changes it.

For a steady reorder business, that's fine. For toy and gift wholesale, it breaks in three places:

- **First orders.** Nothing checks whether it's a buyer's first order, so a new stockist gets whatever the account was set to when it was created. To prepay new stockists, someone has to remember to set tight terms on every new account and loosen them later.
- **Seasonal dating.** Extending Net 60 to your spring-buy accounts means editing every one of those company locations by hand, then editing them all back when the window closes. Across thousands of accounts that's not a task, it's a season.
- **Large-order ceilings.** A static term can't say "Net 30 normally, but a deposit on anything over $25,000." The term doesn't know the order total. So the oversized order ships on the same terms as the small one.

The [native versus app comparison](/blog/shopify-b2b-payment-terms-native-vs-app) walks through the full boundary of what Shopify does on its own.

## Common mistakes to avoid

A few things worth getting right before your spring buy.

**Ordering the rules wrong.** First match wins, so a dating rule above your deposit rules will hand Net 60 to a first-time buyer's holiday order. Deposits go on top, dating below, catch-all last.

**Forgetting to remove the dating tag.** If dating is tag-driven and you never untag, those accounts stay on Net 60 into the next year. Build the untag into your post-season close, or scope the tag to a year so it reads as expired.

**No ceiling on the top rung.** Established accounts on Net 30 or Net 60 dating still need an order-value ceiling above them, or one unusually large invoice goes out on unsecured credit. Rule two exists for exactly this.

**Testing in production.** These rules touch checkout during your highest-volume window. Test each scenario in a simulator before you publish, not on a live spring-buy order.

## When native Shopify isn't enough

Everything above, first-order prepay, seasonal dating, large-order ceilings, is something a static per-company term structurally can't do. There's no evaluation step in native terms, so there's nothing to attach a condition to. You change the stored value or you don't.

<div style={{backgroundColor: '#f5f3ff', border: '1px solid #c4b5fd', borderLeft: '4px solid #7C3AED', borderRadius: '8px', padding: '1rem 1.25rem', margin: '1.5rem 0'}}>
  <strong style={{color: '#5b21b6'}}>Run your whole terms policy as rules, before the spring buy hits.</strong><br/>
  <span style={{color: '#374151', fontSize: '0.95rem'}}><a href="https://apps.shopify.com/termstack" style={{color: '#7C3AED', fontWeight: '600', textDecoration: 'underline'}}>TermStack</a> checks first order, order value, tags, and collections at checkout and applies the right term or deposit automatically, with a simulator to test each rule and one-click rollback if it's too generous. <a href="https://apps.shopify.com/termstack" style={{color: '#7C3AED', fontWeight: '600', textDecoration: 'underline'}}>Try TermStack free for 14 days →</a></span>
</div>

A Payment Customization Function adds the evaluation step native terms are missing. It runs at checkout, inside Shopify's own performance budget, with no external API call. First order, order total, customer tag, collection, company location, and the buyer's existing Shopify-assigned terms are all available as conditions, and you combine them into the policy you actually run.

## Quick reference

| Rule (in order) | Condition | Applied term |
|---|---|---|
| 1 | First order | 50% deposit |
| 2 | Order total ≥ $25,000 | 50% deposit |
| 3 | Account tagged for dating | Net 60 |
| 4 | Has at least 1 previous order (or store default) | Net 30 |

## Frequently asked questions

<BlogFaq>

<BlogFaqItem question="What payment terms do toy and gift wholesalers usually offer?">
Standard trade is Net 30 for established stockists. The vertical's defining feature is seasonal dating: orders written in spring for fall delivery get extended terms like Net 60 or Net 90 so the retailer pays closer to when they sell. New stockists are usually asked for a deposit or prepayment on their first order until they have built a payment history.
</BlogFaqItem>

<BlogFaqItem question="Can you offer seasonal holiday dating terms to retailers on Shopify?">
Yes, but not with a date. Shopify Plus has no payment term that keys off a delivery date, so you drive dating with a customer tag applied to accounts in your spring buy, or with a seasonal collection. A rule then applies Net 60 or Net 90 to any order carrying that tag or those products, evaluated at checkout.
</BlogFaqItem>

<BlogFaqItem question="How do you handle net terms for thousands of small retail accounts?">
Not one setting per company. A small set of prioritized rules keyed to conditions like first order, order value, and account tag governs the entire base. The rules evaluate top down at checkout and the first match wins, so thousands of accounts run on a handful of lines of policy instead of a spreadsheet.
</BlogFaqItem>

<BlogFaqItem question="Can Shopify require a deposit from first-time wholesale buyers automatically?">
Not natively. Shopify Plus payment terms are static and set once per company location, so a first order gets whatever the account was assigned. A Payment Customization Function can check whether it is the buyer's first order at checkout and apply a deposit. <a href="https://apps.shopify.com/termstack" style={{textDecoration: 'underline'}}>TermStack</a> does this with a rule, so new stockists prepay without anyone flagging the account by hand.
</BlogFaqItem>

<BlogFaqItem question="Does Shopify have a payment term for a specific delivery date?">
No. There is no native condition for a delivery or ship date, and a Shopify Function cannot look one up at checkout. Holiday dating is handled by tagging the accounts or products you want to extend terms to, then writing a rule against that tag or collection. It is the honest limitation to design around, not a gap in any app.
</BlogFaqItem>

<BlogFaqItem question="Is dynamic payment terms setup available on Shopify plans below Plus?">
No. B2B companies, company locations, and payment terms are Shopify Plus features, and Payment Customization Functions are Plus only. On a lower plan there is no B2B checkout context for a rule to evaluate, so the whole approach needs Plus.
</BlogFaqItem>

<BlogFaqItem question="How do I test payment terms rules before my spring buy without breaking checkout?">
Use a simulator. In TermStack you build a test order for each scenario, a new stockist, a large order, a tagged dating account, and confirm which rule fires before you publish. Every change is versioned with one-click rollback, so if a rule is too generous you revert it and the old policy is live again at the next checkout.
</BlogFaqItem>

</BlogFaq>

## Summary

Toy and gift wholesale is a credit business wearing a product business. Seasonal dating, constant new stockists, and thousands of small accounts mean your terms have to be generous, safe, and automatic all at once, and a static term per company can only ever be one of those.

Four rules cover most of it: prepay the first order, put a deposit ceiling on very large orders, extend Net 60 dating to your tagged spring-buy accounts, and drop everyone else onto Net 30. Order them deposits first, dating below, catch-all last, and test each one in a simulator before the buy.

<a href="https://apps.shopify.com/termstack" style={{textDecoration: 'underline'}}>TermStack</a> gives you those conditions, the simulator, the version history, and the audit trail in one place, so the policy that runs your busiest season is something you can defend rather than something living in a spreadsheet. If you're heading into a spring buy, this is the setup to have in place before the orders start landing.

<div style={{textAlign: 'center', marginTop: '2rem'}}>
  <a href="https://apps.shopify.com/termstack" style={{display: 'inline-block', padding: '0.75rem 2rem', backgroundColor: '#0f172a', color: 'white', borderRadius: '9999px', fontWeight: 700, fontSize: '0.875rem', textDecoration: 'none'}}>Try TermStack free for 14 days →</a>
</div>
