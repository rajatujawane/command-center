#!/usr/bin/env bash
# engine/linear/linear.sh — thin wrapper over the Linear GraphQL API.
#
#   ready                              list dispatchable issues (TSV: ident, title, project)
#   get <IDENT>                        one issue as JSON
#   comment <IDENT> <key> <body>       post a comment; no-op if <key> already posted
#   status <IDENT> <status-name-key>   move the card (key from config.json statuses)
#   comments <IDENT> [since-iso]       read comments (TSV: id, createdAt, body-one-line)
#   whoami                             sanity check the key
#
# Needs LINEAR_API_KEY in .env. Names (statuses, labels, team) come from config.json —
# this script never hardcodes a UUID and never caches one.
set -euo pipefail

here="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
root="$(cd "$here/../.." && pwd)"
cfg="$here/config.json"
[ -f "$root/.env" ] && set -a && . "$root/.env" && set +a
# usage before credentials, so `linear.sh` with no args explains itself
[ $# -eq 0 ] && { sed -n '2,14 p' "$0" | sed 's/^# \{0,1\}//'; exit 1; }
: "${LINEAR_API_KEY:?LINEAR_API_KEY not set — add it to .env (see .env.example)}"

api=$(jq -r '.api' "$cfg")
team=$(jq -r '.team_key' "$cfg")
st() { jq -r ".statuses.$1" "$cfg"; }
lb() { jq -r ".labels.$1" "$cfg"; }

gql() {  # gql <query> <variables-json>
  local body
  body=$(jq -n --arg q "$1" --argjson v "$2" '{query:$q, variables:$v}')
  local out
  out=$(curl -sS -X POST "$api" \
        -H "Authorization: $LINEAR_API_KEY" \
        -H "Content-Type: application/json" \
        --data "$body")
  if echo "$out" | jq -e '.errors' >/dev/null 2>&1; then
    echo "linear.sh: API error" >&2
    echo "$out" | jq -r '.errors[].message' >&2
    return 1
  fi
  echo "$out"
}

split_ident() {  # VAR-37 -> sets $I_TEAM $I_NUM
  I_TEAM="${1%%-*}"; I_NUM="${1##*-}"
  [[ "$I_NUM" =~ ^[0-9]+$ ]] || { echo "linear.sh: bad identifier '$1'" >&2; return 1; }
}

issue_json() {  # issue_json <IDENT>
  split_ident "$1"
  gql 'query($t:String!,$n:Float!){issues(filter:{team:{key:{eq:$t}},number:{eq:$n}},first:1){nodes{
        id identifier title description url
        state{name type} project{name} team{key}
        labels{nodes{name}} assignee{name}}}}' \
      "$(jq -n --arg t "$I_TEAM" --argjson n "$I_NUM" '{t:$t,n:$n}')" \
  | jq -e '.data.issues.nodes[0] // (error("no such issue"))'
}

case "${1:-}" in

  whoami)
    gql 'query{viewer{name email}}' '{}' | jq -r '.data.viewer | "\(.name) <\(.email)>"'
    ;;

  ready)
    # Dispatchable = Ready + execution:agent, on our team. Anything in Reference status,
    # or carrying execution:never / execution:human, cannot match this filter by construction.
    gql 'query($t:String!,$s:String!,$l:String!){issues(filter:{
          team:{key:{eq:$t}}, state:{name:{eq:$s}}, labels:{name:{eq:$l}}
        },first:50){nodes{identifier title project{name} labels{nodes{name}}}}}' \
        "$(jq -n --arg t "$team" --arg s "$(st ready)" --arg l "$(lb agent)" '{t:$t,s:$s,l:$l}')" \
    | jq -r --arg never "$(lb never)" '
        .data.issues.nodes[]
        | select([.labels.nodes[].name] | index($never) | not)
        | [.identifier, .title, (.project.name // "")] | @tsv'
    ;;

  get)
    issue_json "${2:?usage: get <IDENT>}"
    ;;

  comment)
    ident="${2:?usage: comment <IDENT> <key> <body>}"; key="${3:?}"; body="${4:?}"
    marker="<!-- cc:$key -->"
    if comments_out=$(gql 'query($t:String!,$n:Float!){issues(filter:{team:{key:{eq:$t}},number:{eq:$n}},first:1){nodes{comments(first:100){nodes{body}}}}}' \
         "$(split_ident "$ident"; jq -n --arg t "$I_TEAM" --argjson n "$I_NUM" '{t:$t,n:$n}')") \
       && echo "$comments_out" | jq -r '.data.issues.nodes[0].comments.nodes[].body' | grep -qF "$marker"; then
      echo "already posted: $key"; exit 0
    fi
    id=$(issue_json "$ident" | jq -r '.id')
    gql 'mutation($i:String!,$b:String!){commentCreate(input:{issueId:$i,body:$b}){success}}' \
        "$(jq -n --arg i "$id" --arg b "$body

$marker" '{i:$i,b:$b}')" \
    | jq -r 'if .data.commentCreate.success then "posted" else "FAILED" end'
    ;;

  status)
    ident="${2:?usage: status <IDENT> <status-key>}"; want="$(st "${3:?}")"
    [ "$want" = "null" ] && { echo "linear.sh: unknown status key '$3' (see config.json)" >&2; exit 1; }
    id=$(issue_json "$ident" | jq -r '.id')
    sid=$(gql 'query($t:String!,$n:String!){workflowStates(filter:{team:{key:{eq:$t}},name:{eq:$n}},first:1){nodes{id}}}' \
          "$(jq -n --arg t "$team" --arg n "$want" '{t:$t,n:$n}')" \
        | jq -er '.data.workflowStates.nodes[0].id // (error("no status named \"'"$want"'\" on team '"$team"'"))')
    gql 'mutation($i:String!,$s:String!){issueUpdate(id:$i,input:{stateId:$s}){success}}' \
        "$(jq -n --arg i "$id" --arg s "$sid" '{i:$i,s:$s}')" \
    | jq -r 'if .data.issueUpdate.success then "moved" else "FAILED" end'
    ;;

  comments)
    ident="${2:?usage: comments <IDENT> [since-iso]}"; since="${3:-1970-01-01T00:00:00Z}"
    split_ident "$ident"
    gql 'query($t:String!,$n:Float!){issues(filter:{team:{key:{eq:$t}},number:{eq:$n}},first:1){nodes{
          comments(first:100){nodes{id createdAt body user{name}}}}}}' \
        "$(jq -n --arg t "$I_TEAM" --argjson n "$I_NUM" '{t:$t,n:$n}')" \
    | jq -r --arg since "$since" '
        .data.issues.nodes[0].comments.nodes[]
        | select(.createdAt > $since)
        | [.id, .createdAt, (.user.name // "?"), (.body | gsub("[\n\t]";" "))] | @tsv'
    ;;

  *)
    sed -n '2,14p' "$0" | sed 's/^# \{0,1\}//'
    exit 1
    ;;
esac
