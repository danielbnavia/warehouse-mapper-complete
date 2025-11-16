# Update-FlowPackage.ps1
# Updates the exported flow package with our complete flow definition

param(
    [string]$WorkingDir = "M:\warehouse-mapper-complete\power\working_package",
    [string]$CompleteFlowPath = "M:\warehouse-mapper-complete\power\flow.json"
)

$ErrorActionPreference = "Stop"

Write-Host "=" * 70 -ForegroundColor Cyan
Write-Host "Updating Flow Package with Complete Definition" -ForegroundColor Cyan
Write-Host "=" * 70 -ForegroundColor Cyan

# Step 1: Load our complete flow
Write-Host "`n[1/4] Loading complete flow definition..." -ForegroundColor Yellow
$completeFlow = Get-Content $CompleteFlowPath -Raw -Encoding UTF8 | ConvertFrom-Json
$completeDefinition = $completeFlow.properties.definition

Write-Host "✓ Loaded complete flow with $($completeDefinition.actions.Count) actions" -ForegroundColor Green

# Step 2: Load the exported definition
$defPath = Join-Path $WorkingDir "Microsoft.Flow\flows\0d53c697-da73-4aa7-8697-b31eef52d7a9\definition.json"
Write-Host "`n[2/4] Loading exported definition..." -ForegroundColor Yellow
$exportedDef = Get-Content $defPath -Raw -Encoding UTF8 | ConvertFrom-Json

Write-Host "✓ Loaded exported definition" -ForegroundColor Green

# Step 3: Merge - keep exported metadata but use our complete actions/triggers
Write-Host "`n[3/4] Merging definitions..." -ForegroundColor Yellow

# Keep the exported properties we need
$flowId = $exportedDef.id
$flowName = $exportedDef.name
$flowType = $exportedDef.type
$apiId = $exportedDef.properties.apiId
$displayName = "Scope Mapper - Create Planner Tasks from Webhook"
$metadata = $exportedDef.properties.definition.metadata
$connections = $exportedDef.properties.connectionReferences

# Replace the definition with our complete one
$exportedDef.properties.definition = $completeDefinition

# Restore important metadata
$exportedDef.properties.definition.metadata = $metadata
$exportedDef.properties.apiId = $apiId
$exportedDef.properties.displayName = $displayName

# Preserve connection references
$exportedDef.properties.connectionReferences = $connections

Write-Host "✓ Definitions merged successfully" -ForegroundColor Green
Write-Host "  - Flow ID: $flowId" -ForegroundColor Gray
Write-Host "  - Actions: $($completeDefinition.actions.Count)" -ForegroundColor Gray
Write-Host "  - Triggers: $($completeDefinition.triggers.Count)" -ForegroundColor Gray

# Step 4: Save updated definition
Write-Host "`n[4/4] Saving updated definition..." -ForegroundColor Yellow
$exportedDef | ConvertTo-Json -Depth 100 | Set-Content $defPath -Encoding UTF8

Write-Host "✓ Definition saved!" -ForegroundColor Green

# Create the updated package
Write-Host "`n[BONUS] Creating updated package..." -ForegroundColor Yellow
$packagePath = "M:\warehouse-mapper-complete\power\ScopeMapperFlow_UPDATED.zip"

if (Test-Path $packagePath) {
    Remove-Item $packagePath -Force
}

$filesToZip = Get-ChildItem $WorkingDir -Recurse
Compress-Archive -Path "$WorkingDir\*" -DestinationPath $packagePath -Force

Write-Host "Updated package created" -ForegroundColor Green
Write-Host "Location: $packagePath" -ForegroundColor Cyan

Write-Host ""
Write-Host "COMPLETE - Package Ready to Import" -ForegroundColor Green

Write-Host "`nNext Steps:" -ForegroundColor Yellow
Write-Host "1. Go to Power Automate" -ForegroundColor White
Write-Host "2. Click Import then Import Package Legacy" -ForegroundColor White
Write-Host "3. Upload ScopeMapperFlow_UPDATED.zip" -ForegroundColor White
Write-Host "4. Configure Planner connection" -ForegroundColor White
Write-Host "5. Click Import button" -ForegroundColor White
