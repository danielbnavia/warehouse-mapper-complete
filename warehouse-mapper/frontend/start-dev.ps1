Write-Host ""
Write-Host "============================================" -ForegroundColor Cyan
Write-Host "  Warehouse Mapper - Frontend Dev Server" -ForegroundColor Cyan
Write-Host "============================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "Starting development server..." -ForegroundColor Yellow
Write-Host ""
Write-Host "Once started, open your browser to:" -ForegroundColor Green
Write-Host "  http://localhost:5173" -ForegroundColor White -BackgroundColor DarkGreen
Write-Host ""
Write-Host "Press Ctrl+C to stop the server" -ForegroundColor Yellow
Write-Host ""
Write-Host "============================================" -ForegroundColor Cyan
Write-Host ""

Set-Location $PSScriptRoot
npm run dev
