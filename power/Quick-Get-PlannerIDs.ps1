# Quick-Get-PlannerIDs.ps1
# Faster approach - uses Microsoft Graph REST API directly
# Your Team ID: 6cdbd2a2-7e69-492e-ad7e-a617ed1c6597

Write-Host "`n=== Quick Planner ID Retrieval ===" -ForegroundColor Cyan
Write-Host "This will open your browser to get an access token...`n" -ForegroundColor Yellow

# Known Team ID from webhook
$teamId = "6cdbd2a2-7e69-492e-ad7e-a617ed1c6597"

Write-Host "Team ID: $teamId" -ForegroundColor Green
Write-Host "(From your Teams webhook URL)`n" -ForegroundColor Gray

# Option 1: Use Graph Explorer (easiest)
Write-Host "=== OPTION 1: Use Graph Explorer (Recommended) ===" -ForegroundColor Cyan
Write-Host "`n1. Opening Graph Explorer in browser..." -ForegroundColor Yellow

$graphUrl = "https://developer.microsoft.com/en-us/graph/graph-explorer?request=groups/$teamId/planner/plans&method=GET&version=v1.0"

Start-Process $graphUrl

Write-Host "`n2. In Graph Explorer:" -ForegroundColor Yellow
Write-Host "   - Sign in with your Microsoft account" -ForegroundColor White
Write-Host "   - Click 'Run query'" -ForegroundColor White
Write-Host "   - Look for the Plan you want in the results" -ForegroundColor White
Write-Host "   - Copy the 'id' field`n" -ForegroundColor White

Write-Host "3. Once you have the Plan ID, we'll get the Bucket IDs..." -ForegroundColor Yellow
Write-Host "`nEnter your Plan ID (or press Enter to skip): " -NoNewline -ForegroundColor Yellow
$planId = Read-Host

if ($planId) {
    Write-Host "`nOpening Graph Explorer to get Bucket IDs..." -ForegroundColor Yellow
    $bucketsUrl = "https://developer.microsoft.com/en-us/graph/graph-explorer?request=planner/plans/$planId/buckets&method=GET&version=v1.0"
    Start-Process $bucketsUrl

    Write-Host "`nLook for buckets named:" -ForegroundColor Yellow
    Write-Host "- 'Action Items'" -ForegroundColor White
    Write-Host "- 'Missing Information'" -ForegroundColor White
    Write-Host "`nCopy their 'id' values`n" -ForegroundColor White
}

# Option 2: Manual from Planner UI
Write-Host "`n=== OPTION 2: Get from Planner UI ===" -ForegroundColor Cyan
Write-Host "`n1. Opening Planner..." -ForegroundColor Yellow
Start-Process "https://tasks.office.com"

Write-Host "`n2. In Planner:" -ForegroundColor Yellow
Write-Host "   - Find your 'NF 3PL Integrations' plan" -ForegroundColor White
Write-Host "   - Click to open it" -ForegroundColor White
Write-Host "   - Look at the URL in your browser" -ForegroundColor White
Write-Host "   - The Plan ID is after '/PlanViews/': " -ForegroundColor White
Write-Host "     https://tasks.office.com/.../PlanViews/[PLAN_ID_HERE]" -ForegroundColor Gray
Write-Host "`n   - For Bucket IDs, you'll need to use Graph Explorer (Option 1)`n" -ForegroundColor White

Write-Host "`n=== Next Steps ===" -ForegroundColor Cyan
Write-Host "Once you have the IDs, I'll help you update your Power Automate flow!" -ForegroundColor Yellow
Write-Host "`n"
