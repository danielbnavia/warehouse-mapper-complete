# Deploy-With-CLI.ps1
# Deploy flow using Power Platform CLI

<#
.SYNOPSIS
    Deploy Scope Mapper flow using Power Platform CLI

.DESCRIPTION
    This script uses the Power Platform CLI (pac) to deploy the flow
    directly to your environment.

.EXAMPLE
    .\Deploy-With-CLI.ps1
#>

$ErrorActionPreference = "Stop"

$envId = "Default-2131d362-e12d-44c1-843b-a1413d6b96a3"
$flowId = "20db2fc2-1b67-4c77-b0e4-2dd42e611538"
$scriptDir = $PSScriptRoot
$flowFile = Join-Path $scriptDir "flow.json"

Write-Host "=" * 70 -ForegroundColor Cyan
Write-Host "Power Platform CLI Deployment" -ForegroundColor Cyan
Write-Host "=" * 70 -ForegroundColor Cyan

# Check if pac CLI is installed
Write-Host "`nChecking for Power Platform CLI..." -ForegroundColor Yellow

try {
    $pacVersion = pac --version 2>$null
    Write-Host "✓ Power Platform CLI found: $pacVersion" -ForegroundColor Green
} catch {
    Write-Host "✗ Power Platform CLI not found!" -ForegroundColor Red
    Write-Host "`nTo install Power Platform CLI:" -ForegroundColor Yellow
    Write-Host "1. Install using winget:" -ForegroundColor White
    Write-Host "   winget install Microsoft.PowerPlatformCLI" -ForegroundColor Cyan
    Write-Host "`n2. Or download from:" -ForegroundColor White
    Write-Host "   https://aka.ms/PowerPlatformCLI" -ForegroundColor Cyan
    Write-Host "`n3. Then run this script again" -ForegroundColor White
    exit 1
}

# Authenticate
Write-Host "`nAuthenticating to Power Platform..." -ForegroundColor Yellow
Write-Host "A browser window will open for authentication." -ForegroundColor Gray

try {
    pac auth create --environment $envId
    Write-Host "✓ Authentication successful" -ForegroundColor Green
} catch {
    Write-Host "✗ Authentication failed: $_" -ForegroundColor Red
    Write-Host "`nTry manual authentication:" -ForegroundColor Yellow
    Write-Host "pac auth create --environment $envId" -ForegroundColor Cyan
    exit 1
}

# List current environment
Write-Host "`nCurrent environment:" -ForegroundColor Yellow
pac env who

Write-Host "`n" -NoNewline
Write-Host "IMPORTANT: " -ForegroundColor Red -NoNewline
Write-Host "Power Platform CLI has limited support for deploying flows." -ForegroundColor Yellow
Write-Host "The recommended approach is to import via the Power Automate portal." -ForegroundColor Yellow

Write-Host "`nWould you like to:" -ForegroundColor Yellow
Write-Host "  [1] Open Power Automate portal for manual import (RECOMMENDED)" -ForegroundColor White
Write-Host "  [2] Continue with CLI experimental approach" -ForegroundColor White
Write-Host "  [3] Exit" -ForegroundColor White
Write-Host "`nChoice (1-3): " -NoNewline -ForegroundColor Yellow
$choice = Read-Host

switch ($choice) {
    "1" {
        Write-Host "`nOpening Power Automate portal..." -ForegroundColor Green
        $portalUrl = "https://make.powerautomate.com/environments/$envId/flows"
        Start-Process $portalUrl

        Write-Host "`nIn the browser:" -ForegroundColor Yellow
        Write-Host "1. Click 'Import' → 'Import Package (Legacy)'" -ForegroundColor White
        Write-Host "2. Upload: ScopeMapperFlow_Complete.zip" -ForegroundColor White
        Write-Host "3. Configure connection and import" -ForegroundColor White

        Write-Host "`nFlow file location:" -ForegroundColor Yellow
        Write-Host $scriptDir -ForegroundColor Cyan
    }

    "2" {
        Write-Host "`nAttempting CLI deployment..." -ForegroundColor Yellow
        Write-Host "Note: This may not work for all flow types" -ForegroundColor Gray

        # Try to export solution
        Write-Host "`nThis approach requires:" -ForegroundColor Yellow
        Write-Host "1. Creating a solution in Power Platform" -ForegroundColor White
        Write-Host "2. Adding the flow to the solution" -ForegroundColor White
        Write-Host "3. Exporting and importing the solution" -ForegroundColor White

        Write-Host "`nFor now, please use manual import (Option 1)" -ForegroundColor Yellow
    }

    default {
        Write-Host "`nExiting..." -ForegroundColor Gray
    }
}

Write-Host "`n" -NoNewline
Write-Host "=" * 70 -ForegroundColor Cyan
Write-Host ""
