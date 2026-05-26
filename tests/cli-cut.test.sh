#!/usr/bin/env bash
set -euo pipefail

source "$(dirname "$0")/lib-testing.sh"
source "$(dirname "$0")/lib-cutpaste.sh"

test-init "cutpaste cut"

cutpaste_fixture_sample

test-case "cuts matching blocks"
output="$("$BASE_PATH/bin/cutpaste" cut sample.txt 'block*')"
test-expect "$output" $'a\nb'
