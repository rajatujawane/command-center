# QA Image — cb-20260614-past-due-invoices-b2b

## Hero: 20-hero-past-due-invoices-b2b.svg

- Background: #F5F0E6 cream. PASS
- Two-tone title: "Past / Due" ink, "Invoices" violet. PASS
- Font sizes used: 135, 60, 28, 18, 15, 13, 12. All allowed. PASS
- Left column overflow: "Past" at 135px is 4 chars (~300px), well within 530px limit. PASS
- Right column card: x=540 to x=1140 (540+600). Within bounds. PASS
- UI mock: conditions table, outcome field with violet border, Save rule button in violet. PASS
- No status pills, no browser chrome, no date/read-time text. PASS
- Bottom timeline strip: 4 stages with correct semantic colors (ink, amber, red, violet). PASS
- Watermark: VarrLabs bottom-right at x=1140 y=608. PASS
- One fix applied: removed redundant second-rule row that overlapped the Save button. Fixed by removing the row and placing the Save button cleanly below the outcome field.

## Inline 1: 20a-collections-workflow-timeline.svg

- Background: #F5F0E6 cream. PASS
- Title centered, 30px Inter 700. PASS
- Hairline at y=140. PASS
- 4 stage cards in white (#FFFFFF) on cream, with #DDD2B8 borders. PASS
- Accent lines use semantic colors: green (Day 5, most resolve), amber (Day 15, caution), red (Day 30-45, hold), violet (Day 60+). PASS
- Card text uses #5C5046 (muted on white). PASS
- All content within x=80–1120. Card at x=881 width=239 → right edge 1120. PASS
- Watermark at x=1140 y=655. PASS

## Inline 2: 20b-past-due-account-rules-flow.svg

- Background: #F5F0E6 cream. PASS
- Title centered, 30px Inter 700. PASS
- Hairline at y=140. PASS
- Flow steps on left in white cards with correct borders. PASS
- TermStack rule card on right in white with violet-bordered outcome field. PASS
- Recovery note card at bottom. PASS
- All content within x=80–1120. PASS
- Watermark at x=1140 y=655. PASS

## Result: PASS — no further fixes needed. All three images use light editorial theme, correct color tokens, VarrLabs watermark bottom-right.
