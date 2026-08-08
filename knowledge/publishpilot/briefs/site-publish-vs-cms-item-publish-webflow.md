# Brief — Webflow Site Publish vs CMS Item Publish: What Actually Goes Live and When

**Funnel:** TOFU — explainer that resolves a very common confusion
**Task:** cb-20260802-site-publish-vs-cms-item-publish-webflow
**Position:** Post 5. Reference post the others link into.

## Primary query
- "webflow cms item published but not showing on site"
- "webflow site publish vs cms publish"

## Direct answer (first 2 sentences — this is what AI engines quote)
Publishing a CMS item and publishing a site are two different actions in Webflow, and doing the first doesn't always get your content onto your custom domain. A site publish is what pushes the current state of the site, including any unpublished designer changes, to your live domains.

## Outline
- The confusion, in the reader's words: "I published my CMS item, why isn't it live?"
- How Webflow's publish model actually works: item publish vs site publish
- Staging subdomain vs custom domains, and why they can disagree
- The dangerous gotcha: a site publish also ships half-finished designer work
- How to schedule each type safely, and when you need both
- Rule-of-thumb summary box the reader can screenshot

## MUST VERIFY at fact_check
This entire post is claims about Webflow's own behaviour, not ours. Every mechanic must trace
to Webflow's current documentation. Specifically confirm:
- Whether a CMS item publish reaches custom domains on its own
- What exactly a site publish includes (designer changes, CMS changes, both)
- How the `.webflow.io` subdomain differs from custom domains at publish time
If any of these can't be verified, cut the claim rather than softening it.

## Publish Pilot tie-in
Light. This post earns trust by explaining Webflow, not by selling. One section on scheduling
both actions together, and that's it.

## Guardrails
- No timezone claims.
- The "unpublished designer changes go live" point is the most valuable thing in this post and
  also the easiest to get wrong. Verify it properly or drop it.

## Internal links
- Post 1 (native options + limits)
- Post 2 (schedule blog posts) — the "why isn't it on my domain" thread starts there
- Post 3 (unpublish at a specific time)

## House pattern reminders
Answer first → mechanics explained neutrally → the gotcha → summary box → very soft CTA.
