# Merge-FlowDefinition.ps1
# Merges our complete flow definition into the exported package

$ErrorActionPreference = "Stop"

Write-Host "Merging flow definitions..." -ForegroundColor Yellow

# Read our complete flow
$ourFlowPath = "M:\warehouse-mapper-complete\power\flow.json"
$ourFlow = Get-Content $ourFlowPath -Raw | ConvertFrom-Json

# Read the exported definition
$exportedDefPath = "M:\warehouse-mapper-complete\power\temp_check\Microsoft.Flow\flows\0d53c697-da73-4aa7-8697-b31eef52d7a9\definition.json"
$exportedDef = Get-Content $exportedDefPath -Raw | ConvertFrom-Json

# Replace the definition section with ours
$exportedDef.properties.definition = $ourFlow.properties.definition

# Keep the existing connection references
Write-Host "Preserving connection references..." -ForegroundColor Cyan

# Save the merged definition
$exportedDef | ConvertTo-Json -Depth 100 | Set-Content $exportedDefPath -Encoding UTF8

Write-Host "✓ Flow definition merged successfully!" -ForegroundColor Green

# Now repackage it
Write-Host "`nRepackaging..." -ForegroundColor Yellow

$packageSource = "M:\warehouse-mapper-complete\power\temp_check\*"
$packageDest = "M:\warehouse-mapper-complete\power\ScopeMapperFlow_Updated.zip"

# Remove old package if exists
if (Test-Path $packageDest) {
    Remove-Item $packageDest -Force
}

# Create new package
Compress-Archive -Path $packageSource -DestinationPath $packageDest -Force

Write-Host "✓ Package created: ScopeMapperFlow_Updated.zip" -ForegroundColor Green
Write-Host "`nYou can now import this package in Power Automate!" -ForegroundColor Cyan
