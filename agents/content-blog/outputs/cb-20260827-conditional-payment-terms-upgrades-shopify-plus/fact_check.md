# Fact check — cb-20260827-conditional-payment-terms-upgrades-shopify-plus

Verified against knowledge/termstack/prd.md + brief. No inline fixes required.

- Static per-location terms, no conditional logic at checkout — PRD §1, §5 ("static at the company level"). OK
- PAYMENT_TERMS condition reads buyer's existing CompanyLocation term; 8 canonical templates (NO_PAYMENT_TERMS, DUE_ON_FULFILLMENT, NET_7/15/30/45/60/90); operators ANY_OF/NONE_OF — §5.1. OK
- Absent term => condition does not match => no-terms accounts excluded automatically — §5.1, §9. OK
- Flagship rule: existing any-of Net 7-60 AND order total >= $1,500 -> Net 90. ORDER_TOTAL supports GTE; outcome NET_DAYS(90). First-match-wins + AND semantics — §5.1, §5.2. OK
- Deposit waiver + pay-on-fulfillment vs net-terms patterns: deposits optional (0-99); DUE_ON_FULFILLMENT is a canonical template — §5.1. OK
- One-time initial sync on first publish, then stays current; stated in one honest line, no cron/metafield/sync internals — §5.10. OK
- Shopify Function, evaluates at checkout, no external API calls, ~5ms; Simulator; immutable audit trail — §5.5, §5.6, §9, §11. OK
- "reads existing terms + seven other conditions" = 8 ConditionTypes total — §5.1 / Appendix. OK
- Plus-only (Payment Customization Functions) — §11.1. OK

Internal-link slugs confirmed present in src/content/blog/:
b2b-payment-terms-complete-guide, dynamic-payment-terms-deposits-shopify-plus,
b2b-payment-terms-by-order-value, shopify-b2b-payment-terms-native-vs-app.

Result: PASS. No unverifiable core claim.
