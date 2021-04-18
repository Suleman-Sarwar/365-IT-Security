#Get Credential
$creds=Get-Credential

#Connect MSOnline
Connect-MsolService -Credential $creds

Install-Module AzureAD
$creds=Get-Credential
Connect-AzureAD -Credential $creds


#Install AADRM Module
Install-Module AADRM 

#Connect AADRM
Connect-AadrmService -Credential $creds

#Check AADRM Logs
Get-AadrmUserLog
Get-AadrmAdminLog

Get-AadrmUsageLogFeature

Enable-AadrmUsageLogFeature  

Get-AadrmConfiguration



Get-AadrmUserLog -Path E:\Logs -fordate 2/1/2016

