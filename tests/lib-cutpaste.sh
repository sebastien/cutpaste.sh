#!/usr/bin/env bash

cutpaste_fixture_sample() {
	cat >sample.txt <<'EOF'
a
--8<-- START:block1
x
--8<-- START:inner
y
--8<-- END:block1
b
# --8<-- START:block2
c
# --8<-- END:block2
EOF
}
