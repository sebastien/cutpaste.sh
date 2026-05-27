#!/usr/bin/env bash
set -euo pipefail

source "$(dirname "$0")/lib-testing.sh"
source "$(dirname "$0")/lib-cutpaste.sh"

test-init "cutpaste get"

cutpaste_fixture_sample

test-case "reads block content"
output="$("$BASE_PATH/bin/cutpaste" get sample.txt block1)"
test-expect "$output" $'x\n--8<-- START:inner\ny'

test-case "defaults path to stdin"
output="$(cat sample.txt | "$BASE_PATH/bin/cutpaste" get block1)"
test-expect "$output" $'x\n--8<-- START:inner\ny'
