#!/usr/bin/env bash
set -euo pipefail

source "$(dirname "$0")/lib-testing.sh"
source "$(dirname "$0")/lib-cutpaste.sh"

test-init "cutpaste syntax"

test-case "recognizes only well-formed separators"
cat >sample.txt <<'EOF'
intro
### --8<-- START:block-1
one
### --8<-- END:block-1
text --8<-- START:not-a-block
two
text --8<-- END:not-a-block
  --8<-- START:block_2
three
  --8<-- END:block_2
### --8<-- START:bad$name
four
### --8<-- END:bad$name
--8<--START:missing-space
five
### --8<-- START:lonely
orphan
### --8<-- START:block.3
six
### --8<-- END:block.3
### --8<-- START:block-4
seven
### --8<-- END:block-4
EOF
output="$("$BASE_PATH/bin/cutpaste" list sample.txt)"
test-expect "$output" $'block-1\nblock_2\nblock.3\nblock-4'

test-case "treats nested start markers as block content"
cat >sample.txt <<'EOF'
alpha
--8<-- START:outer
before
--8<-- START:inner
middle
--8<-- END:inner
after
--8<-- END:outer
--8<-- START:tail
done
--8<-- END:tail
EOF
output="$("$BASE_PATH/bin/cutpaste" list sample.txt)"
test-expect "$output" $'outer\ntail'
output="$("$BASE_PATH/bin/cutpaste" get sample.txt outer)"
test-expect "$output" $'before\n--8<-- START:inner\nmiddle\n--8<-- END:inner\nafter'
output="$("$BASE_PATH/bin/cutpaste" cut sample.txt outer)"
test-expect "$output" $'alpha\n--8<-- START:tail\ndone\n--8<-- END:tail'

test-case "keeps separator-like lines inside replacement values"
cat >sample.txt <<'EOF'
header
--8<-- START:target
old
--8<-- END:target
footer
EOF
output="$(
	printf '%s\n' \
		'first' \
		'--8<-- START:fake' \
		'second' \
		'--8<-- END:fake' \
	| "$BASE_PATH/bin/cutpaste" set sample.txt target
)"
test-expect "$output" $'header\n--8<-- START:target\nfirst\n--8<-- START:fake\nsecond\n--8<-- END:fake\n--8<-- END:target\nfooter'
