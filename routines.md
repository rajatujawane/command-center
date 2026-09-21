# Claude Code local routines (configured in the app, recorded here)

folder for all: ~/Developer/command-center   (trusted once)

| routine          | schedule        | prompt                  |
|------------------|-----------------|-------------------------|
| outreach         | daily 03:00     | start outreach          |
| content-blog     | daily 05:00     | start content-blog      |
| morning-brief    | daily 07:15     | send the brief          |
| content-x        | daily 08:00     | start content-x         |
| content-linkedin | weekly Thu 09:00| start content-linkedin  |
| replies          | every 30m       | read replies            |

NOTE 2026-09-17 to 09-21: brief, content-blog and outreach all stopped within hours of each
other and ran for 4.5 days. CAUSE: Claude was signed out. Not a bug, and nothing to fix in
this repo — but worth keeping, because of what it shows: when auth drops, every routine stops
at once, silently, and the result is indistinguishable from a quiet week. Four morning briefs
were missed and an approved blog post sat unpublished, and the first anyone knew of it was
reading the heartbeat by hand.

That is the case for the watchdog below, and it is not hypothetical. `board` will fail the
same way on the next sign-out.

`replies` still shows ZERO rows in 222 — separate and older. Verify it against the app; this
file records intent, the heartbeat records reality, and for `replies` they disagree.

## board — Claude Code routine, hourly

| routine | schedule | prompt      |
|---------|----------|-------------|
| board   | hourly   | start board |

Cron: `0 * * * *`

Hourly, not 15m, because Claude Code routines are capped at once per hour. One scheduling
system for everything, and no launchd environment or keychain surprises.

What hourly costs you: up to 60 minutes before a Ready card is picked up, and up to 60 more
before an answer is acted on. Both are fine while `max_active` is 1 and every task ends at a
review gate waiting on me — I am the slow part, not the poller.

If that latency ever annoys: `ops/com.varrlabs.board.plist` runs `ops/board-tick.sh` every
15 minutes via launchd, with no hourly cap. The tick answers "is there work?" in ~2 seconds
with one HTTPS call and only wakes a session when there is, so idle ticks are effectively
free. It is written and tested but NOT installed. `DRY_RUN=1 ops/board-tick.sh` is still the
quickest way to ask what it would do right now.

Answer draining lives INSIDE the dispatcher (run.md step 1), so one wake records an answer and
resumes the task in the same pass rather than waiting for the next hour. `replies` drains too
as a backstop; harmless, because every action is keyed and idempotent.

### Capacity
    max_active          1   tasks the AGENT can act on at once
    max_open            3   total tasks sitting in tasks/active/, any state
    max_claims_per_day  5   runaway backstop
A task at a gate or waiting on an answer does NOT count toward max_active — it is on my desk,
not the agent's. Hitting max_open means go and review, not raise the number.

## Notifications
Linear is the record: every question, answer and result lives on the card. iMessage to the
"Command Center" group is the interrupt, and only for the two stalled states — a task waiting
on an answer, and a task blocked. `replies` reads that group every 30m.
Answers are accepted in ONE place: a comment on the Linear card. Slack is not wired up.

## Watchdog
Every dispatcher run ends with `ops/heartbeat.sh`, which pings an external check. If the mini
dies, the pings stop and the check emails you — a dead machine cannot report its own death, so
the alert has to come from somewhere else. Set the destination to something you read on your
phone, not on this Mac.
