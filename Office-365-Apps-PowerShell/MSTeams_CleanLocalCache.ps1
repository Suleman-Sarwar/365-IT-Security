# Delete Microsoft Teams Cache files from local pc

$challenge = Read-Host "This PowerShell Script will delete Microsoft Teams local cache, do you want to delete this files (Y/N)?"
$challenge = $challenge.ToUpper()
if ($challenge -eq "N"){
Stop-Process -Id $PID
}elseif ($challenge -eq "Y"){
Write-Host "Stopping Microsoft Teams Process" -ForegroundColor Red
try{
Get-Process -ProcessName Teams | Stop-Process -Force
Start-Sleep -Seconds 3
Write-Host "Teams Process Sucessfully Stopped" -ForegroundColor Green
}catch{
echo $_
}
Write-Host "Clearing Microsoft Teams Local Cache Files" -ForegroundColor Red
try{
Get-ChildItem -Path $env:APPDATA\"Microsoft\teams\application cache\cache" | Remove-Item -Confirm:$false
Get-ChildItem -Path $env:APPDATA\"Microsoft\teams\blob_storage" | Remove-Item -Confirm:$false
Get-ChildItem -Path $env:APPDATA\"Microsoft\teams\databases" | Remove-Item -Confirm:$false
Get-ChildItem -Path $env:APPDATA\"Microsoft\teams\cache" | Remove-Item -Confirm:$false
Get-ChildItem -Path $env:APPDATA\"Microsoft\teams\gpucache" | Remove-Item -Confirm:$false
Get-ChildItem -Path $env:APPDATA\"Microsoft\teams\Indexeddb" | Remove-Item -Confirm:$false
Get-ChildItem -Path $env:APPDATA\"Microsoft\teams\Local Storage" | Remove-Item -Confirm:$false
Get-ChildItem -Path $env:APPDATA\"Microsoft\teams\tmp" | Remove-Item -Confirm:$false

Write-Host "Teams Disk Cache Cleaned" -ForegroundColor Green
}catch{
echo $_
}

Write-Host "Stopping Chrome Process" -ForegroundColor Red
try{
Get-Process -ProcessName Chrome| Stop-Process -Force
Start-Sleep -Seconds 3

Write-Host "Chrome Browser Sucessfully Stopped" -ForegroundColor Green
}catch{
echo $_
}

Write-Host "Clearing Chrome Cache" -ForegroundColor Red
try{
Get-ChildItem -Path $env:LOCALAPPDATA"\Google\Chrome\User Data\Default\Cache" | Remove-Item -Confirm:$false
Get-ChildItem -Path $env:LOCALAPPDATA"\Google\Chrome\User Data\Default\Cookies" -File | Remove-Item -Confirm:$false
Get-ChildItem -Path $env:LOCALAPPDATA"\Google\Chrome\User Data\Default\Web Data" -File | Remove-Item -Confirm:$false
Write-Host "Microsft Teams Cache from Chrome Cleaned" -ForegroundColor Green
}catch{
echo $_
}
Write-Host "Stopping IE & Edge Process" -ForegroundColor Red
try{
Get-Process -ProcessName MicrosoftEdge | Stop-Process -Force
Get-Process -ProcessName IExplore | Stop-Process -Force
Write-Host "Internet Explorer and Edge Processes Sucessfully Stopped" -ForegroundColor Green
}catch{
echo $_
}
Write-Host "Clearing IE and Edge Cache" -ForegroundColor Yellow
try{
RunDll32.exe InetCpl.cpl, ClearMyTracksByProcess 8
RunDll32.exe InetCpl.cpl, ClearMyTracksByProcess 2
Write-Host "IE and Edge Cleaned" -ForegroundColor Green
}catch{
echo $_
}
Write-Host "Microsoft Teams Cleanup Completed. Now Launching Microsft Teams" -ForegroundColor Green
Start-Process -FilePath $env:LOCALAPPDATA\Microsoft\Teams\current\Teams.exe
Stop-Process -Id $PID
}else{
Stop-Process -Id $PID
}
