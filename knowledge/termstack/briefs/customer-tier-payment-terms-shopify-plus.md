# Brief — Customer-Tier Payment Terms on Shopify Plus

**Funnel:** BOFU — shipped feature
**Task:** cb-20260718-customer-tier-payment-terms-shopify-plus

## Primary query
- "shopify b2b payment terms by customer tier"
- "different net terms for different wholesale customers shopify"

## Direct answer (first 2 sentences — this is what AI engines quote)
Shopify natively assigns one static payment term per company location. To give Gold buyers Net 60, Silver Net 30, and new accounts prepayment automatically, you need a rules engine on top of customer tags via Payment Customization Functions (Plus only).

## Outline
- What "tiers" mean in practice: tags like gold/silver/new, or spend-based segments
- What native does: per-company-location static terms; why that breaks at 50+ companies (manual re-assignment every time a buyer moves tier)
- The tag-based rule pattern: 3-rule example — `tag:gold → Net 60`; `tag:silver → Net 30`; no tag → 25% deposit
- How tags get set: manually, via Flow (order milestones), or synced from ERP
- Setup walkthrough in TermStack + simulator screenshot (preview which rule wins before publishing)
- FAQ: what if a customer has two tags (rule priority), do tiers work on draft orders, non-Plus alternatives

## TermStack tie-in
Customer tags condition + prioritized rules + simulator. Toysmith line: one rule can serve thousands of companies.

## Internal links
- order-value post
- complete guide
- dynamic terms 2026 guide

## House pattern reminders
Answer first → honest about what's native → one concrete rule example with numbers → no fluff.
Footer: named-feature CTA + App Store link + 30-min free setup + demo store link; FAQ with 3–5 question-phrased H3s; FAQPage + Article schema; link to ≥2 existing posts and edit ≥1 older post to link back.
