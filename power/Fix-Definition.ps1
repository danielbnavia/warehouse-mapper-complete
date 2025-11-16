# Fix-Definition.ps1 - Fix JSON formatting and BOM issues

$defPath = "M:\warehouse-mapper-complete\power\working_package\Microsoft.Flow\flows\0d53c697-da73-4aa7-8697-b31eef52d7a9\definition.json"

Write-Host "Reading and reformatting definition..." -ForegroundColor Yellow

# Read without BOM and parse
$jsonContent = Get-Content $defPath -Raw -Encoding UTF8
$jsonContent = $jsonContent.TrimStart([char]0xFEFF) # Remove BOM if present

# Parse and reformat with proper indentation
$definition = $jsonContent | ConvertFrom-Json

Write-Host "Saving with proper formatting..." -ForegroundColor Yellow

# Save with proper formatting and without BOM
$utf8NoBom = New-Object System.Text.UTF8Encoding $false
[System.IO.File]::WriteAllText($defPath, ($definition | ConvertTo-Json -Depth 100), $utf8NoBom)

Write-Host "Creating cleaned package..." -ForegroundColor Yellow

# Repackage
$packagePath = "M:\warehouse-mapper-complete\power\ScopeMapperFlow_FIXED.zip"
if (Test-Path $packagePath) { Remove-Item $packagePath -Force }

Compress-Archive -Path "M:\warehouse-mapper-complete\power\working_package\*" -DestinationPath $packagePath -Force

Write-Host "DONE - Package ready:" -ForegroundColor Green
Write-Host $packagePath -ForegroundColor Cyan
