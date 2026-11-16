#!/usr/bin/env bash
# Har URL ko ping karta hai (jagane ke liye) aur check karta hai ke /api/health sahi jawab de raha hai.
# Env: URLS = ek ya zyada URL (newline/space/comma se alag). Exit 0 = sab theek, 1 = koi down.
# Output: summary.txt (alert ke liye). TIMEOUT/TRIES se tuning.
set -u
TIMEOUT="${TIMEOUT:-90}"   # Render free ko jagne mein ~1 minute lagta hai
TRIES="${TRIES:-3}"
: > summary.txt
bad=0
urls="$(printf '%s' "${URLS:-}" | tr ',' '\n' | tr -s ' \t\r' '\n' | sed '/^$/d')"
if [ -z "$urls" ]; then echo "URLS khali hai (Settings -> Variables -> TARGET_URLS)" | tee summary.txt; exit 2; fi
while IFS= read -r base; do
  base="${base%/}"
  case "$base" in http://*|https://*) ;; *) echo "- $base : INVALID URL (http/https chahiye)" >> summary.txt; bad=1; continue;; esac
  ok=0; why="no response"
  for i in $(seq 1 "$TRIES"); do
    out="$(curl -sS -m "$TIMEOUT" -w '\n%{http_code}' "$base/api/health" 2>&1)" ; rc=$?
    code="$(printf '%s' "$out" | tail -n1)"; body="$(printf '%s' "$out" | sed '$d')"
    if [ $rc -eq 0 ] && [ "$code" = "200" ] && printf '%s' "$body" | grep -q '"status" *: *"ok"'; then ok=1; break; fi
    if [ $rc -ne 0 ]; then why="curl error $rc"; elif [ "$code" = "200" ]; then why="health body not ok"; else why="HTTP $code"; fi
    sleep 5
  done
  if [ $ok -eq 1 ]; then echo "UP   $base"; else echo "DOWN $base ($why)"; echo "- $base : $why after $TRIES tries" >> summary.txt; bad=1; fi
done <<< "$urls"
exit $bad
