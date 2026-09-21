#!/usr/bin/env bash
# ops/board-tick.sh — the cheap poll. Runs on a timer; wakes Claude only when there is work.
#
# Waking a Claude session costs ~10-20k tokens before it can even discover the board is
# empty. This does the discovering with one HTTPS call and exits, so a short interval is
# nearly free. It NEVER advances a task itself — it decides "is there work", then hands over
# to `start board`, which is the only thing that claims or advances anything.
#
# Exit 0 always. A poller that fails loudly on a transient network blip is a poller that
# wakes you at 3am for nothing; the watchdog is what notices real silence.
set -uo pipefail
cd "$(dirname "${BASH_SOURCE[0]}")/.." || exit 0
export PATH="/opt/homebrew/bin:/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin:$PATH"

log() { echo "$(date -u +%Y-%m-%dT%H:%M:%SZ) board-tick: $*" >> logs/board-tick.log; }
mkdir -p logs

# The heartbeat pings on EVERY tick, working or idle. That is the point: it proves the poller
# is alive. Pinging only when there is work would make a quiet week look identical to a dead
# mini, which is exactly what the watchdog exists to tell apart.
ops/heartbeat.sh >/dev/null 2>&1

# --- brakes ------------------------------------------------------------------------------
[ -f state/pause ] && { log "paused — state/pause exists"; exit 0; }

if ! engine/linear/linear.sh whoami >/dev/null 2>&1; then
  log "board unreachable — not waking (never claim from stale state)"; exit 0
fi

# --- is there anything to do? ------------------------------------------------------------
reason=""

# 1. a dispatchable card nobody has claimed
while IFS=$'\t' read -r id _rest; do
  [ -z "$id" ] && continue
  [ -f "agents/board/tasks/active/$id.json" ] && continue
  [ -f "agents/board/tasks/done/$id.json" ] && continue
  reason="new card $id"; break
done < <(engine/linear/linear.sh ready 2>/dev/null)

# 2. a waiting task whose card has a comment newer than the question we posted
if [ -z "$reason" ]; then
  for f in agents/board/tasks/active/*.json; do
    [ -e "$f" ] || continue
    id=$(jq -r '.id' "$f")
    jq -e '[.steps[] | select(.blocked_on // "" | startswith("question:"))] | length > 0' "$f" >/dev/null 2>&1 || continue
    since=$(jq -r '.last_comment_check // .claimed_at' "$f")
    if engine/linear/linear.sh comments "$id" "$since" 2>/dev/null | grep -qv '^$'; then
      reason="answer on $id"; break
    fi
  done
fi

# 3. a claimed task with work left that is not blocked and not sitting at a gate
if [ -z "$reason" ]; then
  for f in agents/board/tasks/active/*.json; do
    [ -e "$f" ] || continue
    if jq -e '
      (.controller == "agent")
      and ([.steps[] | select(.status != "done")] | first) as $s
      | ($s != null and ($s.blocked_on // "") == "" and $s.gate != "gate")
    ' "$f" >/dev/null 2>&1; then
      reason="unfinished work on $(jq -r .id "$f")"; break
    fi
  done
fi

[ -z "$reason" ] && { log "idle — nothing to do"; [ -n "${DRY_RUN:-}" ] && echo "IDLE"; exit 0; }

# DRY_RUN=1 reports what it WOULD do and wakes nothing. Use it to check the detection logic
# without spending a session — see ops/TESTS.md test 8.
[ -n "${DRY_RUN:-}" ] && { echo "WOULD WAKE: $reason"; exit 0; }

# --- wake the dispatcher -----------------------------------------------------------------
log "waking: $reason"
ops/with-timeout.sh 1800 claude -p "start board" \
  --permission-mode acceptEdits >> logs/board-tick.log 2>&1
rc=$?
[ $rc -eq 124 ] && log "dispatcher killed at the 30m limit" || log "dispatcher exited $rc"
exit 0
