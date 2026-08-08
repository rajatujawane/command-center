# QA image — cb-20260802-schedule-blog-posts-webflow-step-by-step

Rendered both SVGs to PNG (Chrome headless, exact viewBox size) and viewed them.
Note: qlmanage pads to a 1200x1200 square, which falsely looks like a right-side crop; the
true-size Chrome render is what was inspected.

## Hero — main-site/public/blog/schedule-blog-posts-webflow-step-by-step.svg (1200x630)
- Two-tier title reads cleanly: "Schedule" (ink) / "Webflow" (violet gradient) / "blog posts"
  (ink) / "Step by step." (muted). No overflow past the left column.
- Right column: Product UI mock (Option 1) — white card, soft drop shadow, violet backdrop
  rect behind it. Fields: What = "Monday launch post", Date & time = "Mon, Aug 11 · 9:00 AM"
  (violet focal border/value), Action = "Publish", filled violet "Schedule publish" button.
- No timezone field (compliant), no status pills, no browser chrome, no date/read-time text,
  no mono kicker. Watermark "PublishPilot" two-tone bottom-right.
- Legible and on-brand. No fix required.

## Inline — main-site/public/blog/schedule-blog-posts-webflow-step-by-step-two-schedules.svg (1200x520)
- Type C flow: "Schedule the post" (CMS item publish, Mon Aug 11 9:00 AM) -> "Schedule the
  site" (full-site publish) -> green-bordered outcome box "Post lands correctly". Violet accent
  lines below the first two headers; outcome box uses border color as the signal (no interior
  accent line, per rule). Arrows violet-headed.
- All text within margins, no overflow, watermark present. Legible and on-brand. No fix required.

## Result
Both images pass on the first view. 0 of the allowed 2 fix rounds used. Proceed to commit.
