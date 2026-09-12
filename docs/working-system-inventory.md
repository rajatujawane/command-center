# Working system: repository inventory

Inspected 8 September 2026 using gh and Git.

## Source and inspection boundary

- Repository: https://github.com/rajatujawane/command-center
- GitHub default and only branch at inspection: `master`; no `main` branch.
- Base commit: `11ab5f2d8cbeb49ca7aac153bafb404d97389599` (`BAU 8th sept 2026 11am`).
- Working branch created after an up-to-date fast-forward pull: `codex/working-system-inventory`.
- Working checkout: `/Users/rajatujawane/Developer/command-center`. The user explicitly authorized replacing the older non-Git snapshot with the latest GitHub content. Replacement and pull are complete.
- All further work and documents live in this checkout. The earlier Codex-folder checkout is no longer used.
- The initial pass was a repository inspection; subsequent sections record the bounded actual-Mac-mini checks supplied by Rajat.
- No existing workflow, schedule, task state or delivery rule was changed or executed. This branch adds inspection/planning documents and a disabled offline Step 4 foundation.

## What exists and what to reuse

| Capability | Repository evidence | Implication |
| --- | --- | --- |
| Operating rules and project routing | `CLAUDE.md` | Reuse project-scoped instructions and explicit missing-config blockage. |
| Recorded Claude local routines | `routines.md` | Verify actual installed schedules on the mini; this file is documentation, not proof they are enabled. |
| Blog dispatcher | `agents/content-blog/run.md` | Already intakes tasks and processes workers sequentially, including across products. |
| Task progress and outputs | `agents/content-blog/tasks/`, `outputs/`, `worker.md` | Existing folder/JSON state supports restarting at recorded steps. Preserve it behind an adapter. |
| Product-specific blog configuration | `agents/content-blog/projects/{termstack,publishpilot}/config.json` | Reuse the structure, while distinguishing website/content jobs from app development. |
| Outreach preparation | `agents/outreach/agent.json`, `run.md`, project configuration | Existing prospect state and draft workflow remain in place. No sends from this inspection. |
| Morning brief | `engine/brief/SKILL.md` | Extend the existing summary later with Linear work; avoid a second competing brief. |
| Reply handling | `engine/replies/SKILL.md` | Existing iMessage veto and attention handling is not a general question-answer/resume bridge. |
| Per-project limits and heartbeat records | `state/budget.json`, `state/heartbeat.json` | Preserve existing caps. Historical state alone does not establish live service health. |
| Delivery and promotion | `engine/deliver/SKILL.md`, `engine/promote/SKILL.md`, blog worker | Preserve the established blog delivery policy when adding a development runner. |

TermStack blog work targets `rajatujawane/varr-labs-website`, default branch `main`, production branch `prod`. This is not evidence of the TermStack app-code repository.

Publish Pilot blog work targets `rajatujawane/publish-pilot`, site root `main-site`, default branch `main`, production branch `prod`. Verify job-specific code paths and build/test commands before development work.

## Gaps and ambiguities to resolve

1. **Shared checkout:** the blog worker's branch step says to commit uncommitted files first, switch the configured repository branch, pull and create a blog branch. Its commit step uses `git add -A`. New development workers must use isolated working copies and must not overlap with this checkout. Do not automatically commit unrelated user changes.
2. **Serial execution is already intentional:** the dispatcher explicitly serializes blog workers because budgets and the notification thread are shared. Do not introduce parallel work merely because tasks target different products.
3. **Step granularity differs:** root rules describe at most one step per task per run; the blog worker explicitly advances branch through commit in one run and stops before delivery. Preserve documented current behavior; resolve this wording when changing the runner contract.
4. **Routine documentation needs host verification:** `routines.md` lists content-x and content-linkedin, but neither agent has run instructions in this revision. It also repeats blog and brief entries. Verify whether these are stale documentation or installed jobs before editing them.
5. **No new-system components existed at the base revision:** commit `11ab5f2d8cbeb49ca7aac153bafb404d97389599` contains no Linear task adapter, protected Linear reference registry, transactional task claims, run/session database, general pending-question/resume bridge, or human takeover controller. The Step 4 work on this branch begins adding the disabled registry and durable record layer.
6. **Preview configuration may have drifted:** `.claude/launch.json` declares port 3000 for both site configurations, while the blog project configs use preview ports 3001 and 3002. The launch file uses paths under `/Users/rajatserver/Developer/`. Verify real listeners, launch behavior and host paths before editing any values.
7. **Reply identity is limited:** the existing iMessage reader selects inbound messages from a named group and emits only timestamp and text. It does not establish an authorized sender ID or stable source-message ID. A future general answer/resume bridge needs both; do not treat all group replies as authorization.
8. **Development configuration remains incomplete:** the new disabled TermStack register establishes its repository and Linear project/document IDs. Dedicated test store, test commands, release/notification policy and job-specific allowed actions remain unknown and block dispatch.

## Recorded state, not a live health check

The latest recorded heartbeat rows inspected were:
- outreach: 2026-09-08T03:00:00Z, ok true
- content-blog: 2026-09-04T05:00:00Z, ok true
- brief: 2026-09-08T07:15:00Z, ok true

The blog task snapshot has 27 done, 11 incoming and 3 active JSON files. These counts and timestamps can change independently on the host. Do not conclude the mini is healthy or failing solely from this Git snapshot.

## Map to the build plan

| Step | Repository-level result | Remaining work |
| --- | --- | --- |
| 0: inspect existing setup | Operating rules, configs, recorded routines, state layout and shared-checkout behavior reviewed. Mini checkout, routines, timezone, Claude version/authentication and TermStack checkout/default branch recorded. | Before live dispatch, verify active processes/listeners, test commands/environment, release policy, Remote Control operation and recovery baseline. |
| 4: project register and durable run records | Disabled TermStack register, Linear mapping, durable SQLite schema, protected registry loader and offline acceptance check implemented on this branch. | Verify missing live configuration and initialize/reconcile one real pilot record without enabling dispatch. |
| 5: task picker | Existing dispatcher selects local blog tasks, not Linear issues. | Implement Linear eligibility checks, reference rejection, budgets, transactional claims, current-state rechecks and a dry run that cannot launch work. |

## Proposed next system milestone

Within the already planned system-building time, first complete the actual-host inventory and identify the right project/repository mapping for one future pilot. Record missing access and capabilities explicitly. Use the result to scope Steps 4 and 5; do not promise both complete within the remaining weekly hours.

A reviewable result consists of:
- A verified host inventory with paths, branches, routines and Claude capabilities.
- A proposed mapping for the selected pilot product, TermStack, including its Linear project and working-instructions document.
- A bounded next implementation brief with dependencies and acceptance checks.

Human-owned preorder development remains human-owned. No automatic worker is enabled by this document.

Rajat selected **TermStack** as the future Step 4 pilot on 8 September 2026. This choice scopes the remaining repository, branch and test-command verification; it does not authorize starting a worker or changing TermStack behavior.

Rajat identified the TermStack application-code checkout on the mini as `/Users/rajatserver/Developer/term-stack` (correcting the initially reported folder name `termstack`). This is distinct from the `rajatujawane/varr-labs-website` repository used by TermStack blog work. On 8 September 2026, the checkout was clean on branch `credit-control`, tracking `origin/credit-control`, at revision `36bafcca539fc11bd95f003975278b4dc704b7f8`. The locally recorded remote default is `origin/main`. A release-branch role, if any, and the test commands remain to be verified. Future development work must not reuse or switch this current checkout without an explicit isolation plan.


## Additional local verification on 8 September

- All 236 tracked JSON files parse successfully.
- All four tracked shell scripts pass `bash -n`; no operational script was executed.
- All 41 blog task files (11 incoming, 3 active, 27 done) reference existing project configurations.
- The local Claude executable reports version 2.1.263. This is not verification of the Mac mini's installed version, account access or Remote Control.
- The active Publish Pilot timezone blog task records a PRD/brief conflict and an unresolved build precondition. Its state was preserved. Ask the owner to resolve the product-content question in its existing workflow; do not clear it as part of system setup.
- No secrets were read, Hunter credits spent, messages sent, PRs merged, services started or Linear tasks dispatched.

These checks establish file integrity and basic routing only. They do not prove operational success, script behavior, deployment health or live authentication.

## Actual Mac mini inventory

Rajat is running read-only Terminal commands on the mini and returning their output for verification. No SSH host, login identity or credential has been requested.

Verified on 8 September 2026:

- Checkout: `/Users/rajatserver/Developer/command-center`
- Git top level: `/Users/rajatserver/Developer/command-center`
- Branch: `master`, tracking `origin/master`
- Revision: `11ab5f2d8cbeb49ca7aac153bafb404d97389599`
- Working tree: clean; `git status --short --branch` reported no changed or untracked files
- Claude Code version: `2.1.238`
- The installed CLI exposes persisted session continuation and resume (`--continue`, `--resume`), session forking (`--fork-session`), background agents (`--background` and `claude agents`), cloud sessions (`--cloud`) and Remote Control (`--remote-control`). Availability in help output does not prove that authentication or each remote capability currently works.
- Rajat confirmed that Claude Code is signed in and can run normal sessions on the mini. No account identifier, credential or secret was requested or recorded. Remote Control operation remains untested.

This confirms that the mini is at the repository inventory's base revision. It does not establish whether the mini has fetched the latest remote state, because no fetch or pull was performed during this read-only check.

### Visible local routines

The Claude routine UI showed these three local routines on 8 September 2026:

| UI name | Visible schedule | Visible next-run state |
| --- | --- | --- |
| Content blog | Every day at 5:00 AM | Tomorrow at 5:00 AM |
| Morning brief | Every day at approximately 7:15 AM | Tomorrow at approximately 7:15 AM |
| Cold outreach | Every day at approximately 3:00 AM | Tomorrow at approximately 3:00 AM |

The UI states that local routines run only while the computer is awake and online. Prompts and checkout settings were verified in the later detail dialogs below. Exact working-folder values were truncated, and explicit enablement controls were not visible.

Compared with `routines.md`, the visible UI names differ for content-blog and outreach. No content-x, content-linkedin or replies routine was visible. This is a recorded discrepancy, not evidence that those routines were deleted or intentionally disabled.

Content blog details visible in its edit dialog:

- Name: `Content blog`
- Description and instructions: `start content-blog`
- Schedule: daily at `05:00 AM`, subject to the UI's stated randomized delay of several minutes
- Checkout mode: `Current branch`; Worktree was not selected
- Permission mode shown: `Bypass permissions`
- Model shown: `Opus 4.8`
- Working-folder field began `/Users/rajatserver/Developer/co...`; the screenshot truncated the remainder, so the exact configured value remains unverified
- No timezone or separate enabled control was visible

This confirms that the installed content-blog routine is configured to operate on a shared current-branch checkout rather than an isolated worktree. No routine was run or edited during inspection.

Morning brief details visible in its edit dialog:

- Name: `Morning brief`
- Description: `send the brief`
- Instructions: `send the brief. Check CLAUDE.md at /Users/rajatserver/Developer/command-center/CLAUDE.md for routing. Do not invoke any anthropic-skills.* skill.`
- Schedule: daily at `07:15 AM`, subject to the UI's stated randomized delay of several minutes
- Checkout mode: `Current branch`; Worktree was not selected
- Permission mode shown: `Bypass permissions`
- Model shown: `Sonnet 5`
- Working-folder field was visually truncated after `/Users/rajatserver/Developer/co...`

Cold outreach details visible in its edit dialog:

- Name: `Cold outreach`
- Description and instructions: `start outreach.`
- Schedule: daily at `03:00 AM`, subject to the UI's stated randomized delay of several minutes
- Checkout mode: `Current branch`; Worktree was not selected
- Permission mode shown: `Auto`
- Model shown: `Opus 4.8`
- Working-folder field was visually truncated after `/Users/rajatserver/Developer/co...`

The instruction strings above are recorded routine configuration, not instructions followed during this inventory. All three visible routines use the current branch and have Worktree unselected. No routine was run, saved or edited during inspection.

Rajat confirmed that the Mac mini's active timezone is IST. The routine times above therefore use IST. The exact IANA timezone identifier was not displayed and remains unverified.

Remaining live-host checks before dispatch:

1. Relevant active processes and site listeners; confirm preview URLs and port ownership without starting a server.
2. TermStack test commands/environment, any release branch distinct from `main`, artifact location, notification route, allowed actions and release policy.
3. Remote Control operation, restart/login requirements, state backup location and recovery procedure.
4. Explicit routine enablement state if the UI exposes it.

Keep the report factual. A missing tool or access permission is an open check, not proof the service is broken. Do not modify running jobs or execute delivery routines during this inventory.

## Step 0 boundary for continuing

The live-host evidence is sufficient to scope an offline Step 4 foundation. The following checks remain explicitly unknown and must fail closed before any live TermStack dispatch: TermStack test commands and test store, any release branch distinct from `main`, artifact and notification settings, allowed actions and release policy, preview-port ownership, Remote Control operation, restart/login behavior and state backup/recovery location. Detailed routine run history was intentionally not required.

This boundary does not claim that every live-host checklist item is verified. It allows local, disabled infrastructure work to continue without starting or changing a routine, worker, message, publish, promotion or product checkout.

## Smallest useful Step 4 scope

Build only the durable, offline foundation for the TermStack pilot:

1. Add a central TermStack project-register entry containing the verified mini checkout `/Users/rajatserver/Developer/term-stack`, default branch `main`, verified Linear IDs and explicit unknown values for test commands, test store and release policy. Keep dispatch disabled; validation must reject use while required values are unknown.
2. Add an idempotent SQLite schema for runs, transactional ownership/claims, pending questions, answers, handoffs, outbox events and the protected reference registry.
3. Add a local acceptance check that uses a temporary database to prove schema reapplication is safe, duplicate ownership is rejected, a run can be resumed from stored state and a completed result can remain in an undelivered outbox without rerunning work.
4. Document initialization and inspection commands only. Do not connect Linear, launch Claude, add a schedule, touch TermStack's checkout, migrate blog JSON, send a message or enable dispatch.

The implementation is reviewable when the disabled TermStack record validates fail-closed and the temporary-database acceptance check passes without changing existing workflow state.

### Step 4 implementation progress

The offline Step 4 foundation is implemented:

- Added `projects/termstack.json` as the central development-project entry. It records the verified mini path and default branch, requires worktree isolation, forbids sending, leaves unverified values unset and keeps dispatch disabled.
- Added `engine/runner/validate-project.sh`. Configuration validation passes without touching the TermStack checkout; dispatch validation fails while dispatch is disabled or required fields remain unknown.
- Added `projects/README.md` with validation commands and the fail-closed contract.
- Read back the connected Linear TermStack project and `TermStack — Working instructions` document. Recorded project UUID `3f45f10a-407a-4503-a40a-185c972a5051`, document UUID `d752d813-9865-467c-be88-82f75419c668`, workspace/team UUIDs and the confirmed GitHub repository URL in the disabled register. Linear was not modified.
- Added `projects/protected-references.json` with the 12 permanent VAR-5 through VAR-16 UUIDs and seed markers read from `Varr Labs — Reference library and setup`.
- Added `engine/runner/schema.sql` for migrations, runs, active claims, questions, answers, handoffs, outbox events and protected references. Runtime database files are ignored by Git.
- Added an idempotent protected-reference loader and an offline acceptance test. The test applies the schema twice, loads the registry twice, rejects duplicate active ownership without leaving a partial run, resumes a stored phase, records question/answer and handoff state, preserves a pending outbox event beside a completed run, and checks database integrity.
- Verified both register JSON files, all runner shell syntax and whitespace. The offline acceptance test passes; normal project validation passes; dispatch readiness returns the expected refusal.

No existing agent configuration, routine, task state, budget, message, Linear object or product checkout was changed. No persistent runner database was created. Step 4 is not live: test/store/release/notification policy remains unknown, dispatch is false, and there is no scheduler or worker integration.
