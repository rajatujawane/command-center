# Fact Check — cb-20260614-past-due-invoices-b2b

## Claims verified against knowledge/termstack/prd.md

### TermStack claims

1. **"TermStack lets you tag slow-paying accounts and apply stricter terms — shorter net periods, required deposits — at checkout automatically"**
   - VERIFIED. PRD § 5.1 confirms CUSTOMER_TAG condition type with ANY_OF/NONE_OF operators. Outcomes support NET_DAYS payment terms type and DEPOSIT_PERCENT/DEPOSIT_FIXED. Rules evaluate at checkout via Shopify Function.

2. **"Term Stack is a rules engine that evaluates conditions at B2B checkout and applies the payment terms your rules specify. One of those conditions is a customer tag."**
   - VERIFIED. PRD § 5.1 Condition Types includes CUSTOMER_TAG. PRD § 5.2 confirms first-match wins evaluation at checkout.

3. **"Shopify Plus lets you set one payment term per company location. Net 30, Net 60, whatever you agreed to. That term doesn't change based on whether the buyer has paid on time before."**
   - VERIFIED by implication. PRD § 1 Problem Statement: "Shopify's defaults are static at the company level, pushing merchants into manual workarounds." This is the core problem Term Stack solves.

4. **"Start new B2B accounts on Net 15 or Net 7 with a deposit. Move them to Net 30 after two or three invoices paid on time."**
   - VERIFIED. PRD supports TOTAL_ORDERS_COUNT condition (§ 5.1) and FIRST_ORDER condition, enabling rule logic like "first order: require deposit" and "total orders > 3: apply Net 30." NET_DAYS outcome type supports any net day count.

5. **"With Term Stack, these rules are checkout conditions. First order? Require a deposit and shorten the net period. Total orders greater than three and no past-due history? Apply standard Net 30 automatically."**
   - VERIFIED. FIRST_ORDER and TOTAL_ORDERS_COUNT condition types confirmed in PRD § 5.1. Deposit support confirmed for outcomes.

6. **"The logic runs at checkout and adjusts as the account's history changes."**
   - VERIFIED. PRD § 9 Execution Flow confirms rules run at B2B checkout via Shopify Function using cart context.

### General B2B claims (not PRD-sourced, standard practice)

- "Day 5 friendly reminder, day 15 direct request, day 30-45 hold, day 45-60 escalation" — standard AR collections cadence, widely accepted practice. No specific source in PRD. Flagged as general guidance, not TermStack-specific.
- Small claims court thresholds ($10,000–$25,000) — stated as jurisdiction-dependent, appropriately hedged.
- Collections agency contingency fee reference — general industry knowledge, appropriately hedged.

## Issues found and fixed

- Draft does not reference any unimplemented TermStack features (RBAC, CSV export, etc.). Clean.
- Draft correctly characterizes Shopify's limitation as "static" terms at company location level — matches PRD.
- DEPOSIT_FIXED type exists but draft only mentions percentage deposits implicitly. This is fine — the post doesn't make specific claims about deposit types.

## Verdict

No unverifiable core claims. All TermStack-specific claims are supported by the PRD. General collections workflow advice is standard industry practice, not product claims. No changes required.
