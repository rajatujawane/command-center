#!/usr/bin/env bash
# engine/hunter/hunter.sh — metered Hunter.io client. Project-agnostic.
#
# Knows nothing about prospects, outreach, or any project. It makes exactly four
# calls, meters every credit, and refuses to spend past the ceiling of the open run.
#
#   hunter.sh account
#   hunter.sh run-begin <project> <credit_ceiling> <verify_ceiling>
#   hunter.sh run-status
#   hunter.sh run-end
#   hunter.sh domain-search <domain> [extra=query&params]
#   hunter.sh email-finder  <domain> <first_name> <last_name>
#   hunter.sh verify        <email>
#
# Costs (hunter.io/pricing, confirmed 2026-08):
#   domain-search  1 credit PER EMAIL RETURNED   -> always capped by limit; 0 results = free
#   email-finder   1 credit                      -> no email found = free
#   verify         0.5 credit                    -> always charged
#   account        free
# Same email searched or verified twice in one billing period is charged once.
#
# Every metered call appends a row to state/hunter-ledger.jsonl tagged with the
# project, so spend is attributable. The API key is read from .env and is NEVER
# echoed, logged, or written to the ledger or cache.

set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
CONF="$ROOT/engine/hunter/config.json"
LEDGER="$ROOT/state/hunter-ledger.jsonl"
CACHE="$ROOT/state/hunter-cache.json"
RUN="$ROOT/state/hunter-run.json"
API="https://api.hunter.io/v2"

die() { echo "hunter: $*" >&2; exit 1; }

# --- key -------------------------------------------------------------------
[ -f "$ROOT/.env" ] || die ".env not found. Copy .env.example and set HUNTER_API_KEY."
# shellcheck disable=SC1091
set -a; . "$ROOT/.env"; set +a
[ -n "${HUNTER_API_KEY:-}" ] || die "HUNTER_API_KEY is empty in .env"

# --- atomic write ----------------------------------------------------------
atomic() { # atomic <path> <content>
  printf '%s\n' "$2" > "$1.tmp" && mv "$1.tmp" "$1"
}

# --- run ledgering ---------------------------------------------------------
run_field() { [ -f "$RUN" ] && jq -r "$1" "$RUN" || echo ""; }

require_run() {
  [ -f "$RUN" ] || die "no open run. Call: hunter.sh run-begin <project> <credit_ceiling> <verify_ceiling>"
}

# Refuse BEFORE the call if its worst case could breach either ceiling.
guard() { # guard <worst_case_credits> <is_verify:0|1>
  require_run
  local worst="$1" isv="$2"
  local ceil spent vceil vdone
  ceil=$(run_field '.credit_ceiling'); spent=$(run_field '.spent')
  vceil=$(run_field '.verify_ceiling'); vdone=$(run_field '.verifies')

  if [ "$ceil" != "null" ] && \
     awk -v s="$spent" -v w="$worst" -v c="$ceil" 'BEGIN{exit !(s+w > c)}'; then
    die "CEILING: spent $spent + worst-case $worst would exceed credit ceiling $ceil. Stopping."
  fi
  if [ "$isv" = "1" ] && [ "$vceil" != "null" ] && [ "$vdone" -ge "$vceil" ]; then
    die "CEILING: verification ceiling $vceil reached. Stopping."
  fi
}

# Hunter returns {"errors":[...]} on 401/403/429/quota-exhausted. Those cost nothing,
# so they must never be charged to the ledger or the ceiling.
check_error() { # check_error <response_json>
  if jq -e '.errors' >/dev/null 2>&1 <<<"$1"; then
    jq '.' <<<"$1" >&2
    die "API error (not charged): $(jq -r '.errors[0].details // .errors[0].id' <<<"$1")"
  fi
}

charge() { # charge <credits> <endpoint> <target> <result> <is_verify:0|1>
  local c="$1" ep="$2" tg="$3" res="$4" isv="$5"
  local proj; proj=$(run_field '.project')
  jq -cn --arg ts "$(date -u +%FT%TZ)" --arg p "$proj" --arg e "$ep" \
         --arg t "$tg" --arg r "$res" --argjson c "$c" \
    '{ts:$ts, project:$p, endpoint:$e, target:$t, result:$r, credits:$c}' >> "$LEDGER"
  local tmp; tmp=$(jq --argjson c "$c" --argjson v "$isv" \
    '.spent = (.spent + $c) | .verifies = (.verifies + $v)' "$RUN")
  atomic "$RUN" "$tmp"
}

# --- cache -----------------------------------------------------------------
# Per-domain intel: pattern, accept_all, disposable, webmail. Persists across
# billing periods — Hunter's "free repeat within the period" expires, this doesn't.
cache_domain() { # cache_domain <domain> <response_json>
  [ -f "$CACHE" ] || atomic "$CACHE" '{}'
  local d="$1" body="$2" tmp
  tmp=$(jq --arg d "$d" --argjson b "$body" --arg ts "$(date -u +%FT%TZ)" '
    .[$d] = ((.[$d] // {}) + {
      pattern:    ($b.data.pattern    // .[$d].pattern),
      accept_all: ($b.data.accept_all // .[$d].accept_all),
      disposable: ($b.data.disposable // .[$d].disposable),
      webmail:    ($b.data.webmail    // .[$d].webmail),
      last_seen:  $ts
    })' "$CACHE")
  atomic "$CACHE" "$tmp"
}

cmd="${1:-}"; shift || true

case "$cmd" in

  # ---- free ---------------------------------------------------------------
  account)
    curl -sS --get "$API/account" --data-urlencode "api_key=$HUNTER_API_KEY" \
      | jq '{plan: .data.plan_name, reset_date: .data.reset_date,
             used: .data.requests.searches.used, available: .data.requests.searches.available,
             verifications_used: .data.requests.verifications.used,
             verifications_available: .data.requests.verifications.available}'
    ;;

  run-begin)
    [ $# -ge 3 ] || die "run-begin <project> <credit_ceiling> <verify_ceiling>  (use null for unset, not both)"
    proj="$1"; cc="$2"; vc="$3"
    [ "$cc" = "null" ] && [ "$vc" = "null" ] && die "at least one ceiling must be set"
    [ -f "$RUN" ] && die "a run is already open ($(run_field '.project'), spent $(run_field '.spent')). Call run-end first."
    atomic "$RUN" "$(jq -n --arg p "$proj" --argjson c "$cc" --argjson v "$vc" \
      --arg ts "$(date -u +%FT%TZ)" \
      '{project:$p, started:$ts, credit_ceiling:$c, verify_ceiling:$v, spent:0, verifies:0}')"
    cat "$RUN"
    ;;

  run-status) require_run; cat "$RUN" ;;

  run-end)
    require_run
    jq '{project, started, spent, verifies, credit_ceiling, verify_ceiling}' "$RUN"
    rm -f "$RUN"
    ;;

  # ---- metered ------------------------------------------------------------
  domain-search)
    [ $# -ge 1 ] || die "domain-search <domain> [extra=query&params]"
    domain="$1"; extra="${2:-}"
    limit=$(jq -r '.domain_search_limit' "$CONF")
    guard "$limit" 0   # worst case: limit emails returned = limit credits
    url="$API/domain-search?domain=$domain&limit=$limit&api_key=$HUNTER_API_KEY"
    [ -n "$extra" ] && url="$url&$extra"
    body=$(curl -sS "$url")
    check_error "$body"
    n=$(jq '(.data.emails // []) | length' <<<"$body")
    cache_domain "$domain" "$body"
    charge "$n" "domain-search" "$domain" "$n emails" 0
    jq '.' <<<"$body"
    ;;

  email-finder)
    [ $# -ge 3 ] || die "email-finder <domain> <first_name> <last_name>"
    domain="$1"; first="$2"; last="$3"
    guard 1 0
    body=$(curl -sS --get "$API/email-finder" \
      --data-urlencode "domain=$domain" --data-urlencode "first_name=$first" \
      --data-urlencode "last_name=$last" --data-urlencode "api_key=$HUNTER_API_KEY")
    check_error "$body"
    email=$(jq -r '.data.email // ""' <<<"$body")
    if [ -n "$email" ]; then charge 1 "email-finder" "$first $last @$domain" "$email" 0
    else charge 0 "email-finder" "$first $last @$domain" "not found (free)" 0; fi
    jq '.' <<<"$body"
    ;;

  verify)
    [ $# -ge 1 ] || die "verify <email>"
    email="$1"
    guard 0.5 1
    body=$(curl -sS --get "$API/email-verifier" \
      --data-urlencode "email=$email" --data-urlencode "api_key=$HUNTER_API_KEY")
    check_error "$body"
    status=$(jq -r '.data.status // "error"' <<<"$body")
    charge 0.5 "email-verifier" "$email" "$status" 1
    jq '.' <<<"$body"
    ;;

  *) die "usage: account | run-begin | run-status | run-end | domain-search | email-finder | verify" ;;
esac
