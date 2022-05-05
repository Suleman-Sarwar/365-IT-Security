function Invoke-BadPWD{

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
            
            Write-Host "Changing password for: " $user : $password -ForegroundColor Red "[*] Failed!"}
    Else{

            Write-Host "Changing password for: " $user : $password -ForegroundColor Green "[*] Success!"}
    
}}

# Import-Module C:\Users\userid\BadPWD.ps1
Invoke-BadPWD -File wordlist.txt -user userid
