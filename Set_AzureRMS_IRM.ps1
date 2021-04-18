##### Enable and Configure RMS including set Message Encryption for Office 365 #####

### Connect to AADRM Service
Get-Command -Module aadrm
Install-Module AADRM -Force
$cred = Get-Credential
Connect-AadrmService -Credential $cred

### Connect Exchange Online PowerShell ###
$cred = Get-Credential
$session = New-PSSession -ConfigurationName Microsoft.Exchange -ConnectionUri https://outlook.office365.com/powershell-liveid/ -Credential $cred -Authentication Basic -AllowRedirection
Import-PSSession $session

### Check and Activate AADRM Service ###
Get-AadrmConfiguration

###Collect configuration information needed for message encryption
$rmsConfig = Get-AadrmConfiguration
$licenseUri = $rmsConfig.LicensingIntranetDistributionPointUrl

### Collect IRM configuration for Office 365 
$irmConfig = Get-IRMConfiguration
$list = $irmConfig.LicensingLocation
if (!$list) { $list = @() }
if (!$list.Contains($licenseUri)) { $list += $licenseUri }

### Enable message encryption for Office 365
Set-IRMConfiguration -LicensingLocation $list
Set-IRMConfiguration -AzureRMSLicensingEnabled $true -InternalLicensingEnabled $true

### Enable the Protect button in Outlook on the web (Optional)
Set-IRMConfiguration -SimplifiedClientAccessEnabled $true

### Enable server decryption for Outlook on the web, Outlook for iOS, and Outlook for Android
Set-IRMConfiguration -ClientAccessServerEnabled $true

Test-IRMConfiguration -Sender "eshlomo9@gmail.com"