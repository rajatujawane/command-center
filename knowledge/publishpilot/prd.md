> Reconciled against the `publish-pilot` **main** branch on 2026-08-02 (HEAD `04a0d85`).
> The repo's own `docs/PRD.md` is stale (dated 2026-04-11) — this file is corrected and is
> what command-center reads. Sections marked **[drift]** differ from the repo doc.
> Anything a blog post claims about plans, prices, or features must trace to THIS file.

# Product Requirements Document — Publish Pilot

**Version:** 1.1 (reconciled from code)
**Date:** 2026-08-02
**Status:** Living Document

---

## 1. Product Overview

**Publish Pilot** is a SaaS platform that allows Webflow users to schedule and automate their content publishing operations. It removes the need for manual, real-time intervention when publishing CMS items, HTML element changes, or full site publishes.

**Tagline:** "Automate & Schedule Your Webflow Publishing Effortlessly"

**Target Users:** Webflow designers, developers, and marketing teams who manage content publishing on a schedule. Since workspaces shipped, agencies managing several client sites are a first-class case.

**Note for writers:** Publish Pilot has no timezone picker. Never claim timezone support, and don't mention timezone as an aside. Timezone may only appear when explaining Webflow's own Site Settings behaviour.

---

## 2. Problem Statement

Webflow does not natively support scheduled publishing. Teams that need content to go live at a specific time (e.g., a product launch at midnight, a blog post at 9 AM) must be manually present to trigger the publish. This creates operational friction, requires off-hours work, and increases the chance of human error.

---

## 3. Solution

Publish Pilot integrates with Webflow via OAuth 2.0 and uses AWS EventBridge to fire scheduled Lambda functions that call the Webflow API at the specified time. Three action types:

1. **CMS Item Scheduling** — publish, draft, or archive specific CMS items
2. **Site-Wide Scheduling** — publish an entire site to custom domains
3. **HTML Element Scheduling** — inject CSS into elements via Webflow's custom code API (with optional auto-removal)

---

## 4. Tech Stack

### Backend
| Layer | Technology |
|---|---|
| Runtime | Node.js 22.x (TypeScript) |
| Infrastructure | Pulumi (AWS) |
| GraphQL API | AWS AppSync |
| REST API | AWS API Gateway |
| Database | AWS DynamoDB |
| Authentication | AWS Cognito |
| Task Scheduling | AWS EventBridge + Lambda |
| Payments | Lemon Squeezy |
| Transactional email | ZeptoMail **[drift — new]** |
| Product/ops events | LogSnag **[drift — new]** |
| HTTP Client | Axios |

### Frontend (Dashboard)
| Layer | Technology |
|---|---|
| Framework | Next.js 15.1.4 + React 19.0.0 |
| UI Framework | Chakra UI v3 |
| State Management | Redux Toolkit |
| GraphQL Client | Apollo Client |
| Auth | AWS Amplify Auth |
| Calendar | react-big-calendar + date-fns |
| Analytics | PostHog |
| Forms | react-hook-form |

### Marketing Site
Next.js 15.1.4 + React 19.0.0, Chakra UI, PostHog.

---

## 5. Architecture Overview

```
publish-pilot/
├── main-site/        # Marketing / landing page (Next.js)
├── front-end/        # User dashboard (Next.js + Redux)
├── back-end/         # Lambda functions + AWS infrastructure (Pulumi)
├── brand-kit/        # Brand assets
└── .github/          # CI/CD workflows
```

### Backend services **[drift — reorganised]**

`back-end/src/` is now top-level domains plus a `shared-services/` folder:

- **schedule-manager** — CRUD for schedule definitions, incl. recurrence validation
- **execute-schedule** — EventBridge-triggered; runs actions against the Webflow API
- **cms-collections** — CMS collection and item metadata
- **site-custom-domains** — domain enumeration per Webflow site
- **workspace** — workspaces, memberships, invitations, role auth guards
- **webhook-system** — outbound webhook configs, dispatch queue, test sends
- **shared-services/**
  - `user` — account and profile management
  - `subscription-system` — Lemon Squeezy billing lifecycle, plan details, effective limits
  - `usage-system` — monthly execution quota tracking
  - `webflow-interaction` — OAuth 2.0 + Webflow API calls
  - `scheduling-system` — EventBridge rule creation, audit trail, next-run computation
  - `schedule-runs` — per-run history rows (90-day TTL)
  - `email` — ZeptoMail transactional send (workspace invites today)
  - `logsnag` — event emission across lifecycle / revenue / usage / workspace / alerts

### REST Endpoints (API Gateway)
| Endpoint | Purpose |
|---|---|
| `GET /health-check` | Service health |
| `GET /webflow/install` | Webflow OAuth callback |
| `POST /ls/webhook` | Lemon Squeezy payment webhooks |

### GraphQL (AppSync)
All dashboard data operations are served via AppSync with Lambda resolvers.

---

## 6. DynamoDB Data Model **[drift — 5 new tables]**

| Table | Key Data |
|---|---|
| `users` | Account info, subscription state |
| `schedules` | Schedule definitions, executions, recurrence config, state |
| `schedule-runs` | Per-run history rows, 90-day TTL **(new)** |
| `subscription-usage` | Monthly execution count |
| `webflow-interaction` | OAuth access/refresh tokens, linked sites |
| `audit-logs` | Execution events with timestamps and error details, 90-day TTL |
| `special-tokens` | VIP subscription token registry |
| `cms-collections` | Cached CMS collection metadata |
| `workspaces` | Workspace records **(new)** |
| `memberships` | User ↔ workspace membership + role **(new)** |
| `invitations` | Pending workspace invites **(new)** |
| `webhook-configs` | Outbound webhook endpoints per workspace **(new)** |

---

## 7. Current Features

### Scheduling
- [x] Create, edit, delete schedules with a name, content type, and action type
- [x] **CMS scheduling** — publish / draft / archive one or more CMS items at a specific time
- [x] **Site-wide scheduling** — publish site to all custom domains or Webflow subdomain
- [x] **HTML element scheduling** — inject CSS via Webflow custom code API, with optional auto-removal
- [x] **Single execution** — fire once at a set time
- [x] **Start/End scheduling** — define a start action and an end action
- [x] **Recurring schedules** — DAILY / WEEKLY / MONTHLY / CUSTOM cadence **[drift — was v2 "planned", now shipped]**
      - Gated to **Pro and above**, plus all free-trial variants (trials mirror Pro here)
      - **Not supported for HTML_ELEMENT** content type (rejected with `RECURRING_NOT_SUPPORTED_FOR_HTML_ELEMENT`)
      - Server is the authority; the UI gate is only a hint. Unknown plans fail closed.
- [x] Calendar view of all upcoming schedules
- [x] Table view with sort, filter, and search
- [x] Run history per schedule (drawer in the dashboard)

### Workspaces & Teams **[drift — was v2 "planned", now shipped]**
- [x] Workspaces with membership and role-based access: **owner / admin / editor / viewer**
- [x] Email invitations with expiry, sent via ZeptoMail from `invites@publishpilot.app`
- [x] `/invite` acceptance flow in the dashboard
- [x] Per-plan member limits (see pricing)

### Outbound Webhooks / Integrations **[drift — was v2 "planned", now shipped]**
- [x] Outbound webhooks on schedule execution results
- [x] Named integrations on the marketing site: **Slack, Zapier, custom webhook**
- [x] Test-send from the dashboard
- [x] **Business tier only, and paid only** — trials are deliberately excluded, since webhooks are the feature justifying the Business price

### Webflow Integration
- [x] OAuth 2.0 authorization flow (`/webflow/install`)
- [x] Multi-site support, subject to per-plan site limits
- [x] Automatic OAuth token refresh on expiry
- [x] Webflow API v2
- [x] CMS collection and item browsing within the dashboard

### Execution Engine
- [x] AWS EventBridge-based scheduling
- [x] Retry logic with exponential backoff for transient failures
- [x] Detailed error codes and messages per failure type
- [x] Audit log of every execution event (`EXECUTION_STARTED`, `EXECUTION_COMPLETED`, `EXECUTION_FAILED`)
- [x] Separate per-run history rows for the dashboard's run drawer

### Account & Billing
- [x] Email-based sign-up via AWS Cognito (auto-confirmed)
- [x] Three paid tiers: Starter, Pro, Business — monthly and annual
- [x] Three trial variants: standard (7 days), launch offer (30 days), VIP (60 days) **[drift — undocumented before]**
- [x] Business **add-on units**: +4 sites and +400 executions each **[drift — new]**
- [x] Plan upgrade/downgrade with end-of-period deferral, and a `higherPlanBenefit` grace window so a requested downgrade doesn't revoke paid-for entitlements early
- [x] Usage dashboard showing current month's execution count vs. plan limit
- [x] VIP/token-based free subscription access

### UX / General
- [x] Dark mode support
- [x] Responsive / mobile-optimized design
- [x] PostHog analytics; LogSnag operational events
- [x] Processing state screen during Webflow OAuth

---

## 8. Pricing Tiers **[drift — every price changed]**

Source of truth: `back-end/src/shared-services/subscription-system/services/types/plan-details.ts`, cross-checked against `main-site/src/app/components/pricing.tsx`.

| Plan | Monthly | Yearly (per mo) | Billed annually | Executions/mo | Sites | Members | Recurring | Webhooks | Audit Log |
|---|---|---|---|---|---|---|---|---|---|
| **Starter** | $19 | $15 | $180 | 100 | 2 | 5 | — | — | 14 days |
| **Pro** | $39 | $29 | $348 | 500 | 5 | 15 | ✅ | — | 60 days |
| **Business** | $79 | $65 | $780 | 1,200 | 12 | Unlimited | ✅ | ✅ | 90 days |

**Trials:** 100 executions, 2 sites, 2 members. Standard 7 days, launch offer 30 days, VIP 60 days. Trials may use recurring schedules; they may **not** use webhooks.

**Business add-on:** +$19/mo (+$15/mo billed annually) per unit, each granting **4 additional sites and 400 additional executions**.

The old $10 / $25 / $49 pricing in the repo's `docs/PRD.md` is dead. Business executions were also cut from 1,500 to 1,200 (commit `e9b9e72`). **Never quote the old numbers in a post.**

---

## 9. Environments

| Environment | Domain |
|---|---|
| Production | `publishpilot.app` / `api.publishpilot.app` |
| Staging | `api-stage.publishpilot.app` |
| Dev | `api-dev.publishpilot.app` |

Managed via Pulumi stack files (`Pulumi.dev.yaml`, `Pulumi.stage.yaml`, `Pulumi.prod.yaml`).

---

## 10. Known Limitations

- Recurring schedules are **not** available for HTML element content
- Recurring requires Pro or above
- Outbound webhooks require paid Business
- No bulk schedule creation via CSV or template
- No execution-result email notifications — email is wired up but currently only sends workspace invites
- Audit log is read-only; no export functionality
- No timezone picker anywhere in the product
- "Publish Now" (immediate execution) is still a placeholder in `schedule-menu.tsx`

---

## 11. Roadmap

### Near-term
- **"Publish Now"** — placeholder UI exists; not implemented
- **Execution-result email notifications** — ZeptoMail is integrated for invites; extending it to run results is the remaining work
- **Payment event recording** — Lemon Squeezy `payment_success` / `payment_failed` / `payment_recovered` / `payment_refunded` still have stub handlers
- **Audit log export** — CSV/JSON download

### Later
- **Template schedules** — save and reuse a schedule configuration
- **Bulk scheduling** — CSV upload or clone-schedule
- **Advanced analytics dashboard** — execution trends, success/failure rates, plan consumption
- **Webflow CMS filtering** — schedule by field criteria rather than manual item selection
- **Platforms beyond Webflow** — open question

*Recurring scheduling, team/workspace support, and outbound webhooks have all shipped and moved out of this section.*

---

## 12. Non-Functional Requirements

| Category | Requirement |
|---|---|
| **Availability** | Lambda + EventBridge — no server management; auto-scales |
| **Reliability** | Exponential backoff retry on Webflow API failures |
| **Security** | OAuth tokens encrypted at rest in DynamoDB; Cognito JWT auth; workspace role guards on every mutation; entitlement checks fail closed on unknown plans |
| **Observability** | Audit log + run history for executions; PostHog for product analytics; LogSnag for lifecycle/revenue/usage/workspace/alert events |
| **Compliance** | Subscription lifecycle events tracked; billing deferral and `higherPlanBenefit` grace prevent unintended charges or early revocation |
| **Performance** | EventBridge fires Lambda within seconds of scheduled time |

---

## 13. Open items to verify before writing about them

1. **Audit log retention.** Marketing and this doc say 14 / 60 / 90 days by plan, but `log-audit-event.ts` writes a flat 90-day TTL on every row regardless of plan. Either the tiering isn't enforced or it lives somewhere I didn't find. **Don't make retention a selling point in a post until this is settled.**
2. Execution-accuracy SLA is still undefined (how close to the scheduled second must a run fire?).
3. Whether platforms beyond Webflow are on the roadmap at all.

---

*Reconciled from the main branch on 2026-08-02. Re-check after any pricing change, plan-limit change, or new entitlement gate.*
