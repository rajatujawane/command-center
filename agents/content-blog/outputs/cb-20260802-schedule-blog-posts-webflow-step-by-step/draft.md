# How to Schedule Blog Posts in Webflow (Step-by-Step)

Meta description: You can schedule a Webflow blog post to publish at a set time, but only if it has never gone live. Here is the step-by-step, plus the site-publish part people miss.

You can schedule a Webflow blog post to go live at a set time, but Webflow's native option only works if the post has never been published before. For anything you have already published once, or for the site changes a new post depends on, you also have to think about the full-site publish, which Webflow cannot schedule at all.

Most people hit this the same way: you write three posts on Friday, you want them live at 9am on Monday, Wednesday, and Friday, and you do not want to be at your desk to click Publish each morning.

This post walks through scheduling a brand-new blog post natively, step by step, then covers the part that trips people up: making sure the post actually reaches your live domain.

## Before you start

Native scheduled publishing has two requirements worth checking first.

- **A qualifying Site plan.** Native scheduling is not available on the Starter or Basic Site plans, and you need a paid Site plan to publish to a custom domain at all.
- **A post that has never been published.** This is the big one. Native scheduling only appears for a CMS Collection item that has not gone live before. If you have already published the post even once, the Schedule option will not be there.

If both are true, you can schedule the post in about a minute.

## Step-by-step: schedule a new blog post in Webflow

These steps assume your blog is a CMS Collection, which is how most Webflow blogs are built.

1. **Open the CMS Collection item.** Go to your blog Collection and open the individual post you want to schedule. Write it, add the cover image, set the fields, and leave it ready to go.
2. **Open the status dropdown.** In the top right of the item editor, find the publish status dropdown. For a never-published item it shows options including **Schedule**.
3. **Choose Schedule.** Pick the date and time you want the post to go live. The time follows your site's configured timezone in **Site Settings**, not a timezone you set per post, so confirm that setting before you schedule anything time-sensitive.
4. **Pick the domains.** In the schedule dialog, choose which domains the post publishes to. Select your production custom domain if you want it live for real visitors, not just the webflow.io staging subdomain.
5. **Save the schedule.** Webflow queues the publish. At the set time it pushes that one item live to the domains you picked, whether or not you are online.

That is the whole native flow for a fresh post. It genuinely works, and it runs in the cloud, so you do not need your computer on.

## The part people miss: the site publish

Here is where a scheduled post quietly goes wrong.

A scheduled CMS item publish pushes **only that item**. It does not carry any other staged changes with it. If your new post depends on something you also changed but have not published, a new Collection template, an updated blog index layout, a nav link, a design tweak, that dependent change stays on staging while the post goes live against the old layout.

The clean fix is a full-site publish once everything is ready. And that is the native gap: Webflow has no way to schedule a full-site publish for a future time. You can schedule the item, but the site publish is still a manual click.

So the real question is not "how do I schedule one post," it is "how do I schedule the post and the site publish together, so the whole thing lands correctly at 9am." Natively, you cannot. You schedule the item, then you still have to be there to publish the site.

## When native scheduling isn't enough

Two things push teams past native scheduling: editing posts that are already live, and pairing a post with a site publish.

[Publish Pilot](https://publishpilot.app) is built for exactly that gap. It connects to your Webflow site once through Webflow's own OAuth, then schedules the actions Webflow leaves out, all from one calendar.

- **Republish a live post on a schedule.** Fix a typo or update a published post and have the change go live at a set time. Native scheduling cannot touch an item that has already been published.
- **Schedule a full-site publish.** Queue the whole site to publish at a specific date and time, so a new post and the layout it depends on go live together, with no one clicking Publish.
- **Draft or archive on a timer.** Take a post back to draft when a campaign ends, or archive it, automatically at a set time.
- **Start and end scheduling.** Publish a post Friday morning and move it back to draft Monday night, both set up front.

This is the "two schedules, one outcome" case: one scheduled CMS item publish, one paired scheduled site publish, and the post lands correctly without you being awake for it.

## What the calendar looks like once posts are queued

Once you have a few posts scheduled, the value is seeing them in one place. A calendar view shows every queued publish, republish, draft, and site publish across your site, so you can tell at a glance that Monday, Wednesday, and Friday each have a post set for 9am. You are scheduling a content pipeline, not babysitting three separate Publish clicks.

## Quick reference

| Task | Webflow native | Publish Pilot |
|---|---|---|
| Schedule a brand-new blog post to publish | Yes | Yes |
| Schedule a republish of an already-live post | No | Yes |
| Schedule a full-site publish | No | Yes |
| Move a post to draft or archive on a timer | No | Yes |
| See all scheduled publishes on one calendar | No | Yes |

## Summary

Scheduling a new Webflow blog post is straightforward: open the CMS item, use the status dropdown, choose Schedule, set the date and time, and pick your live domain. The catch is that it only works for posts that have never been published, and it moves just that one item, not the full-site publish a new post often depends on. For republishing live posts, pairing a post with a site publish, or seeing everything on one calendar, [Publish Pilot](https://publishpilot.app) handles the scheduling Webflow cannot. For the full native breakdown, see our post on [Webflow's native scheduling and where it stops](/blog/schedule-publishing-webflow-native-limits).

---

Ready to stop babysitting the Publish button? [Start your free 7-day trial](https://publishpilot.app), no card required, and schedule your first Webflow post in minutes.
