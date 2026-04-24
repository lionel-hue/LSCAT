# lscat

[![License](https://img.shields.io/badge/license-Custom-blue.svg?style=flat-square)](LICENSE)
[![Platform](https://img.shields.io/badge/platform-Linux%20%7C%20WSL%20%7C%20macOS-success?style=flat-square&logo=linux)]()
[![Shell](https://img.shields.io/badge/shell-Bash%205.0%2B-4EAA25?style=flat-square&logo=gnubash)]()
[![Made by](https://img.shields.io/badge/made%20by-LIONEL%20SISSO-FF6B6B?style=flat-square)]()

**List and concatenate directory/file contents — built for humans and AI workflows.**

`lscat` is a Bash utility that walks your directory tree, prints a structured overview, and concatenates file contents with customizable delimiters. It is especially useful for feeding entire codebases into AI prompts via the [MCP (Model Context Protocol)](#mcp-integration) standard.

---

## Table of Contents

- [Features](#features)
- [MCP Integration](#mcp-integration)
- [Installation](#installation)
- [Quick Start](#quick-start)
- [Usage](#usage)
- [Options Reference](#options-reference)
- [Header Styles](#header-styles)
- [Compression Modes](#compression-modes)
- [Pattern Matching](#pattern-matching)
- [Filtering](#filtering)
- [Output to File](#output-to-file)
- [Examples](#examples)
- [Tips & Best Practices](#tips--best-practices)
- [Issues](#issues)
- [Contributing](#contributing)
- [License](#license)

---

## Features

- **Recursive directory traversal** with full tree or compact list display
- **File content concatenation** with configurable delimiters
- **Four header styles** — `tree`, `ls`, `ls-R`, `none` — to balance verbosity and compactness
- **Two compression modes** — strip whitespace (`-c`) or flatten to a single line per file (`-C`)
- **Pattern-based filtering** — skip directories and files matching glob patterns at any depth
- **Hidden file support** — include or exclude dotfiles and hidden directories
- **Line numbers** in output
- **Multi-destination output** — pipe to stdout or write to one or more files
- **Color-coded terminal output** — automatically disabled when writing to a file
- **Built-in installer** — one command to install system-wide or per-user

---

## Installation

### Quick install (recommended)

Run the built-in installer, which will guide you through per-user or system-wide placement:

```bash
chmod +x lscat
./lscat --install
```

You will be prompted to choose one of:

| Option | Path | Requires sudo |
|--------|------|---------------|
| Current user | `~/.local/bin/lscat` | No |
| System-wide | `/usr/local/bin/lscat` | Yes |
| System-wide (alt) | `/usr/bin/lscat` | Yes |
| Custom + symlink | User-defined | Maybe |

The installer automatically adds `~/.local/bin` to your `$PATH` in `~/.bashrc` and `~/.zshrc` if it is not already present.

### Manual install

```bash
chmod +x lscat
cp lscat ~/.local/bin/lscat
```

Make sure `~/.local/bin` is on your `$PATH`:

```bash
echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.bashrc
source ~/.bashrc
```

---

## Quick Start

```bash
# Show a tree of the current directory
lscat

# Show and concatenate all files in the current directory
lscat -d .

# Recursively process all directories
lscat -d "*"

# Process only specific file types
lscat -f "*.md"

# Save a full project snapshot to a file for an AI prompt
lscat -d "*" -C -H none -D context.txt
```

---

## Usage

```
lscat [OPTIONS]
```

Files and directories **must** be specified with `-f` or `-d` flags. Positional arguments are not supported. When called with no arguments, `lscat` produces a non-recursive tree of the current directory.

---

## Options Reference

### Input

| Flag | Long form | Description |
|------|-----------|-------------|
| `-d DIR [DIR...]` | `--dir` | Directories to process. Supports patterns and multiple values. |
| `-f FILE [FILE...]` | `--file` | Files to process (non-recursive, current directory by default). Supports glob patterns. |
| `-a` | `--all` | Include hidden files and directories (dotfiles). |

**Special values for `-d`:**

| Value | Behaviour |
|-------|-----------|
| `.` | Current directory only, non-recursive |
| `*` | All non-hidden directories, recursively |
| `.*` | All hidden directories, recursively |
| `migration*/` | All directories whose name matches the glob |

**Special values for `-f`:**

| Value | Behaviour |
|-------|-----------|
| `*` | All non-hidden files in the current directory |
| `.*` | All hidden files in the current directory |
| `*.md` | All Markdown files in the current directory |
| `client/src/*.js` | All `.js` files inside `client/src/` |

### Output

| Flag | Long form | Description |
|------|-----------|-------------|
| `-D FILE` | `--destination` | Write output to this file (creates if missing, overwrites if present). Can be specified multiple times for multiple output files. |
| `-de STR` | `--delimiter` | String printed between file contents. Default: `---` |
| `-l` | `--line-numbers` | Prefix each line of file content with its line number. |

### Compression

| Flag | Long form | Description |
|------|-----------|-------------|
| `-c` | `--compress` | Remove leading/trailing whitespace and blank lines from file contents. |
| `-C` | `--compress-hard` | Aggressive mode: also join all lines into a single line per file. Implies `-c`. Best used with `-H none` to minimise total token count. |

### Header Style

| Flag | Long form | Description |
|------|-----------|-------------|
| `-H TYPE` | `--header-type` | Controls the directory listing format. Valid values: `tree` (default), `ls`, `ls-R`, `none`. |

### Filtering

| Flag | Long form | Description |
|------|-----------|-------------|
| `-sd PATTERN` | `--skip-dir` | Skip any directory matching this pattern. Matches at any depth. Repeatable. |
| `-sf PATTERN` | `--skip-file` | Skip any file matching this pattern. Matches at any depth. Repeatable. |

### Utility

| Flag | Long form | Description |
|------|-----------|-------------|
| `-i` | `--install` | Run the interactive installer. Must be used alone. |
| `-h` | `--help` | Print the help message. |
| `-v` | `--version` | Print version information. |

---

## Header Styles

The `-H` / `--header-type` flag controls how the directory structure is displayed before file contents.

### `tree` (default)

Full tree with branch connectors. Most informative, most verbose.

```
📁 .
├── README.md
├── lscat
└── src/
    ├── main.sh
    └── utils.sh
```

### `ls`

Flat list of files and folders. Compact, easy to scan.

```
📁 .
README.md
lscat
src/
```

### `ls-R`

Recursive listing with indented subdirectories, similar to `ls -R`.

```
📁 .
README.md
lscat
src/
  src/
    main.sh
    utils.sh
```

### `none`

No directory header printed at all. Combined with `-C`, this produces the most compact output possible — ideal for maximising the amount of code you can fit in an AI context window.

```bash
lscat -d "*" -C -H none -D context.txt
```

---

## Compression Modes

### `-c` — Standard compression

Strips leading/trailing whitespace and removes blank lines from each file's content. Good for reducing noise while keeping code readable.

### `-C` — Hard compression

Strips all whitespace and collapses each file into a single continuous line. Intended for AI context packing where token count matters more than readability.

> **Tip:** Combine `-C -H none` for maximum density. You can always pair with `-D` to save the result to a file before pasting into a prompt.

---

## Pattern Matching

`lscat` supports glob patterns in `-d`, `-f`, `-sd`, and `-sf` flags. Because the shell expands unquoted globs before passing them to the script, **always quote patterns**:

```bash
# Good — lscat receives the literal pattern
lscat -f "*.md"
lscat -d "migration*/"

# Bad — the shell expands *.md before lscat sees it
lscat -f *.md
```

### How patterns are matched

- `-d "migration*/"` matches any directory whose name starts with `migration`, at any depth.
- `-sf "*.log"` skips any file ending in `.log`, anywhere in the tree.
- `-sd node_modules` skips every directory named `node_modules`, no matter how deeply nested.
- `-sd ./client/node_modules` skips only that specific path.

---

## Filtering

Skip patterns apply to **both** the tree display and file content processing — a skipped directory or file will not appear in either section of the output.

### Skip common noise directories

```bash
lscat -d "*" -sd node_modules -sd .git -sd dist -sd __pycache__
```

### Skip specific file types

```bash
lscat -d "." -sf "*.log" -sf "*.lock"
```

### Combine directory and file skips

```bash
lscat -d "*" -sd node_modules -sd .git -sf "*.min.js" -sf "*.map"
```

---

## Output to File

Use `-D` to write output to a file. Color codes are automatically stripped when writing to a file, making it safe to parse or share.

```bash
# Single output file
lscat -d "." -D snapshot.txt

# Multiple output files
lscat -d "." -D snapshot.txt -D backup.txt

# Custom delimiter
lscat -d "." -de "========" -D snapshot.txt
```

The output file is created if it does not exist and overwritten if it does. Combined with compression, this is the recommended workflow for preparing AI context:

```bash
lscat -d "*" -sd node_modules -sd .git -C -H none -D context.txt
```

---

## Examples

### Browse the current directory

```bash
lscat
```

Non-recursive tree of the current directory, including hidden files.

---

### Concatenate all files in the project

```bash
lscat -d "*"
```

Recursively lists and concatenates all non-hidden files.

---

### Process only Markdown files

```bash
lscat -f "*.md"
```

---

### Process files in a subdirectory

```bash
lscat -f "docs/*.md"
```

---

### Skip build artifacts and version control

```bash
lscat -d "*" -sd node_modules -sd .git -sd dist -sd build
```

---

### Compact output for an AI prompt

```bash
lscat -d "*" -sd node_modules -sd .git -C -H none -D context.txt
```

Creates a flat, compressed dump of your entire project with no directory headers — ready to paste into an AI prompt.

---

### Include hidden files

```bash
lscat -d "." -a
```

---

### Show all hidden directories recursively

```bash
lscat -d ".*"
```

---

### Skip all hidden directories but include hidden files

```bash
lscat -d "*" -a -sd ".*"
```

---

### Use a custom delimiter and save to file

```bash
lscat -D output.txt -de "========" -d "."
```

---

### Mix files and directories

```bash
lscat -f ".gitignore" "README.md" -d src tests
```

Processes specific named files alongside full directory trees.

---

### Compact headers with hard compression

```bash
lscat -H ls -C -D output.txt -d "." -f "*.md"
```

Flags can be in any order.

---

## Tips & Best Practices

**Always quote glob patterns** to prevent premature shell expansion:

```bash
lscat -f "*.js"      # correct
lscat -f *.js        # may break depending on your shell
```

**Use `-H none -C` together** when maximising token efficiency for AI prompts. The tree header adds substantial output that you often don't need when the AI only needs to read the code.

**Use `-sd` for deep skip patterns.** Because `-sd node_modules` matches at any depth, you do not need to specify the full path. A single flag handles all nested occurrences.

**Use `-l` for debugging.** Line numbers make it easy to reference specific positions when discussing code with an AI or in a code review.

**Use `-de` to add visual separation** when pasting multiple files into a document:

```bash
lscat -d "." -de "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
```

---

## Issues

All bugs, feature requests, and technical issues must be reported in the **original repository** on GitHub:
👉 [https://github.com/lionel-hue/LSCAT/issues](https://github.com/lionel-hue/LSCAT/issues)

Please do **not** open issues in forks.

---

## Contributing

Contributions are welcome! You are free to fork, modify, and redistribute this project for non-commercial use. If you have improvements or bug fixes, please submit a Pull Request to the original repository.

When contributing or redistributing:
- **Do not** modify the project author or claim ownership.
- **Do not** modify or falsify the commit history, authorship metadata, or project logs.
- **Always** clearly acknowledge the original owner ([LIONEL SISSO]).
- Ensure your changes follow the [License](#license).

---

## License

Custom License — see [LICENSE](LICENSE) for details.

**Key Terms:**
- **Non-Commercial Use Only**: This software cannot be used or redistributed for profit.
- **Attribution Required**: You must credit the original author ([LIONEL SISSO]).
- **Original Repo for Issues**: All issues must be raised in the main repository.
