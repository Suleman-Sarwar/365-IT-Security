#Set Azure Naming Policy

Install-Module -Name AzureAD
Import-Module AzureAD
$cred=Get-Credential
Connect-AzureAD -Credential $cred

#-----------------------------------------------------------------------

###View current settings

$Setting = Get-AzureADDirectorySetting -Id (Get-AzureADDirectorySetting | where -Property DisplayName -Value "Group.Unified" -EQ).id
$Setting.Values

#-----------------------------------------------------------------------

###Create naming policy with custom blocked words

#Option 1 - Apply PrefixSuffixNamingRequirement and CustomBlockedWordsList  
$Setting["PrefixSuffixNamingRequirement"] =“Teams_[GroupName]_[Department]"
$Setting["CustomBlockedWordsList"]=“HR,IT,Marketing,Sales"
Set-AzureADDirectorySetting -Id (Get-AzureADDirectorySetting | where -Property DisplayName -Value "Group.Unified" -EQ).id -DirectorySetting $Setting

#Option 2 - Apply PrefixSuffixNamingRequirement and CustomBlockedWordsList 
$Settings[“PrefixSuffixNamingRequirement”] = "Teams-[GroupName]"
$Settings[“CustomBlockedWordsList”] = "HR,IT,Marketing,Sales,CFO,CEO,Shit,Payroll"
Set-AzureADDirectorySetting -Id $Settings.Id -DirectorySetting $Settings

#Option 3 - Apply PrefixSuffixNamingRequirement 
$Settings[“PrefixSuffixNamingRequirement”] = "Teams-[GroupName]"
Set-AzureADDirectorySetting -Id $Settings.Id -DirectorySetting $Settings

#-----------------------------------------------------------------------

#Import Custom words
$Words = (Get-AzureADDirectorySetting).Values | Where-Object -Property Name -Value CustomBlockedWordsList -EQ 
Add-Content "c:\temp\blockedwordslist.txt" -Value $words.value.Split(",").Replace("`"","")  
