@echo off
setlocal
:: dircat.bat - Windows Launcher for dircat.ps1
:: Ensures PowerShell runs without execution policy barriers

set "SCRIPT_DIR=%~dp0"
set "PS_SCRIPT=%SCRIPT_DIR%dircat.ps1"

if not exist "%PS_SCRIPT%" (
    echo Error: dircat.ps1 not found in %SCRIPT_DIR%
    exit /b 1
)

:: Run PowerShell with bypassed execution policy for this script
powershell -NoProfile -ExecutionPolicy Bypass -File "%PS_SCRIPT%" %*
endlocal