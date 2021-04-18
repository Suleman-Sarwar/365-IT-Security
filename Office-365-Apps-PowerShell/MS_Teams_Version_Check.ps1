
function get-MSTeams {
# you must specify a save path:
    [string]$Destinationpath = '\\srv\Content\Applications\Microsoft\Teams'
    [string]$filename = 'Teams_windows_x64.exe'
    $checksite = Invoke-WebRequest https://chocolatey.org/packages/microsoft-teams
    $getversion = ($checksite.AllElements | where {$_.title -like 'Latest Version'} | select Outertext).outertext
    $getversion -match '\d+\.\d+\.\d+\.\d+'
    $version = $Matches[0]
    $downloadUri = "https://statics.teams.microsoft.com/production-windows-x64/$($version)/$($filename)"
   
    if (Test-Path "$Destinationpath\$version\$FileName") {
        Write-Host 'Update is not required' -ForegroundColor Green -BackgroundColor Black       
    }
    else {
        try {
            mkdir "$Destinationpath\$version"
            Invoke-WebRequest -Uri $downloadUri -OutFile "$Destinationpath\$version\$filename" -ErrorAction Stop
            Write-Warning "Downloading new version MS-Teams $version"
        }
        catch {
            $error[0].exception
        }
    }
# in this function you need specify your SMTP server,  specify sender, And the recipients
   
    function Send-Email-anonymously_MS-Teams ($version) {
       
        $User = "anonymous"
        $PWord = ConvertTo-SecureString –String "anonymous" –AsPlainText -Force
        $Creds = New-Object –TypeName System.Management.Automation.PSCredential –ArgumentList $user, $pword
        # Specify recipients
        Send-MailMessage -To user@domain.com `
        #Specify Sender
            -From SoftwareCheck@domain.com `
            -Subject "Found new version MS-Teams"`
            -Body "Version: $version `nOriginal link: $downloadUri `nDownloaded in: $destinatiopath" `
            #Specify SMTP server
            -SmtpServer "mail.domain.com" `
            -Credential $Creds `
            -Encoding Default
    }
    Send-Email-anonymously_MS-Teams
}
get-MSTeams
