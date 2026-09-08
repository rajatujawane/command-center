---
title: "Get Slack Notifications When Your Webflow Site Publishes"
date: "2026-09-11"
description: "Webflow won't tell you when a publish succeeds or fails. Connect Slack to Publish Pilot and get a message in your channel on every scheduled publish."
coverImage: "/blog/slack-notifications-webflow-publish.svg"
tags: ["Webflow", "Automation", "Product"]
author: "Publish Pilot"
tldr:
  - "Webflow doesn't notify you when a scheduled publish succeeds or fails, so you end up refreshing the live site to check."
  - "Publish Pilot's Slack integration posts to a channel you choose on every scheduled execution, success or failure."
  - "Pick which events you want, then send a test event to confirm the connection before you rely on it."
  - "Slack, Zapier, and custom webhooks are on the Business plan only. Trials don't include them."
  - "A failure message tells you which schedule failed and why, so you can act instead of finding out later."
faq:
  - q: "Does Webflow send a notification when a site publishes?"
    a: "No. Webflow publishes the site but does not message you to confirm it worked or tell you if it failed. You have to check the live site yourself. Publish Pilot adds this by posting to Slack on every scheduled execution."
  - q: "How do I get a Slack message when my Webflow site publishes?"
    a: "Connect Slack to Publish Pilot, choose which events you want to hear about, and pick the channel. On each scheduled publish, Publish Pilot posts the result to that channel. You can send a test event first to confirm it works."
  - q: "Do I get notified when a scheduled publish fails?"
    a: "Yes. If you turn on failure events, Publish Pilot posts a message when a scheduled execution fails, and it tells you which schedule failed and the error behind it. The run is also recorded in the audit log and run history."
  - q: "Which plan includes Slack notifications?"
    a: "The Business plan. Slack, Zapier, and custom webhooks are Business-only and are not included in trials. Business is $79 per month, or $65 per month billed annually."
  - q: "Can I send notifications somewhere other than Slack?"
    a: "Yes. Publish Pilot also supports Zapier and a custom webhook, so teams that don't use Slack can route publish results into their own tools. All three are on the Business plan."
  - q: "Does Publish Pilot email me when a publish finishes?"
    a: "No. There are no execution-result emails today. Notifications go through Slack, Zapier, or a custom webhook. Email is used only for workspace invites."
---

You schedule a Webflow publish for 2am so a launch goes live overnight. You go to bed. In the morning, did it work?

Webflow won't tell you. It publishes the site, but it doesn't send you anything to confirm the publish succeeded, and it doesn't warn you if it failed. The only way to know is to open the live site and look. For an overnight or off-hours publish, that means either staying up or trusting it blind.

This post covers how to get a **Slack notification when your Webflow site publishes**, what a failure message tells you, and the plan you need to turn it on.

## What Webflow tells you, and what it doesn't

Webflow's job ends at the publish. When you trigger one, the site goes live and the Designer shows a confirmation in that moment. But a scheduled publish happens when you're not watching, and Webflow has no way to reach you after the fact.

So there's a gap. The publish is automated, but the confidence isn't. You're back to refreshing the live URL to check something you already set up to run on its own. That's fine at 3pm on a Tuesday. It's not fine at 2am, or across a dozen client sites, or when a launch depends on the publish landing exactly when it should.

The fix is a notification that comes to you, in a place you already watch.

## Slack notifications on every scheduled publish

Publish Pilot posts to a Slack channel of your choice on every scheduled execution, success or failure. You connect Slack once, choose which events you care about, and the result lands in your channel the moment the publish runs.

- **Success events.** A message confirms the scheduled publish ran, so you know the launch is live without opening the site.
- **Failure events.** If a run fails, you hear about it right away instead of discovering it hours later.
- **Your channel.** Point notifications at whatever channel fits, whether that's a shared `#launches` channel or a private one only you watch.

The point is simple. The publish already runs on its own. Now the confirmation does too.

## For agencies: a channel per client

If you run several client Webflow sites, this earns its keep fast. Give each client its own channel, name it something like `#acme-site`, and route that client's publish notifications there.

Now every scheduled publish leaves a visible record in the client's channel. When a weekly content drop goes live, the channel shows it. When a launch lands, the team sees it without logging into the dashboard or Webflow at all. It doubles as proof of work: the client, or the account lead, can watch publishing happen without asking you for a status update.

This pairs naturally with running [one workspace per client](/blog/agencies-multiple-client-webflow-sites). Each workspace handles its own sites and schedules, and each one can post to its own channel.

## Setting it up

Connecting Slack takes a few minutes and lives entirely in the dashboard.

1. **Open** your integration settings in the dashboard.
2. **Connect Slack** and authorize the channel you want notifications to post to.
3. **Choose your events.** Decide whether you want success notifications, failure notifications, or both.
4. **Send a test event.** Fire a test message to confirm it lands in the right channel before you rely on it for a real launch.

That last step matters. Send the test, watch it appear in Slack, and you know the wiring is right. Then the next [scheduled publish](/blog/recurring-publishing-webflow-daily-weekly-monthly) posts on its own.

## What a failure notification tells you

A success message is reassuring. A failure message is the one that saves you.

When a scheduled execution fails, the notification tells you which schedule failed and the reason behind it, so you're not guessing. Under the hood, Publish Pilot retries transient failures with backoff before it gives up, so a brief hiccup with the Webflow API doesn't turn into a false alarm. If a run still fails after that, you get the message.

Every run, pass or fail, is also written to the **audit log** and the **run history** in the dashboard. The Slack message is the alert; the run history is the record you go back to. Between the two, a failed overnight publish becomes something you fix at 8am with full context, rather than something a client notices before you do.

One honest note: notifications today come through Slack, Zapier, or a custom webhook. There are no execution-result emails and no SMS. If email in your inbox is what you're after, that isn't here yet.

## Not on Slack? Zapier and custom webhooks

Slack is the common case, but it isn't the only option. Publish Pilot also supports **Zapier** and a **custom webhook**, so you can route publish results wherever your team actually works.

- **Zapier.** Send publish events into a Zap and fan them out to whatever Zapier connects to.
- **Custom webhook.** Post the result to your own endpoint and handle it however you like.

All three cover the same core job: tell you when a Webflow publish ran, and tell you when it didn't.

## When native Webflow isn't enough

Webflow gives you the publish. It doesn't give you the confirmation, and it can't reach you when a scheduled publish runs while you're away. That's the gap [Publish Pilot](https://publishpilot.app) fills, both by running the publish for you and by telling you how it went.

This is why the notification feature sits on the **Business plan**. Slack, Zapier, and custom webhooks are Business-only, and they're not part of any trial. Business is $79 per month, or $65 per month billed annually. If you're scheduling publishes you can't afford to guess about, especially [overnight launches](/blog/schedule-webflow-product-launch-midnight) or work across multiple client sites, that's the tier that includes the alerts.

## Quick reference

| Notification channel | What it does | Plan |
|----------------------|--------------|------|
| **Slack** | Posts publish results to a channel you pick | Business |
| **Zapier** | Sends publish events into your Zaps | Business |
| **Custom webhook** | Posts results to your own endpoint | Business |
| **Email / SMS** | Not available for execution results | Not offered |

## Summary

Webflow publishes your site but never tells you how it went. Publish Pilot closes that loop: connect Slack, choose your events, and get a message on every scheduled publish, success or failure, with enough detail on a failure to actually act. It's on the Business plan, and it turns a publish you have to check into one that reports back to you.

---

Tired of refreshing the live site to see if a publish worked? [Start your free trial](https://publishpilot.app) and see your Webflow publishes reported straight to Slack.
