# Deploy-ToPowerAutomate.ps1
# Helper script to guide Power Automate flow deployment

<#
.SYNOPSIS
    Guides deployment of Scope Mapper flow to Power Automate

.DESCRIPTION
    This script helps you deploy the Power Automate flow by:
    1. Opening Power Automate in your browser
    2. Getting your Planner IDs
    3. Providing step-by-step instructions
    4. Testing the deployed flow

.EXAMPLE
    .\Deploy-ToPowerAutomate.ps1
#>

param(
    [Parameter(Mandatory=$false)]
    [switch]$SkipPlannerIDs,

    [Parameter(Mandatory=$false)]
    [switch]$SkipBrowserOpen
)

$ErrorActionPreference = "Stop"

# Color functions
function Write-Title {
    param([string]$Message)
    Write-Host "`n" -NoNewline
    Write-Host "=" * 70 -ForegroundColor Cyan
    Write-Host $Message -ForegroundColor Cyan
    Write-Host "=" * 70 -ForegroundColor Cyan
}

function Write-Step {
    param([int]$Number, [string]$Message)
    Write-Host "`nSTEP $Number: " -NoNewline -ForegroundColor Yellow
    Write-Host $Message -ForegroundColor White
}

function Write-Instruction {
    param([string]$Message)
    Write-Host "  → $Message" -ForegroundColor Gray
}

function Write-Success {
    param([string]$Message)
    Write-Host "✓ $Message" -ForegroundColor Green
}

function Write-Info {
    param([string]$Message)
    Write-Host "ℹ $Message" -ForegroundColor Cyan
}

function Write-Warning-Custom {
    param([string]$Message)
    Write-Host "⚠ $Message" -ForegroundColor Yellow
}

# Main script
Write-Title "Power Automate Flow Deployment Assistant"

Write-Host "`nThis script will guide you through deploying the Scope Mapper flow." -ForegroundColor White
Write-Host "It will help you with all required steps and verify your configuration." -ForegroundColor White

# Check files exist
$scriptDir = $PSScriptRoot
$zipFile = Join-Path $scriptDir "ScopeMapperFlow_Complete.zip"
$plannerScript = Join-Path $scriptDir "Get-PlannerIDs.ps1"
$testScript = Join-Path $scriptDir "Test-Webhook.ps1"

Write-Host "`nVerifying files..." -ForegroundColor Yellow

if (-not (Test-Path $zipFile)) {
    Write-Host "✗ ERROR: ScopeMapperFlow_Complete.zip not found!" -ForegroundColor Red
    exit 1
}
Write-Success "Flow package found: ScopeMapperFlow_Complete.zip"

if (-not (Test-Path $plannerScript)) {
    Write-Warning-Custom "Get-PlannerIDs.ps1 not found (optional)"
} else {
    Write-Success "Planner ID script found"
}

if (-not (Test-Path $testScript)) {
    Write-Warning-Custom "Test-Webhook.ps1 not found (optional)"
} else {
    Write-Success "Test script found"
}

# Step 1: Get Planner IDs
if (-not $SkipPlannerIDs) {
    Write-Step 1 "Get Your Planner IDs"
    Write-Host ""
    Write-Host "You'll need:" -ForegroundColor White
    Write-Instruction "Plan ID (where tasks will be created)"
    Write-Instruction "Action Items Bucket ID"
    Write-Instruction "Missing Information Bucket ID"

    Write-Host "`nWould you like to run Get-PlannerIDs.ps1 now? (Y/N): " -NoNewline -ForegroundColor Yellow
    $response = Read-Host

    if ($response -eq "Y" -or $response -eq "y") {
        if (Test-Path $plannerScript) {
            Write-Host "`nLaunching Get-PlannerIDs.ps1..." -ForegroundColor Green
            & $plannerScript
            Write-Host "`nPress any key to continue..." -ForegroundColor Yellow
            $null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
        } else {
            Write-Host "Script not found. Please get IDs manually." -ForegroundColor Red
        }
    } else {
        Write-Info "You can get IDs later from Graph Explorer:"
        Write-Instruction "https://developer.microsoft.com/en-us/graph/graph-explorer"
    }
} else {
    Write-Info "Skipping Planner ID retrieval (--SkipPlannerIDs flag set)"
}

# Step 2: Open Power Automate
Write-Step 2 "Open Power Automate Portal"

if (-not $SkipBrowserOpen) {
    Write-Host "`nOpening Power Automate in your browser..." -ForegroundColor Green
    Start-Process "https://make.powerautomate.com"
    Start-Sleep -Seconds 2
    Write-Success "Browser opened"
} else {
    Write-Info "Skipping browser open (--SkipBrowserOpen flag set)"
    Write-Host "`nManually open: " -NoNewline -ForegroundColor White
    Write-Host "https://make.powerautomate.com" -ForegroundColor Cyan
}

# Step 3: Import Flow
Write-Step 3 "Import the Flow Package"
Write-Host ""
Write-Instruction "In Power Automate portal, click 'My flows' in left menu"
Write-Instruction "Click 'Import' → 'Import Package (Legacy)'"
Write-Instruction "Click 'Upload' and select this file:"
Write-Host "`n  $zipFile" -ForegroundColor Cyan
Write-Instruction "Click 'Import' and wait for completion"

Write-Host "`nPress any key when import is complete..." -ForegroundColor Yellow
$null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")

# Step 4: Configure Connection
Write-Step 4 "Configure Planner Connection"
Write-Host ""
Write-Instruction "When prompted for 'Planner' connection:"
Write-Instruction "  - Select existing connection, OR"
Write-Instruction "  - Click 'Create new' and sign in with your M365 account"
Write-Instruction "Click 'Save'"

Write-Host "`nPress any key when connection is configured..." -ForegroundColor Yellow
$null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")

# Step 5: Edit Flow Variables
Write-Step 5 "Update Flow Variables"
Write-Host ""
Write-Instruction "Click 'Edit' on the imported flow"
Write-Instruction "Find these 3 'Initialize variable' actions and update:"
Write-Host ""
Write-Host "  1. Initialize_PlanID:" -ForegroundColor White
Write-Host "     Value: " -NoNewline -ForegroundColor Gray
Write-Host "YOUR_PLAN_ID_HERE" -ForegroundColor Yellow
Write-Host ""
Write-Host "  2. Initialize_ActionItemsBucketID:" -ForegroundColor White
Write-Host "     Value: " -NoNewline -ForegroundColor Gray
Write-Host "YOUR_ACTION_ITEMS_BUCKET_ID" -ForegroundColor Yellow
Write-Host ""
Write-Host "  3. Initialize_MissingInfoBucketID:" -ForegroundColor White
Write-Host "     Value: " -NoNewline -ForegroundColor Gray
Write-Host "YOUR_MISSING_INFO_BUCKET_ID" -ForegroundColor Yellow
Write-Host ""
Write-Instruction "Click 'Save' after updating"

Write-Host "`nPress any key when variables are updated..." -ForegroundColor Yellow
$null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")

# Step 6: Get Webhook URL
Write-Step 6 "Get Webhook URL"
Write-Host ""
Write-Instruction "In the flow editor, click on the 'manual' trigger (first action)"
Write-Instruction "Copy the 'HTTP POST URL' shown"
Write-Host ""
Write-Host "Paste the webhook URL here: " -NoNewline -ForegroundColor Yellow
$webhookUrl = Read-Host

if ($webhookUrl -and $webhookUrl -match '^https?://') {
    Write-Success "Webhook URL captured: $($webhookUrl.Substring(0, [Math]::Min(50, $webhookUrl.Length)))..."

    # Save to file
    $configFile = Join-Path $scriptDir "webhook_url.txt"
    $webhookUrl | Out-File -FilePath $configFile -Encoding UTF8
    Write-Success "Webhook URL saved to: webhook_url.txt"

} else {
    Write-Warning-Custom "Invalid or empty webhook URL. You can test manually later."
    $webhookUrl = $null
}

# Step 7: Test the Flow
Write-Step 7 "Test the Flow"
Write-Host ""

if ($webhookUrl -and (Test-Path $testScript)) {
    Write-Host "Would you like to test the flow now? (Y/N): " -NoNewline -ForegroundColor Yellow
    $response = Read-Host

    if ($response -eq "Y" -or $response -eq "y") {
        Write-Host "`nLaunching test script..." -ForegroundColor Green
        & $testScript -WebhookUrl $webhookUrl
    } else {
        Write-Info "You can test later with:"
        Write-Host "  .\Test-Webhook.ps1 '$webhookUrl'" -ForegroundColor Cyan
    }
} else {
    Write-Info "To test the flow, run:"
    if ($webhookUrl) {
        Write-Host "  .\Test-Webhook.ps1 '$webhookUrl'" -ForegroundColor Cyan
    } else {
        Write-Host "  .\Test-Webhook.ps1 YOUR_WEBHOOK_URL" -ForegroundColor Cyan
    }
}

# Summary
Write-Title "Deployment Summary"

Write-Host ""
Write-Success "Flow deployment steps completed!"
Write-Host ""
Write-Host "What you've done:" -ForegroundColor White
Write-Host "  ✓ Retrieved Planner IDs (Plan, Buckets)" -ForegroundColor Gray
Write-Host "  ✓ Imported flow to Power Automate" -ForegroundColor Gray
Write-Host "  ✓ Configured Planner connection" -ForegroundColor Gray
Write-Host "  ✓ Updated flow variables" -ForegroundColor Gray
Write-Host "  ✓ Obtained webhook URL" -ForegroundColor Gray

Write-Host "`nNext Steps:" -ForegroundColor Yellow
Write-Host "  1. Verify tasks are created in your Planner plan" -ForegroundColor White
Write-Host "  2. Integrate webhook URL into your application" -ForegroundColor White
Write-Host "  3. Monitor flow runs in Power Automate" -ForegroundColor White

Write-Host "`nUseful Commands:" -ForegroundColor Yellow
if ($webhookUrl) {
    Write-Host "  Test flow:       " -NoNewline -ForegroundColor Gray
    Write-Host ".\Test-Webhook.ps1 (already has URL)" -ForegroundColor Cyan
}
Write-Host "  Get IDs again:   " -NoNewline -ForegroundColor Gray
Write-Host ".\Get-PlannerIDs.ps1" -ForegroundColor Cyan
Write-Host "  View docs:       " -NoNewline -ForegroundColor Gray
Write-Host "Start README.md" -ForegroundColor Cyan

Write-Host "`nDocumentation:" -ForegroundColor Yellow
Write-Host "  Quick Start:     README.md" -ForegroundColor Gray
Write-Host "  Full Guide:      DEPLOYMENT_GUIDE.md" -ForegroundColor Gray
Write-Host "  Quick Ref:       QUICK_REFERENCE.md" -ForegroundColor Gray

Write-Title "Deployment Complete!"

Write-Host ""
