# Simple-Update.ps1 - Directly update the flow definition

$defPath = "M:\warehouse-mapper-complete\power\working_package\Microsoft.Flow\flows\0d53c697-da73-4aa7-8697-b31eef52d7a9\definition.json"
$flowPath = "M:\warehouse-mapper-complete\power\flow.json"

Write-Host "Loading files..." -ForegroundColor Yellow

# Load both files
$exported = Get-Content $defPath -Raw | ConvertFrom-Json
$complete = Get-Content $flowPath -Raw | ConvertFrom-Json

Write-Host "Updating actions and triggers..." -ForegroundColor Yellow

# Replace actions and triggers
$exported.properties.definition.actions = $complete.properties.definition.actions
$exported.properties.definition.triggers = $complete.properties.definition.triggers

Write-Host "Saving updated definition..." -ForegroundColor Yellow

# Save
$exported | ConvertTo-Json -Depth 100 -Compress | Set-Content $defPath -Encoding UTF8

Write-Host "Creating updated package..." -ForegroundColor Yellow

# Package it
$packagePath = "M:\warehouse-mapper-complete\power\ScopeMapperFlow_UPDATED.zip"
if (Test-Path $packagePath) { Remove-Item $packagePath -Force }

Compress-Archive -Path "M:\warehouse-mapper-complete\power\working_package\*" -DestinationPath $packagePath -Force

Write-Host "DONE - Package ready at:" -ForegroundColor Green
Write-Host $packagePath -ForegroundColor Cyan
