#!/usr/bin/env bash
set -euo pipefail

source "$(dirname "$0")/lib-testing.sh"

test-init "cutpaste help"

test-case "shows help"
output="$("$BASE_PATH/bin/cutpaste" help)"
test-substring "$output" "Usage:" "cutpaste list PATH [BLOCKISH...]" "cutpaste --version"
