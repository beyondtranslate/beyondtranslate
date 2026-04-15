#!/usr/bin/env sh
set -eu

if [ -f "$HOME/.cargo/env" ]; then
  . "$HOME/.cargo/env"
fi

exec wrangler deploy
