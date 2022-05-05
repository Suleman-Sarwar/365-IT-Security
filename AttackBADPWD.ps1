#This script intends to check Azure AD Password Protection for weak passwords. 
#Make sure you run this in an elevated administrative PowerShell session. RSAT tools and password reset capability is required.
#This script can be run against a list. 
# >>> First, test the script in a lab environment, and run it carefully on a test user!!!!!

function Invoke-AttackBADPWD{

    param (
        [Parameter(Mandatory=$true)]
        [string]$File,
        [string]$user
    )
    
    if (!$File) {Write-Host "Invalid file path..."; break}

    $Passwords = Get-Content $File
    $Error = $false
    
     ForEach ($Password in $Passwords){
     
     Set-ADAccountPassword -Identity $user -Reset -NewPassword (ConvertTo-SecureString -AsPlainText $Password -Force) -ErrorAction SilentlyContinue -ErrorVariable ProcessError;
     
     If ($ProcessError)
        {
            
            Write-Host "Change Password for: " $user : $password -ForegroundColor Red "[*] Failed!"}
    Else{

            Write-Host "Change password for: " $user : $password -ForegroundColor Green "[*] Success!"}
    }}

Import-Module C:\temp\AttackBADPWD.ps1 -Verbose
Invoke-AttackBADPWD -File C:\temp\list.txt -user "elli@domain.com" -Verbose
