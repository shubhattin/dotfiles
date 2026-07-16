#!/usr/bin/env bash

set -euo pipefail

# Prefer Noctalia's integrated lock-then-suspend path when available.
if command -v noctalia >/dev/null 2>&1; then
  noctalia msg session lock-and-suspend
  exit 0
fi

# Fallback for sessions without Noctalia
systemctl suspend
