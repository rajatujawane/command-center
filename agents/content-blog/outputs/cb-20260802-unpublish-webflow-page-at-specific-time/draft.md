---
title: "How to Unpublish a Webflow Page at a Specific Time"
date: "2026-08-14"
description: "Webflow has no native way to take a page down on a schedule. Here is how draft and archive work, and how to schedule a takedown at a set time."
coverImage: "/blog/unpublish-webflow-page-at-specific-time.svg"
tags: ["Webflow", "Scheduling", "CMS"]
author: "Publish Pilot"
tldr:
  - "Webflow has no native way to unpublish or take a page down on a schedule. Native scheduling only publishes brand-new CMS items."
  - "To take a live CMS item off the site, you set it to draft or archive. Draft keeps it as an editable item; archive moves it to a separate archived list for records."
  - "Neither draft nor archive deletes the item, and neither reaches your live site on its own. Webflow removes drafted and archived items at the next full-site publish."
  - "Publish Pilot schedules a CMS item to draft or archive at a set time, and can schedule the site publish that makes the takedown go live."
  - "Start/End scheduling lets you publish a page at one time and take it back down at another, both set up in advance."
faq:
  - q: "Can you unpublish a Webflow page at a specific time?"
    a: "Not natively. Webflow's only scheduling option publishes a brand-new CMS item at a future time. There is no native setting to take a live page or item down on a schedule. To do it automatically you need a tool like Publish Pilot, which schedules a CMS item to draft or archive at a set time and can schedule the site publish that applies it."
  - q: "What is the difference between draft and archive in Webflow?"
    a: "Draft keeps the item as a normal, editable item in your Collection but marks it to come off the live site. Archive moves the item into a separate archived list, out of your active items, so it is kept for reference but no longer part of the live Collection. Both remove the item from the live site at the next full-site publish, and neither deletes it."
  - q: "Does drafting or archiving a CMS item take it off the live site immediately?"
    a: "No. Setting an item to draft or archived does not change your live site on its own. Webflow removes drafted and archived items at the next full-site publish. Until that publish runs, the item stays visible on your live custom domain."
  - q: "Does taking a Webflow item down delete it?"
    a: "No. Draft and archive both keep the item in your CMS. Draft leaves it as an editable item you can republish later; archive files it in a separate archived list. Neither one deletes the content, so you can bring it back."
  - q: "How do I schedule a Webflow page to go live and then come down automatically?"
    a: "Use Start/End scheduling in Publish Pilot. You set a start action to publish or republish the item at one time and an end action to draft or archive it at another. Both are set up in advance and run in the cloud at the times you pick."
  - q: "Why is my drafted Webflow item still showing on my custom domain?"
    a: "Because the change has not been published yet. Marking an item draft or archived only stages the change. It reaches your custom domain when a full-site publish runs, so the item stays live until that publish completes."
---

Your limited-time promo ended at midnight, but the offer page is still live because no one was awake to take it down. Or an event wrapped up, a legal takedown deadline landed, and the page needs to come off the site at a set time, not whenever someone remembers to open Webflow.

Webflow has no native way to unpublish a page at a specific time. Its only scheduling option publishes a brand-new CMS item, and it does nothing for taking content down on a timer.

This post covers why that gap exists, how draft and archive actually behave when you take an item off the site, and how to schedule a takedown so a page comes down on time without you being there.

## Why Webflow can't take a page down on a schedule

Webflow's native scheduling does exactly one thing: it publishes a single CMS item that has never been live, at a future date and time. That is the whole feature. There is no native option to schedule a draft, an archive, an unpublish, or a full-site takedown.

So the direction only runs one way. You can queue something to go live later, but you cannot queue anything to come down later. Every takedown is a manual, in-the-moment action: open the item, change its state, and publish. If the deadline is 2am or falls on a weekend, someone still has to be there.

We covered the publish side of this gap in detail in [how to schedule publishing in Webflow and its native limits](/blog/schedule-publishing-webflow-native-limits). Taking content down is the same wall from the other side.

## When you need a scheduled takedown

A scheduled takedown is not an edge case. It comes up any time a page has a defined end, not just a defined start:

- **Limited-time offers.** A sale or discount page that must stop being reachable the moment the promotion closes.
- **Promo banners and announcements.** A CMS-driven banner that should disappear when the campaign ends, so nobody sees an expired message.
- **Event pages.** A registration or event page that should come down once the event is over and the content is stale.
- **Legal or compliance deadlines.** A page that has to be removed by a specific date. Publish Pilot can schedule that removal to run at a set time. It cannot advise you on the requirement itself, so treat the deadline and any compliance question as yours to confirm.

In every case the need is the same: the page comes down at a set time, on its own.

## Draft vs archive: what each does to a live item

To take a live CMS item off your site, you change its state to **draft** or **archive**. They reach the same visible result, the item leaves your live site, but they do different things to the item inside your CMS. Getting this right matters, because picking the wrong one changes how easily you can bring the page back.

**Draft** keeps the item as a normal, editable item in its Collection. Setting a live item to draft marks it to come off the site, but it stays in your active item list where you can edit and republish it later. Draft is the state to use for a takedown you expect to reverse.

**Archive** moves the item into a separate archived list, out of your active items. The content is kept for reference, but it is no longer part of the live Collection you work with day to day. Archive is the state for a takedown you want filed away and out of the way, not something you plan to flip back on next week.

One thing is true of both: neither deletes the item, and neither takes effect on its own. Webflow removes drafted and archived items from the live site **at the next full-site publish**, not the instant you change the state.

| State | What it does to the item | Live URL after the next site publish | Best for |
|---|---|---|---|
| **Draft** | Keeps it as an editable item in the active Collection | Removed from the live site, easy to republish later | Temporary takedowns you plan to restore |
| **Archive** | Moves it to a separate archived list, kept for records | Removed from the live site, filed out of active items | Takedowns you want kept but out of the way |

Note this is different from Webflow's manual **Unpublish** action, which pulls an item off the site immediately and resets it to draft. Unpublish is a click you do in the moment. It is not something Webflow lets you schedule.

## How to schedule a takedown when native isn't enough

Since Webflow has no scheduled takedown, this is the gap [Publish Pilot](https://publishpilot.app) fills. You schedule a CMS item to draft or archive at a specific date and time, and it runs in the cloud at that moment, whether or not you are online.

Here is the flow for taking an item down on a schedule:

1. **Connect your Webflow site** to Publish Pilot once, through Webflow's own OAuth.
2. **Pick the item** you want to take down.
3. **Choose the action:** draft or archive, using the difference above to decide.
4. **Set the date and time** the takedown should run.
5. **Add the site publish** so the change actually reaches your live domain (more on why in the next section).

For a page that has both a start and an end, use **Start/End scheduling** instead of two separate schedules. You set a start action to [publish or republish the item](/blog/schedule-webflow-cms-item-to-publish-automatically) at one time and an end action to draft or archive it at another. A promo page can publish Friday at 9am and take itself down Monday at midnight, both set up in one place ahead of time. That is the difference between planning a campaign once and babysitting it at both ends.

## Why the takedown needs a site publish to go live

Here is the part that trips people up. Marking an item as draft or archived does not change your live site by itself. Webflow only removes those items at the next full-site publish. Until a publish runs, the drafted or archived item stays visible on your live custom domain.

So a scheduled takedown really has two parts: change the item's state, and publish the site so that change reaches your domain. Publish Pilot fires the scheduled action within seconds of the time you set, but the takedown still has to propagate through a site publish before it shows up live. This is why the steps above include scheduling the site publish alongside the draft or archive, so both happen at the time you intend rather than leaving the item stranded live.

Plan for that propagation. If a page absolutely must be down by a hard deadline, schedule the takedown and its publish with a little room to spare, not at the exact second the deadline hits.

## Summary

Webflow can schedule a new page to go up, but nothing to bring a page down. To take a live CMS item off the site you set it to draft, which keeps it editable, or archive, which files it away for records. Neither deletes the item, and neither reaches your live domain until a full-site publish runs. [Publish Pilot](https://publishpilot.app) closes that gap: schedule a CMS item to draft or archive at a set time, pair it with a scheduled site publish, and use Start/End scheduling to handle both ends of a page's life without being at your desk for either.

---

Ready to stop babysitting the Publish button at both ends? [Start your free trial](https://publishpilot.app) and schedule your first Webflow takedown in minutes.
