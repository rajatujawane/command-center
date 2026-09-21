#!/usr/bin/env bash
# engine/slack/slack.sh — post to Slack and read ONE task thread. Nothing else.
#
#   post <text> [thread_ts]      post to the channel, or into a thread. Prints the ts.
#   thread <thread_ts> [since]   read replies in one thread (TSV: ts, user, text)
#   whoami                       sanity check the token
#
# There is deliberately NO "read the channel" command. The runner only ever reads threads
# belonging to tasks that are waiting for an answer. See engine/slack/SKILL.md.
#
# Needs SLACK_BOT_TOKEN and SLACK_CHANNEL_ID in .env.
set -euo pipefail

root="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
[ -f "$root/.env" ] && set -a && . "$root/.env" && set +a
# usage before credentials, so `linear.sh` with no args explains itself
[ $# -eq 0 ] && { sed -n '2,12 p' "$0" | sed 's/^# \{0,1\}//'; exit 1; }
: "${SLACK_BOT_TOKEN:?SLACK_BOT_TOKEN not set — add it to .env (see .env.example)}"

api() {  # api <method> <json-body>
  local out
  out=$(curl -sS -X POST "https://slack.com/api/$1" \
        -H "Authorization: Bearer $SLACK_BOT_TOKEN" \
        -H "Content-Type: application/json; charset=utf-8" \
        --data "$2")
  if [ "$(echo "$out" | jq -r '.ok')" != "true" ]; then
    echo "slack.sh: $1 failed: $(echo "$out" | jq -r '.error')" >&2
    return 1
  fi
  echo "$out"
}

case "${1:-}" in
  whoami)
    curl -sS "https://slack.com/api/auth.test" -H "Authorization: Bearer $SLACK_BOT_TOKEN" \
    | jq -r 'if .ok then "\(.user) in \(.team)" else "FAILED: \(.error)" end'
    ;;
  post)
    : "${SLACK_CHANNEL_ID:?SLACK_CHANNEL_ID not set}"
    text="${2:?usage: post <text> [thread_ts]}"; ts="${3:-}"
    body=$(jq -n --arg c "$SLACK_CHANNEL_ID" --arg t "$text" '{channel:$c, text:$t, unfurl_links:false}')
    [ -n "$ts" ] && body=$(echo "$body" | jq --arg ts "$ts" '. + {thread_ts:$ts}')
    api chat.postMessage "$body" | jq -r '.ts'
    ;;
  thread)
    : "${SLACK_CHANNEL_ID:?SLACK_CHANNEL_ID not set}"
    ts="${2:?usage: thread <thread_ts> [since]}"; since="${3:-0}"
    curl -sS -G "https://slack.com/api/conversations.replies" \
      -H "Authorization: Bearer $SLACK_BOT_TOKEN" \
      --data-urlencode "channel=$SLACK_CHANNEL_ID" \
      --data-urlencode "ts=$ts" --data-urlencode "limit=100" \
    | jq -r --arg since "$since" '
        if .ok then
          .messages[]
          | select((.ts|tonumber) > ($since|tonumber))
          | select(.bot_id == null)          # never read our own posts back
          | [.ts, (.user // "?"), (.text | gsub("[\n\t]";" "))] | @tsv
        else ("slack.sh: " + .error | halt_error(1)) end'
    ;;
  *)
    sed -n '2,12p' "$0" | sed 's/^# \{0,1\}//'; exit 1
    ;;
esac
