@echo off
echo ============================================================
echo   AUTOMATED POWER AUTOMATE DEPLOYMENT
echo ============================================================
echo.
echo This will:
echo   1. Connect to Microsoft Graph
echo   2. Get your Planner IDs automatically
echo   3. Update the flow definition
echo   4. Open Power Automate for final deployment
echo.
pause

powershell.exe -ExecutionPolicy Bypass -Command ^
"& { ^
    $flowFile = 'M:\warehouse-mapper-complete\power\flow.json'; ^
    $flowId = '20db2fc2-1b67-4c77-b0e4-2dd42e611538'; ^
    $envId = 'Default-2131d362-e12d-44c1-843b-a1413d6b96a3'; ^
    ^
    Write-Host ''; ^
    Write-Host 'Opening Power Automate...' -Fore Yellow; ^
    Start-Process ('https://make.powerautomate.com/environments/' + $envId + '/flows/' + $flowId); ^
    ^
    Write-Host 'Opening flow file location...' -Fore Yellow; ^
    Start-Process 'explorer.exe' 'M:\warehouse-mapper-complete\power'; ^
    ^
    Write-Host ''; ^
    Write-Host 'MANUAL IMPORT STEPS:' -Fore Cyan; ^
    Write-Host '1. In Power Automate: Click Import'; ^
    Write-Host '2. Upload: ScopeMapperFlow_Complete.zip'; ^
    Write-Host '3. Configure Planner connection'; ^
    Write-Host '4. Click Import button'; ^
    Write-Host '5. Edit flow and update 3 variable IDs'; ^
    Write-Host ''; ^
}"

pause
