```
              __                   __              __
  _______  __/ /_____  ____ ______/ /____    _____/ /_
 / ___/ / / / __/ __ \/ __ `/ ___/ __/ _ \  / ___/ __ \
/ /__/ /_/ / /_/ /_/ / /_/ (__  ) /_/  __/ (__  ) / / /
\___/\__,_/\__/ .___/\__,_/____/\__/\___(_)____/_/ /_/
             /_/
```


`cutpaste` is small CLI tool to cut/paste text information within placeholders,
typically in the shape of `--8<-- START:$BLOCK` where `$BLOCK` is a non-whitespace
alphanumeric string (with `.`, `-` and `_` supported).

```
--8<-- START:BLOCK
--8<-- END:BLOCK
```

`cutpaste` works great when:

- You want to inject and update content in a given file without touching the rest
- You want to emulate "includes" with a format that doesn't support it

## Quickstart

To install:

```
curl -o cutpaste https://raw.githubusercontent.com/sebastien/cutpaste.sh/refs/heads/main/bin/cutpaste && chmod +x cutpaste
mkdir ~/.local/bin; mv cutpaste ~/.local/bin
```

or

```
git clone git@github.com:sebastien/cutpaste.sh.git
env -C cutpaste.sh make install
```

## Reference

In the following:

- `PATH` is a pathname, with `-` for `stdin`
- `BLOCKISH` is the name of a block, with wildcards supported

Commands:

- `cutpaste list PATH [BLOCKISH…]` lists all blocks at the given path
- `cutpaste get PATH BLOCK` get the current value for the given block
- `cutpaste set PATH BLOCK [VALUE]` replaces the block with the given value (or stdin), outputting the result
- `cutpaste cut PATH [BLOCKISH…]` removes the block altogether, including separator
- `cutpaste strip PATH [BLOCKISH…]` removes the block altogether, excluding separator
- `cutpaste help` shows the help message
- `cutpaste --version` shows the current version

Commands support the following options:

- `-h|--help` shows the command help message
- `-w|--overwrite` overwrites the input file in place for `set`, `cut` and `strip`
- `-d|--dry` performs a dry run and prints a unified diff instead of writing or returning content

Notes:

- `PATH` may be `-` to read from stdin
- `set - BLOCK VALUE` is supported for stdin input
- `set - BLOCK` without `VALUE` is rejected because stdin cannot safely provide both the document and the replacement value


## Syntax

For `cutpaste` to recognise a separator, it must:

- Stand on a single line
- Match on a line with only spaces or non-alphanumeric characters as prefix
- Have only spaces or nothing as suffix
- `BLOCK` must be alphanumeric, no whitespace, `._-` allowed
- `--8<--` can contain as many prefix or suffix `-`, but at least two

For `cutpaste` to recognise a block, it must:

- Start with a `START` separator with a `$BLOCK`
- No be contained within another `START` block separator
- Explicitly end with an `END` separator with the same `$BLOCK` name.

