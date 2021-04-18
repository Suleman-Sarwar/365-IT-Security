# Set Azure Naming Policy with specific settings

## Install Modules & Connect to Azure AD

Set-ExecutionPolicy Bypass -Scope CurrentUser
Install-Module -Name AzureADPreview -Force -AllowClobber
Import-Module AzureADPreview
$cred=Get-Credential
Connect-AzureAD -Credential $cred

#-----------------------------------------------------------------------

## View Current settings

Get-AzureADDirectorySetting 
Get-AzureADDirectorySetting | ForEach-Object Values
Get-AzureADDirectorySettingTemplate | ? {$_.DisplayName -eq "Group.Unified"} | fl

#-----------------------------------------------------------------------

# Create settings at the directory level > in specific senarion when Active Directory settings groups isn't available

Get-AzureADDirectorySettingTemplate
$TemplateId = (Get-AzureADDirectorySettingTemplate | Where-Object { $_.DisplayName -eq "Group.Unified" }).Id
$Template = Get-AzureADDirectorySettingTemplate -Id $TemplateId
$Setting = $Template.CreateDirectorySetting()
New-AzureADDirectorySetting -DirectorySetting $Setting
$Setting.Values

#-----------------------------------------------------------------------

## Create Office 365 Group with Naming Policy based with few options

### Option - Apply PrefixSuffixNamingRequirement and CustomBlockedWordsList  

$Setting["PrefixSuffixNamingRequirement"] =“Teams_[GroupName]_[Department]"
$Setting["CustomBlockedWordsList"]=“HR,IT,Marketing,Sales"
Set-AzureADDirectorySetting -Id (Get-AzureADDirectorySetting | Where-Object -Property DisplayName -Value "Group.Unified" -EQ).id -DirectorySetting $Setting

### Option - Apply PrefixSuffixNamingRequirement and CustomBlockedWordsList 

$Settings[“PrefixSuffixNamingRequirement”] = "Teams-[GroupName]"
$Settings[“CustomBlockedWordsList”] = "HR,IT,CEO"
Set-AzureADDirectorySetting -Id $Settings.Id -DirectorySetting $Settings

### Option - Apply PrefixSuffixNamingRequirement 

$Settings[“PrefixSuffixNamingRequirement”] = "Teams-[GroupName]"
Set-AzureADDirectorySetting -Id $Settings.Id -DirectorySetting $Settings

### Option > Use values for the blocked words

$settings = Get-AzureADDirectorySetting | where-object {$_.displayname -eq “Group.Unified”}
$settings["CustomBlockedWordsList"] = "HR"
Set-AzureADDirectorySetting -Id $settings.Id -DirectorySetting $settings

#-----------------------------------------------------------------------

#Import Custom words

$Words = (Get-AzureADDirectorySetting).Values | Where-Object -Property Name -Value CustomBlockedWordsList -EQ 
Add-Content "c:\temp\blockedwordslist.txt" -Value $words.value.Split(",").Replace("`"","")  

#-----------------------------------------------------------------------------------------------------------------