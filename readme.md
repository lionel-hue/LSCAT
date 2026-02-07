# lscat - Advanced List and Concatenate Tool

`lscat` is a powerful command-line utility that combines directory listing with file concatenation capabilities, designed for AI analysis, documentation generation, and bulk file processing.

![Version](https://img.shields.io/badge/version-1.7.0-blue)
![Shell](https://img.shields.io/badge/shell-bash-green)
![License](https://img.shields.io/badge/license-MIT-green)

## ✨ Features

- **Beautiful tree structure** display with color-coded file types
- **Pattern matching** for directories (`-d`) and files (`-f`) with separate controls
- **Flexible recursion control** - `-d` for recursive directory traversal, `-f` for non-recursive file selection
- **Granular skip patterns** - `-sd` for directories only, `-sf` for files only
- **Content concatenation** with customizable delimiters
- **Compression options** for AI token optimization
- **Hidden file control** with granular visibility options
- **Output to file** with automatic color disabling
- **Line numbering** for code analysis
- **Header type selection** - Choose between tree, ls, or ls-R styles
- **Flexible flag ordering** - All flags can be used in ANY order
- **Easy installation** with system-wide setup option

## 📦 Installation

### Quick Install

```bash
# Download and install
git clone https://github.com/lionel-hue/LSCAT
cd LSCAT
chmod +x lscat
./lscat -i
```

Choose from these installation methods:
1. **User installation** (~/.local/bin) - Recommended
2. **System-wide** (/usr/local/bin) - Requires sudo
3. **System-wide** (/usr/bin) - Requires sudo
4. **Custom location** with symlink

## 🚀 Usage

### Basic Examples

```bash
# Show beautiful tree of current directory (non-recursive, shows hidden)
lscat

# Process directories recursively
lscat -d *

# Process files in current directory only
lscat -f *

# Process specific directories
lscat -d client server

# Process specific files
lscat -f .gitignore README.md package.json

# Mix files and directories
lscat -f *.md -d src tests
```

### Skip Pattern Examples (NEW in v1.7.0)

```bash
# Skip directories only (node_modules, .git)
lscat -sd node_modules -sd .git -d *

# Skip files only (*.log, *.tmp)
lscat -sf *.log -sf *.tmp -d *

# Mix directory and file skips
lscat -sd node_modules -sf *.log -d src -f *.md

# Skip hidden directories but keep hidden files
lscat -sd .* -d * -a

# Skip specific directory path
lscat -sd ./client/node_modules/ -d .
```

### Flexible Flag Ordering (NEW in v1.7.0)

All flags can be used in **ANY order** - no more restrictions!

```bash
# All of these work identically:
lscat -H ls -C -D output.txt -d src -f *.md
lscat -f *.json -sd node_modules -d . -a -c
lscat -D archive.txt -de "***" -H none -C -sd .git -d *
lscat -c -l -a -d * -sf *.log -D analysis.txt
```

### Pattern Examples

```bash
# All non-hidden directories recursively
lscat -d *

# All directories (including hidden) recursively
lscat -d * -a

# Current directory only (including hidden)
lscat -d . -a

# All .md files in current directory
lscat -f *.md

# All hidden files in current directory
lscat -f .*

# All .js files in src directory
lscat -f src/*.js

# All migration directories
lscat -d server/database/migration*/
```

### Advanced Examples

```bash
# Output to file with custom delimiter
lscat -D output.txt -de "***"

# Include hidden files, compress content, show line numbers
lscat -a -c -l

# Skip specific patterns (directories and files separately)
lscat -sd node_modules -sd .git -sf *.log -d *

# All non-hidden recursively (skip hidden files only)
lscat -d * -a -sf .*

# Aggressive compression (all code in one line)
lscat -C

# Process project for AI analysis with flexible flag ordering
lscat -H ls -C -D ai_input.txt -f *.md *.json -d src -sd node_modules -sf *.log

# Compact ls-style header with hard compression
lscat -d * -C -H ls

# Recursive ls-style listing
lscat -d src -H ls-R
```

### Header Type Examples

```bash
# Default tree structure (verbose)
lscat -d . -H tree

# Compact ls-style listing
lscat -d . -H ls

# Recursive ls-style listing
lscat -d . -H ls-R

# Compact headers with compressed content
lscat -d * -c -H ls

# Hard compression with compact headers
lscat -d * -C -H ls
```

## 📋 Options

| Option | Short | Description |
|--------|-------|-------------|
| `--dir` | `-d` | Directories to process (supports patterns, recursive) |
| `--file` | `-f` | Files to process (supports patterns, non-recursive) |
| `--skip-dir` | `-sd` | **NEW** Skip directories matching pattern (supports wildcards) |
| `--skip-file` | `-sf` | **NEW** Skip files matching pattern (supports wildcards) |
| `--all` | `-a` | Include hidden files and directories |
| `--destination` | `-D` | Output file(s) |
| `--delimiter` | `-de` | Delimiter between file contents (default: "---") |
| `--compress` | `-c` | Remove indentation and blank lines |
| `--compress-hard` | `-C` | Aggressive compression (one-line per file) |
| `--line-numbers` | `-l` | Show line numbers in file contents |
| `--header-type` | `-H` | Change header display style: tree (default), ls, ls-R, none |
| `--install` | `-i` | Install lscat system-wide |
| `--help` | `-h` | Show help message |
| `--version` | `-v` | Show version information |

## 🎯 Behavior Summary

| Command | Recursion | Hidden Files | Description |
|---------|-----------|--------------|-------------|
| `lscat` | ❌ Non-recursive | ✅ Shows hidden | Tree of current directory |
| `lscat -d .` | ❌ Non-recursive | ❌ Hides hidden (unless `-a`) | Current directory only |
| `lscat -d *` | ✅ Recursive | ❌ Hides hidden (unless `-a`) | All directories recursively |
| `lscat -f *` | ❌ Non-recursive | ❌ Hides hidden (unless `-a`) | All files in current directory |
| `lscat -f *.md` | ❌ Non-recursive | ❌ Hides hidden (unless `-a`) | All .md files in current directory |

## 🔧 Pattern Syntax

### Directory Patterns (`-d` flag)

```bash
# Wildcards (recursive)
lscat -d *              # All non-hidden directories
lscat -d .*             # All hidden directories
lscat -d src/*          # All items in src directory

# Directory patterns
lscat -d migration*/    # All migration directories
lscat -d test*          # All directories starting with 'test'

# Multiple patterns
lscat -d src lib tests
```

### File Patterns (`-f` flag)

```bash
# File patterns (non-recursive)
lscat -f *              # All non-hidden files in current directory
lscat -f .*             # All hidden files in current directory
lscat -f *.md           # All markdown files in current directory
lscat -f src/*.js       # All JS files in src directory (non-recursive)

# Specific files
lscat -f package.json README.md .gitignore
```

### Skip Patterns (`-sd` and `-sf` flags)

```bash
# Skip directories only
lscat -sd node_modules -sd .git -sd dist       # Skip specific dirs
lscat -sd .*                                    # Skip all hidden dirs
lscat -sd test_*                                # Skip dirs with pattern
lscat -sd ./cache -sd ./logs                    # Skip specific paths

# Skip files only
lscat -sf *.log -sf *.tmp                       # Skip by extension
lscat -sf package-lock.json -sf .env            # Skip specific files
lscat -sf *_backup.*                            # Skip with wildcards
lscat -sf .*                                    # Skip all hidden files

# Mix both types
lscat -sd node_modules -sf *.log -d src
```

## 📝 Header Types

### Tree (Default)

```bash
lscat -d . -H tree
```

**Output:**
```
📁 current-directory/
├── 📁 src/
│   ├── 📁 components/
│   │   ├── Button.js
│   │   └── Header.js
│   ├── App.js
│   └── index.js
├── package.json
└── README.md
```
*Full tree structure with branches and indentation*

### LS (Compact)

```bash
lscat -d . -H ls
```

**Output:**
```
📁 current-directory/
Button.js
Header.js
App.js
index.js
package.json
README.md
```
*Simple ls-style list, compact and space-efficient*

### LS-R (Recursive LS)

```bash
lscat -d . -H ls-R
```

**Output:**
```
📁 current-directory/
Button.js
Header.js
App.js
index.js
src/
  components/
    Button.js
    Header.js
  App.js
  index.js
package.json
README.md
```
*Recursive ls-style list with indentation for subdirectories*

## ⚡ Skip Pattern Behavior

The `-sd` and `-sf` flags use **intelligent pattern matching** with type-specific behavior:

| Pattern Type | What it skips | Example |
|--------------|---------------|---------|
| **Exact name** | Items with exact name | `-sd node_modules` skips dirs named `node_modules` |
| **Wildcard** | Pattern matches | `-sf *.log` skips all `.log` files |
| **Path pattern** | Items under path | `-sd ./cache` skips `./cache` directory |
| **Hidden items** | Hidden files/dirs | `-sd .*` skips hidden dirs, `-sf .*` skips hidden files |
| **Directory traversal** | Nested directories | `-sd node_modules` skips ALL `node_modules` dirs at any depth |

**Key difference from v1.6:** `-sd` ONLY skips directories, `-sf` ONLY skips files. No more ambiguous behavior!

## 📝 Output Examples

### Tree Structure with Skips

```bash
lscat -d . -sd node_modules -sf *.log
```

```
📁 current-directory/
├── 📁 src/
│   ├── App.js
│   └── index.js
├── package.json
└── README.md
# node_modules directory and *.log files are completely omitted
```

### File Contents with Delimiter

```
File: src/App.js
---
import React from 'react';
import Button from './components/Button';

function App() {
  return <Button>Click me</Button>;
}

export default App;
```

## 🎨 Color Coding

- **Blue**: Directories
- **Green**: Text files (.txt, .md, no extension)
- **Magenta**: Shell scripts (.sh, .bash)
- **Yellow**: Python files (.py)
- **Cyan**: JavaScript/TypeScript (.js, .ts)
- **Default**: Other file types

## 💡 Use Cases

### AI Analysis with Compact Headers

```bash
# Prepare codebase for AI analysis with compact headers
lscat -H ls -C -D codebase.txt -f *.md *.json -d src -sd node_modules -sf *.log
```

### Documentation with Line Numbers

```bash
# Create project documentation with line numbers
lscat -f *.md -d docs -l -H tree -D documentation.txt
```

### Code Review with Compression

```bash
# Review source code only with compression
lscat -d src -sd node_modules -sd dist -l -c -H ls
```

### Project Archive

```bash
# Archive project structure and contents
lscat -d * -f * -a -sd node_modules -sd .git -D project_archive.txt
```

### Configuration Audit

```bash
# Audit configuration files (skip binaries, keep configs)
lscat -f .* *.json *.yml *.yaml -sd .git -c -H ls -D config_audit.txt
```

### Space-Efficient Output for Large Projects

```bash
# Maximum space savings for large codebases
lscat -H ls -C -D compact_output.txt -d * -sd node_modules -sd .git -sd dist
```

## ⚠️ Important Notes

1. **Flag Separation**: Files and directories must be specified with `-f` or `-d` flags
2. **Recursion**: `-d` is recursive with `*`, `-f` is non-recursive only
3. **Skip Patterns**: 
   - `-sd` skips **directories ONLY**
   - `-sf` skips **files ONLY**
   - Patterns match at any depth in the directory tree
4. **Compression**:
   - `-c`: Removes indentation and blank lines
   - `-C`: Aggressive compression (one line per file)
5. **Header Types**:
   - `tree`: Default full tree structure (verbose)
   - `ls`: Simple ls-style list (compact)
   - `ls-R`: Recursive ls-style list with indentation
   - `none`: No headers (maximum space saving)
6. **Colors**: Automatically disabled when outputting to file
7. **Pattern Quotes**: Use quotes for patterns: `-f "*.md"` not `-f *.md`
8. **Flexible Ordering**: All flags can be used in ANY order (v1.7.0+)
9. **Install Option**: `-i` cannot be combined with other options

## 🔄 Version History

- **1.7.0** - **MAJOR UPDATE**: Split `-s` into `-sd` (skip dirs) and `-sf` (skip files); fully flexible flag ordering; improved skip pattern handling
- **1.6.0** - Added header-type "none" option for maximum space saving
- **1.5.0** - Added `-H` flag for header type selection (tree, ls, ls-R), improved space efficiency
- **1.4.0** - Added `-f` flag for file processing, improved skip pattern matching, removed positional arguments
- **1.3.1** - Fixed default behavior consistency, enhanced pattern matching
- **1.3.0** - Added comprehensive pattern support for all flags
- **1.2.1** - Fixed regex errors, improved installation
- **1.2.0** - Added compression and line numbering
- **1.1.0** - Added skip patterns and hidden file handling
- **1.0.0** - Initial release with basic listing and concatenation

## 📄 License

MIT License

Copyright (c) 2023 [Lionel SISSO]

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

See the [LICENSE](LICENSE) file for the full text.

## 🤝 Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## 📧 Support

For issues, questions, or suggestions:
- Open an issue on GitHub
- Check the examples in this README
- Use `lscat --help` for command reference

---

Made with ❤️ for developers and AI enthusiasts