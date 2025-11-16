@echo off
echo.
echo ============================================
echo   Warehouse Mapper - Frontend Dev Server
echo ============================================
echo.
echo Starting development server...
echo.
echo Once started, open your browser to:
echo   http://localhost:5173
echo.
echo Press Ctrl+C to stop the server
echo.
echo ============================================
echo.

cd /d "%~dp0"
npm run dev

pause
