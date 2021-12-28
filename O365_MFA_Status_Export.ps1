# This PowerShell script provide a quick report about the Office 365 MFA for configured and unconfigured users.
# This PowerShell required Office 365 read-only permissions
Connect-MsolService
Write-Host "Finding Azure AD Accounts"
$Users = Get-MsolUser -All | ? { $_.UserType -ne "Guest" }
$Report = [System.Collections.Generic.List[Object]]::new() # Create output file
Write-Host "Checking" $Users.Count "Azure AD Accounts"
ForEach ($User in $Users) {
    $MFAEnforced = $User.StrongAuthenticationRequirements.State
    $MFAPhone = $User.StrongAuthenticationUserDetails.PhoneNumber
    $DefaultMFAMethod = ($User.StrongAuthenticationMethods | ? { $_.IsDefault -eq "True" }).MethodType
    If (($MFAEnforced -eq "Enforced") -or ($MFAEnforced -eq "Enabled")) {
        Switch ($DefaultMFAMethod) {
            "OneWaySMS" { $MethodUsed = "One-way SMS" }
            "TwoWayVoiceMobile" { $MethodUsed = "Phone call verification" }
            "PhoneAppOTP" { $MethodUsed = "Hardware token or authenticator app" }
            "PhoneAppNotification" { $MethodUsed = "Authenticator app" }
        }
    }
    Else {
        $MFAEnforced = "Not Enabled"
        $MethodUsed = "MFA Not Used"
    }
    $ReportLine = [PSCustomObject] @{
        User        = $User.UserPrincipalName
        Name        = $User.DisplayName
        MFAUsed     = $MFAEnforced
        MFAMethod   = $MethodUsed
        PhoneNumber = $MFAPhone
    }
    $Report.Add($ReportLine)
}
Write-Host "Report is in C:\Temp\O365MFAUsers.CSV"
$Report | Select User, Name, MFAUsed, MFAMethod, PhoneNumber
$Report | Sort Name | Export-CSV -NoTypeInformation C:\Temp\O365MFAUsers.csv
