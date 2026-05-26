#!/usr/bin/env bash
set -euo pipefail

source "$(dirname "$0")/lib-testing.sh"

test-init "cutpaste version"

test-case "shows version"
version="$(awk -F'"' '/^CUTPASTE_VERSION=/{print $2; exit}' "$BASE_PATH/bin/cutpaste")"
expected="cutpaste $version"
output="$("$BASE_PATH/bin/cutpaste" --version)"
test-expect "$output" "$expected"
