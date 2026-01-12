# lscat - Advanced List and Concatenate Tool

`lscat` is a powerful command-line utility that combines directory listing with file concatenation capabilities, designed for AI analysis, documentation generation, and bulk file processing.

![Version](https://img.shields.io/badge/version-1.4.0-blue)
![Shell](https://img.shields.io/badge/shell-bash-green)
![License](https://img.shields.io/badge/license-MIT-green)

## ✨ Features

- **Beautiful tree structure** display with color-coded file types
- **Pattern matching** for directories (`-d`) and files (`-f`) with separate controls
- **Flexible recursion control** - `-d` for recursive directory traversal, `-f` for non-recursive file selection
- **Content concatenation** with customizable delimiters
- **Compression options** for AI token optimization
- **Hidden file control** with granular visibility options
- **Output to file** with automatic color disabling
- **Advanced skip patterns** for precise file/directory exclusion
- **Line numbering** for code analysis
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

# Skip specific patterns
lscat -s *.log -s node_modules -s .git

# All non-hidden recursively (skip hidden)
lscat -d * -a -s .*

# Aggressive compression (all code in one line)
lscat -C

# Process project for AI analysis
lscat -f *.md *.json -d src -s node_modules -s *.log -c -D ai_input.txt
```

## 📋 Options

| Option | Short | Description |
|--------|-------|-------------|
| `--dir` | `-d` | Directories to process (supports patterns, recursive) |
| `--file` | `-f` | Files to process (supports patterns, non-recursive) |
| `--skip` | `-s` | Skip files/dirs matching pattern (supports wildcards) |
| `--all` | `-a` | Include hidden files and directories |
| `--destination` | `-D` | Output file(s) |
| `--delimiter` | `-de` | Delimiter between file contents (default: "---") |
| `--compress` | `-c` | Remove indentation and blank lines |
| `--compress-hard` | `-C` | Aggressive compression (one-line per file) |
| `--line-numbers` | `-l` | Show line numbers in file contents |
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
lscat -d *           # All non-hidden directories
lscat -d .*          # All hidden directories
lscat -d src/*       # All items in src directory

# Directory patterns
lscat -d migration*/ # All migration directories
lscat -d test*       # All directories starting with 'test'

# Multiple patterns
lscat -d src lib tests
```

### File Patterns (`-f` flag)
```bash
# File patterns (non-recursive)
lscat -f *           # All non-hidden files in current directory
lscat -f .*          # All hidden files in current directory
lscat -f *.md        # All markdown files in current directory
lscat -f src/*.js    # All JS files in src directory (non-recursive)

# Specific files
lscat -f package.json README.md .gitignore
```

### Skip Patterns (`-s` flag)
```bash
# Skip by extension
lscat -s *.log -s *.tmp

# Skip directories
lscat -s node_modules -s .git -s dist

# Skip specific files
lscat -s package-lock.json -s .env

# Skip with wildcards
lscat -s test_* -s *_backup.*

# Skip paths
lscat -s ./cache -s ./logs

# Skip hidden items
lscat -s .*
```

## ⚡ Skip Pattern Behavior

The `-s` flag uses **intelligent pattern matching**:

| Pattern Type | What it skips | Example |
|--------------|---------------|---------|
| **Exact name** | Items with exact name | `-s node_modules` skips `./node_modules` but not `src/node_modules.js` |
| **Wildcard** | Pattern matches | `-s *.log` skips all `.log` files |
| **Path pattern** | Items under path | `-s ./cache` skips `./cache` directory |
| **Hidden items** | Hidden files/dirs | `-s .*` skips all hidden items |
| **Directory only** | Directories only | `-s node_modules` only skips dirs named `node_modules` |

**Note**: Skip patterns are applied after file/directory selection but before content processing.

## 📝 Output Examples

### Tree Structure
```
📁 current-directory/
├── 📁 src/
│   ├── 📁 components/
│   │   ├── Button.js
│   │   └── Header.js
│   ├── App.js
│   └── index.js
├── 📁 public/
│   ├── index.html
│   └── favicon.ico
├── package.json
├── README.md
└── .gitignore
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

### AI Analysis
```bash
# Prepare codebase for AI analysis (skip unnecessary files)
lscat -f *.md *.json -d src -s node_modules -s *.log -c -D codebase.txt
```

### Documentation
```bash
# Create project documentation
lscat -f *.md -d docs -l -D documentation.txt
```

### Code Review
```bash
# Review source code only
lscat -d src -s node_modules -s dist -l -c
```

### Project Archive
```bash
# Archive project structure and contents
lscat -d * -f * -a -s node_modules -s .git -D project_archive.txt
```

### Configuration Audit
```bash
# Audit configuration files
lscat -f .* *.json *.yml *.yaml -s .git -c -D config_audit.txt
```

## ⚠️ Important Notes

1. **Flag Separation**: Files and directories must be specified with `-f` or `-d` flags
2. **Recursion**: `-d` is recursive with `*`, `-f` is non-recursive only
3. **Skip Patterns**: Applied to both files and directories with intelligent matching
4. **Compression**: 
   - `-c`: Removes indentation and blank lines
   - `-C`: Aggressive compression (one line per file)
5. **Colors**: Automatically disabled when outputting to file
6. **Pattern Quotes**: Use quotes for patterns: `-f "*.md"` not `-f *.md`
7. **Install Option**: `-i` cannot be combined with other options

## 🔄 Version History

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

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.

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