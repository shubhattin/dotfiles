#!/usr/bin/env bash
# Launch Noctalia with lock-screen-safe env and restart after crashes.
# Unsetting IM modules avoids fcitx5/Qt text-input crashes on the lock surface.
set -u

unset QT_IM_MODULE QT_IM_MODULES GTK_IM_MODULE XMODIFIERS
export QT_IM_MODULE=
export QT_IM_MODULES=
export GTK_IM_MODULE=

backoff=1
while true; do
  if pgrep -x noctalia >/dev/null 2>&1; then
    sleep 2
    continue
  fi

  # Drop stale IPC artifacts from a previous crash before relaunching.
  rm -f "${XDG_RUNTIME_DIR:-/run/user/$(id -u)}"/noctalia-*.sock \
        "${XDG_RUNTIME_DIR:-/run/user/$(id -u)}"/noctalia-*.lock 2>/dev/null || true

  noctalia "$@"
  status=$?
  echo "[noctalia-wrap] $(date -Is) exited ${status}; restarting in ${backoff}s" >&2
  sleep "$backoff"
  if (( backoff < 8 )); then
    backoff=$((backoff * 2))
  fi
done
