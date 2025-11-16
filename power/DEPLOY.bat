@echo off
REM Quick deployment launcher for Power Automate flow

echo.
echo ============================================================
echo   Power Automate Flow - Quick Deploy
echo ============================================================
echo.
echo This will help you deploy the Scope Mapper flow.
echo.

powershell -ExecutionPolicy Bypass -File "%~dp0Deploy-ToPowerAutomate.ps1"

pause
