#####Change Office 365 Language

#Run the following command to configure the preferred language settings for specific user 
Set-MsolUser -UserPrincipalName eshlomo@eurekaps.com -PreferredLanguage “uen-us”

#Verify the language settings for the user account, run the following command 
Get-MsolUser -UserPrincipalName eshlomo@eurekaps.com | fl PreferredLanguage

#Change specific user to have English language in thier mailbox
Set-MailboxRegionalConfiguration -Identity eshlomo@eurekspa.com -Language "en-us" -LocalizeDefaultFolderName:$true

#Change all users to have English language in thier mailboxes
Get-mailbox -ResultSize unlimited | Set-MailboxRegionalConfiguration -Language "en-us" -LocalizeDefaultFolderName:$true

####Office 365 Preferred Language Settings for AD Synced Users

#Run the following command to configure the preferred language settings for specific user 
Set-ADUser eshlomo@eurekaps.com -Replace @{‘PreferredLanguage’=”en-us”}

#Update the preferred language attribute in a specific OU
Get-ADUser –SearchBase “OU=Test,DC=domain,DC=com” –Filter * –Properties PreferredLanguage | ForEach-Object {Set-ADUser $_.SAMAccountName –replace @{PreferredLanguage=“en-us”}}
