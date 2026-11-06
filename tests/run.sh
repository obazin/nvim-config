#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")/.."
audit_test_dir=$(mktemp -d)
trap 'rm -rf "$audit_test_dir"' EXIT
export XDG_STATE_HOME="$audit_test_dir/state"
export XDG_CACHE_HOME="$audit_test_dir/cache"
export NVIM_LOG_FILE="$audit_test_dir/nvim.log"
if [ "$#" -eq 0 ]; then
  set -- tests/*_test.lua
fi
for test_file in "$@"; do
  nvim --headless -u NONE -i NONE -l tests/run.lua "$test_file"
done
