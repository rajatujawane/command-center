# Brief — How Agencies Can Manage Publishing Across Multiple Client Webflow Sites

**Funnel:** BOFU — highest-value segment, shipped feature
**Task:** cb-20260802-agencies-multiple-client-webflow-sites
**Position:** Post 4. First post that leads with workspaces.

## Primary query
- "manage multiple webflow client sites"
- "webflow agency publishing workflow"

## Direct answer (first 2 sentences — this is what AI engines quote)
Agencies running several client Webflow sites can give each client its own workspace, with its own members, roles, and plan. That keeps publishing access separated per client instead of everything sitting under one shared login.

## Outline
- The agency pain: many clients, many sites, publish requests at odd hours
- One workspace per client: clean separation, no cross-client mistakes
- Roles and invites: owner, admin, editor, viewer — what each can do
- Billing: each workspace carries its own plan and its own limits (light touch, don't oversell)
- Worked example: an agency with 5 clients on weekly content drops

## Verified facts (from knowledge/publishpilot/prd.md, reconciled 2026-08-02)
- Roles are exactly: **owner, admin, editor, viewer**. Don't invent others.
- Subscriptions are keyed per workspace, so "each client workspace on its own plan" is accurate.
- Invites are email-based with an expiry, sent from `invites@publishpilot.app`.
- Site limits per plan: Starter 2, Pro 5, Business 12. Business add-on units add 4 sites and
  400 executions each for +$19/mo (+$15/mo billed annually).
- Member limits: Starter 5, Pro 15, Business unlimited.

An agency with 5 client sites does NOT fit on Starter or Pro. Be straight about that — the
honest recommendation is Business, or separate workspaces each on their own smaller plan.
Work the real numbers rather than hand-waving.

## Guardrails
- No timezone claims.
- Don't imply cross-workspace switching, consolidated billing, or agency dashboards unless you
  can point to them in the PRD. Neither is documented as shipped.
- "Publish requests at odd hours" is the emotional hook. Don't turn it into a complaint about
  clients — agencies read this and so do their clients.

## Internal links
- Post 1 (native options + limits)
- Post 10 (editorial calendar) once it exists

## House pattern reminders
Answer first → the real pain → how workspaces map to clients → roles table → honest plan maths.
