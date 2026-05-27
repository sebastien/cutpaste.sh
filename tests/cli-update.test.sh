#!/usr/bin/env bash
set -euo pipefail

source "$(dirname "$0")/lib-testing.sh"

test-init "cutpaste command blocks"

test-case "lists commands alongside block names"
cat >sample.txt <<'EOF'
header
--8<-- START:block1 -- printf 'generated'
old
--8<-- END:block1
EOF
output="$("$BASE_PATH/bin/cutpaste" list sample.txt)"
test-expect "$output" $'block1 -- printf \'generated\''

test-case "defaults to update on stdin when no command is given"
output="$(cat sample.txt | "$BASE_PATH/bin/cutpaste")"
test-expect "$output" $'header\n--8<-- START:block1 -- printf \'generated\'\ngenerated\n--8<-- END:block1'

test-case "recognizes BEGIN markers in jsonc-style comments"
cat >begin-sample.txt <<'EOF'
header
// --8<-- BEGIN:block1 -- printf 'generated'
old
// --8<-- END:block1
EOF
output="$("$BASE_PATH/bin/cutpaste" list begin-sample.txt)"
test-expect "$output" $'block1 -- printf \'generated\''

output="$("$BASE_PATH/bin/cutpaste" update begin-sample.txt)"
test-expect "$output" $'header\n// --8<-- BEGIN:block1 -- printf \'generated\'\ngenerated\n// --8<-- END:block1'

test-case "uses a block command when set has no explicit value"
output="$("$BASE_PATH/bin/cutpaste" set sample.txt block1)"
test-expect "$output" $'header\n--8<-- START:block1 -- printf \'generated\'\ngenerated\n--8<-- END:block1'

test-case "updates command blocks in place"
cat >sample.txt <<'EOF'
header
--8<-- START:block1 -- printf 'first\nsecond'
old
--8<-- END:block1
footer
EOF
output="$("$BASE_PATH/bin/cutpaste" update sample.txt)"
test-expect "$output" $'header\n--8<-- START:block1 -- printf \'first\\nsecond\'\nfirst\nsecond\n--8<-- END:block1\nfooter'

test-case "indents generated command output"
cat >indented.txt <<'EOF'
  --8<-- START:block1 -- printf 'first\nsecond'
  old
  --8<-- END:block1
EOF
output="$("$BASE_PATH/bin/cutpaste" update -i indented.txt)"
test-expect "$output" $'  --8<-- START:block1 -- printf \'first\\nsecond\'\n  first\n  second\n  --8<-- END:block1'
