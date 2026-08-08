#!/usr/bin/env bash
# agents/outreach/qualify.sh <domain-or-url>
#
# Free, deterministic qualification probe. NO API, NO cost, NO Hunter quota.
# Emits one JSON verdict on stdout. Run this BEFORE a prospect is allowed into the
# pool — every disqualification it catches is one that would otherwise burn a search.
#
# Built from the 2026-08-08/09 sweep, where 21 of 25 top-fit prospects turned out to
# be dead stores, password-protected stores, non-Shopify sites, or "wholesale" that
# was really a JotForm / ExpertVoice account. Each check below caught a real one.
#
# verdict:
#   DEAD             domain does not resolve, or HTTPS is broken (airtek, kitchensupply)
#   CLOSED           store is password-protected or unavailable (neuro, uncle-jack)
#   NOT_SHOPIFY      no cdn.shopify.com anywhere (biom)
#   OFF_PLATFORM_B2B wholesale runs on a third-party app/platform (le-toy-van, laird)
#   NO_B2B_CHANNEL   live Shopify but no wholesale/trade/dealer surface at all
#   REVIEW           passed every mechanical check; a human decides fit
#
# REVIEW is not a pass. It means "worth a person's two minutes", nothing more.

set -uo pipefail

raw="${1:?usage: qualify.sh <domain-or-url>}"
domain="${raw#http://}"; domain="${domain#https://}"; domain="${domain%%/*}"
UA='Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/126 Safari/537.36'
H="/tmp/qualify.$$.html"; trap 'rm -f "$H" "$H".*' EXIT

get() { curl -sSL -m 20 -A "$UA" -o "$2" -w '%{http_code} %{url_effective}' "$1" 2>/dev/null || echo "000 -"; }
# grep -c exits 1 on zero matches, so `|| echo 0` would append a SECOND line and
# break --argjson. Always normalise through this.
count() { local n; n=$(grep -ocE "$1" "$2" 2>/dev/null | head -1); printf '%s' "${n:-0}"; }

# --- 1. DNS -----------------------------------------------------------------
if ! host "$domain" >/dev/null 2>&1 && ! nslookup "$domain" >/dev/null 2>&1; then
  jq -n --arg d "$domain" '{domain:$d, verdict:"DEAD", reason:"domain does not resolve"}'; exit 0
fi

# --- 2. TLS. Shopify always terminates valid TLS; a broken cert means not Shopify-hosted.
tls_err=$(curl -sS -m 20 -o /dev/null "https://$domain/" 2>&1 >/dev/null); tls_rc=$?
if [ $tls_rc -ne 0 ] && [ $tls_rc -ne 22 ] && [ $tls_rc -ne 52 ]; then
  if curl -sSL -m 20 -o /dev/null "http://$domain/" 2>/dev/null; then
    jq -n --arg d "$domain" --arg e "$(printf '%s' "$tls_err" | head -1)" \
      '{domain:$d, verdict:"DEAD", reason:"HTTPS fails, only http responds — not a Shopify-hosted storefront", tls_error:$e}'
    exit 0
  fi
fi

# --- 3. Fetch root ----------------------------------------------------------
read -r code final <<<"$(get "https://$domain/" "$H")"
title=$(grep -oiE '<title>[^<]*</title>' "$H" 2>/dev/null | head -1 | sed 's/<[^>]*>//g' | tr -d '\r\n' | sed 's/^ *//;s/ *$//')
shop=$(count 'cdn\.shopify\.com' "$H")

# --- 4. Closed / password-protected ----------------------------------------
if printf '%s' "$final" | grep -qiE '/password' \
   || printf '%s' "$title" | grep -qiE 'store is unavailable|opening soon|password|coming soon'; then
  jq -n --arg d "$domain" --arg t "$title" --arg f "$final" \
    '{domain:$d, verdict:"CLOSED", reason:"store is password-protected or unavailable", title:$t, final_url:$f}'; exit 0
fi
if [ "$code" = "404" ] || [ "$code" = "000" ]; then
  jq -n --arg d "$domain" --arg c "$code" --arg f "$final" \
    '{domain:$d, verdict:"CLOSED", reason:("root returns HTTP " + $c), final_url:$f}'; exit 0
fi

# --- 5. Shopify? ------------------------------------------------------------
if [ "$shop" -eq 0 ]; then
  jq -n --arg d "$domain" --arg t "$title" --arg f "$final" \
    '{domain:$d, verdict:"NOT_SHOPIFY", reason:"zero cdn.shopify.com references", title:$t, final_url:$f}'; exit 0
fi

# --- 6. Installed apps. Third-party wholesale apps mean B2B is NOT native, and most
#        run on non-Plus plans — TermStack is Plus-only, so this is a hard signal.
apps=$(grep -oiE 'extensions/[a-f0-9-]+/[a-z0-9-]+' "$H" 2>/dev/null | sed 's|.*/||' | sed 's/-[0-9]*$//' | sort -u | tr '\n' ',' | sed 's/,$//')
offplat=$(printf '%s' "$apps" | grep -oiE 'wholesale-gorilla|sparklayer|wholesale-club|b2b-wholesale|expertvoice|wholesale-pricing|bss-b2b' | sort -u | tr '\n' ',' | sed 's/,$//')

# --- 7. Wholesale surface ---------------------------------------------------
links=$(grep -oiE 'href="[^"]*(wholesale|/trade|b2b|stockist|retailer|dealer)[^"]*"' "$H" 2>/dev/null \
        | sed 's/href="//;s/"$//' | sort -u | head -6)
[ -z "$links" ] && printf '%s' "$(grep -oiE 'href="[^"]*(wholesale|dealer)[^"]*"' "$H" 2>/dev/null)" >/dev/null

# B2B subdomains — the strongest native-B2B tell (fsaproshop had exactly this)
subs=""
for s in wholesale b2b trade dealers; do
  sc=$(curl -sSL -m 12 -A "$UA" -o "$H.sub" -w '%{http_code}' "https://$s.$domain/" 2>/dev/null || echo 000)
  if [ "$sc" = "200" ] && [ "$(count 'cdn\.shopify\.com' "$H.sub")" -gt 0 ]; then
    auth=$(count 'customer_authentication' "$H.sub")
    subs="$subs https://$s.$domain(shopify,auth=$auth)"
  fi
done

# Common wholesale paths
paths=""
for p in /pages/wholesale /pages/wholesale-login /pages/trade /pages/for-dealers /pages/stockists; do
  pc=$(curl -sSL -m 12 -A "$UA" -o "$H.pg" -w '%{http_code}' "https://$domain$p" 2>/dev/null || echo 000)
  [ "$pc" = "200" ] && paths="$paths $p"
done

auth_root=$(count 'customer_authentication' "$H")

# --- 8. Verdict -------------------------------------------------------------
verdict="REVIEW"; reason="passed mechanical checks — human decides fit"
if [ -n "$offplat" ]; then
  verdict="OFF_PLATFORM_B2B"; reason="third-party wholesale app detected ($offplat) — B2B is not native and these run on non-Plus plans"
elif [ -z "$links" ] && [ -z "$subs" ] && [ -z "$paths" ]; then
  verdict="NO_B2B_CHANNEL"; reason="live Shopify but no wholesale/trade/dealer/stockist surface anywhere"
fi

jq -n --arg d "$domain" --arg v "$verdict" --arg r "$reason" --arg t "$title" --arg f "$final" \
      --argjson shop "$shop" --arg apps "$apps" --arg off "$offplat" \
      --arg subs "$(printf '%s' "$subs" | sed 's/^ //')" --arg paths "$(printf '%s' "$paths" | sed 's/^ //')" \
      --argjson auth "$auth_root" --arg links "$(printf '%s' "$links" | tr '\n' ' ')" '
{domain:$d, verdict:$v, reason:$r, title:$t, final_url:$f,
 shopify_refs:$shop, customer_authentication:($auth>0),
 apps:$apps, offplatform_app:$off,
 b2b_subdomains:$subs, wholesale_paths:$paths, wholesale_links:$links}'
