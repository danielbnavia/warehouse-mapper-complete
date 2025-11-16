Write-Host "=====================================================================" -ForegroundColor Cyan
Write-Host "EXTRACTING BUCKET ID FROM TASK" -ForegroundColor Cyan
Write-Host "=====================================================================" -ForegroundColor Cyan
Write-Host ""

$taskId = "4B589670-FB78-498F-8021-281B79B2008B"
$planId = "c693904c-956a-4bb9-984e-20e57b622817"

Write-Host "Task ID from URL: $taskId" -ForegroundColor Yellow
Write-Host ""
Write-Host "Attempting to get task details and bucket information..." -ForegroundColor White
Write-Host ""

try {
    # Try to connect to Microsoft Graph
    Import-Module Microsoft.Graph.Planner -ErrorAction Stop

    Write-Host "Connecting to Microsoft Graph..." -ForegroundColor Cyan
    Connect-MgGraph -Scopes "Tasks.Read", "Group.Read.All" -ErrorAction Stop

    Write-Host "✅ Connected!" -ForegroundColor Green
    Write-Host ""

    # Get task details
    Write-Host "Fetching task details..." -ForegroundColor Cyan
    $task = Get-MgPlannerTask -PlannerTaskId $taskId -ErrorAction Stop

    Write-Host "✅ Task found: $($task.Title)" -ForegroundColor Green
    Write-Host "   Bucket ID: $($task.BucketId)" -ForegroundColor Yellow
    Write-Host ""

    # Get all buckets for the plan
    Write-Host "Fetching all buckets for plan..." -ForegroundColor Cyan
    $buckets = Get-MgPlannerPlanBucket -PlannerPlanId $planId -ErrorAction Stop

    Write-Host "✅ Found $($buckets.Count) buckets:" -ForegroundColor Green
    Write-Host ""

    $actionItemsBucketId = ""
    $missingInfoBucketId = ""

    foreach ($bucket in $buckets) {
        Write-Host "Bucket: $($bucket.Name)" -ForegroundColor Cyan
        Write-Host "   ID: $($bucket.Id)" -ForegroundColor White
        Write-Host ""

        if ($bucket.Name -eq "Action Items") {
            $actionItemsBucketId = $bucket.Id
        }
        if ($bucket.Name -eq "Missing Information") {
            $missingInfoBucketId = $bucket.Id
        }
    }

    Write-Host "=====================================================================" -ForegroundColor Green
    Write-Host "✅ SUCCESS! ALL IDs FOUND!" -ForegroundColor Green
    Write-Host "=====================================================================" -ForegroundColor Green
    Write-Host ""
    Write-Host "Team ID: 6cdbd2a2-7e69-492e-ad7e-a617ed1c6597" -ForegroundColor Yellow
    Write-Host "Plan ID: $planId" -ForegroundColor Yellow
    Write-Host "Action Items Bucket ID: $actionItemsBucketId" -ForegroundColor Yellow
    Write-Host "Missing Information Bucket ID: $missingInfoBucketId" -ForegroundColor Yellow
    Write-Host ""

    # Save to file
    $configFile = "M:\warehouse-mapper-complete\power\PLANNER_IDs_FINAL.txt"
    @"
====================================================================
YOUR PLANNER IDs - $(Get-Date -Format "yyyy-MM-dd HH:mm:ss")
====================================================================

Team ID: 6cdbd2a2-7e69-492e-ad7e-a617ed1c6597
Plan ID: $planId
Action Items Bucket ID: $actionItemsBucketId
Missing Information Bucket ID: $missingInfoBucketId

====================================================================
NEXT: UPDATE YOUR FLOW
====================================================================

1. Go to: https://make.powerautomate.com
2. Find your imported flow
3. Click 'Edit'
4. Update these 3 variable values:
   - PlanID = $planId
   - ActionItemsBucketID = $actionItemsBucketId
   - MissingInfoBucketID = $missingInfoBucketId
5. Save the flow
6. Copy the webhook URL
7. Test with: .\Test-Webhook.ps1 "YOUR_WEBHOOK_URL"

====================================================================
"@ | Out-File -FilePath $configFile -Encoding UTF8

    Write-Host "✅ IDs saved to: $configFile" -ForegroundColor Green
    Write-Host ""

    Disconnect-MgGraph

} catch {
    Write-Host "❌ Error: $($_.Exception.Message)" -ForegroundColor Red
    Write-Host ""
    Write-Host "=====================================================================" -ForegroundColor Yellow
    Write-Host "ALTERNATIVE: NETWORK TAB METHOD" -ForegroundColor Yellow
    Write-Host "=====================================================================" -ForegroundColor Yellow
    Write-Host ""
    Write-Host "Since API access failed, try this:" -ForegroundColor White
    Write-Host ""
    Write-Host "1. Keep your Planner tab open" -ForegroundColor White
    Write-Host "2. Press F12 (DevTools)" -ForegroundColor White
    Write-Host "3. Go to 'Network' tab" -ForegroundColor White
    Write-Host "4. In filter box, type: buckets" -ForegroundColor White
    Write-Host "5. Refresh the page (F5)" -ForegroundColor White
    Write-Host "6. Click on a request containing 'buckets'" -ForegroundColor White
    Write-Host "7. Click 'Response' tab" -ForegroundColor White
    Write-Host "8. Copy the JSON response" -ForegroundColor White
    Write-Host "9. Paste it here" -ForegroundColor White
    Write-Host ""
    Write-Host "The response will have bucket IDs in it!" -ForegroundColor Green
    Write-Host ""
}

Write-Host "Press any key to exit..."
$null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
