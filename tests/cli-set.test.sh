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

test-case "defaults path to stdin"
output="$(cat sample.txt | "$BASE_PATH/bin/cutpaste" set block1 NEW)"
test-expect "$output" $'a\n--8<-- START:block1\nNEW\n--8<-- END:block1\nb\n# --8<-- START:block2\nc\n# --8<-- END:block2'

test-case "dry runs with unified diff"
output="$("$BASE_PATH/bin/cutpaste" set -d sample.txt block1 NEW)"
test-substring "$output" "--- sample.txt (original)" "+++ sample.txt (updated)" "-x" "+NEW"

test-case "overwrites files in place"
output="$("$BASE_PATH/bin/cutpaste" set -w sample.txt block1 NEW)"
test-expect "$output" ""
output="$(cat sample.txt)"
test-expect "$output" $'a\n--8<-- START:block1\nNEW\n--8<-- END:block1\nb\n# --8<-- START:block2\nc\n# --8<-- END:block2'

test-case "skips overwrite when content is unchanged"
before_files="$(find . -maxdepth 1 -type f | sort)"
before_mtime="$(stat -c %Y sample.txt)"
sleep 1
output="$("$BASE_PATH/bin/cutpaste" set -w sample.txt block1 NEW)"
after_mtime="$(stat -c %Y sample.txt)"
after_files="$(find . -maxdepth 1 -type f | sort)"
test-expect "$output" ""
test-expect "$after_mtime" "$before_mtime"
test-expect "$after_files" "$before_files"

test-case "indents replaced block content"
cat >indented.txt <<'EOF'
  --8<-- START:block1
  old
  --8<-- END:block1
EOF
output="$("$BASE_PATH/bin/cutpaste" set -i indented.txt block1 $'first\nsecond')"
test-expect "$output" $'  --8<-- START:block1\n  first\n  second\n  --8<-- END:block1'
