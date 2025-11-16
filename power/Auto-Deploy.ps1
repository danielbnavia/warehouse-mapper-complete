# Auto-Deploy.ps1
# Fully automated deployment script

param(
    [string]$FlowId = "20db2fc2-1b67-4c77-b0e4-2dd42e611538",
    [string]$EnvironmentId = "Default-2131d362-e12d-44c1-843b-a1413d6b96a3"
)

$ErrorActionPreference = "Continue"

Write-Host "=" * 70 -ForegroundColor Cyan
Write-Host "Automated Power Automate Flow Deployment" -ForegroundColor Cyan
Write-Host "=" * 70 -ForegroundColor Cyan

Write-Host "`nFlow ID: $FlowId" -ForegroundColor White
Write-Host "Environment ID: $EnvironmentId" -ForegroundColor White

# Step 1: Connect to Microsoft Graph with device code
Write-Host "`n[1/5] Connecting to Microsoft Graph..." -ForegroundColor Yellow

try {
    # Use device code for non-interactive
    Connect-MgGraph -Scopes "Group.Read.All", "Tasks.Read", "Tasks.ReadWrite" -UseDeviceCode -NoWelcome
    Write-Host "✓ Connected to Microsoft Graph" -ForegroundColor Green
} catch {
    Write-Host "✗ Failed to connect to Microsoft Graph" -ForegroundColor Red
    Write-Host "Error: $_" -ForegroundColor Red

    # Try alternative - check if already connected
    try {
        $context = Get-MgContext
        if ($context) {
            Write-Host "✓ Already connected as: $($context.Account)" -ForegroundColor Green
        }
    } catch {
        Write-Host "Please run this in a separate PowerShell window:" -ForegroundColor Yellow
        Write-Host "Connect-MgGraph -Scopes 'Group.Read.All','Tasks.Read','Tasks.ReadWrite'" -ForegroundColor Cyan
        exit 1
    }
}

# Step 2: Get Teams
Write-Host "`n[2/5] Getting your Teams..." -ForegroundColor Yellow

try {
    $teams = Get-MgUserJoinedTeam -UserId "me"
    Write-Host "✓ Found $($teams.Count) team(s)" -ForegroundColor Green

    if ($teams.Count -eq 0) {
        Write-Host "✗ No teams found" -ForegroundColor Red
        exit 1
    }

    # Use first team or let user choose
    if ($teams.Count -eq 1) {
        $selectedTeam = $teams[0]
    } else {
        Write-Host "`nAvailable teams:" -ForegroundColor Cyan
        for ($i = 0; $i -lt $teams.Count; $i++) {
            Write-Host "  [$($i+1)] $($teams[$i].DisplayName)" -ForegroundColor White
        }

        $selection = Read-Host "`nSelect team number (or press Enter for first)"
        if ([string]::IsNullOrWhiteSpace($selection)) {
            $selectedTeam = $teams[0]
        } else {
            $selectedTeam = $teams[[int]$selection - 1]
        }
    }

    Write-Host "✓ Selected: $($selectedTeam.DisplayName)" -ForegroundColor Green
    $teamId = $selectedTeam.Id

} catch {
    Write-Host "✗ Failed to get teams: $_" -ForegroundColor Red
    exit 1
}

# Step 3: Get Plans
Write-Host "`n[3/5] Getting Planner plans..." -ForegroundColor Yellow

try {
    $plans = Get-MgGroupPlannerPlan -GroupId $teamId
    Write-Host "✓ Found $($plans.Count) plan(s)" -ForegroundColor Green

    if ($plans.Count -eq 0) {
        Write-Host "✗ No plans found. Please create a plan first." -ForegroundColor Red
        exit 1
    }

    # Use first plan or let user choose
    if ($plans.Count -eq 1) {
        $selectedPlan = $plans[0]
    } else {
        Write-Host "`nAvailable plans:" -ForegroundColor Cyan
        for ($i = 0; $i -lt $plans.Count; $i++) {
            Write-Host "  [$($i+1)] $($plans[$i].Title)" -ForegroundColor White
        }

        $selection = Read-Host "`nSelect plan number (or press Enter for first)"
        if ([string]::IsNullOrWhiteSpace($selection)) {
            $selectedPlan = $plans[0]
        } else {
            $selectedPlan = $plans[[int]$selection - 1]
        }
    }

    Write-Host "✓ Selected: $($selectedPlan.Title)" -ForegroundColor Green
    $planId = $selectedPlan.Id

} catch {
    Write-Host "✗ Failed to get plans: $_" -ForegroundColor Red
    exit 1
}

# Step 4: Get Buckets
Write-Host "`n[4/5] Getting buckets..." -ForegroundColor Yellow

try {
    $buckets = Get-MgPlannerPlanBucket -PlannerPlanId $planId
    Write-Host "✓ Found $($buckets.Count) bucket(s)" -ForegroundColor Green

    if ($buckets.Count -eq 0) {
        Write-Host "⚠ No buckets found. Creating default buckets..." -ForegroundColor Yellow

        # Create Action Items bucket
        $actionBucket = New-MgPlannerBucket -PlanId $planId -Name "Action Items"
        Write-Host "✓ Created 'Action Items' bucket" -ForegroundColor Green

        # Create Missing Information bucket
        $missingBucket = New-MgPlannerBucket -PlanId $planId -Name "Missing Information"
        Write-Host "✓ Created 'Missing Information' bucket" -ForegroundColor Green

        $actionItemsBucketId = $actionBucket.Id
        $missingInfoBucketId = $missingBucket.Id
    } else {
        # Find or assign buckets
        $actionItemsBucket = $buckets | Where-Object { $_.Name -like "*Action*" } | Select-Object -First 1
        $missingInfoBucket = $buckets | Where-Object { $_.Name -like "*Missing*" } | Select-Object -First 1

        if (-not $actionItemsBucket) {
            Write-Host "⚠ No 'Action Items' bucket found, using first bucket" -ForegroundColor Yellow
            $actionItemsBucket = $buckets[0]
        }

        if (-not $missingInfoBucket) {
            if ($buckets.Count -ge 2) {
                Write-Host "⚠ No 'Missing Information' bucket found, using second bucket" -ForegroundColor Yellow
                $missingInfoBucket = $buckets[1]
            } else {
                Write-Host "⚠ Creating 'Missing Information' bucket" -ForegroundColor Yellow
                $missingInfoBucket = New-MgPlannerBucket -PlanId $planId -Name "Missing Information"
            }
        }

        $actionItemsBucketId = $actionItemsBucket.Id
        $missingInfoBucketId = $missingInfoBucket.Id

        Write-Host "✓ Action Items Bucket: $($actionItemsBucket.Name)" -ForegroundColor Green
        Write-Host "✓ Missing Info Bucket: $($missingInfoBucket.Name)" -ForegroundColor Green
    }

} catch {
    Write-Host "✗ Failed to get/create buckets: $_" -ForegroundColor Red
    exit 1
}

# Step 5: Update flow.json with IDs
Write-Host "`n[5/5] Updating flow definition..." -ForegroundColor Yellow

$flowJsonPath = Join-Path $PSScriptRoot "flow.json"

try {
    $flowContent = Get-Content $flowJsonPath -Raw | ConvertFrom-Json

    # Update the variable values
    $flowContent.properties.definition.actions.Initialize_TeamID.inputs.variables[0].value = $teamId
    $flowContent.properties.definition.actions.Initialize_PlanID.inputs.variables[0].value = $planId
    $flowContent.properties.definition.actions.Initialize_ActionItemsBucketID.inputs.variables[0].value = $actionItemsBucketId
    $flowContent.properties.definition.actions.Initialize_MissingInfoBucketID.inputs.variables[0].value = $missingInfoBucketId

    # Save updated flow
    $updatedFlowPath = Join-Path $PSScriptRoot "flow.updated.json"
    $flowContent | ConvertTo-Json -Depth 100 | Set-Content $updatedFlowPath

    Write-Host "✓ Flow definition updated" -ForegroundColor Green
    Write-Host "✓ Saved to: flow.updated.json" -ForegroundColor Green

} catch {
    Write-Host "✗ Failed to update flow: $_" -ForegroundColor Red
    exit 1
}

# Summary
Write-Host "`n" -NoNewline
Write-Host "=" * 70 -ForegroundColor Cyan
Write-Host "Configuration Complete!" -ForegroundColor Green
Write-Host "=" * 70 -ForegroundColor Cyan

Write-Host "`nConfiguration Values:" -ForegroundColor Yellow
Write-Host "  Team ID:              $teamId" -ForegroundColor White
Write-Host "  Plan ID:              $planId" -ForegroundColor White
Write-Host "  Action Items Bucket:  $actionItemsBucketId" -ForegroundColor White
Write-Host "  Missing Info Bucket:  $missingInfoBucketId" -ForegroundColor White

Write-Host "`nNext Steps:" -ForegroundColor Yellow
Write-Host "  1. The flow definition has been updated with your IDs" -ForegroundColor White
Write-Host "  2. Now opening Power Automate to apply the changes..." -ForegroundColor White

# Open Power Automate
$flowUrl = "https://make.powerautomate.com/environments/$EnvironmentId/flows/$FlowId"
Start-Process $flowUrl

Write-Host "`n  3. In the browser, click 'Edit' on your flow" -ForegroundColor White
Write-Host "  4. The flow should now have the correct IDs configured" -ForegroundColor White
Write-Host "  5. Click 'Save' to apply the changes" -ForegroundColor White

Write-Host "`nTo test the flow, run:" -ForegroundColor Yellow
Write-Host "  .\Test-Webhook.ps1 YOUR_WEBHOOK_URL" -ForegroundColor Cyan

Write-Host "`n" -NoNewline
Disconnect-MgGraph -ErrorAction SilentlyContinue
Write-Host "Deployment automation complete!" -ForegroundColor Green
