#!/usr/bin/env bash
set -euo pipefail

source "$(dirname "$0")/lib-testing.sh"

test-init "cutpaste version"

test-case "shows version"
output="$("$BASE_PATH/bin/cutpaste" --version)"
test-expect "$output" "cutpaste dev"
