#!/usr/bin/env bash
set -euo pipefail

source "$(dirname "$0")/lib-testing.sh"
source "$(dirname "$0")/lib-cutpaste.sh"

test-init "cutpaste set"

cutpaste_fixture_sample

test-case "replaces block content"
output="$("$BASE_PATH/bin/cutpaste" set sample.txt block1 NEW)"
test-expect "$output" $'a\n--8<-- START:block1\nNEW\n--8<-- END:block1\nb\n# --8<-- START:block2\nc\n# --8<-- END:block2'

test-case "supports stdin input"
output="$(cat sample.txt | "$BASE_PATH/bin/cutpaste" set - block1 NEW)"
test-expect "$output" $'a\n--8<-- START:block1\nNEW\n--8<-- END:block1\nb\n# --8<-- START:block2\nc\n# --8<-- END:block2'

test-case "dry runs with unified diff"
output="$("$BASE_PATH/bin/cutpaste" set -d sample.txt block1 NEW)"
test-substring "$output" "--- sample.txt (original)" "+++ sample.txt (updated)" "-x" "+NEW"

test-case "overwrites files in place"
output="$("$BASE_PATH/bin/cutpaste" set -w sample.txt block1 NEW)"
test-expect "$output" ""
output="$(cat sample.txt)"
test-expect "$output" $'a\n--8<-- START:block1\nNEW\n--8<-- END:block1\nb\n# --8<-- START:block2\nc\n# --8<-- END:block2'
