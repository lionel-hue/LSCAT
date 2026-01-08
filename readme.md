# lscat - Advanced List and Concatenate Tool

`lscat` is a powerful command-line utility that combines directory listing with file concatenation capabilities, designed for AI analysis, documentation generation, and bulk file processing.

![Version](https://img.shields.io/badge/version-1.3.1-blue)
![Shell](https://img.shields.io/badge/shell-bash-green)
![License](https://img.shields.io/badge/license-MIT-green)

## ✨ Features

- **Beautiful tree structure** display with color-coded file types
- **Pattern matching** for directories and skip patterns (`*.md`, `.*`, `migration*/`)
- **Flexible recursion control** - different behaviors for `lscat`, `lscat .`, `lscat -d .`, `lscat -d *`
- **Content concatenation** with customizable delimiters
- **Compression options** for AI token optimization
- **Hidden file control** with granular visibility options
- **Output to file** with automatic color disabling
- **Pattern-based skipping** for excluding files/directories
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

# Same as above (positional directory)
lscat .

# Recursive listing with file contents
lscat -d *

# Process specific directory
lscat -d src

# Process multiple directories
lscat -d src lib tests
```

### Pattern Examples
```bash
# All non-hidden items recursively
lscat -d *

# All items (including hidden) recursively
lscat -d * -a

# Current directory only (including hidden)
lscat -d . -a

# All .md files in current directory
lscat -d *.md

# All hidden items in current directory
lscat -d .*

# All .js files in src directory
lscat -d src/*.js

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
lscat -s *.log -s .git -s node_modules

# All non-hidden recursively (skip hidden)
lscat -d * -a -s .*

# Aggressive compression (all code in one line)
lscat -C
```

## 📋 Options

| Option | Short | Description |
|--------|-------|-------------|
| `--dir` | `-d` | Directories to process (supports patterns) |
| `--skip` | `-s` | Skip files/dirs matching pattern |
| `--all` | `-a` | Include hidden files and directories |
| `--destination` | `-D` | Output file(s) |
| `--delimiter` | `-de` | Delimiter between file contents |
| `--compress` | `-c` | Remove indentation and blank lines |
| `--compress-hard` | `-C` | Aggressive compression (one-line per file) |
| `--line-numbers` | `-l` | Show line numbers in file contents |
| `--install` | `-i` | Install lscat system-wide |
| `--help` | `-h` | Show help message |
| `--version` | `-v` | Show version information |

## 🎯 Behavior Summary

| Command | Recursion | Hidden Files | Pattern Support |
|---------|-----------|--------------|-----------------|
| `lscat` | ❌ Non-recursive | ✅ Shows hidden | N/A |
| `lscat .` | ❌ Non-recursive | ✅ Shows hidden | N/A |
| `lscat -d .` | ❌ Non-recursive | ❌ Hides hidden (unless `-a`) | ✅ |
| `lscat -d *` | ✅ Recursive | ❌ Hides hidden (unless `-a`) | ✅ |
| `lscat -d *.md` | ✅ Recursive | ❌ Hides hidden (unless `-a`) | ✅ |

## 🔧 Pattern Syntax

### Directory Patterns
```bash
# Wildcards
lscat -d *           # All non-hidden items
lscat -d .*          # All hidden items
lscat -d *.md        # All markdown files
lscat -d src/*.js    # All JS files in src

# Directory patterns
lscat -d migration*/ # All migration directories
lscat -d test*       # All items starting with 'test'

# Multiple patterns
lscat -d *.md *.txt README.*
```

### Skip Patterns
```bash
# Skip file types
lscat -s *.log -s *.tmp

# Skip directories
lscat -s node_modules -s .git

# Skip specific files
lscat -s package-lock.json -s .env

# Skip with wildcards
lscat -s test_* -s *_backup.*
```

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

### File Contents
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
# Prepare codebase for AI analysis
lscat -d * -c -D codebase.txt
```

### Documentation
```bash
# Create project documentation
lscat -d src *.md -l -D documentation.txt
```

### Code Review
```bash
# Review specific file types
lscat -d *.js *.ts -l -c
```

### Backup/Archive
```bash
# Archive project structure and contents
lscat -d * -a -D project_archive.txt
```

## ⚠️ Notes

1. **Skip patterns** match both files and directories
2. **Compression** creates dense, left-aligned text optimized for AI tokens
3. **Hard compression** (`-C`) removes all newlines between statements
4. **Colors are automatically disabled** when outputting to file
5. **Patterns work with all value-accepting flags** (`-d`, `-s`, etc.)
6. **Install option** (`-i`) cannot be combined with other options

## 🔄 Version History

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