<#
.SYNOPSIS
    dircat - Windows List and Concatenate Tool (Equivalent to lscat)
.VERSION
    1.7.2
.DESCRIPTION
    Recursively lists directory structure and concatenates file contents with
    customizable delimiters. Useful for AI analysis, documentation, or bulk file processing.
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

$VERSION = "1.7.2"
$SCRIPT_NAME = "dircat"
$WRITING_TO_FILE = $false
$INCLUDE_HIDDEN = $false
$COMPRESS = $false
$COMPRESS_HARD = $false
$SHOW_LINE_NUMBERS = $false
$NON_RECURSIVE = $false
$POSITIONAL_DIRECTORIES = $false

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
}

# Resolve Paths
$ValidDirs = @()
foreach ($dir in $DIRECTORIES) {
    if ($dir -eq ".") { $ValidDirs += (Get-Location).Path }
    elseif (Test-Path $dir -PathType Container) { $ValidDirs += (Resolve-Path $dir).Path }
    else { Write-Host "Warning: Directory not found: $dir" -ForegroundColor Yellow }
}

$ValidFiles = @()
foreach ($file in $FILES) {
    if (Test-Path $file -PathType Leaf) { $ValidFiles += (Resolve-Path $file).Path }
    else { Write-Host "Warning: File not found: $file" -ForegroundColor Yellow }
}

# Output Handler
$OutputAction = { param($content) if ($WRITING_TO_FILE) { $content | Out-File -FilePath $D -Append -Encoding UTF8 } else { Write-Host $content } }

# Main Execution
if ($WRITING_TO_FILE) {
    Write-Host "Output will be saved to: $D" -ForegroundColor Cyan
    if (Test-Path $D) { Clear-Content $D }
}

foreach ($dir in $ValidDirs) {
    Process_Directory $dir
}

foreach ($file in $ValidFiles) {
    Process_File $file
}

# =============================================================================
# Functions
# =============================================================================

function Print_Help {
    Write-Host "dircat - List and Concatenate Tool (Windows)"
    Write-Host "Version: $VERSION"
    Write-Host ""
    Write-Host "USAGE:"
    Write-Host "  dircat.bat [OPTIONS]"
    Write-Host ""
    Write-Host "OPTIONS:"
    Write-Host "  -d, --dir DIR          Directories to process recursively"
    Write-Host "  -f, --file FILE        Files to process (non-recursive)"
    Write-Host "  -sd, --skip-dir PAT    Skip directories matching pattern"
    Write-Host "  -sf, --skip-file PAT   Skip files matching pattern"
    Write-Host "  -a, --all              Include hidden files and directories"
    Write-Host "  -D, --destination FILE Output file"
    Write-Host "  -de, --delimiter CHAR  Delimiter (default: '---')"
    Write-Host "  -c, --compress         Compress content (remove indentation)"
    Write-Host "  -C, --compress-hard    Aggressive compression (one-line)"
    Write-Host "  -l, --line-numbers     Show line numbers"
    Write-Host "  -H, --header-type TYPE tree, ls, ls-R, none"
    Write-Host "  -i, --install          Install system-wide"
    Write-Host "  -h, --help             Show help"
    Write-Host "  -v, --version          Show version"
}

function Print_Version {
    Write-Host "dircat version $VERSION" -ForegroundColor Green
    Write-Host "Windows Equivalent of lscat"
}

function Install_Dircat {
    Write-Host "Installing dircat..." -ForegroundColor Cyan
    $InstallPath = "$env:USERPROFILE\.local\bin"
    if (-not (Test-Path $InstallPath)) { New-Item -ItemType Directory -Force -Path $InstallPath | Out-Null }
    
    $ScriptSrc = $PSCommandPath
    $ScriptDest = "$InstallPath\dircat.ps1"
    $BatSrc = $ScriptSrc -replace "\.ps1$", ".bat"
    $BatDest = "$InstallPath\dircat.bat"

    Copy-Item $ScriptSrc $ScriptDest -Force
    Copy-Item $BatSrc $BatDest -Force

    Write-Host "Installed to $InstallPath" -ForegroundColor Green
    Write-Host "Please add $InstallPath to your PATH environment variable."
}

function Should_Skip {
    param($Path, $Type) # Type: 'Dir' or 'File'
    $Name = Split-Path $Path -Leaf
    $Patterns = if ($Type -eq 'Dir') { $SKIP_DIRS } else { $SKIP_FILES }
    
    foreach ($pat in $Patterns) {
        if ($Name -like $pat) { return $true }
        if ($Path -like "*$pat*") { return $true }
    }
    return $false
}

function Compress_Content {
    param($Content)
    if ($COMPRESS_HARD) {
        return ($Content -split "`n" | ForEach-Object { $_.Trim() } | Where-Object { $_ } ) -join " "
    } elseif ($COMPRESS) {
        return ($Content -split "`n" | ForEach-Object { $_.Trim() } | Where-Object { $_ -ne "" }) -join "`n"
    }
    return $Content
}

function Print_Header {
    param($Text)
    if ($WRITING_TO_FILE) {
        $OutputAction.Invoke("`n═══════════════════════════════════════════════════")
        $OutputAction.Invoke($Text)
        $OutputAction.Invoke("══════════════════════════════════════════════════=`n")
    } else {
        Write-Host "`n═══════════════════════════════════════════════════" -ForegroundColor Magenta
        Write-Host $Text -ForegroundColor White
        Write-Host "═══════════════════════════════════════════════════`n" -ForegroundColor Magenta
    }
}

function Get_Tree_Structure {
    param($Dir, $Prefix = "", $IsLast = $true)
    # Simplified Tree Logic for Windows Parity
    $Items = Get-ChildItem $Dir -Force | Where-Object { 
        if (-not $INCLUDE_HIDDEN -and $_.Name.StartsWith(".")) { return $false }
        if (Should_Skip $_.FullName $(if ($_.PSIsContainer) { 'Dir' } else { 'File' })) { return $false }
        return $true
    } | Sort-Object Name
    
    $Count = $Items.Count
    for ($i = 0; $i -lt $Count; $i++) {
        $Item = $Items[$i]
        $IsLastItem = ($i -eq $Count - 1)
        $Symbol = if ($IsLastItem) { "└── " } else { "├── " }
        $Color = if ($Item.PSIsContainer) { "Blue" } else { "Green" }
        
        if ($WRITING_TO_FILE) {
            $OutputAction.Invoke("$Prefix$Symbol$($Item.Name)")
        } else {
            Write-Host "$Prefix$Symbol$($Item.Name)" -ForegroundColor $Color
        }

        if ($Item.PSIsContainer -and $NON_RECURSIVE -eq $false) {
            $NewPrefix = $Prefix + $(if ($IsLastItem) { "    " } else { "│   " })
            Get_Tree_Structure $Item.FullName $NewPrefix
        }
    }
}

function Process_Directory {
    param($Dir)
    if (Should_Skip $Dir 'Dir') { return }

    if ($H -ne "none") {
        Print_Header "Directory Structure: $Dir"
        if ($H -eq "tree") {
            if ($WRITING_TO_FILE) { $OutputAction.Invoke("📁 $Dir") } else { Write-Host "📁 $Dir" -ForegroundColor Blue }
            Get_Tree_Structure $Dir
        } else {
            # LS Style
            Get-ChildItem $Dir -Force | ForEach-Object { 
                if (-not $INCLUDE_HIDDEN -and $_.Name.StartsWith(".")) { return }
                $OutputAction.Invoke($_.Name) 
            }
        }
    }

    Print_Header "File Contents"
    $Files = Get-ChildItem $Dir -Recurse -File -Force | Where-Object {
        if (-not $INCLUDE_HIDDEN -and $_.Name.StartsWith(".")) { return $false }
        if (Should_Skip $_.FullName 'File') { return $false }
        return $true
    } | Sort-Object FullName

    foreach ($File in $Files) {
        Process_File $File.FullName
    }
}

function Process_File {
    param($Path)
    if (Should_Skip $Path 'File') { return }
    
    if ($WRITING_TO_FILE) {
        $OutputAction.Invoke("`nFile: $Path")
        $OutputAction.Invoke($de)
    } else {
        Write-Host "`nFile: $Path" -ForegroundColor White
        Write-Host $de -ForegroundColor Gray
    }

    $Content = Get-Content $Path -Raw -Encoding UTF8
    if ($SHOW_LINE_NUMBERS) {
        $Lines = $Content -split "`n"
        for ($i = 0; $i -lt $Lines.Count; $i++) {
            $Line = if ($COMPRESS -or $COMPRESS_HARD) { ($Lines[$i]).Trim() } else { $Lines[$i] }
            if ($Line -ne "" -or -not ($COMPRESS -or $COMPRESS_HARD)) {
                $OutputAction.Invoke("{0,6} {1}" -f ($i + 1), $Line)
            }
        }
    } else {
        $OutputAction.Invoke((Compress_Content $Content))
    }
}