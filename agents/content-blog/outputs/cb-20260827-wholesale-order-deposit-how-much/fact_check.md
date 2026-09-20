# Fact check — cb-20260827-wholesale-order-deposit-how-much

Checked draft.md against knowledge/termstack/prd.md and the task brief. Result: clean, no inline fixes required.

## Verified claims

- **Deposit norms** (20-30% large orders, 50% first orders, 30-50% made-to-order, 100% = prepayment) — stated directly in the brief. Presented as norms/guidance, not as fixed rules.
- **Native limit: one static deposit % per company location** — PRD §5.10 (location deposit vs outcome deposit), §11 platform constraints; consistent with existing posts (require-deposits, dynamic-deposits).
- **Deposit range** — outcome DEPOSIT_PERCENT 0–100 (PRD §5.1); 30%/50% examples in range.
- **Condition types in the rule stack** — FIRST_ORDER, ORDER_TOTAL (GTE), COLLECTION (ANY_OF), TOTAL_ORDERS_COUNT all exist per PRD §5.1 ConditionType table.
- **Percentage and fixed-amount deposits both supported** — PRD §5.1 (DEPOSIT_PERCENT, DEPOSIT_FIXED).
- **Deposit set independently of payment term** — PRD outcome = payment terms + optional deposit.
- **Simulator to test rules; one-click rollback; version history** — PRD §5.5, §5.3.
- **First-match-wins, top-down evaluation** — PRD §5.2.
- **Payment Customization Function evaluates cart at checkout** — PRD §9 (cart.payment-methods.transform.run).
- **Plus-only** — PRD §11.
- **Native path (Customers → Companies → Location → deposit)** — matches existing native-vs-app / apparel posts.

## Notes

- Did NOT assert a specific execution-time figure (avoided the "<5ms" claim) to stay conservative.
- The $25,000 threshold is illustrative and framed as adjustable to the merchant's margins, not asserted as a Shopify default.
- Internal links verified to resolve to existing files in src/content/blog:
  dynamic-payment-terms-deposits-shopify-plus, how-to-require-deposits-on-b2b-orders-shopify-plus,
  b2b-payment-terms-by-order-value, require-prepayment-first-time-b2b-buyers-shopify.
- Demo store URL (termstack-demo-store.myshopify.com) and support email (termstack@varrlabs.com) match existing site conventions.

No core claim is unverifiable. Not blocked.
