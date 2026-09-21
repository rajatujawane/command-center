#!/usr/bin/env bash
# ops/heartbeat.sh — tell the outside world this machine is alive.
#
# A dead mini cannot report that it is dead. This ping has to be received by something
# that is NOT this machine, so silence is what triggers the alert.
#
# Setup (once):
#   1. healthchecks.io (free) -> create a check named "command-center"
#   2. Period = your shortest routine interval. Grace = 2x that.
#   3. Put its ping URL in .env as HEARTBEAT_PING_URL
#   4. Set the alert destination to an address you read on your PHONE, not on this Mac.
#
# Called at the end of every dispatcher run. Never fails a run: if the ping cannot be
# delivered, that is the watchdog's problem to notice, not this script's to escalate.
set -uo pipefail
root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
[ -f "$root/.env" ] && set -a && . "$root/.env" && set +a
[ -z "${HEARTBEAT_PING_URL:-}" ] && { echo "heartbeat: no HEARTBEAT_PING_URL set — skipped"; exit 0; }
curl -fsS -m 10 --retry 2 "$HEARTBEAT_PING_URL" >/dev/null 2>&1 \
  && echo "heartbeat: ok" || echo "heartbeat: ping failed (not fatal)"
exit 0
