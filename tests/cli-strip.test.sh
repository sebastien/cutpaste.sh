#!/usr/bin/env bash
set -euo pipefail

source "$(dirname "$0")/lib-testing.sh"
source "$(dirname "$0")/lib-cutpaste.sh"

test-init "cutpaste strip"

cutpaste_fixture_sample

test-case "strips matching blocks"
output="$("$BASE_PATH/bin/cutpaste" strip sample.txt 'block*')"
test-expect "$output" $'a\n--8<-- START:block1\n--8<-- END:block1\nb\n# --8<-- START:block2\n# --8<-- END:block2'
