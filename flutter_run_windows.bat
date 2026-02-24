@echo off
REM Run Flutter on Windows via cmd to avoid PowerShell "Unable to determine engine version" error.
cd /d "%~dp0"
flutter run -d windows
pause
