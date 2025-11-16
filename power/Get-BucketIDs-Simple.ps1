Write-Host "=====================================================================" -ForegroundColor Cyan
Write-Host "BUCKET ID EXTRACTOR - MANUAL METHOD" -ForegroundColor Cyan
Write-Host "=====================================================================" -ForegroundColor Cyan
Write-Host ""

$planId = "c693904c-956a-4bb9-984e-20e57b622817"

Write-Host "Your Plan ID: $planId" -ForegroundColor Green
Write-Host ""
Write-Host "=====================================================================" -ForegroundColor Yellow
Write-Host "METHOD 1: EXTRACT FROM PLANNER URL" -ForegroundColor Yellow
Write-Host "=====================================================================" -ForegroundColor Yellow
Write-Host ""
Write-Host "1. Go to your Planner page" -ForegroundColor White
Write-Host "2. Click on a task in the 'Action Items' bucket" -ForegroundColor White
Write-Host "3. The URL will show the bucket ID" -ForegroundColor White
Write-Host ""
Write-Host "Example URL:" -ForegroundColor Gray
Write-Host "https://planner.cloud.microsoft/...&task=xyz123&bucketId=ABC789..." -ForegroundColor Gray
Write-Host ""
Write-Host "The bucketId parameter is what we need!" -ForegroundColor Green
Write-Host ""
Write-Host "=====================================================================" -ForegroundColor Yellow
Write-Host "PASTE YOUR URLS HERE:" -ForegroundColor Yellow
Write-Host "=====================================================================" -ForegroundColor Yellow
Write-Host ""

# Get Action Items bucket URL
Write-Host "Action Items bucket - Click a task and paste the URL:" -ForegroundColor Cyan
$actionItemsUrl = Read-Host "URL"

if ($actionItemsUrl -match "bucketId=([^&]+)") {
    $actionItemsBucketId = $matches[1]
    Write-Host "✅ Found Action Items Bucket ID: $actionItemsBucketId" -ForegroundColor Green
} else {
    Write-Host "❌ Couldn't find bucketId in URL" -ForegroundColor Red
    Write-Host "The URL should contain '&bucketId=' parameter" -ForegroundColor Yellow
    $actionItemsBucketId = Read-Host "Enter Action Items Bucket ID manually"
}

Write-Host ""

# Get Missing Information bucket URL
Write-Host "Missing Information bucket - Click a task and paste the URL:" -ForegroundColor Cyan
$missingInfoUrl = Read-Host "URL"

if ($missingInfoUrl -match "bucketId=([^&]+)") {
    $missingInfoBucketId = $matches[1]
    Write-Host "✅ Found Missing Information Bucket ID: $missingInfoBucketId" -ForegroundColor Green
} else {
    Write-Host "❌ Couldn't find bucketId in URL" -ForegroundColor Red
    Write-Host "The URL should contain '&bucketId=' parameter" -ForegroundColor Yellow
    $missingInfoBucketId = Read-Host "Enter Missing Information Bucket ID manually"
}

Write-Host ""
Write-Host "=====================================================================" -ForegroundColor Cyan
Write-Host "✅ YOUR PLANNER IDs - READY TO USE!" -ForegroundColor Cyan
Write-Host "=====================================================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "Team ID:" -ForegroundColor Yellow
Write-Host "6cdbd2a2-7e69-492e-ad7e-a617ed1c6597" -ForegroundColor White
Write-Host ""
Write-Host "Plan ID:" -ForegroundColor Yellow
Write-Host "$planId" -ForegroundColor White
Write-Host ""
Write-Host "Action Items Bucket ID:" -ForegroundColor Yellow
Write-Host "$actionItemsBucketId" -ForegroundColor White
Write-Host ""
Write-Host "Missing Information Bucket ID:" -ForegroundColor Yellow
Write-Host "$missingInfoBucketId" -ForegroundColor White
Write-Host ""
Write-Host "=====================================================================" -ForegroundColor Cyan
Write-Host "NEXT STEP: UPDATE YOUR FLOW VARIABLES" -ForegroundColor Cyan
Write-Host "=====================================================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "1. Open Power Automate: https://make.powerautomate.com" -ForegroundColor White
Write-Host "2. Find your imported flow" -ForegroundColor White
Write-Host "3. Click 'Edit'" -ForegroundColor White
Write-Host "4. Update these 3 variables:" -ForegroundColor White
Write-Host ""
Write-Host "   Variable: PlanID" -ForegroundColor Yellow
Write-Host "   Value: $planId" -ForegroundColor White
Write-Host ""
Write-Host "   Variable: ActionItemsBucketID" -ForegroundColor Yellow
Write-Host "   Value: $actionItemsBucketId" -ForegroundColor White
Write-Host ""
Write-Host "   Variable: MissingInfoBucketID" -ForegroundColor Yellow
Write-Host "   Value: $missingInfoBucketId" -ForegroundColor White
Write-Host ""
Write-Host "5. Click 'Save'" -ForegroundColor White
Write-Host ""
Write-Host "=====================================================================" -ForegroundColor Green
Write-Host "DONE! Your flow will be ready to test!" -ForegroundColor Green
Write-Host "=====================================================================" -ForegroundColor Green
Write-Host ""

# Save to file
$configFile = "M:\warehouse-mapper-complete\power\PLANNER_IDs.txt"
@"
====================================================================
YOUR PLANNER IDs - $(Get-Date -Format "yyyy-MM-dd HH:mm:ss")
====================================================================

Team ID: 6cdbd2a2-7e69-492e-ad7e-a617ed1c6597
Plan ID: $planId
Action Items Bucket ID: $actionItemsBucketId
Missing Information Bucket ID: $missingInfoBucketId

====================================================================
FLOW VARIABLE CONFIGURATION
====================================================================

Update these 3 variables in your Power Automate flow:

1. PlanID = $planId
2. ActionItemsBucketID = $actionItemsBucketId
3. MissingInfoBucketID = $missingInfoBucketId

====================================================================
"@ | Out-File -FilePath $configFile -Encoding UTF8

Write-Host "✅ IDs saved to: $configFile" -ForegroundColor Green
Write-Host ""
Write-Host "Press any key to exit..."
$null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
