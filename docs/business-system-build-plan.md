# Build our business working system

Updated: 8 September 2026

Working copy: `docs/business-system-build-plan.md` in `/Users/rajatujawane/Developer/command-center`. Continue editing this repository copy. Earlier Codex-folder outputs and Linear setup manifests are historical references; their presence does not mean the live runner is configured.

This is the implementation plan for Rajat's business: TermStack, Publish Pilot, Preorder & Back in Stock, games, shared systems, the Varr Labs Website, and Varr Labs Lib. Available time: 30–40 hours per week. The main problems to solve are too much parallel work, repeated manual testing, and losing track of progress.

**Current state (7 September 2026, continued through Linear MCP):** Varr Labs (VAR) now has seven projects. All 12 protected reference examples remain verified as VAR-5 through VAR-16. Twenty real tasks are captured as VAR-17 through VAR-36: VAR-26 is Doing because development was already in progress, and the other 19 are in Inbox. The six saved views remain pending because this Linear MCP connector exposes no view read/write tools. No week, priority, cycle or due date has been selected.

**Current focus:** complete Step 3 by choosing one primary outcome and, when capacity allows, one smaller outcome for the week. Reserve necessary operations and buffer first, budget Rajat's time separately from agent runtime, confirm undecided next performers, group selected work into realistic blocks and record what is displaced. Rajat has deferred the six saved views for a later supported-interface session. Before Step 4, complete the Step 0 Mac mini inventory. The permanent reference UUID registry is saved locally with read-only file mode and a checksum; runtime protection is not installed. Do not enable a worker until command-center loads and enforces it.

**Setup records:** see linear-setup-manifest.json, linear-reference-registry.json, linear-verification.json and linear-views-remaining.md in this continuation's output folder. The manifest records actual team, project, status and execution-label IDs. In Linear: [Reference library and setup](https://linear.app/varr-labs/document/varr-labs-reference-library-and-setup-0b27f005e0a3).


## 1. What we are building

| Piece | Its job | What you do there |
| --- | --- | --- |
| Linear | Authoritative task list: priorities, scope, dependencies, questions and decisions | Capture and organize work; answer and review |
| Command-center on the Mac mini | Schedule and supervise work; save execution progress | Usually runs in the background |
| Command-center webpage | Combine Linear tasks with worker activity and evidence | See your next action, questions, results and session controls |
| Claude Code | Carry out a prepared task in an isolated workspace | Take over a conversation when useful |
| GitHub | Code, changes, reviews and build results | Inspect and release changes |
| Slack, when connected | Notifications and task conversations | Reply in a linked task thread |

The webpage reads both Linear and command-center. It is not a second task list. Priority and task edits write through to Linear; execution controls go through command-center. Slack conversations must be linked back to the same task.

Initial defaults: one automated worker; check eligible work every 10 minutes and after a run finishes; a Run now action uses the same eligibility rules. These are future settings, not schedules installed by this document. Set actual time, retry and spending limits before the live pilot.

### Shared context and evidence locations — agreed operating rules

This Markdown guide defines the system-wide rules. Each product has one authoritative Linear project document named `<Product> — Working instructions` for its actual links and product-specific practices. Start with TermStack. The TermStack document is recorded as created and linked in Step 3. Check and reuse existing product documents before creating more.

| Information | Authoritative location |
| --- | --- |
| Product purpose, repository URL, branch conventions, production and test-store links, test instructions and product boundaries | Product's Working instructions document in Linear, linked prominently from the project overview |
| Task scope, acceptance criteria, dependencies, clarification questions, answers, decisions and final result | Linear issue |
| PR URL and tested commit | Relevant Linear issue; PR links back to the issue. Resolve PR numbers within the documented repository; do not maintain a second permanent PR list |
| Code changes, code-review discussion and CI/build results | GitHub PR and its checks; link from Linear |
| Manual test checklist, expected/actual results and screenshots | Linear issue; link that evidence from the PR when useful |
| Research findings, source URLs and decisions | Linear issue for short work; linked Linear document for longer research, with a short outcome summary in the issue |
| Agent session, workspace, ownership, raw execution logs and resume checkpoint | Command-center run record, linked from the issue once implemented |
| Notifications and quick task discussion | Slack when connected, pointing to the Linear issue. Decisions and answers must reach the canonical issue through verified sync or an explicit summary |

Upload each evidence item once and link to it elsewhere. GitHub CI logs stay in GitHub. If a recording or log is too large for its normal home, use a configured durable artifact store and put its access-controlled link in Linear; do not invent or provision a storage service during task capture. Local temporary paths are not sufficient final evidence for work that must be reviewed from another device.

The product document should contain: product context; repository and relevant documentation; each environment's purpose and links; how to identify the deployed version; manual and automated test instructions; the evidence rules above; completion/review rules; action boundaries; and unresolved setup questions. Store access instructions or secret-manager references, never passwords, tokens or store credentials in documents, issues or screenshots.

During execution preparation, agents read the product document, issue and linked PR before asking code-level questions. Task capture does not require GitHub MCP access: capture the known reference and defer repository inspection to the execution environment when needed. Product working instructions hold generic context; individual PR scope and test progress belong only in their task. Ask for a shared repository or test-store link once, then save the answer in the product document. Ask task-specific questions only when records cannot establish the answer. A repository permission failure must be reported as an access problem, not treated as a missing URL.

Environment defaults and actual test runs are different records. Record the selected store/environment, tested commit or build, test date, tester, results and evidence on each testing issue. Never assume the latest PR revision is deployed because a store is listed in the product document. Record deployment state with a timestamp when confirmed; re-check when relevant.

**PR #20 example:** use the documented TermStack repository to resolve the PR and attach it to the testing issue. Prepare a manual checklist from its changes. Rajat records results/screenshots in that issue. A failure gets a linked bug issue when separate work is needed. Record the overall outcome and exact tested version before unblocking the protected-scope approval task. Unknown deployment or testing progress remains unknown until verified or answered.

**Future command-center mapping:** store the Linear project ID, Working instructions document ID/URL and repository mapping in the product register. Treat operational repository/workspace settings as a validated projection of that document; record discrepancies for resolution instead of silently maintaining conflicting instructions. Other product policies remain linked to the same document. This does not implement the register or a synchronization process.

## 2. Build order and completion checks

Complete the steps in order. Each step has an observable finish condition. Do not build a large dashboard before one task can travel through the entire system.

### Step 0 — Inspect what already exists

**Status: sufficient live-host inventory completed for offline Step 4 scoping; listed live checks remain open before dispatch.** On 8 September, used gh to retrieve the only/default branch `master` (there is no `main`). With explicit permission, replaced the old non-Git folder at `/Users/rajatujawane/Developer/command-center`, pulled latest and created `codex/working-system-inventory` before edits. Base commit: `11ab5f2d8cbeb49ca7aac153bafb404d97389599`. All current work lives in that Developer checkout. The mini's command-center checkout, clean state, installed routines, timezone, Claude version/authentication and the TermStack pilot checkout/default branch were then verified. See [repository inventory](working-system-inventory.md) for evidence, explicit unknowns and the bounded Step 4 scope. No live worker may be enabled from this partial operational baseline.

- [x] Inspect the current remote repository's operating rules, recorded routines, per-agent project configuration and state layout; record its base revision.
- [ ] Read the current command-center operating rules, routines, configurations and active jobs on the actual Mac mini.
- [ ] Record repository locations, default/release branches, test commands, existing remote access and Claude Code version/authentication.
- [x] Check outstanding local changes before modifying any repository. On 8 September, the mini checkout at `/Users/rajatserver/Developer/command-center` was clean on `master` at `11ab5f2d8cbeb49ca7aac153bafb404d97389599`, tracking `origin/master`.
- [x] Preserve the existing blog review window, veto handling, automatic delivery/promotion and per-project caps. The base revision and configuration were recorded as the rollback point; Step 4 is separate and disabled.
- [x] Keep existing outreach behavior as drafts only. No outreach configuration was changed and this work does not authorize sending messages to merchants or agencies.
- [x] Identify shared-checkout behavior in the current repository's blog worker: it commits existing changes, switches branches and uses git add -A. The dispatcher already serializes blog workers. Isolate future development work; verify actual host usage before changing concurrency.

**Finished when:** a short inventory records what works today, what is missing and which existing behavior must continue. Never infer current server health from old repository logs.

### Step 1 — Set up Linear after it is connected

**Status: partially complete — saved views and Inbox default confirmation remain.**

- [x] Connect through Linear MCP and inspect the workspace, team, projects, statuses and labels.
- [x] Reuse Varr Labs (VAR) and the original five projects; add Varr Labs Website and Varr Labs Lib when their real work was captured.
- [x] Verify the required workflow statuses and execution/area labels; record their actual IDs.
- [x] Prepare exact definitions for all six views and validate their filters against the initial issue snapshot.
- [x] Revalidate the planned filters against the current 36-issue snapshot: All real work 24, This week 0, My next actions 1, Agent queue 0, Needs me 0, Reference library 12.
- [x] Save the setup manifest and a reference index in Linear.
- [ ] Inspect/reuse or create the six saved views; record their IDs and URLs and verify their actual results.
- [ ] Confirm Inbox is the default status. The earlier setup selected it, but MCP cannot read back the default flag.

Inspect existing teams, projects, statuses, labels and views first. Reuse suitable objects. If there are multiple plausible workspaces, resolve that specific ambiguity before creating objects. Do not restructure unrelated existing work.

Reused existing team **Varr Labs**, key **VAR**, UUID `292e27d9-b1f8-4aef-95a3-3fcaf855c8d9`. Product grouping:

1. TermStack
2. Publish Pilot
3. Preorder & Back in Stock
4. Games
5. Shared systems — pricing, email, testing infrastructure and command-center
6. Varr Labs Website — developer landing page and product pages for the Shopify app portfolio
7. Varr Labs Lib — reusable packages for Shopify apps

These are seven ongoing projects. Product work and distribution stay together. Do not create separate workspaces or department teams.

Create or map these statuses. Use returned IDs in configuration; never depend only on a displayed status name.

| Status | Linear category | Meaning |
| --- | --- | --- |
| Inbox | Backlog | Captured, not committed; default for new real tasks |
| Backlog | Backlog | Defined work for later |
| Reference | Backlog | Examples only; excluded from all work queues |
| Ready | Unstarted | Defined and eligible for its next step |
| Doing | Started | Work is underway |
| Waiting for input | Started | A specific answer is required |
| Human control | Started | Rajat has taken over; automation cannot run it |
| Review | Started | Deliverable and evidence need inspection |
| Blocked | Started | External, technical or budget blockage |
| Done | Completed | This task's defined deliverable is verified |
| Canceled | Canceled | Intentionally stopped |

Preserve Linear's required categories and reserved Duplicate status. Reference is not the default. Do not enable new automatic transitions that move examples into Ready.

Use labels rather than assuming arbitrary custom fields are available:

- `reference-only`
- Plan keys `execution:never`, `execution:human`, `execution:agent` map to stored children `never`, `human`, `agent` under the `execution` group. Use the UUIDs from the setup manifest; the stored names do not include the prefix.
- `area:development`, `area:testing`, `area:conversion`, `area:distribution`, `area:research`, `area:maintenance`, `area:operations`
- `this-week` for the initial weekly selection; do not require cycles in the first version

A human remains accountable for real tasks. The execution label says who performs the next work. Native agent delegation can be added later; it is not required for this design.

Create these views where supported by the connected tool. If a feature is not exposed, record the exact remaining UI action; do not claim it was created.

| View | Inclusion rule |
| --- | --- |
| All real work | Exclude reference status, reference label and execution:never |
| This week | Real work + this-week |
| My next actions | Real work requiring a human next action, sorted by priority |
| Agent queue | Real work + Ready + execution:agent; final runtime checks still apply |
| Needs me | Real work waiting for input, review, or human intervention |
| Reference library | Reference examples only |

Add product-filtered versions as needed, without duplicating tasks. After creating the structure, read it back and record all returned IDs and links in a setup manifest.

**Finished when:** all seven project groups are understandable, reference examples are visible only in the reference view by default, and no live task has been dispatched.

### Step 2 — Add examples that nobody picks up

**Status: examples complete — saved-view and installed scheduler acceptance checks remain.**

- [x] Search reference seeds and reuse the existing first example, VAR-5.
- [x] Create the remaining 11 examples, VAR-6 through VAR-16, with complete descriptions.
- [x] Read back all 12 examples: warning titles, unique seeds, correct projects, Reference status, reference-only + never + area labels.
- [x] Verify all 12 have no assignee, delegate, cycle, due date, priority or this-week label.
- [x] Save all 12 original UUIDs in the permanent reference registry, with read-only file mode and a checksum.
- [x] Verify planned filters exclude all 12 from operational views using the current snapshot.
- [x] Pass local reference checks with Ready status and stripped labels/description; original UUIDs remain rejected.
- [ ] Verify exclusion in the actual saved Linear views once those views exist.
- [ ] Load and enforce the registry in command-center, then run the installed scheduler acceptance checks before enabling dispatch.

Every example must have all of these properties:

- Title starts `[EXAMPLE — DO NOT RUN]`.
- Status is `Reference`.
- Labels include `reference-only` and `execution:never`.
- No assignee, due date, cycle or `this-week` label.
- Description begins: **Reference example. Do not execute, schedule, assign or promote this issue. Create a separate real task to use the pattern.**
- A stable seed marker identifies the example, such as `studio-reference-v1:ts-rule-bug`.

Add every example's returned Linear issue ID to a **protected reference ID registry**. Save that registry in the setup manifest now and load it into command-center before a scheduler is enabled. Reference exclusion is enforced in code, not only in an agent prompt.

The scheduler and dashboard must reject an issue if ANY reference indicator applies: protected ID, reference seed/origin, Reference status, reference-only label or execution:never. Missing configuration or an unavailable registry must prevent dispatch. Run now and answer/resume actions use the same protection.

Changing an example's status to Ready does not make it executable. Removing its labels still does not make its protected ID executable. A future “Create real task from example” action creates a new ID in Inbox with no automatic authorization; the original remains protected. The new task has a source-example link, not a reference-origin marker, and receives fresh scope and policy review.

Prepare these 12 examples. Names such as TS-42 in explanations are illustrative, not actual Linear IDs.

| Seed key | Product | Example title after prefix | Illustrated performer | Deliverable and evidence | Completion |
| --- | --- | --- | --- | --- | --- |
| ts-rule-bug | TermStack | Fix a rule that sometimes fails | Agent | Reproduction, isolated code change, matching/non-matching tests, screenshots | [x] Done — VAR-5 |
| ts-onboarding-choice | TermStack | Choose an onboarding design | Human | Choice between prepared options, reason and follow-up scope | [x] Done — VAR-6 |
| ts-nonplus-research | TermStack | Research non-Plus expansion | Agent | Cited feasibility and demand findings; limitations; recommendation | [x] Done — VAR-7 |
| ts-agency-drafts | TermStack | Prepare five agency outreach drafts | Agent | Relevant prospects, tailored drafts, proposed follow-up dates; no sends | [x] Done — VAR-8 |
| ts-customer-conversation | TermStack | Prepare a paying-merchant conversation | Human | Question list and an example structure for recording insights; no booking or contact | [x] Done — VAR-9 |
| pp-conversion-audit | Publish Pilot | Find the largest conversion drop-off | Agent | Clearly labeled sample funnel analysis, missing-data checklist and experiment proposal | [x] Done — VAR-10 |
| pp-activation-email | Publish Pilot | Draft an activation email sequence | Agent | Trigger, audience, draft copy and success measure; no sends | [x] Done — VAR-11 |
| preorder-validation | Preorder & Back in Stock | Validate a merchant segment | Agent | Research plan, hypotheses, free-scope and support-cost questions, review criterion | [x] Done — VAR-12 |
| games-recovery-audit | Games | Rank the first recovery batch | Agent | Sample inventory structure: store status, historical earnings, repair effort, confidence | [x] Done — VAR-13 |
| games-update | Games | Restore one selected game | Agent | Example build/update checklist and release evidence requirements; no actual build or submission | [x] Done — VAR-14 |
| shared-pricing | Shared systems | Extract a proven pricing module | Agent | Example consumer list, scope, versioning and regression-test expectations | [x] Done — VAR-15 |
| cc-session-handoff | Shared systems | Save and resume a work session | Agent | Example handoff record: session, workspace, progress, evidence and next step | [x] Done — VAR-16 |

For each description include: product; goal; required inputs; scope and exclusions; performer being illustrated; completion criteria; evidence; a sample question if relevant; and “How to create a real task from this example.” Do not invent real customer identities, metrics, session URLs or completed results.

Illustrated performer is explanatory text only. All 12 actual issues retain execution:never. Simulated Ready, Doing or Review states belong in description examples, never in their actual status.

Search stable seed markers before creating anything. On a repeated setup run, reuse matching examples. Save a manifest containing team/project/status/label/view IDs, example IDs, seed markers and links. Keep credentials out of that manifest. Creating examples must not create code branches, Claude sessions, outreach drafts, notifications to other people, or jobs.

**Finished when:** the reference library demonstrates the whole structure; My next actions, This week and the Agent queue contain none of the examples. A scheduler dry run rejects all example IDs even when a test copy of their metadata says Ready.

### Step 3 — Capture real work and choose a week

**Status: task capture complete; weekly work areas, time allocation and flexible work-block structure selected. Detailed checkpoints and remaining performer decisions are pending.**

**Current planning window: 8–14 September 2026.** Rajat confirmed **30 hours of human capacity** for the next seven days on 8 September. This includes development, manual testing, agent supervision/review, support and administration; unattended agent runtime is separate. The working allocation is 16 hours for Preorder development, 10 hours for system building and 4 hours of buffer. This records a weekly planning decision, not a permanent capacity limit or a Linear update.

**Confirmed allocation:** 10 hours for building this agent/working system, including its planning and setup. Count this as planned outcome work, once, within the 30-hour total. The concrete system milestone and completion criteria remain to be defined; this allocation does not promise completion of the whole system. Rajat confirmed no other scheduled support, reviews, meetings or administration for this window. This does not exclude unexpected support or review effort within selected outcomes.

**Selected primary work:** Rajat chose **Preorder development**, with **Rajat / human as the confirmed performer**, not an autonomous agent. Current work reported on 8 September: cleaning up the UIs, removing unnecessary features/UI, and fixing the PRD. **Confirmed screen in scope: Back in Stock.** Rajat will add the detailed cleanup/removal list later; do not infer particular features to remove or block the rest of weekly planning on this deferred detail. Rajat confirmed this development will continue into next week and requested keeping this week's existing main-work allocation: **16 hours**. This is a time budget, not an estimate to complete all development. At the weekly checkpoint, record completed UI changes, PRD updates, validation performed, unfinished work and the next starting point; leave the larger development issue open until its actual acceptance criteria are met. Specific cleanup completion criteria remain deferred. VAR-26 is the existing development issue recorded as Doing with human execution in the saved inventory; confirm its current scope before making task-level changes. TermStack PR #20 testing and scope approval were suggested but were not selected as this week's main outcome.

**Weekly allocation:** 16 hours for Preorder development including testing/review, 10 hours for building the working system including planning/setup, and 4 hours retained as uncommitted buffer. No separate scheduled operations were reported. Use system-building work as the second planned work area rather than adding a third commitment by default. Revisit next week's availability and scope; continuing development does not automatically reserve next week's hours.

**Flexible work blocks:** Rajat cannot yet specify available days or daily hours. Keep dates and start times unset; this does not block weekly planning. Use roughly two-hour movable blocks as a planning default: eight for Preorder work and five for system work, plus four hours left uncommitted. Blocks may be shortened or combined around actual availability. These represent the total weekly budgets, including time already spent, not additional hours. Before each block choose one concrete next action; afterwards record progress, time used and where to resume. If availability shrinks or urgent work enters, reduce or defer planned work explicitly rather than silently increasing the 30-hour total. No calendar events or schedules are created.

- [x] Create and link `TermStack — Working instructions` with reusable product context and evidence rules. The Shopify test-store link remains an explicit unknown.
- [x] Capture real work separately from reference examples. Twenty tasks are saved as VAR-17 through VAR-36; VAR-26 is Doing because it was already in progress, and the other 19 are in Inbox.
- [x] Give every captured task one project, a clear outcome, confirmed context, scope, exclusions, acceptance criteria, evidence requirements, dependencies and explicit open questions.
- [x] Record confirmed execution choices without inventing them: three human tasks, two agent tasks and 15 tasks whose next performer remains unspecified.
- [x] Complete a first capture pass across TermStack, Publish Pilot, Preorder & Back in Stock, Varr Labs Website and Varr Labs Lib without adding priority, deadline, cycle or `this-week`.
- [ ] Confirm the next performer for the 15 tasks currently marked unspecified.
- [x] Confirm available human capacity for the current week: 30 hours for 8–14 September 2026. Reconfirm for subsequent weeks.
- [x] Reserve capacity for known operations and uncertainty: no separate scheduled operations reported; 4 hours retained as buffer in the current plan.
- [ ] Select one primary outcome and, when remaining capacity allows, one smaller outcome. Define completion criteria, check dependencies and rank candidate outcomes by customer impact and the weekly goal.
- [ ] Estimate Rajat's effort for the selected work, including briefing agents, answering questions, manual testing and reviewing results. Track agent runtime and spending separately; do not count unattended agent hours as Rajat's working hours.
- [ ] Allocate hours according to estimated scope, dependencies and uncertainty. Adjust each week; projects receive no automatic time quota. If the work does not fit, reduce its scope or defer it rather than consume the buffer in advance.
- [x] Define flexible work blocks for the selected weekly work: roughly two hours each, with days/times unset until availability is known.
- [ ] During the week, record actual progress and time used. When urgent work enters, explicitly reduce, defer or replace existing commitments and record what it displaces.
- [ ] Periodically review projects receiving no time so that deferred maintenance and other obligations remain deliberate choices.

Weekly allocation follows outcomes and their estimated effort. Operations includes necessary support, reviews, maintenance and administration outside the selected outcomes; count any activity only once. Buffer remains uncommitted for uncertainty and urgent work. An outcome is a verifiable result, not an hour target or a broad intention such as “improve TermStack.”

These are illustrative allocations of **Rajat's time** for a 35-hour week, not fixed rules or commitments:

| Example week | Primary outcome | Smaller outcome | Operations | Buffer |
| --- | --- | --- | --- | --- |
| Starting example | 20h | 7h | 3h | 5h |
| Larger development outcome | 24h | 4h | 2h | 5h |
| Research-heavy week | 17h | 10h | 3h | 5h |
| Several required reviews | 18h | 5h | 7h | 5h |

A project receives time only when one of its issues contributes to a selected outcome or required operations. Adapt the total to actual availability; the smaller outcome may be omitted when the primary outcome and necessary operations fill the remaining capacity.

Current real-work capture:

| Project | Issues | Current state |
| --- | --- | --- |
| TermStack | VAR-17–VAR-20, VAR-35–VAR-36 | Six in Inbox; VAR-18 is blocked by VAR-17 |
| Publish Pilot | VAR-21–VAR-25 | Five in Inbox |
| Preorder & Back in Stock | VAR-26–VAR-31 | VAR-26 Doing; five in Inbox; VAR-27 is blocked by VAR-26 |
| Varr Labs Website | VAR-32–VAR-33 | Two in Inbox; VAR-33 blocks cross-project coordination issue VAR-30 |
| Varr Labs Lib | VAR-34 | One PR-review task in Inbox |
| Games | None captured yet | No real task selected |
| Shared systems | None captured yet | Command-center implementation remains in later plan steps |

**Finished when:** the selected outcomes have clear completion criteria and fit the week's human capacity alongside operations and buffer. Rajat can see one recommended next action and why it matters. Reference tasks never appear in recommendations or capacity totals.

### Step 4 — Add the project register and durable run records

**Status: offline foundation implemented on `codex/working-system-inventory`; not initialized or enabled on the mini.** The disabled TermStack register contains verified Linear project/document IDs, GitHub repository mapping, mini checkout path and default branch. Required test, store, release and notification settings remain unset. The idempotent SQLite schema, append-only protected-reference loader and temporary-database acceptance check are present. Dispatch validation intentionally fails. No Linear write, routine, scheduler, worker or persistent coordination database was created.

Extend command-center rather than replacing the existing content pipeline. A project register maps each Linear project ID to its repository/workspace, default branch, build/test instructions, test environment, artifact location, notification route and allowed action policy.

Use a small local SQLite database for new runner coordination, with transactional claims and an event/outbox table. Existing blog JSON files can remain in place behind an adapter. Do not require a risky migration of working blog state. These are implementation choices, not features currently in the repository.

Minimum records:

| Record | Required contents |
| --- | --- |
| Run | Task ID, run ID, project ID, worker/session ID, workspace, code revision, phase, start/heartbeat/end times, attempts, budget and outcome |
| Pending question | Question ID, task ID, question, recommendation, blockage, originating run, reply link and resolution |
| Answer | Question ID, authorized responder, source comment/event ID, timestamp and answer text |
| Handoff | Actual controller, session/workspace, completed work, changed files, tests, uncertainty and next action |
| Outbox/event | Unique event ID, intended board update, delivery state and retry count |
| Reference registry | Protected Linear issue IDs and seed markers; no scheduler may run without loading it |

Linear owns user-facing task intent and status. The database owns process state and checkpoints. If delivery to Linear fails, keep the result in the outbox and retry; do not restart the completed work. Respect a human's cancellation, takeover or changed instructions when reconciling state.

**Finished when:** one real pilot record can be saved, restarted and reconciled without duplicate execution or lost results. This step alone does not enable dispatch.

### Step 5 — Build the scheduler with explicit eligibility

A task is executable only when all checks pass:

1. Its workspace, team and project are allowlisted and configured.
2. No reference or never-execute rule applies.
3. Its current status is Ready and execution policy is agent.
4. Scope, acceptance criteria, required inputs and permitted actions are present.
5. Dependencies are satisfied and it has no unresolved required question.
6. It is not paused, canceled, under human control, already claimed or already completed for this task version.
7. Worker capacity, time, retry, spending and pending-review limits allow the run.

Pick highest priority, then dependencies/weekly commitment, then oldest eligible task as a stable tie-breaker. The model may recommend reprioritization; it must not silently change the strategic commitment.

Claim the task transactionally and recheck current board state before execution. Start with one worker. A lease is a temporary ownership record: if it expires, investigate the old process before reassigning the task. Lease expiry alone is not proof that the old worker stopped.

Run the checker every 10 minutes and after completion. A manual Run now request does not bypass eligibility. Poll with overlap and deduplicate IDs so missed or repeated responses do not lose work. If the board cannot be read, do not claim new tasks from stale state.

**Finished when:** a dry run explains its selection, rejects examples and duplicates, and respects human control, questions and budgets. Then select a separate real pilot task before enabling live dispatch.

### Step 6 — Execute one task with Claude

Use `claude -p` initially. Supply the prepared task brief, exact workspace, loaded project instructions and narrowly configured tool permissions. Capture structured output and the session ID. Do not assume non-interactive execution can stop to show Rajat an interactive question.

Illustrative CLI shape, not a complete production command:

```bash
claude -p "Work on the prepared task brief" --output-format json
```

Validate outputs against a result contract: `needs_input`, `ready_for_review`, `completed_deliverable`, `blocked` or `failed`, plus summary and evidence. Exit code alone never proves the task succeeded. Keep permission-denial and infrastructure failures distinct from product-test failures.

Every code job gets its own working copy/branch. Never automatically commit unrelated human changes. Manage test servers outside a short-lived Claude invocation when they must survive its exit. Save checkpoints between bounded steps; do not assume interruption during a tool call leaves a complete step.

**Finished when:** one authorized real task produces a saved session, isolated changes and a truthful result on the Linear card. A dashboard has not yet been required.

### Step 7 — Implement questions and answers

1. Claude returns needs_input with a precise question, recommendation, saved progress and exact blockage.
2. Command-center saves it durably and posts it on the Linear task under Waiting for input.
3. The background invocation exits. The task waits in saved state; no process needs to sit idle overnight.
4. Rajat answers on that task, through the future dashboard, or in its genuinely synchronized Slack thread.
5. The bridge associates the answer with the pending question and verifies the responder. It acknowledges that the answer was recorded.
6. When every required question is resolved, the scheduler rechecks eligibility and resumes the same saved session with the answer and current task context.

Use explicit reply actions or a simple syntax such as `Answer Q-123: ...`. Store question and source-comment IDs. Do not treat every comment, quoted text, bot echo or unrelated Slack reply as permission to resume. Deduplicate mirrored events. Edited/conflicting answers require re-evaluation rather than blind re-execution.

Illustrative continuation:

```bash
claude -p "Continue using the recorded answer and current brief" --resume SESSION_ID
```

SESSION_ID is a placeholder; use the ID actually recorded for this task. If its transcript is missing, report that and reconstruct from the saved brief/handoff in a new session without pretending the original history survived.

**Finished when:** one test question survives a restart, one answer is recorded once, and work resumes once. A reply to a reference example cannot start work.

### Step 8 — Add human takeover and hand-back

Implement controller states separately from business progress: agent, takeover_requested, human, handback_pending. Expose them through the task and later the dashboard.

1. Take over immediately blocks new automatic dispatch for this task.
2. Interrupt the active Claude turn cleanly. Confirm the worker and relevant child operations stopped before allowing another controller to write.
3. Save the actual files, revision and latest complete checkpoint; flag unfinished steps.
4. Resume the recorded session interactively in the same isolated task directory:

```bash
claude --resume SESSION_ID
```

5. Enable `/remote-control` in that interactive session to continue through Claude's supported remote interface.
6. Keep the task in Human control until Rajat explicitly hands it back. Disconnecting a phone is not a hand-back signal.
7. On hand-back, save the new instructions and actual code/test state, confirm the human session is no longer driving the workspace, then recheck eligibility before resuming automation.

`claude -p` is not automatically a Remote Control session. Verify headless-to-interactive resumption and Remote Control using the mini's installed version and account. Begin with a documented manual handover; add a one-click launcher only after that path works. If the capability is unavailable, retain the saved task handoff and existing private remote terminal as the explicit fallback.

**Finished when:** Rajat can take over, change the task, and hand it back without two writers, lost edits, or an automatic restart during human control.

### Step 9 — Automate one meaningful TermStack test

- [ ] Confirm a dedicated test store has the features required for the selected rule.
- [ ] Install the test version of TermStack and create known fixtures: shoppers, products and rule inputs.
- [ ] Agree the expected matching, non-matching, boundary and conflict behavior before implementation.
- [ ] Run the journey: create rule → open storefront/checkout → act as each shopper → assert the expected outcome.
- [ ] Save tested revision/build, environment, assertions, screenshots, errors, failed/skipped checks and cleanup results.
- [ ] Prove the test catches a deliberate regression, then restore the correct code and show it passes.

Development tasks include the relevant testing in their acceptance criteria. Failed checks lead to bounded repair attempts or a blockage. A test that never ran is not passed. Review uses the exact code revision tested; a later change invalidates affected evidence.

Code changes reach Review with a pull request. Production actions follow their explicit workflow policy; for new product changes, start with human release review. Mark a release-scoped task Done only after release and its required smoke check. A draft-only task can finish when its requested draft is delivered. Preserve the existing blog policy rather than applying new release gates to it by default.

**Finished when:** one real TermStack task has a reproducible test, trustworthy evidence and a clear review outcome.

### Step 10 — Build the small command-center webpage

This is a separate private webpage, combining Linear and local run information. Implement it after the runner loop works. Keep credentials and execution controls on the backend, never in the browser bundle. Use existing authenticated private access initially; do not expose an unauthenticated control endpoint.

Initial screen:

- **Your next move:** one human action, estimated time, reason and what it unblocks.
- **Agent work:** current task, last activity, upcoming eligible work and pause controls.
- **Needs you:** pending questions, reviewable deliverables and meaningful failures.
- **Since you left:** verified results and the next starting point.
- **System state:** mini last seen, stale/offline state and limits reached.

Task detail: Linear link, original brief, run/session ID, workspace, current phase, readable activity, evidence, open question, Take over and Hand back. Add Reference library as a separate view with a visible non-executable banner. Never offer Run now or Take over for an example.

Every control is a backend request that checks authorization, current task version, ownership and reference exclusion. Show pending/failure states truthfully. Do not display success before the operation is acknowledged. A stopped mini must show last-known timestamps, not a green running indicator. If hosted on the mini, the whole webpage may be unavailable during an outage; Linear remains the fallback, and the independent heartbeat alert must live elsewhere.

**Finished when:** the same task is consistent across Linear and the webpage. You can answer and perform a verified takeover; stale data and failed actions are visible.

### Step 11 — Add Slack when connected

Use project channels, initially `#command-center`, `#termstack`, `#publish-pilot`, `#preorder` and `#games`. Shared infrastructure can use #command-center until a separate channel becomes useful. Avoid department channels that split one product's context.

- [ ] Connect Linear's Slack integration with the required workspace permissions.
- [ ] Create or reuse channels intentionally; do not assume auto-created public channels are suitable.
- [ ] Link one discussion thread to each real task that needs conversation. Create genuine synchronization; an ordinary pasted/link-existing issue is not sufficient.
- [ ] Keep answers in the task's synchronized thread. Command-center processes the recorded answer once, acknowledges it and resumes through the standard scheduler checks.
- [ ] Route useful worker updates through the command-center notification adapter. Do not duplicate messages already mirrored by Linear.
- [ ] Put morning summaries and important operational failures in #command-center. Keep unchanged, non-actionable status quiet.

Use Linear comments as the initial answer source so the runner does not need to treat all Slack messages as commands. If a future custom Slack app needs event access, choose and verify its supported connection method; do not add an inbound public endpoint by assumption.

Our Slack integration targets the Mac mini runner. Installing Anthropic's native Claude-in-Slack experience alone is not the same local architecture. Keep unrelated cloud execution out of this workflow unless deliberately chosen.

**Finished when:** a question and reply stay attached to one task across Slack and Linear, duplicated delivery starts no duplicate run, and no reference example sends an operational notification.

### Step 12 — Make operation and recovery dependable

- [ ] Configure the mini's runner to restart after boot using its supported service manager; verify sleep, network and power behavior.
- [ ] Document any physical login or disk-unlock dependency after a full restart.
- [ ] Back up configuration, protected reference registry, run database and necessary session state; test restoring them. Treat session transcripts as private.
- [ ] Add an independent heartbeat check with a realistic threshold and an alert destination Rajat chooses. It must not depend on the failed mini to send the alert.
- [ ] Exercise pause, rate limit, expired authentication, unavailable Linear, failed result delivery and interrupted test cleanup.
- [ ] Preserve caps per product. Do not quietly borrow another product's spending allowance.
- [ ] Retain enough logs for diagnosis, omit credentials, and set artifact retention deliberately.

**Finished when:** restart does not duplicate work, an offline mini is detectable, and a failed sync can be replayed without rerunning the task.

### Step 13 — Expand the same pattern to business work

| Workflow | Agent deliverable | Human decision / completion condition |
| --- | --- | --- |
| TermStack growth | Merchant/agency research and outreach drafts | Review positioning and authorize actual sends separately |
| Non-Plus expansion | Feasibility and demand report with sources | Decide the offer and scope before development |
| Publish Pilot conversion | Funnel analysis, scoped improvement and email drafts | Verify data, audience, message and measured result |
| Preorder & Back in Stock launch | Segment/channel research and launch experiment | Define free scope, support budget and continue/stop criteria |
| Games recovery | Ranked inventory, selected update and build evidence | Verify recoverable value; release under the chosen policy |
| Shared pricing/email | Proven module extracted for identified consumers | Test every affected consumer; track versions and rollout |
| Varr Labs Website | Original design and product-page pull requests | Review visuals, claims and evidence; authorize merge/deployment separately |
| Varr Labs Lib | Reusable-package review and adoption plan | Review API boundaries and evidence; authorize merge/publication separately |
| Blogs | Existing scheduled draft, validation and publication flow | Existing review/veto policy continues |

Schedule non-development work with the same eligibility, ownership, question and budget rules. A report can be complete without authorizing its recommended project. New follow-up work enters Inbox unless already explicitly defined and authorized.

**Finished when:** each added workflow saves meaningful manual time or improves a measured business outcome without increasing review overload.

## 3. Real task template

Use this structure for both real tasks and explanatory reference descriptions. Reference issues must retain the warning and execution:never properties from Step 2.

```markdown
Goal:
Product:
Next performer: Human / Agent
Why now:
Required inputs and links:
Product Working instructions document:
Linked PR, if relevant:
Scope:
Out of scope:
Expected result / completion criteria:
Required tests or other evidence:
For testing: environment/store, tested commit/build, date, tester, expected/actual results and evidence links:
Dependencies:
Estimated human effort (including briefing, questions, manual testing and review):
Estimated agent runtime / spending, if relevant (separate from human capacity):
Allowed actions and release/send policy:
Time / retry / spending limits:
Open question, if any:
Latest result:
Resume here: current workspace, session, evidence and next action
```

## 4. Pilot acceptance checklist

Before expanding automation, demonstrate all of these using a separate real pilot plus local validation fixtures:

- [ ] All reference examples are rejected, including a fixture where their status is Ready and labels are missing.
- [ ] Duplicate polls and repeated Run now requests create only one active job.
- [ ] Task edits/cancellation before dispatch are respected.
- [ ] Missing inputs produce a saved question, not a fabricated answer.
- [ ] A delayed/duplicated reply resumes once and only the intended question.
- [ ] Takeover stops agent ownership; human disconnect does not silently hand control back.
- [ ] Hand-back preserves actual files, instructions and test state.
- [ ] The representative product test detects a real regression.
- [ ] Evidence names the exact tested revision; skipped checks are visible.
- [ ] A failed board update is retried without redoing completed work.
- [ ] Restart recovery and stale-worker handling do not create simultaneous writers.
- [ ] Dashboard/Slack never turn a reference example into work.

## 5. Immediate handoff after Linear is connected

The next setup session should do only the following initial batch:

- [x] Inspect the connected workspace, team, projects, statuses, labels and issues.
- [x] Reuse the one-team, original five-project structure; add Varr Labs Website and Varr Labs Lib for newly identified real work.
- [x] Verify statuses and labels available through the connection and save their IDs.
- [x] Prepare all six view definitions and validate their filters locally.
- [ ] Create/reuse the saved views and record their IDs/URLs; MCP does not expose view tools.
- [ ] Confirm Inbox is the default through a supported interface.
- [x] Create or reuse the 12 protected examples, with complete illustrative descriptions.
- [x] Save actual object IDs, issue links and the permanent reference registry in a user-visible setup manifest.
- [x] Verify every example is unassigned and unscheduled.
- [x] Verify the planned operational filters exclude all examples in a local snapshot check.
- [ ] Verify exclusion from the actual saved operational views.
- [x] Report connector limitations and provide the Linear reference index to Rajat.
- [x] Capture the current real-work inventory as VAR-17 through VAR-36 without prioritizing or dispatching it.

Do not execute the examples. Do not connect Slack, launch Claude, install a scheduler, send outreach or modify production as part of this initial Linear setup. Continue later implementation from this checklist with a separate real pilot task and the relevant access.

## 6. Documentation used

The details below support the design; validate installed versions and available connector features during setup.

- [Command-center operating rules](https://github.com/rajatujawane/command-center/blob/master/CLAUDE.md)
- [Current blog worker](https://github.com/rajatujawane/command-center/blob/master/agents/content-blog/worker.md)
- [Linear issue statuses](https://linear.app/docs/configuring-workflows)
- [Linear GitHub integration](https://linear.app/docs/github)
- [Linear Slack integration and synchronized threads](https://linear.app/docs/slack)
- [Claude programmatic execution and session resumption](https://code.claude.com/docs/en/headless)
- [Claude CLI reference](https://code.claude.com/docs/en/cli-reference)
- [Claude Remote Control](https://code.claude.com/docs/en/remote-control)

## 7. Continuation manifest — 7 September 2026

Canonical continuation outputs: /Users/rajatujawane/Documents/Codex/2026-09-06/linear-plugin-linear-openai-curated-remote/outputs.

- Reference issues: VAR-5 reused; VAR-6–VAR-16 created; all 12 verified.
- Protected UUID registry: linear-reference-registry.json (read-only, checksum beside it).
- Object mapping and exact planned view filters: linear-setup-manifest.json.
- Remaining view steps: linear-views-remaining.md; no saved view IDs or URLs exist from this run.
- Snapshot filter checks and local UUID-drift fixtures passed; installed scheduler dry run remains unperformed.
- Inbox default readback remains unavailable through MCP.
- Reference index: https://linear.app/varr-labs/document/varr-labs-reference-library-and-setup-0b27f005e0a3
- Current projects: TermStack, Publish Pilot, Preorder & Back in Stock, Games, Shared systems, Varr Labs Website and Varr Labs Lib.
- Real tasks: VAR-17 through VAR-36. VAR-26 is Doing; all others are in Inbox. No task has priority, a cycle, due date or `this-week`.
- Confirmed next performers: human on VAR-17, VAR-26 and VAR-31; agent on VAR-19 and VAR-20; unspecified on the remaining 15 tasks.
- Confirmed blocking links: VAR-18 blocked by VAR-17; VAR-27 blocked by VAR-26; VAR-30 blocked by VAR-33.
- Step 3 capture is complete. Weekly selection, performer decisions, capacity allocation and work-block grouping are not complete.
