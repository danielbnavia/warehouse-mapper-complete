# Get-PlannerIDs.ps1
# Helper script to retrieve Planner Team, Plan, and Bucket IDs using Microsoft Graph
# Requires Microsoft.Graph PowerShell module

<#
.SYNOPSIS
    Retrieves Planner IDs needed for Power Automate flow configuration

.DESCRIPTION
    This script connects to Microsoft Graph and retrieves:
    - Team IDs
    - Plan IDs for a specified team
    - Bucket IDs for a specified plan

.EXAMPLE
    .\Get-PlannerIDs.ps1
#>

# Check if Microsoft.Graph module is installed
if (-not (Get-Module -ListAvailable -Name Microsoft.Graph)) {
    Write-Host "Microsoft.Graph module not found. Installing..." -ForegroundColor Yellow
    Install-Module Microsoft.Graph -Scope CurrentUser -Force
}

# Import required modules
Import-Module Microsoft.Graph.Teams
Import-Module Microsoft.Graph.Planner

# Connect to Microsoft Graph
Write-Host "`n=== Connecting to Microsoft Graph ===" -ForegroundColor Cyan
Write-Host "You will be prompted to sign in..." -ForegroundColor Yellow

try {
    Connect-MgGraph -Scopes "Group.Read.All", "Tasks.Read"
    Write-Host "Connected successfully!" -ForegroundColor Green
} catch {
    Write-Host "Failed to connect: $_" -ForegroundColor Red
    exit 1
}

# Get all teams the user is a member of
Write-Host "`n=== Your Teams ===" -ForegroundColor Cyan
$teams = Get-MgUserJoinedTeam -UserId "me"

if ($teams.Count -eq 0) {
    Write-Host "No teams found." -ForegroundColor Red
    Disconnect-MgGraph
    exit 1
}

$i = 1
foreach ($team in $teams) {
    Write-Host "[$i] $($team.DisplayName)" -ForegroundColor White
    Write-Host "    ID: $($team.Id)" -ForegroundColor Gray
    $i++
}

# Ask user to select a team
Write-Host "`nEnter the number of your team: " -NoNewline -ForegroundColor Yellow
$teamSelection = Read-Host
$selectedTeam = $teams[$teamSelection - 1]

if (-not $selectedTeam) {
    Write-Host "Invalid selection." -ForegroundColor Red
    Disconnect-MgGraph
    exit 1
}

Write-Host "`nSelected Team: $($selectedTeam.DisplayName)" -ForegroundColor Green
Write-Host "Team ID: $($selectedTeam.Id)" -ForegroundColor Green

# Get plans for the selected team
Write-Host "`n=== Getting Plans for Team ===" -ForegroundColor Cyan
try {
    $plans = Get-MgGroupPlannerPlan -GroupId $selectedTeam.Id

    if ($plans.Count -eq 0) {
        Write-Host "No plans found for this team." -ForegroundColor Red
        Disconnect-MgGraph
        exit 1
    }

    $i = 1
    foreach ($plan in $plans) {
        Write-Host "[$i] $($plan.Title)" -ForegroundColor White
        Write-Host "    ID: $($plan.Id)" -ForegroundColor Gray
        $i++
    }

    # Ask user to select a plan
    Write-Host "`nEnter the number of your plan: " -NoNewline -ForegroundColor Yellow
    $planSelection = Read-Host
    $selectedPlan = $plans[$planSelection - 1]

    if (-not $selectedPlan) {
        Write-Host "Invalid selection." -ForegroundColor Red
        Disconnect-MgGraph
        exit 1
    }

    Write-Host "`nSelected Plan: $($selectedPlan.Title)" -ForegroundColor Green
    Write-Host "Plan ID: $($selectedPlan.Id)" -ForegroundColor Green

} catch {
    Write-Host "Failed to retrieve plans: $_" -ForegroundColor Red
    Disconnect-MgGraph
    exit 1
}

# Get buckets for the selected plan
Write-Host "`n=== Getting Buckets for Plan ===" -ForegroundColor Cyan
try {
    $buckets = Get-MgPlannerPlanBucket -PlannerPlanId $selectedPlan.Id

    if ($buckets.Count -eq 0) {
        Write-Host "No buckets found for this plan." -ForegroundColor Yellow
        Write-Host "You may need to create buckets manually in Planner." -ForegroundColor Yellow
    } else {
        foreach ($bucket in $buckets) {
            Write-Host "`nBucket: $($bucket.Name)" -ForegroundColor White
            Write-Host "ID: $($bucket.Id)" -ForegroundColor Gray
        }
    }

} catch {
    Write-Host "Failed to retrieve buckets: $_" -ForegroundColor Red
}

# Display summary
Write-Host "`n`n=== SUMMARY - Copy these values to your Power Automate flow ===" -ForegroundColor Cyan
Write-Host "=============================================================" -ForegroundColor Cyan

Write-Host "`nTeam ID:" -ForegroundColor Yellow
Write-Host $selectedTeam.Id -ForegroundColor White

Write-Host "`nPlan ID:" -ForegroundColor Yellow
Write-Host $selectedPlan.Id -ForegroundColor White

if ($buckets.Count -gt 0) {
    Write-Host "`nBucket IDs:" -ForegroundColor Yellow
    foreach ($bucket in $buckets) {
        Write-Host "$($bucket.Name): $($bucket.Id)" -ForegroundColor White
    }

    Write-Host "`n`nLook for buckets named:" -ForegroundColor Yellow
    Write-Host "- 'Action Items' (for ActionItemsBucketID)" -ForegroundColor White
    Write-Host "- 'Missing Information' (for MissingInfoBucketID)" -ForegroundColor White
    Write-Host "`nIf these don't exist, create them in Planner and run this script again." -ForegroundColor Yellow
}

Write-Host "`n=============================================================" -ForegroundColor Cyan

# Disconnect
Disconnect-MgGraph
Write-Host "`nDisconnected from Microsoft Graph." -ForegroundColor Green

# Optionally save to file
Write-Host "`nWould you like to save these IDs to a file? (Y/N): " -NoNewline -ForegroundColor Yellow
$saveChoice = Read-Host

if ($saveChoice -eq "Y" -or $saveChoice -eq "y") {
    $outputPath = Join-Path $PSScriptRoot "planner_ids.txt"

    $output = @"
Planner Configuration IDs
Generated: $(Get-Date)
========================

Team ID:
$($selectedTeam.Id)

Plan ID:
$($selectedPlan.Id)

Buckets:
"@

    foreach ($bucket in $buckets) {
        $output += "`n$($bucket.Name): $($bucket.Id)"
    }

    $output | Out-File -FilePath $outputPath -Encoding UTF8
    Write-Host "IDs saved to: $outputPath" -ForegroundColor Green
}

Write-Host "`nScript complete!" -ForegroundColor Green
