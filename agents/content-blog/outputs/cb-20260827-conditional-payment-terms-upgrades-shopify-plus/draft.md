# Give Better Terms to Buyers Who Already Have Them: Conditional Upgrades on Shopify Plus

_Meta description: How to upgrade B2B buyers who already have Net 7-60 to Net 90 on larger orders on Shopify Plus, using their existing payment terms as a rule condition._

Slug: conditional-payment-terms-upgrades-shopify-plus

---

You already decided which buyers deserve credit. You set them up with Net 30, Net 60, whatever their account earned. So why does a trusted buyer with Net 30 get the exact same terms on a $200 reorder as they do on a $5,000 restock?

On Shopify Plus, payment terms are static. One term per company location, applied to every order, forever. There's no native way to say "this buyer already has terms, so give them more room on a bigger order." The account you already trust gets no reward for being a bigger, safer account today than they were when you set them up.

This post covers a pattern that fixes that: reading a buyer's existing payment terms and using it as the condition for a better one. If you want the broader picture first, the [complete guide to B2B payment terms on Shopify Plus](/blog/b2b-payment-terms-complete-guide) lays out the full framework.

## The idea: your existing terms are a signal

Here's the thing most merchants miss. The payment term a buyer already has is itself a piece of data about that account.

A buyer sitting on Net 60 has been through your credit process. A buyer with no terms at all hasn't, or didn't qualify. That distinction is useful, and Shopify already stores it. You just can't act on it at checkout.

So instead of treating the existing term as a fixed setting, treat it as a condition. "If this buyer already has Net 7 through Net 60, and this order is over $1,500, give them Net 90." Accounts with no terms don't match, so they're left exactly where they are. You're rewarding accounts that already earned trust, and only on orders big enough to matter.

## Why Shopify can't do this natively

Shopify Plus assigns payment terms at the company location level. You open a company location, pick a term, save. That term is now attached to every B2B checkout from that buyer.

Two problems make conditional upgrades impossible in that model:

- **Terms are static.** There's no logic layer. The term doesn't change based on order size, cart contents, or anything else about the specific checkout. It's a stored value, not a decision.
- **There's no reading of the current term at checkout.** Even if you wanted to branch on "does this buyer already have terms," native Shopify gives you nowhere to write that rule. Checkout applies the stored term and moves on.

The manual workaround is to keep two company locations per buyer, or to bump a buyer's term up before a big order and back down after. Nobody does that consistently. It drifts, and it's exactly the kind of thing that turns into a credit-risk problem six months later.

## The flagship pattern: upgrade earned accounts on large orders

This is the rule I'd set up first. Read on Shopify Plus using a Payment Customization Function that evaluates rules at checkout.

**Rule: reward trusted buyers on big orders**

Conditions: the buyer's existing payment terms are any of Net 7, Net 15, Net 30, Net 45, or Net 60, AND the order total is at least $1,500.
Outcome: Net 90.

Walk through what happens at checkout:

- A buyer with Net 30 places a $2,000 order. Both conditions match. They get Net 90 on this order.
- The same buyer places a $400 order. The order total condition fails. They keep their normal Net 30.
- A brand-new account with no terms places a $2,000 order. The existing-terms condition fails, because there's no term to match. They're excluded, and they check out on whatever your default is.

That last line is the important one. By making "already has Net 7-60" a required condition, accounts with no terms are excluded automatically. You never accidentally hand Net 90 to a buyer who hasn't been through credit. The upgrade only ever flows to accounts you already approved.

Because rules evaluate top-down and the first match wins, you can stack this above your normal terms. Put the upgrade rule at the top, your standard per-tier rules below it. Big orders from trusted buyers hit the upgrade and stop. Everything else falls through to the normal terms.

## The one honest caveat: the first sync

There's one thing to know. For a rule to read a buyer's existing terms, those terms have to be available to the checkout. The initial setup reads every buyer's current terms from Shopify once, when you first publish a rule that uses them. After that it stays current on its own as accounts change. You set it up once and don't think about it again.

That's the whole footnote. It's not a nightly export you babysit or a spreadsheet you re-upload.

## Two more patterns worth stealing

Once you can branch on existing terms, a few other policies get easy.

**Waive the deposit, but only for accounts that already have terms.** Say you normally require a 20% deposit on first orders. You'd like to waive it for established buyers, but not for unvetted new accounts. Make "already has Net 7-60" the condition for the waiver. Trusted accounts skip the deposit; no-terms accounts still pay it. This is the mirror image of the upgrade rule, and it uses the same signal. If you want the deposit mechanics in depth, see [dynamic payment terms and deposits on Shopify Plus](/blog/dynamic-payment-terms-deposits-shopify-plus).

**Run different policies for pay-on-fulfillment accounts vs. net-terms accounts.** Some buyers pay when the order ships. Others are on true net terms. Those are different risk profiles, and you might want different rules for each: tighter order caps on the pay-on-fulfillment group, more room for the net-terms group. Because the existing term is readable as a condition, you can target each group directly instead of managing them by hand.

**Layer it with order size.** The upgrade rule already combines existing terms with an order total threshold. You can push that further, different upgrade tiers at different order sizes, using the same building blocks. The [B2B payment terms by order value](/blog/b2b-payment-terms-by-order-value) post goes deep on order-total thresholds.

## When native Shopify isn't enough

Shopify Plus gives every buyer one static term. It can't read that term at checkout, can't branch on it, and can't upgrade an account conditionally based on it.

> TermStack is a no-code rules engine for Shopify Plus B2B. It reads a buyer's existing payment terms and seven other conditions at checkout, applies the right terms automatically, and keeps an immutable audit trail of every change.

TermStack runs as a Shopify Function, so rules evaluate at checkout inside Shopify's own infrastructure. No external calls, no checkout slowdown, and a Simulator to test a rule against a real buyer before you publish it.

## FAQ

**Can Shopify Plus give a buyer better payment terms based on the terms they already have?**
Not natively. Shopify Plus assigns one static payment term per company location and applies it to every order. It can't read that term at checkout and use it as a condition. To upgrade a buyer from Net 30 to Net 90 on a large order, you need a Payment Customization Function that reads the existing term. TermStack does this with a rules engine.

**How do you exclude accounts with no payment terms from an upgrade?**
Make "already has payment terms" a required condition on the rule. An account with no term assigned simply doesn't match, so it's excluded automatically and keeps checking out on your default. You don't maintain a separate list of who's eligible.

**Does the upgraded term stick to the buyer permanently?**
No. The upgrade applies at the checkout where the conditions match, for example an order over $1,500. On a smaller order the conditions don't match and the buyer checks out on their normal term. Their stored company-location term never changes.

**What happens on the first order after I set this up?**
The initial setup reads each buyer's current terms from Shopify once when you first publish the rule, then stays current automatically as accounts change. There's no ongoing export or manual refresh to manage.

**Can I combine existing terms with order total and other conditions?**
Yes. All conditions in a rule use AND logic, so every one must match for the rule to fire. The flagship pattern combines existing terms with an order total threshold. You can also add company, customer tag, first order, and order count conditions.

**Does this work on non-Plus plans?**
No. Payment Customization Functions, the Shopify API that powers dynamic terms at checkout, are Shopify Plus only. Non-Plus merchants can't apply or modify payment terms at checkout. For the full breakdown, see native vs. app for B2B payment terms.

## Summary

Your buyers already told you who they are. The term you assigned each account is a signal you paid to generate, through your credit process, and Shopify just lets it sit there. Reading that term as a condition means trusted accounts get more room on the orders that matter, and unvetted accounts stay exactly where they are, with no manual review per checkout.

TermStack makes this configurable without code: set the upgrade rule, test it in the Simulator, publish when it looks right.
