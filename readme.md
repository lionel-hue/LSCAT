# lscat & dircat

**Cross-Platform Directory Listing and Concatenation Tool**

`lscat` (Linux/Mac) and `dircat` (Windows) are powerful utilities designed to recursively list directory structures and concatenate file contents. They are optimized for AI analysis, codebase documentation, and bulk file processing.

## 📦 Installation

### Linux / macOS (lscat)
1. Download the script:
   ```bash
   curl -O https://raw.githubusercontent.com/yourusername/lscat/main/lscat
   chmod +x lscat
   ```
2. Install system-wide:
   ```bash
   ./lscat -i
   ```

### Windows (dircat)
1. Download both files (`dircat.bat` and `dircat.ps1`) into a folder.
2. Run via Command Prompt:
   ```cmd
   dircat.bat --help
   ```
3. Install system-wide (adds to `~\.local\bin`):
   ```cmd
   dircat.bat -i
   ```
   *Note: Add `~\.local\bin` to your PATH environment variable after installation.*

## 🚀 Usage

### Basic Commands

| Platform | Command | Description |
| :--- | :--- | :--- |
| **Linux** | `./lscat` | List current dir (non-recursive) |
| **Windows** | `dircat.bat` | List current dir (non-recursive) |
| **Both** | `-d .` | Explicit current directory |
| **Both** | `-d "*"` | All directories recursively |
| **Both** | `-f "*.md"` | All markdown files (current dir) |

### Feature Parity
Both tools share the same flag structure for cross-platform consistency.

| Flag | Description |
| :--- | :--- |
| `-d, --dir` | Directories to process recursively |
| `-f, --file` | Files to process (non-recursive) |
| `-sd, --skip-dir` | Skip directories matching pattern |
| `-sf, --skip-file` | Skip files matching pattern |
| `-a, --all` | Include hidden files/dirs (`.git`, etc.) |
| `-D, --destination` | Output to file (e.g., `output.txt`) |
| `-de, --delimiter` | Custom delimiter (default: `---`) |
| `-c, --compress` | Remove indentation/blank lines |
| `-C, --compress-hard` | Aggressive compression (one-line per file) |
| `-l, --line-numbers` | Show line numbers in content |
| `-H, --header-type` | `tree` (default), `ls`, `ls-R`, `none` |
| `-i, --install` | Install system-wide |
| `-h, --help` | Show help message |
| `-v, --version` | Show version |

## 📝 Examples

### 1. Full Codebase Dump for AI
Concatenate all code files, skipping dependencies, for context window optimization.
```bash
# Linux
./lscat -d "*" -sd node_modules -sd .git -sf "*.log" -D context.txt

# Windows
dircat.bat -d "*" -sd node_modules -sd .git -sf "*.log" -D context.txt
```

### 2. Compressed Documentation
Generate a compact summary of all markdown files.
```bash
# Linux
./lscat -f "*.md" -c -H ls -D docs.txt

# Windows
dircat.bat -f "*.md" -c -H ls -D docs.txt
```

### 3. Debug Specific Folder
View structure and content of a specific module with line numbers.
```bash
# Linux
./lscat -d src/utils -l -H tree

# Windows
dircat.bat -d src/utils -l -H tree
```

## 🛡️ Skip Patterns
Both tools support robust skipping logic to exclude heavy directories.
- `-sd node_modules`: Skips **all** folders named `node_modules` at any depth.
- `-sf *.log`: Skips **all** files ending in `.log`.
- `-sd .git`: Skips version control data.

## 📄 File Structure
Your project should contain both scripts for cross-platform support:
```text
/project-root
  ├── lscat        (Linux/Mac executable)
  ├── dircat.bat   (Windows launcher)
  ├── dircat.ps1   (Windows logic engine)
  └── README.md
```

## 📜 License
MIT License - See LICENSE file for details.