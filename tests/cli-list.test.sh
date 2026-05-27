#!/usr/bin/env bash
set -euo pipefail

source "$(dirname "$0")/lib-testing.sh"
source "$(dirname "$0")/lib-cutpaste.sh"

test-init "cutpaste list"

cutpaste_fixture_sample

test-case "lists blocks in order"
output="$("$BASE_PATH/bin/cutpaste" list sample.txt)"
test-expect "$output" $'block1\nblock2'

test-case "defaults path to stdin"
output="$(cat sample.txt | "$BASE_PATH/bin/cutpaste" list)"
test-expect "$output" $'block1\nblock2'
