```
              __                   __              __
  _______  __/ /_____  ____ ______/ /____    _____/ /_
 / ___/ / / / __/ __ \/ __ `/ ___/ __/ _ \  / ___/ __ \
/ /__/ /_/ / /_/ /_/ / /_/ (__  ) /_/  __/ (__  ) / / /
\___/\__,_/\__/ .___/\__,_/____/\__/\___(_)____/_/ /_/
             /_/
```


`cutpaste` is small CLI tool to cut/paste text information within placeholders,
typically in the shape of `--8<-- START:$BLOCK` or `--8<-- BEGIN:$BLOCK` where
`$BLOCK` is a non-whitespace alphanumeric string (with `.`, `-` and `_`
supported).

```
--8<-- START:BLOCK
--8<-- END:BLOCK
```

Blocks content can also be generated from commands:

```
--8<-- START:BLOCK -- COMMAND
--8<-- END:BLOCK
```

For instance, if you want to include a file in a `.jsonc` file:

```jsonc
{
  // --8<-- BEGIN:include -- cat ./src/json/preamble.json
  // --8<-- END:include
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

- `PATH` is a pathname, with `-` for `stdin` and defaulting to `stdin` when omitted
- `BLOCKISH` is the name of a block, with wildcards supported

Commands:

- `cutpaste [update] [PATH] [BLOCKISH…]` updates all command blocks, and is the default when no command is given
- `cutpaste list [PATH] [BLOCKISH…]` lists all blocks at the given path (shows command if present)
- `cutpaste get [PATH] BLOCK` get the current value for the given block
- `cutpaste set [PATH] BLOCK [VALUE]` replaces the block with the given value (or stdin), outputting the result
- `cutpaste cut [PATH] [BLOCKISH…]` removes the block altogether, including separator
- `cutpaste strip [PATH] [BLOCKISH…]` removes the block altogether, excluding separator
- `cutpaste update [PATH] [BLOCKISH…]` updates all command blocks
- `cutpaste help` shows the help message
- `cutpaste --version` shows the current version

Commands support the following options:

- `-h|--help` shows the command help message
- `-i|--indent` prefixes replaced or generated lines with the block indentation
- `-w|--overwrite` overwrites the input file in place for `set`, `cut` and `strip`
- `-d|--dry` performs a dry run and prints a unified diff instead of writing or returning content

Notes:

- `PATH` may be `-` to read from stdin
- `set - BLOCK VALUE` is supported for stdin input
- `set - BLOCK` without `VALUE` is rejected because stdin cannot safely provide both the document and the replacement value
- `-i|--indent` uses the common leading whitespace from the block's `START` and `END` separators to indent replacement or generated content


## Syntax

For `cutpaste` to recognise a separator, it must:

- Stand on a single line
- Match on a line with only spaces or non-alphanumeric characters as prefix
- Have only spaces or nothing as suffix (`END` only, `START` or `BEGIN` can contain a command)
- `BLOCK` must be alphanumeric, no whitespace, `._-` allowed
- `command` can be any shell command that fits on one line, will be run as-is
- `--8<--` can contain as many prefix or suffix `-`, but at least two

For `cutpaste` to recognise a block, it must:

- Start with a `START` or `BEGIN` separator with a `$BLOCK`
- Not be contained within another `START` or `BEGIN` block separator
- Explicitly end with an `END` separator with the same `$BLOCK` name.
