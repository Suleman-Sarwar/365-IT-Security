#Microsoft Teams Client customization settings via PowerShell

#Set Source file - desktop-config
$SourceConfigFile = "$env:userprofile\\AppData\Roaming\Microsoft\Teams\desktop-config.json"

#Read settings from desktop-config file
$Teams = (Get-Content -Path $SourceConfigFile | ConvertFrom-Json)

#Check current configuration
Get-Content -Path $SourceDesktopConfigFile | ConvertFrom-Json

#Set Desktop Teams Configuration
$Teams.appPreferenceSettings.openAsHidden = $true
$Teams.appPreferenceSettings.openAtLogin = $true
$Teams.appPreferenceSettings.registerAsIMProvider = $true
$Teams.notificationWindowOnClose = $true
$Teams.theme = "default"
$Teams.appPreferenceSettings.runningOnClose = $true

#Overwrite desktop-config file
$Teams | ConvertTo-Json -Compress | Set-Content -Path $SourceConfigFile -Force

#Write Verbose 
Write-verbose $Teams.appPreferenceSettings.openAsHidden
Write-verbose $Teams.appPreferenceSettings.openAtLogin
Write-verbose $Teams.appPreferenceSettings.registerAsIMProvider
Write-verbose $Teams.notificationWindowOnClose
