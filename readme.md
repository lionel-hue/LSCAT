# 📂 lscat - The Ultimate Codebase Concatenator

![Version](https://img.shields.io/badge/version-1.7.2-blue)
![License](https://img.shields.io/badge/license-MIT-green)
![Platform](https://img.shields.io/badge/platform-Linux%20%7C%20macOS%20%7C%20Windows-lightgrey)
![Shell](https://img.shields.io/badge/shell-Bash%20%7C%20PowerShell-orange)

**lscat** (List & Concatenate) is a powerful cross-platform command-line utility designed to **turn your directory structure and file contents into a single, structured text stream.** 

Think of it as taking a **complete snapshot of your codebase**. It recursively lists your folder structure like a tree and then appends the content of every file underneath, separated by customizable delimiters.

---

## 🚀 Why Use lscat?

In the era of Large Language Models (LLMs), context is king. `lscat` solves the problem of feeding entire projects into AI tools efficiently.

| Use Case | Description |
| :--- | :--- |
| **🤖 AI Analysis** | Paste your entire project into ChatGPT, Claude, or Copilot for refactoring, debugging, or documentation generation. |
| **📚 Documentation** | Generate a text-based archive of your project structure and code for offline reading or wikis. |
| **📦 Bulk Processing** | Quickly combine multiple configuration files, logs, or scripts for review or migration. |
| **👥 Code Review** | Send a specific module's structure and code to a colleague in a single copy-paste action. |
| **💾 Backup** | Create a lightweight text snapshot of critical source code without binary blobs. |

---

## 📦 Installation

`lscat` is designed to work natively on your operating system. 
- **Linux/macOS:** Uses the `lscat` Bash script.
- **Windows:** Uses the `dircat.bat` launcher (which calls `dircat.ps1`).

### 🐧 Linux / macOS

1.  **Download the script:**
    ```bash
    curl -O https://raw.githubusercontent.com/yourusername/lscat/main/lscat
    ```
2.  **Make it executable:**
    ```bash
    chmod +x lscat
    ```
3.  **Test it:**
    ```bash
    ./lscat --help
    ```
4.  **Install System-Wide (Optional):**
    ```bash
    ./lscat -i
    ```
    *Follow the prompts to install to `~/.local/bin` (Recommended) or `/usr/local/bin`.*
    > **⚠️ Note:** If installed to `~/.local/bin`, ensure it is added to your `$PATH`.

### 🪟 Windows

1.  **Download Both Files:**
    You need **both** files in the same folder for Windows to work correctly:
    *   `dircat.bat`: The launcher (handles execution policies).
    *   `dircat.ps1`: The logic engine (PowerShell).
2.  **Test it:**
    Open Command Prompt or PowerShell in that folder:
    ```cmd
    dircat.bat --help
    ```
3.  **Install System-Wide (Optional):**
    ```cmd
    dircat.bat -i
    ```
    > **⚠️ Important:** After installation, add `%USERPROFILE%\.local\bin` to your system **PATH** environment variable. You may need to restart your terminal.

---

## 🎮 Quick Start

| Goal | Command |
| :--- | :--- |
| **List current folder** | `lscat` or `dircat.bat` |
| **List specific folder** | `lscat -d src` |
| **List all folders** | `lscat -d "*"` |
| **List specific files** | `lscat -f "*.md"` |
| **Save to file** | `lscat -D output.txt` |
| **Skip dependencies** | `lscat -sd node_modules -sd .git` |
| **Max Compression (AI)** | `lscat -d "*" -C -H none -sd node_modules` |

---

## 📖 Detailed Usage Guide

### 1. Selecting What to Process

You can target **Directories** (recursive) or **Files** (non-recursive).

#### Directories (`-d`, `--dir`)
Scans folders and all their contents recursively.

```bash
# Process the 'src' folder and all subfolders
lscat -d src

# Process ALL directories recursively (excluding hidden)
lscat -d "*"

# Process ALL directories (including hidden like .git)
lscat -d "*" -a
```

#### Files (`-f`, `--file`)
Grabs specific files in the current directory (non-recursive).

```bash
# Process all Markdown files in current folder
lscat -f "*.md"

# Process specific files
lscat -f readme.md config.json
```

### 2. Skipping Unwanted Content (`-sd`, `-sf`)

Crucial for AI context windows. Skip heavy folders like dependencies, build artifacts, or logs.

```bash
# Skip any folder named 'node_modules' anywhere in the tree
lscat -sd node_modules

# Skip any file ending in .log
lscat -sf "*.log"

# Combine skips for a clean AI context
lscat -d "*" -sd .git -sd node_modules -sd dist -sf "*.log"
```

> **💡 Tip:** Skip patterns match at **any depth**. `-sd node_modules` skips `./node_modules` AND `./client/node_modules`.

### 3. Output Formatting

#### Destination (`-D`, `--destination`)
Save the output to a file instead of printing to the screen.

```bash
lscat -d src -D project_snapshot.txt
```

#### Delimiter (`-de`, `--delimiter`)
Change the separator between files (Default is `---`).

```bash
lscat -d src -de "***"
```

#### Header Types (`-H`, `--header-type`)
Control how the directory structure is displayed before file contents. This is vital for managing output size.

| Type | Description | Best For |
| :--- | :--- | :--- |
| `tree` | Full tree with branches (`├──`, `└──`) | Visual clarity, human reading |
| `ls` | Simple list (compact) | Saving space |
| `ls-R` | Recursive list with indentation | Medium detail |
| `none` | No structure list | **Maximum compression for AI** |

```bash
# Compact output for AI
lscat -d "*" -H ls -C -D ai_context.txt
```

### 4. Compression Modes (Save Tokens!)

When sending code to AI, whitespace costs tokens. Use compression to reduce size significantly.

| Flag | Effect | Example Output |
| :--- | :--- | :--- |
| *(none)* | Original formatting | ` function test() {` |
| `-c` (`--compress`) | Trims indentation & blank lines | `function test() {` |
| `-C` (`--compress-hard`) | **Aggressive:** One line per file | `function test() { ... }` |

```bash
# Maximum space saving for large codebases
lscat -d "*" -sd node_modules -C -H none -D context.txt
```

### 5. Line Numbers (`-l`, `--line-numbers`)
Helpful for debugging references when discussing code with AI or colleagues.

```bash
lscat -d src -l
```

### 6. Hidden Files (`-a`, `--all`)
Include files starting with `.` (like `.gitignore`, `.env`, `.config`).

```bash
# Include hidden files in current directory
lscat -a

# Include hidden directories recursively
lscat -d "*" -a
```

---

## 🧠 Real-World Examples

### 1. The "AI Context" Dump
Prepare your entire project for an LLM, excluding dependencies and build artifacts. This is the most common use case.

```bash
# Linux
./lscat -d "*" -sd node_modules -sd .git -sd dist -sf "*.log" -c -H ls -D ai_context.txt

# Windows
dircat.bat -d "*" -sd node_modules -sd .git -sd dist -sf "*.log" -c -H ls -D ai_context.txt
```

### 2. Documentation Generator
Create a text file containing all your markdown documentation.

```bash
lscat -f "*.md" -d docs -D documentation.txt
```

### 3. Debugging a Specific Module
View the structure and code of a specific utility folder with line numbers.

```bash
lscat -d src/utils -l -H tree
```

### 4. Quick Configuration Review
Combine all config files in the root directory.

```bash
lscat -f "*.json" -f "*.yaml" -f ".env"
```

### 5. Maximum Compression (Token Saving)
Strip all headers and whitespace for massive codebases to fit within strict token limits.

```bash
lscat -d "*" -sd node_modules -C -H none -D tiny_context.txt
```

---

## ⚙️ Technical Details

### Pattern Matching Rules
*   `*`: Matches all non-hidden items.
*   `.*`: Matches all hidden items (starts with `.`).
*   `*.ext`: Matches files with specific extension.
*   **Skip Patterns:** Match at **any depth**. `-sd node_modules` skips `./node_modules` AND `./client/node_modules`.
*   **Quotes:** On Linux/Mac, always quote patterns (e.g., `"*"`) to prevent shell expansion before the script sees them.

### Default Behavior
Running `lscat` or `dircat.bat` without arguments defaults to:
*   Current directory (`.`)
*   Non-recursive
*   Shows hidden files
*   Tree header style

### File Structure
Your project should look like this for cross-platform support:

```text
/project-root
├── lscat          # Linux/Mac script
├── dircat.bat     # Windows launcher
├── dircat.ps1     # Windows logic
└── README.md      # This file
```

### Compression Logic
*   **Normal Compress (`-c`):** Removes leading/trailing whitespace from lines and removes empty lines. Preserves code structure.
*   **Hard Compress (`-C`):** Removes all formatting, joins lines into a single continuous stream per file, handles multiline comments intelligently to avoid breaking syntax completely.

---

## ❓ Troubleshooting & FAQ

**Q: Windows says "Execution Policy" error.**
*   **A:** The `dircat.bat` launcher is designed to bypass this automatically using `-ExecutionPolicy Bypass`. Ensure you run `dircat.bat`, **not** `dircat.ps1` directly.

**Q: Command not found after installation.**
*   **A:** You need to add the installation folder to your PATH.
    *   **Linux/Mac:** `~/.local/bin`
    *   **Windows:** `%USERPROFILE%\.local\bin`
    *   *Tip:* Restart your terminal after installing.

**Q: Output is too large for AI.**
*   **A:** Use hard compression and skip more folders.
    *   Add `-C` (Hard Compress)
    *   Add `-H none` (Remove headers)
    *   Add `-sd` for large folders (e.g., `vendor`, `build`, `coverage`).

**Q: Can I process multiple directories?**
*   **A:** Yes!
    ```bash
    lscat -d src -d tests -d config
    ```

**Q: Why are my hidden files not showing?**
*   **A:** By default, `lscat` shows hidden files in the current directory only. To show them recursively, use `-a` (e.g., `lscat -d "*" -a`).

**Q: Does this support binary files?**
*   **A:** `lscat` attempts to read all files as text. Binary files may produce garbled output. It is recommended to skip binary-heavy directories (e.g., `-sd images -sd bin`).

---

## 🤝 Contributing

We welcome contributions to keep `lscat` and `dircat` in feature parity!

1.  **Fork** the repository.
2.  **Create a feature branch** (`git checkout -b feature/AmazingFeature`).
3.  **Ensure Parity:** If you add a feature to `lscat` (Bash), you must implement it in `dircat` (PowerShell) and vice versa.
4.  **Commit** your changes (`git commit -m 'Add some AmazingFeature'`).
5.  **Push** to the branch (`git push origin feature/AmazingFeature`).
6.  **Open a Pull Request.**

---

## 📜 License

**MIT License**

Copyright (c) 2023 [LIONEL SISSO]

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

---

## 🙏 Acknowledgments

*   **Author:** LIONEL SISSO
*   **Version:** 1.7.2
*   **Inspiration:** Built to bridge the gap between local file systems and AI context windows.

**Happy Coding! 🐱‍💻**