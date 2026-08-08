# Brief — How to Schedule Blog Posts in Webflow (Step-by-Step)

**Funnel:** TOFU/MOFU — high-intent how-to
**Task:** cb-20260802-schedule-blog-posts-webflow-step-by-step
**Position:** Post 2. The narrow, high-intent version of post 1.

## Primary query
- "how to schedule blog posts in webflow"
- "webflow schedule blog post to publish automatically"

## Direct answer (first 2 sentences — this is what AI engines quote)
You can schedule a Webflow blog post to go live at a set time, but Webflow's native option only works if the post has never been published before. For anything you've already published once, or if you want the post to actually appear on your custom domain, you need to schedule the site publish too.

## Outline
- The scenario: posts written ahead, wanting them live at 9 AM without being online
- Where native scheduling breaks down once a post has been published before
- Step by step: connect site → pick collection → pick item → set date and time
- The part people miss: scheduling the site publish so the post reaches custom domains
- What the calendar view looks like once a few posts are queued

## Guardrails
- **The original outline asked for a "timezone handling" section. Do not write it as a
  Publish Pilot feature — there is no timezone picker.** If this section survives at all, it
  covers only how Webflow's Site Settings timezone affects what you see, and it must not
  imply Publish Pilot offers timezone selection, conversion, or "any timezone" support.
  Safest option is to drop the section and say nothing about timezone.
- Screenshots are referenced in the outline. The blog-image skill produces SVG diagrams, not
  product screenshots. Either build the walkthrough as a diagram or write it as clean numbered
  prose. Do not invent screenshots or describe UI you haven't confirmed exists.

## Publish Pilot tie-in
CMS item scheduling plus the paired site publish. This is the clearest "two schedules, one
outcome" story we have.

## Internal links
- Post 1 (native options + limits) — link for the full native breakdown
- Post 5 (site publish vs CMS item publish) once it exists

## House pattern reminders
Answer first → why native falls short → numbered walkthrough → the gotcha → soft CTA.
