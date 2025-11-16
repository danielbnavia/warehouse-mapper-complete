# Test-Webhook.ps1
# PowerShell script to test the Scope Mapper Power Automate webhook

<#
.SYNOPSIS
    Tests the Scope Mapper Power Automate webhook flow

.DESCRIPTION
    Sends a test payload to the webhook URL and displays the response.
    Can use the sample payload file or generate a minimal test payload.

.PARAMETER WebhookUrl
    The webhook URL from Power Automate flow trigger

.PARAMETER UseCustomPayload
    Use minimal custom payload instead of sample_webhook_payload.json

.PARAMETER PayloadFile
    Path to custom JSON payload file (default: sample_webhook_payload.json)

.EXAMPLE
    .\Test-Webhook.ps1 -WebhookUrl "https://prod-123.eastus.logic.azure.com:443/..."

.EXAMPLE
    .\Test-Webhook.ps1 -WebhookUrl "https://prod-123.eastus.logic.azure.com:443/..." -UseCustomPayload

.EXAMPLE
    .\Test-Webhook.ps1 -WebhookUrl "https://prod-123.eastus.logic.azure.com:443/..." -PayloadFile "my_payload.json"
#>

param(
    [Parameter(Mandatory=$true, Position=0)]
    [ValidateNotNullOrEmpty()]
    [string]$WebhookUrl,

    [Parameter(Mandatory=$false)]
    [switch]$UseCustomPayload,

    [Parameter(Mandatory=$false)]
    [string]$PayloadFile = "sample_webhook_payload.json"
)

# Color output functions
function Write-Success {
    param([string]$Message)
    Write-Host "✓ $Message" -ForegroundColor Green
}

function Write-Error-Custom {
    param([string]$Message)
    Write-Host "✗ $Message" -ForegroundColor Red
}

function Write-Section {
    param([string]$Title)
    Write-Host ""
    Write-Host "=" * 60 -ForegroundColor Cyan
    Write-Host $Title -ForegroundColor Cyan
    Write-Host "=" * 60 -ForegroundColor Cyan
}

function Write-Subsection {
    param([string]$Title)
    Write-Host ""
    Write-Host "-" * 60 -ForegroundColor Gray
    Write-Host $Title -ForegroundColor Yellow
    Write-Host "-" * 60 -ForegroundColor Gray
}

# Create minimal test payload
function New-TestPayload {
    $payload = @{
        timestamp = (Get-Date).ToUniversalTime().ToString("yyyy-MM-ddTHH:mm:ssZ")
        scopeDocument = @{
            title = "Test Integration Project (PowerShell)"
            rawText = "This is a test integration project created from PowerShell"
        }
        analysis = @{
            detectedSystems = @()
            detectedProcesses = @()
            missingInformation = @(
                @{
                    item = "PowerShell Test Missing Info"
                    priority = "high"
                    category = "Testing"
                }
            )
        }
        workflows = @{}
        actionItems = @(
            @{
                title = "PowerShell Test Action Item"
                description = "This is a test action item created from PowerShell test script"
                priority = "medium"
                category = "Testing"
                dueInDays = 3
            }
        )
        metadata = @{
            systemCount = 0
            processCount = 0
            missingInfoCount = 1
            actionItemCount = 1
            source = "PowerShell Test Script"
            documentType = "IntegrationScope"
        }
    }

    return $payload
}

# Main execution
Write-Section "Power Automate Webhook Tester (PowerShell)"

# Validate webhook URL
if ($WebhookUrl -notmatch '^https?://') {
    Write-Error-Custom "Webhook URL must start with http:// or https://"
    exit 1
}

Write-Host "Webhook URL: " -NoNewline
Write-Host $WebhookUrl -ForegroundColor White

Write-Host "Timestamp: " -NoNewline
Write-Host (Get-Date -Format "yyyy-MM-dd HH:mm:ss") -ForegroundColor White

# Load or create payload
$payload = $null

if ($UseCustomPayload) {
    Write-Host "`nUsing minimal custom payload..." -ForegroundColor Yellow
    $payload = New-TestPayload
}
else {
    $payloadPath = Join-Path $PSScriptRoot $PayloadFile

    if (-not (Test-Path $payloadPath)) {
        Write-Error-Custom "Payload file not found: $payloadPath"
        Write-Host "Use -UseCustomPayload to generate a test payload instead" -ForegroundColor Yellow
        exit 1
    }

    Write-Host "`nLoading payload from: " -NoNewline
    Write-Host $PayloadFile -ForegroundColor White

    try {
        $payloadJson = Get-Content $payloadPath -Raw
        $payload = $payloadJson | ConvertFrom-Json
    }
    catch {
        Write-Error-Custom "Failed to parse JSON payload: $_"
        exit 1
    }
}

# Display payload summary
Write-Subsection "Payload Summary"

$projectTitle = $payload.scopeDocument.title
$actionItemCount = if ($payload.actionItems) { $payload.actionItems.Count } else { 0 }
$missingInfoCount = if ($payload.analysis.missingInformation) { $payload.analysis.missingInformation.Count } else { 0 }

Write-Host "Project: " -NoNewline
Write-Host $projectTitle -ForegroundColor White

Write-Host "Action Items: " -NoNewline
Write-Host $actionItemCount -ForegroundColor White

Write-Host "Missing Information: " -NoNewline
Write-Host $missingInfoCount -ForegroundColor White

# Send request
Write-Subsection "Sending Request"

try {
    $headers = @{
        "Content-Type" = "application/json"
        "User-Agent" = "Scope-Mapper-PowerShell-Tester/1.0"
    }

    $payloadJson = $payload | ConvertTo-Json -Depth 10

    Write-Host "Request size: " -NoNewline
    Write-Host "$([math]::Round($payloadJson.Length / 1KB, 2)) KB" -ForegroundColor White

    $stopwatch = [System.Diagnostics.Stopwatch]::StartNew()

    $response = Invoke-RestMethod -Uri $WebhookUrl `
        -Method Post `
        -Body $payloadJson `
        -Headers $headers `
        -TimeoutSec 60 `
        -ErrorAction Stop `
        -StatusCodeVariable statusCode

    $stopwatch.Stop()

    # Display response
    Write-Subsection "Response"

    Write-Host "Status Code: " -NoNewline
    Write-Host "$statusCode OK" -ForegroundColor Green

    Write-Host "Response Time: " -NoNewline
    Write-Host "$($stopwatch.ElapsedMilliseconds) ms" -ForegroundColor White

    Write-Success "SUCCESS - Tasks created successfully!"

    Write-Host "`nResponse Details:" -ForegroundColor Yellow
    $response | ConvertTo-Json -Depth 5 | Write-Host

    if ($response.tasksCreated) {
        Write-Host "`nTasks Created:" -ForegroundColor Yellow
        Write-Host "  Action Items: " -NoNewline
        Write-Host $response.tasksCreated.actionItems -ForegroundColor White
        Write-Host "  Missing Information: " -NoNewline
        Write-Host $response.tasksCreated.missingInformation -ForegroundColor White
    }

    Write-Section "Test Completed Successfully"
    exit 0
}
catch {
    $stopwatch.Stop()

    Write-Subsection "Response"

    $statusCode = $_.Exception.Response.StatusCode.value__

    if ($statusCode) {
        Write-Host "Status Code: " -NoNewline
        Write-Host "$statusCode " -ForegroundColor Red -NoNewline
        Write-Host $_.Exception.Response.StatusDescription -ForegroundColor Red
    }
    else {
        Write-Host "Status: " -NoNewline
        Write-Host "Connection Failed" -ForegroundColor Red
    }

    Write-Host "Response Time: " -NoNewline
    Write-Host "$($stopwatch.ElapsedMilliseconds) ms" -ForegroundColor White

    # Determine error type
    if ($statusCode -eq 400) {
        Write-Error-Custom "BAD REQUEST - Invalid payload format"
        Write-Host "`nTip: Validate your JSON structure against the expected schema" -ForegroundColor Yellow
    }
    elseif ($statusCode -eq 401 -or $statusCode -eq 403) {
        Write-Error-Custom "UNAUTHORIZED - Authentication failed"
        Write-Host "`nTip: Check your webhook URL and connection status" -ForegroundColor Yellow
    }
    elseif ($statusCode -eq 404) {
        Write-Error-Custom "NOT FOUND - Invalid webhook URL"
        Write-Host "`nTip: Verify the webhook URL is correct" -ForegroundColor Yellow
    }
    elseif ($statusCode -eq 500) {
        Write-Error-Custom "SERVER ERROR - Flow execution failed"
        Write-Host "`nTip: Check Power Automate run history for details" -ForegroundColor Yellow
    }
    elseif ($statusCode -eq 429) {
        Write-Error-Custom "TOO MANY REQUESTS - Rate limit exceeded"
        Write-Host "`nTip: Wait a few minutes and try again" -ForegroundColor Yellow
    }
    else {
        Write-Error-Custom "REQUEST FAILED"
    }

    # Display error details
    Write-Host "`nError Details:" -ForegroundColor Red
    Write-Host $_.Exception.Message

    if ($_.ErrorDetails.Message) {
        Write-Host "`nResponse Body:" -ForegroundColor Red
        try {
            $errorBody = $_.ErrorDetails.Message | ConvertFrom-Json
            $errorBody | ConvertTo-Json -Depth 5 | Write-Host
        }
        catch {
            Write-Host $_.ErrorDetails.Message
        }
    }

    Write-Section "Test Failed"
    exit 1
}
