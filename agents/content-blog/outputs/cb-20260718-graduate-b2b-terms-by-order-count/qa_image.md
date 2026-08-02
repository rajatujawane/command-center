# QA image — cb-20260718-graduate-b2b-terms-by-order-count

Rendered both SVGs headless (Chrome, exact viewBox dimensions) and viewed them.
`qlmanage` was tried first but only produces square thumbnails, which crops the right column,
so the check was redone at 1200×630 and 1200×680.

## Hero — `public/blog/27-hero-graduate-b2b-terms-by-order-count.svg`

Right-column visual: Option 1, product UI mock. Chosen because this is a rule-configuration
article. Bottom timeline strip included (Order 1 → Order 10) because the post has a genuine
sequence angle.

| Check | Result |
|---|---|
| Cream `#F5F0E6` background, no grid / glow / accent bar | Pass |
| Hook "B2B" at 135px, ≤6 chars, violet; context lines at 60px, ≤13 chars | Pass |
| Left column stays inside x=530 ("Payment Terms" is the widest at ~509) | Pass |
| Subtitle 28px muted, 14 chars | Pass |
| UI mock inside x=550–1130, drop shadow, filled violet "Save rule" button | Pass |
| Condition values (`≥ 2`, `< $25,000`) render fully, not clipped | Pass |
| Chevron sits inside the select field | Pass |
| Timeline labels legible, dashed line broken cleanly by the cream label rect | Pass |
| Watermark "VarrLabs" bottom-right, two-tone | Pass |
| No date, read-time, mono kicker, status pill or browser chrome | Pass |
| Only allowed font sizes (11,12,13,15,18,28,60,135) | Pass |

## Body image — `public/blog/27a-order-count-graduation-ladder.svg`

Type B, three-column framework: one card per rung of the ladder.

| Check | Result |
|---|---|
| Cream background matching the hero | Pass |
| Title 30px centered (32 chars), subtitle 15px muted (76 chars), hairline at y=150 | Pass |
| Three white `#FFFFFF` cards with `#DDD2B8` borders, inside x=80–1120 | Pass |
| Accent lines sit 16px below the header baseline, no strikethrough effect | Pass |
| Semantic colours carry meaning: amber = tightest rung, violet = standard, green = most generous | Pass |
| Body text inside cards uses `#5C5046`, wrapped within the 282px interior | Pass |
| Card content ends well inside the 380px card height | Pass |
| Watermark bottom-right | Pass |

## Result

Pass on the first render. No regeneration needed.

Also verified: `npm run build` succeeds and `/blog/graduate-b2b-payment-terms-by-order-count`
appears in the generated route list.
