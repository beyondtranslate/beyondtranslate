#!/usr/bin/env sh
set -eu

if ! command -v cargo >/dev/null 2>&1; then
  curl https://sh.rustup.rs -sSf | sh -s -- -y --profile minimal
fi

export PATH="$HOME/.cargo/bin:$PATH"

rustup target add wasm32-unknown-unknown
cargo install -q worker-build
worker-build --release
