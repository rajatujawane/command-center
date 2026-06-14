# PRD_Latest.md — Term Stack: Dynamic B2B Payment Terms Rules Engine (Shopify Plus)

**Product:** Shopify-native rules engine for **B2B payment terms** enforced at checkout using **Shopify Functions — Cart Payment Methods Transform**
**Last Updated:** 2026-05-21
**Status:** MVP Built — Pre-Launch

> This document reflects the **actual implemented state** of the Term Stack application as verified against the codebase. It supersedes the original PRD.md which contained planning-phase assumptions and unresolved [OPEN] items.

---

## 1) Overview

### Problem Statement

Shopify Plus B2B merchants need **dynamic** payment terms that reflect real agreements (risk, order size, buyer tier, product mix). Shopify's defaults are **static** at the company level, pushing merchants into manual workarounds (draft orders, invoices, sales ops intervention), causing policy drift, increased credit risk, and checkout friction.

### Solution

Term Stack is a Shopify-embedded app that provides a **rules engine** for B2B payment terms. Merchants define ordered rules with conditions and outcomes. At checkout, a Shopify Function evaluates the rules top-down (first-match wins) and applies the appropriate payment terms.

### Key Differentiators

- **Rules-based engine** with deterministic, auditable evaluation
- **Simulator** for testing rules before publishing
- **Version history** with rollback capability
- **Immutable audit trail** for governance and compliance
- **Plan-based tiering** for different merchant needs

---

## 2) Architecture Overview

### Monorepo Structure

```
term-stack/
├── packages/
│   ├── admin/              # Next.js 15 embedded Shopify admin app
│   ├── backend/            # AWS serverless backend (Lambda + DynamoDB)
│   └── shared-types/       # TypeScript types/interfaces/enums shared across packages
├── extensions/
│   └── term-stack-payment-terms/  # Shopify Function (Rust → WASM)
├── docs/                   # Product documentation
├── brand-kit/              # Brand assets
└── .shopify/              # Shopify CLI config
```

### Tech Stack

| Layer | Technology |
|-------|-----------|
| **Frontend** | Next.js 15.1.4, React 18.2.0, Shopify Polaris Web Components |
| **Backend** | AWS Lambda (Node.js 22.11+), TypeScript 5.9.3 |
| **Database** | AWS DynamoDB |
| **API Gateway** | AWS API Gateway (REST + CORS) |
| **Infrastructure as Code** | Pulumi 3.144.1 |
| **Shopify Function** | Rust → WebAssembly (WASM) |
| **Authentication** | Shopify App Bridge v4 (JWT / idToken) |
| **Error Tracking** | Sentry (frontend + backend) |
| **Analytics** | PostHog (frontend) |
| **Scheduling** | AWS EventBridge Scheduler |
| **Package Manager** | Yarn 4.6.0 |

---

## 3) Personas & Roles

### Target Personas

1. **Merchant Admin (Owner/IT/Admin)** — Installs app, manages settings, publishes rulesets, manages billing.
2. **Finance Ops / Controller / CFO** — Defines payment policy, requires auditability, cares about risk + cashflow.
3. **Sales Ops / Account Manager** — Needs exceptions/overrides, wants consistent terms without manual workarounds.
4. **Ecom Director / RevOps** — Cares about checkout conversion + reduced friction.
5. **Customer Support Lead** — Needs "why this terms?" explainability to reduce tickets.
6. **B2B Buyer (Company Buyer)** — Experiences the policy at checkout; expects clarity/predictability.

### Permissions Model (Current Implementation)

**No in-app RBAC is implemented.** Authentication relies entirely on Shopify App Bridge:

- App is embedded in Shopify admin; only staff with app access can use it
- Authentication via Shopify App Bridge `idToken()` (JWT)
- All authenticated users have identical permissions within the app
- Actor identity is captured for audit trail purposes

> **Future consideration:** The original PRD outlined Admin/Editor/Read-only roles. This remains a potential V2 feature but is not currently implemented.

---

## 4) Billing & Subscription Plans

### Pricing Tiers

| Feature | FREE | CORE ($99/mo) | GROWTH ($149/mo) | SCALE ($299/mo) |
|---------|------|---------------|-----------------|-----------------|
| **Trial Period** | N/A | 14 days | 14 days | 14 days |
| **Max Rules (stored)** | 10 | 90 | 100 | 100 |
| **Max Active Rules (published)** | 0 (cannot publish) | 15 | 40 | 75 |
| **Audit Retention** | 7 days | 30 days | 180 days | 365 days |
| **Version History** | 0 | 1 (rollback) | 20 versions | 90 versions |
| **Simulate History** | No | No | Yes | Yes |

### Subscription Lifecycle

```
States: NONE → ACTIVE → CANCELLED / FROZEN / EXPIRED

NONE       → ACTIVE      (webhook: subscription approved)
ACTIVE     → CANCELLED   (merchant cancels; grace period until currentPeriodEnd)
ACTIVE     → FROZEN      (payment failed; Shopify retrying)
FROZEN     → ACTIVE      (retry succeeded)
FROZEN     → EXPIRED     (all retries exhausted)
CANCELLED  → ACTIVE      (resubscribe)
```

### Feature Access by Status

| Status | Access Level |
|--------|-------------|
| ACTIVE | Full plan features |
| CANCELLED | Grace period until `currentPeriodEnd` or `trialEndsAt` |
| FROZEN | Blocked — treated as FREE plan immediately |
| NONE / EXPIRED | FREE plan only |

### Trial Handling

- First subscription gets 14-day trial
- Trial is immutable per shop (stored in `trialEndsAt`)
- Resubscribing within trial carries over remaining days
- Resubscribing after trial: no trial, immediate billing
- Billing test mode available via `BILLING_TEST_MODE` environment variable

---

## 5) Core Features (Implemented)

### 5.1 Rules Engine

#### Rule Object

A Rule consists of:
- `id` — Unique identifier
- `name` — Human-readable name
- `enabled` — Toggle (true/false)
- `priority` — List order defines evaluation precedence
- `conditions[]` — Array of conditions (AND semantics within a rule)
- `outcome` — Payment terms + optional deposit
- `createdAt`, `updatedAt`, `createdBy`, `updatedBy` — Audit metadata

#### Condition Types

| Condition Type | Description | Available Operators |
|---------------|-------------|-------------------|
| `CUSTOMER_TAG` | Customer tag membership | ANY_OF, NONE_OF |
| `COMPANY` | B2B company identifier | ANY_OF, NONE_OF |
| `COMPANY_LOCATION` | B2B company location | ANY_OF, NONE_OF |
| `ORDER_TOTAL` | Numeric order total comparison | EQUALS, NOT_EQUALS, GTE, GT, LTE, LT, BETWEEN |
| `COLLECTION` | Cart items from collections | ANY_OF, NONE_OF, ALL_OF |
| `FIRST_ORDER` | Whether this is the customer's first order | EQUALS |
| `TOTAL_ORDERS_COUNT` | Total number of previous orders | EQUALS, NOT_EQUALS, GTE, GT, LTE, LT, BETWEEN |
| `PAYMENT_TERMS` | B2B company location's payment terms template (Shopify-assigned) | ANY_OF, NONE_OF |

> **PAYMENT_TERMS** matches against the 8 canonical Shopify `PaymentTermsTemplate` values: `NO_PAYMENT_TERMS`, `DUE_ON_FULFILLMENT`, `NET_7`, `NET_15`, `NET_30`, `NET_45`, `NET_60`, `NET_90`. The value (and optional deposit percentage 1–99) is read from a `location-context` metafield on the buyer's CompanyLocation, kept in sync by the backend (see § 5.10). Absent metafield → condition does not match. **Not to be confused with the merchant's outcome deposit** (0–99 on the Outcome Builder) — see § 5.10.

> **Note vs. Original PRD:** The original PRD specified CUSTOMER_METAFIELD, COMPANY_METAFIELD, and SHIPPING_COUNTRY condition types. These were **not implemented**. Instead, FIRST_ORDER, TOTAL_ORDERS_COUNT, and PAYMENT_TERMS were added. COMPANY and COMPANY_LOCATION are implemented as direct ID-based matching rather than metafield-based.

#### Operators (Full List)

| Operator | Category | Value Shape | Description |
|----------|----------|-------------|-------------|
| ANY_OF | Set | string[] | Any value matches (set intersection non-empty) |
| NONE_OF | Set | string[] | No values match (set intersection empty) |
| ALL_OF | Set | string[] | All values match (subset relationship) |
| CONTAINS | String | string | Value contains substring |
| NOT_CONTAINS | String | string | Value does not contain substring |
| EXISTS | Existence | (none) | Field exists (non-null) |
| NOT_EXISTS | Existence | (none) | Field does not exist |
| EQUALS | Equality | string \| number \| boolean | Exact match |
| NOT_EQUALS | Equality | string \| number \| boolean | Not exact match |
| GTE | Numeric | number | Greater than or equal |
| GT | Numeric | number | Greater than |
| LTE | Numeric | number | Less than or equal |
| LT | Numeric | number | Less than |
| BETWEEN | Numeric | { min, max } | Between inclusive |

> **Note vs. Original PRD:** CONTAINS and NOT_CONTAINS operators were added beyond what was specified in the original PRD.

#### Outcome Types (Payment Terms)

| Payment Terms Type | Description |
|-------------------|-------------|
| `NO_PAYMENT_TERMS` | No specific terms applied |
| `NET_DAYS` | Net X days (e.g., Net 30, Net 60) |
| `DUE_ON_FULFILLMENT` | Payment due when order is fulfilled |
| `DUE_ON_FULFILLMENT_CREATED` | Payment due when fulfillment is created |
| `DUE_ON_INVOICE_SENT` | Payment due when invoice is sent |

> **Note vs. Original PRD:** The original PRD specified `pay_now`, `fixed_date`, and `event_based` as outcome types. The actual implementation uses Shopify-aligned terms: `NO_PAYMENT_TERMS`, `NET_DAYS`, `DUE_ON_FULFILLMENT`, `DUE_ON_FULFILLMENT_CREATED`, `DUE_ON_INVOICE_SENT`.

#### Deposit Support

Outcomes can include an optional deposit:
- **DEPOSIT_PERCENT**: Percentage of order total (0–100)
- **DEPOSIT_FIXED**: Fixed amount deposit

> **Note vs. Original PRD:** The original PRD only mentioned percentage-based deposits. Fixed-amount deposits (`DEPOSIT_FIXED`) were also implemented.

#### Rule Limits

Rule count limits are **plan-based** (not a fixed 200/50 as originally specified):
- FREE: 10 stored / 0 publishable
- CORE: 90 stored / 15 publishable
- GROWTH: 100 stored / 40 publishable
- SCALE: 100 stored / 75 publishable

### 5.2 Rule Evaluation Semantics

- **Deterministic**: Same inputs → same outputs; no randomness; no external calls
- **First-match wins**: Rules evaluated top-down by list order; first matching rule's outcome is applied
- **AND semantics**: All conditions within a rule must match
- **Enabled rules only**: Disabled rules are skipped
- **B2B gating**: If no B2B context (purchasingCompany) exists, Function returns NO_CHANGE (does not affect DTC checkout)
- **No-match behavior**: Configurable via default payment terms setting

### 5.3 Publish & Versioning

- **Draft/Published workflow**: Edits are saved as draft; explicit "Publish" action creates a new version
- **Version history**: Immutable snapshots with timestamps (retention varies by plan)
- **Rollback**: One-click rollback to any accessible previous version (creates a new published version)
- **Compilation**: Rules compiled to compact JSON format optimized for Shopify Function execution
- **Atomic publish**: Version marked published only after successful distribution to Shopify metafield
- **Discard**: Ability to discard draft changes (single rule or all)

### 5.4 Rule Distribution (RESOLVED)

> The original PRD marked distribution as [OPEN]. This has been **resolved**.

**Mechanism:** Metafield-based distribution on PaymentCustomization object.

- Compiled rules are stored as a metafield on the PaymentCustomization
- If payload exceeds 4KB limit, it is **chunked** across multiple metafields
- Function reads the primary metafield and reassembles chunks if present
- **Fallback**: If config not found or unreadable, Function returns NO_CHANGE

### 5.5 Simulator

- Evaluate rules against test checkout contexts
- Supports testing against Draft or Published versions
- **Input methods**:
  - Company/customer/location pickers (fetches data from Shopify)
  - Manual input for order total, tags, etc.
- **Presets**: Built-in test scenarios (VIP customer, large order, wholesale, new customer)
- **Debug output**: Shows matched rule, applied terms, and evaluation trace
- **History simulation**: Available on GROWTH and SCALE plans only

### 5.6 Audit Trail

Immutable log of all mutations with TTL-based retention (varies by plan: 7–365 days).

#### Audit Actions

| Category | Action | Description |
|----------|--------|-------------|
| **Rules** | `RULE_CREATED` | New rule created |
| | `RULE_UPDATED` | Rule fields modified |
| | `RULE_DELETED` | Rule soft-deleted |
| | `RULE_TOGGLED` | Rule enabled/disabled |
| | `RULE_REORDERED` | Rules priority reordered |
| **Ruleset** | `RULESET_PUBLISHED` | Ruleset published to checkout |
| | `RULESET_ROLLBACK` | Rolled back to previous version |
| | `RULESET_RESTORED` | Ruleset restored on app reinstall |
| **Drafts** | `DRAFT_DISCARDED` | Single rule draft discarded |
| | `DRAFT_DISCARDED_ALL` | All drafts discarded |
| **Settings** | `SETTINGS_CHANGED` | Store settings modified |
| **Lifecycle** | `INSTALL_CREATED` | App installed |
| | `APP_UNINSTALLED` | App uninstalled |
| | `SHOPIFY_PLAN_CHANGED` | Shopify plan upgrade/downgrade |
| | `DEV_STORE_MIGRATED` | Dev store transferred to live |

Each audit event includes: actor identity, timestamp, action, before/after changes, and contextual data.

### 5.7 Settings

| Setting | Description | Options |
|---------|-------------|---------|
| **Default Payment Terms** | Behavior when no rule matches | `NO_CHANGE` (no-op) or `DEFAULT_OUTCOME` (apply merchant-defined default) |
| **Fail-Safe Mode** | Behavior on evaluation/config failure | `NO_CHANGE` (default) or `DEFAULT_TERMS` |
| **Enforce Function** | Enable/disable the Shopify Function | Boolean toggle |

### 5.8 Onboarding

- First-time merchant setup flow
- Payment Customization Function creation and activation
- Metafield configuration for rule distribution
- Guided walkthrough of app features

### 5.9 Dashboard

- Setup guide for new merchants
- Rules overview (count, status)
- Usage indicators (plan limits, active rules vs. max)

### 5.10 Location Context Sync (PAYMENT_TERMS feature)

Shopify Functions cannot make external API calls at checkout, so any data the `PAYMENT_TERMS` condition needs must already live on the cart input. The backend solves this by mirroring each B2B CompanyLocation's payment terms into a metafield that the Function reads directly.

#### The Metafield

- **Owner:** `CompanyLocation`
- **Namespace / Key:** `$app:termstack / location-context`
- **Value (JSON):**
  ```json
  { "paymentTerms": { "value": "NET_45", "depositPercentage": 22 } }
  ```
- `depositPercentage` is `null` when no deposit is configured; otherwise an integer in **1–99**.

> **Distinct from outcome deposits.** The `depositPercentage` here mirrors Shopify's payment-terms-template setting on the CompanyLocation — it's *input data* the condition matches against. The merchant's own outcome deposit (set in the Outcome Builder, range 0–99 where 0 = no deposit) is a separate field on the rule's outcome and is what actually gets applied at checkout.

#### Sync Pipeline

1. **Initial backfill** — When a merchant publishes a ruleset that contains any `PAYMENT_TERMS` condition (and no prior backfill exists), the `start-location-context-sync` API handler marks the sync `IN_PROGRESS` and async-invokes the dedicated `backfill-location-context` Lambda (fire-and-forget via `InvocationType: 'Event'`). The backfill iterates all company locations and writes the metafield.
2. **Live updates via webhooks** — `company_location/create` and `company_location/update` are received by a single handler that performs HMAC verify and pushes onto SQS (~50 ms, zero Shopify API calls).
3. **SQS consumer** — `location-context-consumer` dequeues in batches, fetches fresh location data from Shopify, and writes the metafield. Standard (non-FIFO) queue: last-write-wins on the fresh fetch makes ordering irrelevant.
4. **Conditional subscription** — Webhook subscriptions for `company_location/*` are added when an active rule first uses `PAYMENT_TERMS` and removed when the last such rule is deleted. Failed unsubscribes are queued for retry.
5. **Daily cleanup scheduler** — `webhook-cleanup` Lambda scans the `webhook_cleanup_queue` table once a day and retries each failed unsubscribe; deletes on success, gives up after `MAX_ATTEMPTS`. TTL bounds the retry window.
6. **Reconciliation service** — Compares Shopify state against app state and corrects drift.

#### Sync State Machine

Stored on `shop_settings.locationMetafieldContext.sync`:

| State | Meaning |
|-------|---------|
| `PENDING` | Never run (no `PAYMENT_TERMS` rule has been published yet) |
| `IN_PROGRESS` | Backfill Lambda running (frontend polls every 5s) |
| `COMPLETED` | Backfill finished; webhooks keeping data fresh |
| `FAILED` | Backfill errored; `errorMessage` populated |

> **Timeout is client-side only.** The frontend maintains a `FRONTEND_TIMEOUT_MS = 11 min` flag (`hasTimedOut`) that flips the banner copy if `IN_PROGRESS` lasts too long; the backend state itself stays `IN_PROGRESS` until the backfill Lambda transitions it. There is no `TIMED_OUT` server state.

#### Subscription Lifecycle (when rules change)

A single reconciler (`reconcileCompanyLocationSubscription`) runs after every rule mutation. "Desired subscription" is defined as: **any rule — draft OR published, enabled OR disabled — contains a `PAYMENT_TERMS` condition**. Enabled state is intentionally ignored: a disabled rule is one click away from going live, and the re-subscribe + backfill window is minutes, so the webhook stays warm.

| Desired | Current | Action |
|---------|---------|--------|
| ✅ | ❌ | Reset sync → `PENDING`, subscribe webhook in Shopify, trigger backfill Lambda. If subscribe fails, sync goes to `FAILED` and the mutation surfaces an error. |
| ❌ | ✅ | Unsubscribe in Shopify. On Shopify-side failure, the row is enqueued into `webhook_cleanup_queue` for the daily cron to retry — the rule write itself is never blocked. |
| ✅ | ✅ | No-op for subscription; re-evaluates backfill status (covers retrying a previously `FAILED` backfill). |
| ❌ | ❌ | No-op. |

**What gets cleaned up when the last `PAYMENT_TERMS` rule is removed:**
- ✅ Shopify webhook subscription deleted (best-effort, with cron retry)
- ❌ Sync state on `shop_settings` is **not reset** — it retains the last `COMPLETED` / `FAILED` value. Re-adding a `PAYMENT_TERMS` rule later will force it back to `PENDING` and re-run the backfill, so stale state is self-healing.
- ❌ `location-context` metafields on CompanyLocations are **not deleted**. Rationale: cleaning them would burn a Shopify API call per location for zero merchant value, and if the rule is re-added the existing data is still a useful (if possibly stale) starting point — the re-run backfill overwrites it.

#### Reinstall Behavior

When a merchant uninstalls and later reinstalls, `reactivateAccount` restores the archived ruleset as a draft. If any restored rule contains a `PAYMENT_TERMS` condition (`restoreResult.hasPaymentTermsCondition`), the reconciler is invoked **awaited** (not fire-and-forget — reinstall is the one path where the caller blocks on sync setup). This resets sync to `PENDING`, re-subscribes the `company_location/*` webhook, and triggers a fresh backfill — ensuring metafields are accurate even if the location set drifted while the app was uninstalled. Failures here are logged but do not block reactivation.

#### UX

- **`LocationContextSyncProvider`** — React context with 5s polling and an 11-min client-side timeout; sync state can also be pushed directly from the create/update rule API response.
- **Non-dismissable `SyncStatusBanner`** in the AppShell for `IN_PROGRESS` (with a distinct copy variant once `hasTimedOut` flips) and `FAILED` states.
- **Pre-publish warning modal** if the merchant tries to publish a ruleset whose `PAYMENT_TERMS` condition relies on a sync that isn't `COMPLETED`.
- **`LocationContextSyncSettings`** component on the Settings page exposes manual re-sync and current status.
- **`ConditionBuilder`** has a PAYMENT_TERMS variant (template multi-select + deposit input).
- **`SimulatorInputPanel`** displays the selected location's current payment terms snapshot.

---

## 6) Admin UI — Pages & Routes

| Route | Page | Purpose |
|-------|------|---------|
| `/` | Dashboard | Setup guide, rules overview, usage indicators |
| `/rules` | Rules List | View, search, reorder, enable/disable rules |
| `/rules/new` | Create Rule | Rule builder with conditions and outcomes |
| `/rules/[id]` | Edit Rule | Modify existing rule |
| `/rules/versions` | Version History | Browse versions, rollback |
| `/simulator` | Simulator | Test rules against sample inputs |
| `/audit` | Audit Log | View immutable audit trail with filters |
| `/settings` | Settings | Default terms, fail-safe, enforcement toggle |
| `/plans` | Pricing | View plans, upgrade/downgrade |
| `/onboarding` | Onboarding | First-time setup wizard |

### Key UI Components

- **RuleBuilder**: Form for creating/editing rules with condition and outcome builders
- **ConditionBuilder**: Multi-condition UI with type selector, operator, and value inputs
- **OutcomeBuilder**: Payment terms type + deposit selection
- **RulesTable**: Sortable rules list with inline actions (toggle, delete)
- **Simulator**: Rule evaluation with company/customer/location pickers and debug output
- **VersionsTable**: Version history browser with rollback capability
- **UsageIndicator**: Plan limit progress bars
- **PricingCard**: Plan comparison with upgrade buttons
- **PageBannerManager**: Top-of-page contextual alerts
- **CollectionSelector**: Shopify collection picker for conditions
- **CompanyLocationSelector**: B2B company location picker

### Frontend Architecture

- **State Management**: React Context API (AuthProvider, RulesProvider)
- **Data Fetching**: Custom hooks (`use-rules`, `use-simulator`, `use-billing`, `use-audit`, `use-versions`, `use-settings`)
- **API Client**: Shopify App Bridge idToken() for authentication, Bearer token in Authorization header
- **Caching**: Stale-while-revalidate pattern
- **Styling**: Shopify Polaris Web Components + inline styles + global CSS

---

## 7) Backend Architecture

### Layered Architecture

```
Platform Layer (auth, errors, logging, validation)
    ↓
Adapters Layer (DynamoDB repos, Shopify API clients)
    ↓
Services Layer (business logic, orchestration)
    ↓
Functions Layer (thin Lambda handlers)
```

### Services

| Service | Responsibility |
|---------|---------------|
| **Ruleset Service** | Compiler, validator, publisher, rollback logic |
| **Simulator Service** | Rule evaluation engine |
| **Billing Service** | Subscription lifecycle, plan limits, feature access |
| **Settings Service** | Default terms, fail-safe, enforcement modes |
| **Account Service** | Merchant onboarding, reactivation |

### API Endpoints

#### Ruleset Management
| Method | Endpoint | Purpose |
|--------|----------|---------|
| GET | `/api/rulesets` | Get current ruleset (draft + published state) |
| POST | `/api/rulesets/validate` | Validate draft before publish |
| POST | `/api/rulesets/publish` | Publish ruleset to checkout |
| POST | `/api/rulesets/rollback` | Rollback to a previous version |
| POST | `/api/rulesets/draft/discard` | Discard all draft changes |
| GET | `/api/rulesets/versions` | List version history |
| GET | `/api/rulesets/versions/{id}` | Get specific version details |

#### Rule Operations
| Method | Endpoint | Purpose |
|--------|----------|---------|
| POST | `/api/rules` | Create a new rule |
| PUT | `/api/rules/{id}` | Update an existing rule |
| DELETE | `/api/rules/{id}` | Delete a rule |
| POST | `/api/rules/{id}/toggle` | Toggle rule enabled/disabled |
| POST | `/api/rules/reorder` | Reorder rule priorities |

#### Simulator
| Method | Endpoint | Purpose |
|--------|----------|---------|
| POST | `/api/simulate` | Evaluate rules against test context |

#### Audit
| Method | Endpoint | Purpose |
|--------|----------|---------|
| GET | `/api/audit` | List audit events (filterable) |

#### Settings
| Method | Endpoint | Purpose |
|--------|----------|---------|
| GET | `/api/settings` | Get shop settings |
| POST | `/api/settings/default-payment-terms` | Set default payment terms |
| POST | `/api/settings/fail-safe-mode` | Set fail-safe mode |

#### Billing
| Method | Endpoint | Purpose |
|--------|----------|---------|
| GET | `/api/billing/status` | Get subscription status |
| POST | `/api/billing/create-subscription` | Create a new subscription |
| POST | `/api/billing/cancel-subscription` | Cancel subscription |

#### Shopify Integration
| Method | Endpoint | Purpose |
|--------|----------|---------|
| GET | `/api/shopify/companies` | List B2B companies (for simulator) |

#### Location Context (PAYMENT_TERMS sync)
| Method | Endpoint | Purpose |
|--------|----------|---------|
| POST | `/api/sync/location-context/start` | Trigger backfill of `location-context` metafield across all CompanyLocations |
| GET | `/api/sync/location-context/status` | Get current sync status (PENDING / IN_PROGRESS / COMPLETED / FAILED) |
| GET | `/api/sync/location-context/metafield?locationId={id}` | Fetch a single location's metafield snapshot as the Shopify Function would see it (used by simulator) |

#### Webhooks
| Method | Endpoint | Purpose |
|--------|----------|---------|
| POST | `/webhooks/app-uninstalled` | Handle app uninstall |
| POST | `/webhooks/subscription-update` | Handle billing status changes |
| POST | `/webhooks/shop-update` | Handle shop info changes (Plus status, dev→live migration) |
| POST | `/webhooks/company-location` | Handle `company_location/create` + `company_location/update` (HMAC verify → SQS enqueue) |
| POST | `/webhooks/customers-data-request` | GDPR: customer data request |
| POST | `/webhooks/customers-redact` | GDPR: customer deletion |
| POST | `/webhooks/shop-redact` | GDPR: shop deletion |

### Authentication

1. **Frontend → Backend**: Shopify App Bridge `idToken()` generates JWT → sent as `Authorization: Bearer {token}`
2. **Backend validation**: JWT signature verified using Shopify API secret → shop domain extracted → merchant looked up in DynamoDB → subscription context built
3. **Webhook verification**: `X-Shopify-Hmac-SHA256` header validated using API secret
4. **Required Shopify scopes**: `read_payment_customizations`, `write_payment_customizations`, `read_companies`, `write_companies` (the last is required to write the `$app:termstack/location-context` metafield on CompanyLocation — no separate `write_metafields` scope is needed)

---

## 8) Database Schema (DynamoDB)

### Tables

#### `merchants`
| Field | Type | Description |
|-------|------|-------------|
| `shopId` (PK) | String | Unique shop identifier |
| `shopDomain` | String | Shop domain (GSI: `merchant-by-domain-index`) |
| `name`, `email`, `shopOwner` | String | Shop details |
| `countryName`, `timezone`, `currency` | String | Locale info |
| `shopifyPlanName`, `isDevStore`, `isPlusPlan` | String/Boolean | Shopify plan info |
| `plan` | Enum | MerchantPlan (FREE/CORE/GROWTH/SCALE) |
| `subscriptionStatus` | Enum | NONE/ACTIVE/CANCELLED/FROZEN/EXPIRED |
| `shopifySubscriptionId` | String | Shopify billing subscription ID |
| `currentPeriodEnd`, `trialEndsAt` | String | Billing dates |
| `pendingPlan`, `pendingPlanEffectiveAt` | String | Pending plan change |
| `overrideLimits` | Object | Custom feature gate overrides |
| `createdAt`, `updatedAt` | String | Timestamps |

#### `ruleset_versions`
| Field | Type | Description |
|-------|------|-------------|
| `shopId` (PK) | String | Shop identifier |
| `versionTimestamp` (SK) | String | Version timestamp |
| `rules` | Array | All rules (enabled & disabled) |
| `publishedRules` | Array | Enabled rules only (snapshot) |
| `compiledRules` | String | WASM-ready compiled format |
| `status` | Enum | DRAFT / PUBLISHED / ARCHIVED |
| `failSafeMode` | Enum | NO_CHANGE / DEFAULT_TERMS |
| `defaultOutcome` | Object | Outcome for fail-safe defaults |
| `sizeEstimate` | Object | { preCompiled, compiled, numRules } |

#### `ruleset_state`
| Field | Type | Description |
|-------|------|-------------|
| `shopId` (PK) | String | Shop identifier |
| `currentVersionTimestamp` | String/null | Pointer to published version |
| `lastPublishedAt` | String | Last publish timestamp |

#### `audit_log`
| Field | Type | Description |
|-------|------|-------------|
| `shopId` (PK) | String | Shop identifier |
| `timestamp` (SK) | String | Event timestamp |
| `action` | Enum | AuditAction (see Section 5.6) |
| `actor` | Object | { id, name, type } |
| `changes` | Object | { before, after, diff } |
| `ruleId`, `version`, `context` | Various | Contextual data |
| `ttl` | Number | Epoch seconds for TTL expiration |

GSI: `audit-by-action-index` (action)

#### `shop_settings`
| Field | Type | Description |
|-------|------|-------------|
| `shopId` (PK) | String | Shop identifier |
| `defaultPaymentTerms` | Enum | NO_CHANGE / DEFAULT_OUTCOME |
| `failSafeMode` | Enum | NO_CHANGE / DEFAULT_TERMS |
| `enforceFunction` | Boolean | Enable/disable function enforcement |
| `locationMetafieldContext` | Object | `{ sync: { status, lastSyncedAt, locationCount, jobStartedAt, errorMessage }, webhookSubscriptions: {...} }` — drives § 5.10 sync state machine and conditional webhook subscriptions |

#### `webhook_logs`
| Field | Type | Description |
|-------|------|-------------|
| `shopId` (PK) | String | Shop identifier |
| Various fields | Various | Raw webhook data for debugging |
| `ttl` | Number | 180-day TTL |

#### `webhook_cleanup_queue`
| Field | Type | Description |
|-------|------|-------------|
| `shopId` (PK) | String | Shop identifier |
| `topic` (SK) | String | Webhook topic that failed to unsubscribe (e.g. `company_location/create`) |
| `attempts` | Number | Retry attempts to date; abandoned after `MAX_ATTEMPTS` |
| `lastAttemptAt` | String | ISO timestamp of last retry |
| `lastError` | String | Last failure message |
| `ttl` | Number | Bounds the retry window |

Holds failed cleanup operations — today only failed `UNSUBSCRIBE` calls. A daily `webhook-cleanup` Lambda scans, retries each row, deletes on success, and gives up after `MAX_ATTEMPTS`. Rationale: a phantom subscription (we think we unsubscribed; Shopify still delivers) wastes a small amount of consumer compute but is otherwise harmless — daily retry is the right cadence.

---

## 9) Shopify Function (Rust/WASM)

### Configuration

- **API Target**: `cart.payment-methods.transform.run`
- **Return Type**: `CartPaymentMethodsTransformRunResult`
- **Language**: Rust compiled to `wasm32-unknown-unknown`
- **Size Constraint**: <256KB compiled WASM

### Modules

| Module | Purpose |
|--------|---------|
| `main.rs` | Entry point, schema generation |
| `run.rs` | Shopify Function handler (cart context) |
| `context.rs` | Extract evaluation context from GraphQL input |
| `evaluator.rs` | Rule/condition evaluation logic |
| `output.rs` | Convert outcomes to Shopify payment terms |
| `types.rs` | Configuration types (CompiledRuleset) |
| `tests.rs` | Unit tests |

### Execution Flow

1. Read payment config from PaymentCustomization metafield
2. Validate config version (>= 1)
3. Check if B2B checkout (`purchasingCompany` exists) — if not, return NO_CHANGE
4. Build evaluation context from cart data
5. Evaluate rules top-down (first-match wins)
6. Apply matched rule's outcome (payment terms + deposit)
7. Return modified payment methods

### Config Distribution

- Rules stored as metafield on PaymentCustomization object
- Metafield chunked if payload exceeds ~4KB per metafield
- Function reads primary metafield and reassembles chunks
- **Fallback**: NO_CHANGE if config missing or unreadable (fail-safe)

### Per-Location Input (PAYMENT_TERMS)

In addition to the ruleset metafield, the Function's GraphQL input fetches a second metafield directly from the buyer's CompanyLocation:

```graphql
cart.buyerIdentity.purchasingCompany.location {
  locationContext: metafield(namespace: "$app:termstack", key: "location-context") {
    jsonValue
  }
}
```

This is deserialized into `LocationContext { paymentTerms: { value, depositPercentage } }` and surfaced on `EvalContext` as `location_payment_terms` and `location_deposit_percentage`. An absent metafield means the backend hasn't backfilled this location yet — `PAYMENT_TERMS` conditions cannot match, the Function falls through to the next rule.

---

## 10) Infrastructure & Deployment

### AWS Resources (Pulumi-managed)

| Resource | Purpose |
|----------|---------|
| **Lambda Functions** | API handlers, webhook handlers, SQS consumers, and scheduled jobs |
| **DynamoDB Tables** | 7 tables (merchants, ruleset_versions, ruleset_state, audit_log, shop_settings, webhook_logs, webhook_cleanup_queue) |
| **SQS Queues** | `location-context-queue` (main, visibility 600s, retention 4 days, DLQ after 3 receives), `location-context-dlq` (retention 14 days), `backfill-failure-queue` (async-invoke failure destination for backfill Lambda, retention 14 days) |
| **API Gateway** | REST API with CORS |
| **EventBridge Scheduler** | Background jobs (trial expiration, subscription cleanup, daily webhook cleanup) |
| **Route53 + ACM** | Custom domain with HTTPS |
| **CloudWatch** | Logs and monitoring |
| **IAM** | Least-privilege roles for Lambda, scheduler, and SQS consumer |

### Lambda Timeouts (non-default)

Most handlers use the framework default. The following are explicitly raised:

| Lambda | Timeout | Reason |
|--------|---------|--------|
| `backfill-location-context` | **600 s** (10 min) | Iterates every CompanyLocation and writes the metafield; invoked async (`InvocationType: Event`). Failure destination: `backfill-failure-queue` (catches OOM / timeout / init crash that the Lambda's own try/catch can't). |
| `webhook-cleanup` | **300 s** (5 min) | Daily scheduler; scans `webhook_cleanup_queue` and retries failed UNSUBSCRIBE calls. |
| `location-context-consumer` | **120 s** | SQS-triggered; dequeues `company_location/*` events in batches, fetches fresh data from Shopify, writes metafields. SQS visibility timeout is 600 s (5× rule) so retries don't double-process an in-flight batch. |
| `start-location-context-sync` | **60 s** | API handler for `POST /api/sync/location-context/start`. Marks sync `IN_PROGRESS` in DynamoDB and async-invokes the backfill Lambda; returns 200 immediately. Does **not** run the backfill itself. |

### Environments

| Environment | Purpose | Billing |
|-------------|---------|---------|
| `dev` | Development/testing | Test mode |
| `staging` | QA | Test mode |
| `prod` | Production | Real billing |

### Deployment

```bash
yarn build          # Build all packages
yarn deploy         # Deploy dev stack
yarn deploy:prod    # Deploy production
yarn preview:prod   # Preview production changes
```

### Monitoring

- **CloudWatch Logs**: Lambda execution logs
- **Sentry**: Error tracking with source maps (frontend + backend)
- **PostHog**: Frontend product analytics

### Security

- HTTPS everywhere (API Gateway + custom domain)
- CORS configured for Shopify admin origin
- API keys stored as Pulumi secrets (never logged)
- DynamoDB accessed only by Lambda (no public endpoint)
- JWT verified on every request using Shopify API secret
- Webhook HMAC verification

---

## 11) Platform Constraints

1. **Plus-only**: B2B payment terms are Shopify Plus-only features
2. **Payment Customization limit**: Plus stores can activate up to 25 payment customizations; Term Stack uses 1 customization for entire ruleset
3. **Shopify Functions limits**: ~5ms execution, 256KB compiled size, ~64KB input, 20KB output, ~10MB memory
4. **No external API calls from Functions**: All runtime data must be in function input or pre-synced via metafields
5. **Metafield size**: ~4KB per metafield; chunking implemented for larger payloads

---

## 12) What Is NOT Implemented (vs. Original PRD)

The following items from the original PRD are **not implemented**:

| Feature | Original PRD Status | Current Status |
|---------|-------------------|----------------|
| **RBAC (Admin/Editor/Read-only)** | MVP planned | Not implemented; all users have equal access |
| **CUSTOMER_METAFIELD condition** | FR-014 | Not implemented |
| **COMPANY_METAFIELD condition** | FR-015 | Not implemented (COMPANY uses direct ID matching) |
| **SHIPPING_COUNTRY condition** | FR-016 | Not implemented |
| **Payment method shaping** (hide/reorder/rename) | FR-029 | Not implemented |
| **Conflict detection** (unreachable/overlap warnings) | FR-041 | Not implemented |
| **Templates gallery** | FR-059–061 | Not implemented (only simulator presets exist) |
| **Import/Export rules** | FR-066–067 | Not implemented |
| **CSV audit export** | FR-056 | Not implemented |
| **Idempotency keys** | NFR-014 | Not implemented |
| **Per-shop rate limiting** | NFR-013 | Not implemented |
| **Match-all rules** (zero conditions) | FR-025 | Not implemented (rules require at least 1 condition) |
| **Diagnostics/Health panel** | FR-057a | Simplified; no published vs. distributed drift detection |
| **Feature flags system** | Section 13 | Not implemented |

---

## 13) What Was Added (Not in Original PRD)

| Feature | Description |
|---------|-------------|
| **Billing system** | Full 4-tier subscription system (FREE/CORE/GROWTH/SCALE) with trial handling |
| **FIRST_ORDER condition** | Check if customer's first order |
| **TOTAL_ORDERS_COUNT condition** | Check customer's order history count |
| **PAYMENT_TERMS condition** | Match against the buyer's CompanyLocation payment terms template (8 Shopify-canonical values + optional deposit). Backed by a per-location metafield kept in sync by SQS-buffered webhooks + an on-demand backfill Lambda. See § 5.10. |
| **Location Context Sync pipeline** | SQS-buffered `company_location/*` webhook consumer, dedicated 10-min backfill Lambda, conditional webhook subscriptions, daily cleanup scheduler with retry tracking, sync state machine surfaced in the admin UI (banner + pre-publish warning modal). |
| **DEPOSIT_FIXED outcome** | Fixed-amount deposits (not just percentage) |
| **CONTAINS/NOT_CONTAINS operators** | String containment operators |
| **DUE_ON_FULFILLMENT_CREATED** | Additional payment terms type |
| **DUE_ON_INVOICE_SENT** | Additional payment terms type |
| **Plans page** | Pricing display and upgrade flow |
| **Onboarding page** | Guided setup wizard |
| **Dashboard** | Home page with setup guide and usage indicators |
| **SHOP_UPDATE webhook** | Detects Plus status and dev→live migration |
| **GDPR compliance webhooks** | Customer data request/redact, shop redact |
| **Scheduled jobs** | EventBridge schedulers for trial expiration and subscription cleanup |
| **Simulator presets** | Built-in test scenarios |
| **Draft discard** | Ability to discard individual or all draft changes |
| **Dev store migration detection** | Automatic detection when dev store goes live |

---

## 14) Non-Functional Requirements (Current State)

### Performance

- Admin UI: Next.js 15 with SPA navigation
- Backend: Lambda cold starts mitigated by function size optimization
- Function evaluation: Rust/WASM for maximum performance within Shopify's ~5ms budget
- DynamoDB: Single-digit millisecond reads/writes

### Reliability

- Safe fallback: Function never breaks checkout; returns NO_CHANGE on error
- Atomic publish: Version not marked published until distribution succeeds
- Webhook idempotency: Handlers designed to be replayable
- Subscription grace period: Cancelled merchants retain access until period end

### Security

- No PII stored beyond Shopify identifiers
- All data encrypted at rest (AWS managed) and in transit (TLS)
- Shop isolation: All queries scoped to authenticated shop
- JWT verification on every request

### Observability

- Sentry error tracking (frontend + backend)
- CloudWatch structured logs
- PostHog product analytics
- Audit trail for all mutations

---

## 15) Future Roadmap (V2+)

Based on original PRD non-goals and deferred items:

1. **RBAC system** — Admin/Editor/Read-only roles
2. **Additional condition types** — Customer metafields, company metafields, shipping country, segments
3. **OR condition groups** — Currently only AND within a rule
4. **Match-all rules** — Rules with zero conditions as default fallback
5. **Conflict detection** — Pre-publish warnings for unreachable/overlapping rules
6. **Payment method shaping** — Hide/reorder/rename payment methods
7. **Templates gallery** — Preset rule templates for common scenarios
8. **Import/Export** — JSON/CSV rule export and import
9. **Notifications** — Slack/email alerts for failures
10. **Checkout UI extension** — Buyer-facing deposit explainer messaging
11. **Per-checkout logging** — AppliedPolicy event linking to orders
12. **Approvals workflow** — Two-person publish approval
13. **Credit limit module** — Real-time credit ledger
14. **ERP/accounting integrations**
15. **Advanced analytics** — Checkout-time evaluation metrics

---

## 16) Development Setup

### Prerequisites

- Node.js >= 22.11.0
- Yarn 4.6.0
- Rust toolchain (for Shopify Function)
- AWS credentials (for Pulumi deployments)
- Shopify Partner account + dev store

### Environment Variables

```
SHOPIFY_API_KEY=<from partners dashboard>
SHOPIFY_API_SECRET=<from partners dashboard>
NEXT_PUBLIC_SHOPIFY_API_KEY=<same as above>
NEXT_PUBLIC_API_URL=<backend API endpoint>
```

### Key Commands

```bash
yarn dev                # Run admin app in dev mode
yarn build              # Build all packages
yarn typecheck          # Type-check all packages
shopify app dev         # Run Shopify CLI dev tunnel
yarn deploy             # Deploy dev stack (Pulumi)
yarn deploy:prod        # Deploy production
```

### Dev Store

- URL: `store-term-stack.myshopify.com`
- Type: B2B development store

---

## Appendix: Shared Types Package

The `@term-stack/shared-types` package serves as the single source of truth for all TypeScript types across frontend, backend, and extensions:

### Key Enums

- `MerchantPlan`: FREE | CORE | GROWTH | SCALE
- `SubscriptionStatus`: NONE | ACTIVE | CANCELLED | FROZEN | EXPIRED
- `ConditionType`: ORDER_TOTAL | COMPANY | COMPANY_LOCATION | CUSTOMER_TAG | FIRST_ORDER | TOTAL_ORDERS_COUNT | COLLECTION | PAYMENT_TERMS
- `PaymentTermsTemplate` (for PAYMENT_TERMS condition): NO_PAYMENT_TERMS | DUE_ON_FULFILLMENT | NET_7 | NET_15 | NET_30 | NET_45 | NET_60 | NET_90
- `ConditionOperator`: ANY_OF | NONE_OF | ALL_OF | CONTAINS | NOT_CONTAINS | EXISTS | NOT_EXISTS | EQUALS | NOT_EQUALS | GTE | GT | LTE | LT | BETWEEN
- `PaymentTermsType`: NO_PAYMENT_TERMS | NET_DAYS | DUE_ON_FULFILLMENT | DUE_ON_FULFILLMENT_CREATED | DUE_ON_INVOICE_SENT
- `DefaultPaymentTermsType`: NO_CHANGE | DEFAULT_OUTCOME
- `AuditAction`: RULE_CREATED | RULE_UPDATED | RULE_DELETED | RULE_TOGGLED | RULE_REORDERED | RULESET_PUBLISHED | RULESET_ROLLBACK | RULESET_RESTORED | DRAFT_DISCARDED | DRAFT_DISCARDED_ALL | SETTINGS_CHANGED | INSTALL_CREATED | APP_UNINSTALLED | SHOPIFY_PLAN_CHANGED | DEV_STORE_MIGRATED

### Shared Interfaces

- Rule, Condition, Outcome — Rule data structures
- RulesetVersion — Version snapshot
- Merchant — Shop account data
- AuditEvent — Audit trail entries
- API request/response DTOs
- Compiled rules format for Shopify Function
