# Webflow Site Publish vs CMS Item Publish: What Actually Goes Live and When

Meta description: In Webflow, publishing a CMS item and publishing your site are two different actions. Here is what each one pushes live, and why your content may not show yet.

You updated a CMS item in Webflow, hit publish, and checked your live site. Nothing changed. The item looks right in the Editor, the change saved, but the page on your custom domain still shows the old version.

This is one of the most common points of confusion in Webflow, and it comes down to a single fact: publishing a CMS item and publishing your site are two different actions. They push different things, to different places, at different times.

This post explains what each action actually does, why the staging subdomain and your custom domain can disagree, and the one gotcha that catches teams out when they finally do run a site publish.

## The short answer

Publishing a CMS item and publishing a site are two separate operations in Webflow, and doing the first does not always get your content onto your custom domain. A site publish pushes the current state of the whole site, including any staged designer changes, to your live domains.

If your CMS change is not showing up, the usual reason is one of two things: the change is staged but was never actually published, or it was published to your staging subdomain and not to your custom domain. The content is ready. It just has not been pushed to the place you are looking.

## The two publish actions, side by side

Webflow gives you more than one way to push content live, and they are not interchangeable.

**Site publish.** This is the big blue Publish button in the Designer. It takes everything currently staged, your CMS content, your design changes, your page structure, and pushes the whole site to the domains you select. This is the action most people mean when they say "publish."

**CMS item publish.** Inside the Editor or a Collection, an individual item has its own status. You can stage a change to a single item and publish that item without running a full site publish. This is narrower: it is about one piece of content, not the whole site.

The mental model that trips people up is assuming these are the same button with different labels. They are not. One operates on the entire site; the other operates on a single item. Knowing which one you just clicked is usually the whole answer to "why isn't it live."

## Staging subdomain vs custom domains

Every Webflow site has a free staging address that ends in `.webflow.io`. You also have any custom domains you have connected, like `yoursite.com`.

These are separate publish targets. When you publish, Webflow lets you choose which domains to push to. It is entirely possible to publish to your `.webflow.io` staging URL and not to your custom domain, or the reverse.

That is why the two can disagree. You check staging, the change is there, so you assume it is live everywhere. But the custom domain was not part of that publish, so it still shows the old version. Before you conclude something is broken, confirm which domain you are actually looking at, and which domains your last publish included.

## The gotcha: a site publish ships everything staged, not just your one change

Here is the part that matters most, and the part worth slowing down for.

A site publish is all-or-nothing at the site level. It does not publish only the change you were thinking about. It publishes the entire current staged state of the site. That includes design changes anyone on your team has made and left unpublished since the last publish.

So the risk runs in the opposite direction from the "why isn't it live" problem. You go in to push one small CMS fix, you click Publish, and you also ship a half-finished navigation redesign a teammate was still working on, a font change nobody signed off on, and an unfinished section that was never meant to go out yet.

This is why "just hit publish" is not always safe on a site with more than one person touching it. A site publish is a snapshot of everything, not a cherry-pick of the thing you care about.

> A CMS item publish is a scalpel. A site publish is a snapshot of the whole site as it stands right now, unfinished work included.

## When you need each one

Most timing problems come down to picking the right action for the job.

- **Use a CMS item publish** when you want one piece of content to change and nothing else to move. A single corrected blog post, one updated price, one new product.
- **Use a site publish** when the change lives in the design or structure, or when a coordinated set of changes all needs to go live together, like a launch or a relaunch.
- **Use both, in order,** when a release needs new design and new content together. Stage everything, confirm the staged state is clean, then publish the site.

The failure mode is reaching for a site publish out of habit when all you needed was to publish one item, and dragging unfinished work live with it.

## Scheduling each type safely

Webflow's native scheduling is narrow, and it does not cover most of these cases. It can schedule a single brand-new CMS item to publish later, but it has no native way to schedule a full-site publish, and no way to schedule a republish of an item that is already live. We cover exactly where native scheduling stops in [Webflow's native scheduling limits](/blog/schedule-publishing-webflow-native-limits).

This is where deciding the action up front pays off. [Publish Pilot](https://publishpilot.app) lets you schedule either action on its own terms. You can queue a single CMS item to publish, republish, draft, or archive at a set time, so one piece of content moves and nothing else does. Or you can schedule a full-site publish for a specific date and time, so a coordinated release goes live on its own.

Scheduling each action separately also sidesteps the gotcha above. If you schedule the specific CMS item you want live, you are not forced to run a whole-site publish, and you never accidentally push a teammate's unfinished design out with your one small change.

## Quick reference

| Action | What it pushes | Where it goes | Use it when |
|---|---|---|---|
| **CMS item publish** | One CMS item's staged change | The domains you select | You want one piece of content live and nothing else to move |
| **Site publish** | The entire staged site: content, design, structure | The domains you select | Design or structure changed, or a coordinated release needs to go live together |
| **Staging (`.webflow.io`)** | Whatever you publish to it | The free staging subdomain only | You want to preview before it hits a custom domain |
| **Custom domain** | Whatever you publish to it | Your live site | The change is ready for real visitors |

## Summary

Publishing a CMS item and publishing your site are two different actions in Webflow. A CMS item publish moves one piece of content. A site publish pushes the entire staged state of the site, design changes included, to whichever domains you select. When content is not showing up, the usual cause is a change that is staged but never published to the domain you are checking. When too much shows up, the cause is a site publish that carried unfinished work along with it. Deciding which action you actually need, and scheduling it deliberately with [Publish Pilot](https://publishpilot.app), keeps the right things going live and the wrong things staged.

---

Ready to stop guessing which publish button does what? [Start your free trial](https://publishpilot.app) and schedule the exact Webflow publish you need, item or full site, to the minute.
