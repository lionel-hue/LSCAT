<#
.SYNOPSIS
    dircat - Windows List and Concatenate Tool (Equivalent to lscat)
.VERSION
    1.7.2
.DESCRIPTION
    Recursively lists directory structure and concatenates file contents with
    customizable delimiters. Useful for AI analysis, documentation, or bulk
    file processing. Feature parity with lscat (Linux/Mac).
#>

param(
    [switch]$h, [switch]$help,
    [switch]$v, [switch]$version,
    [switch]$i, [switch]$install,
    [switch]$a, [switch]$all,
    [switch]$c, [switch]$compress,
    [switch]$C, [switch]$CompressHard,
    [switch]$l, [switch]$LineNumbers,
    [string]$D, [string]$Destination,
    [string]$de, [string]$Delimiter = "---",
    [string]$H, [string]$HeaderType = "tree",
    [string[]]$d, [string[]]$dir,
    [string[]]$f, [string[]]$file,
    [string[]]$sd, [string[]]$SkipDir,
    [string[]]$sf, [string[]]$SkipFile
)

# =============================================================================
# Global Variables
# =============================================================================
$VERSION = "1.7.2"
$SCRIPT_NAME = "dircat"
$WRITING_TO_FILE = $false
$INCLUDE_HIDDEN = $false
$COMPRESS = $false
$COMPRESS_HARD = $false
$SHOW_LINE_NUMBERS = $false
$NON_RECURSIVE = $false
$POSITIONAL_DIRECTORIES = $false
$FORCE_SHOW_HIDDEN = $false

# =============================================================================
# Helper Functions
# =============================================================================

function Write-Formatted {
    param($Text, $Color = $null)
    if ($WRITING_TO_FILE) {
        # Strip ANSI codes if any, write raw text
        $Text -replace '\033\[[0-9;]*m', '' | Out-File -FilePath $D -Append -Encoding UTF8
    } else {
        if ($Color) {
            Write-Host $Text -ForegroundColor $Color
        } else {
            Write-Host $Text
        }
    }
}

function Print_Help {
    Write-Host "dircat - List and Concatenate Tool (Windows)"
    Write-Host "Version: $VERSION"
    Write-Host ""
    Write-Host "DESCRIPTION:"
    Write-Host " Recursively lists directory structure and concatenates file contents with"
    Write-Host " customizable delimiters. Useful for AI analysis, documentation, or bulk"
    Write-Host " file processing."
    Write-Host ""
    Write-Host "USAGE:"
    Write-Host " dircat.bat [OPTIONS]"
    Write-Host ""
    Write-Host "OPTIONS:"
    Write-Host " -d, --dir DIR1 [DIR2...] Directories to process recursively"
    Write-Host " -d * : All non-hidden directories recursively"
    Write-Host " -d . : Current directory only (non-recursive)"
    Write-Host " Supports patterns: *, .*, migration*/"
    Write-Host " -f, --file FILE1 [FILE2...] Files to process (non-recursive only)"
    Write-Host " -f * : All non-hidden files in current directory"
    Write-Host " -f .* : All hidden files in current directory"
    Write-Host " Supports patterns: *.md, *.js, etc."
    Write-Host " -sd, --skip-dir PATTERN Skip directories matching pattern (can use multiple)"
    Write-Host " -sf, --skip-file PATTERN Skip files matching pattern (can use multiple)"
    Write-Host " Patterns match at any directory level"
    Write-Host " Example: -sd node_modules skips ALL node_modules dirs"
    Write-Host " Example: -sf *.log skips ALL .log files"
    Write-Host " -a, --all Include hidden files and directories"
    Write-Host " -D, --destination FILE Output file(s) (creates if doesn't exist)"
    Write-Host " -de, --delimiter CHAR Delimiter between file contents (default: '---')"
    Write-Host " -c, --compress Compress content (remove indentation and blank lines)"
    Write-Host " -C, --compress-hard Aggressive compression (remove all formatting, one-line per file)"
    Write-Host " -l, --line-numbers Show line numbers in file contents"
    Write-Host " -H, --header-type TYPE Change header display style: tree (default), ls, ls-R, none"
    Write-Host " tree: Full tree structure with branches"
    Write-Host " ls: Simple ls-style list (compact)"
    Write-Host " ls-R: Recursive ls-style list with subdir levels"
    Write-Host " none: No headers (for space saving)"
    Write-Host " -i, --install Install dircat system-wide (standalone option)"
    Write-Host " -h, --help Show this help message"
    Write-Host " -v, --version Show version information"
    Write-Host ""
    Write-Host "EXAMPLES:"
    Write-Host " dircat.bat                      # Non-recursive list of current dir"
    Write-Host " dircat.bat -d '*' -a -sd .*     # All non-hidden recursively (skip hidden dirs)"
    Write-Host " dircat.bat -D output.txt -de '*'# Use custom delimiter, output to file"
    Write-Host " dircat.bat -a -c -l             # Include hidden files, compress, line numbers"
    Write-Host " dircat.bat -f *.md -d client server # Process .md files and client/server dirs"
    Write-Host " dircat.bat -H ls -C -D out.txt -d . -f *.md # Mixed flag order example"
    Write-Host ""
    Write-Host "NOTES:"
    Write-Host " - Skip patterns prevent BOTH tree display AND file processing"
    Write-Host " - Skip patterns match at any depth (e.g., -sd node_modules skips all node_modules)"
    Write-Host " - -d flag is for directories only (recursive with *)"
    Write-Host " - -f flag is for files only (non-recursive, current directory only)"
    Write-Host " - Default (no flags): non-recursive tree of current dir, shows hidden"
}

function Print_Version {
    Write-Host "dircat version $VERSION" -ForegroundColor Green
    Write-Host "Windows Equivalent of lscat"
}

function Install_Dircat {
    Write-Host "Installing dircat..." -ForegroundColor Cyan
    $InstallPath = "$env:USERPROFILE\.local\bin"
    if (-not (Test-Path $InstallPath)) {
        New-Item -ItemType Directory -Force -Path $InstallPath | Out-Null
    }
    
    # Determine source paths
    $ScriptSrc = $PSCommandPath
    $ScriptDest = "$InstallPath\dircat.ps1"
    $BatSrc = $ScriptSrc -replace "\.ps1$", ".bat"
    $BatDest = "$InstallPath\dircat.bat"

    Copy-Item $ScriptSrc $ScriptDest -Force
    Copy-Item $BatSrc $BatDest -Force

    Write-Host "Installed to $InstallPath" -ForegroundColor Green
    Write-Host "Please add $InstallPath to your PATH environment variable."
    
    # Attempt to add to PATH permanently (User Level)
    $CurrentPath = [Environment]::GetEnvironmentVariable("Path", "User")
    if ($CurrentPath -notlike "*$InstallPath*") {
        [Environment]::SetEnvironmentVariable("Path", "$CurrentPath;$InstallPath", "User")
        Write-Host "Added to User PATH (restart terminal to apply)" -ForegroundColor Yellow
    }
}

function Should_Skip {
    param($Path, $Type) # Type: 'Dir' or 'File'
    
    $Name = Split-Path $Path -Leaf
    $Patterns = if ($Type -eq 'Dir') { $SKIP_DIRS } else { $SKIP_FILES }
    
    foreach ($pat in $Patterns) {
        $CleanPattern = $pat.TrimEnd('/')
        if ([string]::IsNullOrWhiteSpace($CleanPattern)) { continue }

        # 1. Check exact name match
        if ($Name -like $CleanPattern) { return $true }
        
        # 2. Check full path match
        if ($Path -like "*$CleanPattern*") { return $true }

        # 3. Check path segments (for deep skipping like node_modules inside client/)
        $Segments = $Path.Split('\', [System.StringSplitOptions]::RemoveEmptyEntries)
        foreach ($seg in $Segments) {
            if ($seg -like $CleanPattern) { return $true }
        }
    }
    return $false
}

function Compress_Content {
    param($Content)
    if ($COMPRESS_HARD) {
        return Compress_Hard_Content -Content $Content
    } elseif ($COMPRESS) {
        # Remove indentation and blank lines
        $Lines = $Content -split "`n"
        $Processed = $Lines | ForEach-Object {
            $Trimmed = $_.Trim()
            if ($Trimmed) { $Trimmed }
        }
        return $Processed -join "`n"
    }
    return $Content
}

function Compress_Hard_Content {
    param($Content)
    # Remove leading/trailing whitespace from each line
    $Lines = $Content -split "`n" | ForEach-Object { $_.Trim() } | Where-Object { $_ }
    
    $Result = ""
    $InMultilineComment = $false
    
    foreach ($Line in $Lines) {
        if ($InMultilineComment) {
            if ($Line -like "*`*/`*") { $InMultilineComment = $false }
            $Result += "$Line "
            continue
        }
        if ($Line -like "/*`*" -and $Line -notlike "*`*/`*") {
            $InMultilineComment = $true
            $Result += "$Line "
            continue
        }

        if ($Result) {
            $LastChar = $Result[-1]
            $FirstChar = $Line[0]
            # Avoid space before punctuation
            if ($LastChar -match '[\({\[<]' -or $FirstChar -match '[.,;:!?\)}\]>]') {
                $Result += "$Line "
            } else {
                $Result += " $Line "
            }
        } else {
            $Result += "$Line "
        }
    }
    return $Result.Trim() -replace '\s+', ' '
}

function Get_Tree_Structure {
    param($Dir, $Prefix = "", $IsLast = $true, $Depth = 0)
    
    if ($NON_RECURSIVE -and $Depth -gt 0) { return }
    if (Should_Skip $Dir 'Dir') { return }

    $Items = Get-ChildItem $Dir -Force | Where-Object {
        if (-not $INCLUDE_HIDDEN -and -not $FORCE_SHOW_HIDDEN -and $_.Name.StartsWith(".")) { return $false }
        if (Should_Skip $_.FullName $(if ($_.PSIsContainer) { 'Dir' } else { 'File' })) { return $false }
        return $true
    } | Sort-Object Name

    $Count = $Items.Count
    for ($i = 0; $i -lt $Count; $i++) {
        $Item = $Items[$i]
        $IsLastItem = ($i -eq $Count - 1)
        $Symbol = if ($IsLastItem) { "└── " } else { "├── " }
        $Color = if ($Item.PSIsContainer) { "Blue" } else { "Green" }
        
        $Output = "$Prefix$Symbol$($Item.Name)"
        if ($Item.PSIsContainer) { $Output += "/" }
        
        Write-Formatted $Output $Color

        if ($Item.PSIsContainer) {
            $NewPrefix = $Prefix + $(if ($IsLastItem) { "    " } else { "│   " })
            Get_Tree_Structure -Dir $Item.FullName -Prefix $NewPrefix -IsLast $IsLastItem -Depth ($Depth + 1)
        }
    }
    if ($Count -eq 0) {
        Write-Formatted "$Prefix(empty)"
    }
}

function Get_Ls_Structure {
    param($Dir, $Indent = "", $Depth = 0)
    
    if ($NON_RECURSIVE -and $Depth -gt 0) { return }
    if (Should_Skip $Dir 'Dir') { return }

    if ($Depth -gt 0 -and $HEADER_TYPE -eq "ls-R") {
        Write-Formatted "$Indent$($Dir.Split('\')[-1])/" "Blue"
        $Indent += "  "
    } elseif ($Depth -eq 0) {
        Write-Formatted "📁 $Dir" "Blue"
    }

    $Items = Get-ChildItem $Dir -Force | Where-Object {
        if (-not $INCLUDE_HIDDEN -and -not $FORCE_SHOW_HIDDEN -and $_.Name.StartsWith(".")) { return $false }
        if (Should_Skip $_.FullName $(if ($_.PSIsContainer) { 'Dir' } else { 'File' })) { return $false }
        return $true
    } | Sort-Object Name

    $Files = $Items | Where-Object { -not $_.PSIsContainer }
    $Dirs = $Items | Where-Object { $_.PSIsContainer }

    foreach ($File in $Files) {
        Write-Formatted "$Indent$($File.Name)" "Green"
    }
    foreach ($SubDir in $Dirs) {
        if ($HEADER_TYPE -eq "ls-R") {
            Get_Ls_Structure -Dir $SubDir.FullName -Indent $Indent -Depth ($Depth + 1)
        } else {
            Write-Formatted "$Indent$($SubDir.Name)/" "Blue"
        }
    }
    if ($Items.Count -eq 0) {
        Write-Formatted "$Indent(empty)"
    }
    if ($HEADER_TYPE -eq "ls-R" -and $Depth -eq 0 -and $Dirs.Count -gt 0) {
        Write-Formatted ""
    }
}

function Process_File {
    param($Path)
    if (Should_Skip $Path 'File') { return }
    
    Write-Formatted ""
    Write-Formatted "File: $Path" "White"
    Write-Formatted $DELIMITER "Gray"

    $Content = Get-Content $Path -Raw -Encoding UTF8
    
    if ($SHOW_LINE_NUMBERS) {
        $Lines = $Content -split "`n"
        for ($i = 0; $i -lt $Lines.Count; $i++) {
            $Line = $Lines[$i]
            if ($COMPRESS -or $COMPRESS_HARD) { $Line = $Line.Trim() }
            if ($Line -or -not ($COMPRESS -or $COMPRESS_HARD)) {
                Write-Formatted ("{0,6} {1}" -f ($i + 1), $Line)
            }
        }
    } else {
        Write-Formatted (Compress_Content -Content $Content)
    }
}

function Process_Directory {
    param($Dir, $ForceHidden = $false)
    
    if (Should_Skip $Dir 'Dir') { return }
    
    $OldForceHidden = $FORCE_SHOW_HIDDEN
    $FORCE_SHOW_HIDDEN = $ForceHidden

    if ($HEADER_TYPE -ne "none") {
        Write-Formatted ""
        Write-Formatted "═══════════════════════════════════════════════════" "Magenta"
        Write-Formatted "Directory Structure: $Dir" "White"
        Write-Formatted "═══════════════════════════════════════════════════" "Magenta"
        
        if ($HEADER_TYPE -eq "tree") {
            Get_Tree_Structure -Dir $Dir
        } else {
            Get_Ls_Structure -Dir $Dir
        }
    }

    Write-Formatted ""
    Write-Formatted "═══════════════════════════════════════════════════" "Magenta"
    Write-Formatted "File Contents" "White"
    Write-Formatted "═══════════════════════════════════════════════════" "Magenta"

    $Files = Get-ChildItem $Dir -Recurse -File -Force | Where-Object {
        if (-not $INCLUDE_HIDDEN -and -not $FORCE_SHOW_HIDDEN -and $_.Name.StartsWith(".")) { return $false }
        if ($NON_RECURSIVE -and $_.DirectoryName -ne $Dir) { return $false }
        if (Should_Skip $_.FullName 'File') { return $false }
        return $true
    } | Sort-Object FullName

    foreach ($File in $Files) {
        Process_File -Path $File.FullName
    }
    
    $FORCE_SHOW_HIDDEN = $OldForceHidden
}

# =============================================================================
# Main Execution
# =============================================================================

# Handle Flags
if ($help) { Print_Help; exit 0 }
if ($version) { Print_Version; exit 0 }
if ($install) { Install_Dircat; exit 0 }

if ($all) { $INCLUDE_HIDDEN = $true }
if ($compress) { $COMPRESS = $true }
if ($CompressHard) { $COMPRESS_HARD = $true; $COMPRESS = $true }
if ($LineNumbers) { $SHOW_LINE_NUMBERS = $true }
if ($Destination) { $D = $Destination; $WRITING_TO_FILE = $true }
if ($Delimiter) { $de = $Delimiter }
if ($HeaderType) { $H = $HeaderType }

# Validate Header Type
if ($H -notin @("tree", "ls", "ls-R", "none")) {
    Write-Host "Error: Invalid header type: $H. Use tree, ls, ls-R, or none" -ForegroundColor Red
    exit 1
}

# Default Behavior
$DIRECTORIES = $d + $dir
$FILES = $f + $file
$SKIP_DIRS = $sd + $SkipDir
$SKIP_FILES = $sf + $SkipFile

if ($DIRECTORIES.Count -eq 0 -and $FILES.Count -eq 0) {
    $DIRECTORIES = @(".")
    $POSITIONAL_DIRECTORIES = $true
    $NON_RECURSIVE = $true
    $FORCE_SHOW_HIDDEN = $true # Default behavior shows hidden in current dir
}

# Resolve Paths
$ValidDirs = @()
foreach ($dir in $DIRECTORIES) {
    if ($dir -eq ".") {
        $ValidDirs += (Get-Location).Path
    } elseif (Test-Path $dir -PathType Container) {
        $ValidDirs += (Resolve-Path $dir).Path
    } else {
        # Handle wildcard expansion for Windows (simplified compared to bash find)
        if ($dir -like "*`*") {
             # Basic wildcard support
             $Expanded = Get-ChildItem -Path . -Filter $dir -Directory -ErrorAction SilentlyContinue
             foreach ($exp in $Expanded) { $ValidDirs += $exp.FullName }
        } else {
            Write-Host "Warning: Directory not found: $dir" -ForegroundColor Yellow
        }
    }
}

$ValidFiles = @()
foreach ($file in $FILES) {
    if (Test-Path $file -PathType Leaf) {
        $ValidFiles += (Resolve-Path $file).Path
    } else {
        # Basic wildcard support for files
        if ($file -like "*`*") {
            $Expanded = Get-ChildItem -Path . -Filter $file -File -ErrorAction SilentlyContinue
            foreach ($exp in $Expanded) { $ValidFiles += $exp.FullName }
        } else {
            Write-Host "Warning: File not found: $file" -ForegroundColor Yellow
        }
    }
}

# Output Handler
if ($WRITING_TO_FILE) {
    Write-Host "Output will be saved to: $D" -ForegroundColor Cyan
    if (Test-Path $D) { Clear-Content $D }
}

foreach ($dir in $ValidDirs) {
    # If default positional, force hidden show
    $Force = ($POSITIONAL_DIRECTORIES -and $dir -eq (Get-Location).Path)
    Process_Directory $dir $Force
}

foreach ($file in $ValidFiles) {
    Process_File $file
}