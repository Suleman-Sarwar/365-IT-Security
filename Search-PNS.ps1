<#
    .NOTES
        Search for Exchange Zero-Day ProxyNotShell IOCs on Folders, Logs, and WebShell.
    
    .DESCRIPTION
    	New attack campaign utilized a new 0-day RCE vulnerability on Microsoft Exchange Server
    	https://www.gteltsc.vn/blog/warning-new-attack-campaign-utilized-a-new-0day-rce-vulnerability-on-microsoft-exchange-server-12715.html 
    
    .Version Support   
	Tested on the following Exchange Version
        - Exchange 2016
        - Exchange 2019
        - Windows Server 2016 (Based on)
        - Windows Server 2019 (Based on)
     
    .EXAMPLE
        .\Search-ExchangeProxyNotShell.ps1
#>

write-host "
########################################################
 Checking for Suspicious files (looking for main files)
########################################################
"
$SuspiciousFiles = @(
"C:\PerfLogs\cm.exe",
"C:\Users\Public\ad.exe",
"C:\root\DrSDKCaller.exe",
"C:\Users\Public\all.exe",
"C:\Users\Public\dump.dll",
"C:\PerfLogs\gpg-error.exe",
"C:\Program Files\Common Files\system\ado\msado32.tlb",
"%ProgramFiles%\Microsoft\ExchangeServer\V15\FrontEnd\HttpProxy\owa\auth\xml.ashx",
"%ProgramFiles%\Microsoft\ExchangeServer\V15\FrontEnd\HttpProxy\owa\auth\errorEE.aspx",
"%ProgramFiles%\Microsoft\ExchangeServer\V15\FrontEnd\HttpProxy\owa\auth\Pxh4HG1v.ashx",
"%ProgramFiles%\Microsoft\ExchangeServer\V15\FrontEnd\HttpProxy\owa\auth\RedirSuiteServiceProxy.aspx",
"%ProgramFiles%\Microsoft\ExchangeServer\V15\FrontEnd\HttpProxy\owa\auth\RedirSuiteServiceProxy.aspx",
)

foreach ($SuspiciousFile in $SuspiciousFiles) {
	if (test-path $SuspiciousFile) {
		write-host "Suspicious File $SuspiciousFile found!" -foregroundcolor red
	}
	else {
		write-host "Suspicious File $SuspiciousFile not found!" -foregroundcolor green
	}
}

write-host "
################################
 Checking for IOC's in IIS Logs
################################
"
Import-Module WebAdministration
$IISLogdir = (get-item "IIS:\Sites\Default Web Site").logfile.directory
if ($IISLogdir -match "%SystemDrive%") {
	$IISLogdir = $IISLogdir.replace("%SystemDrive%","c:")
}
$IOCs = Get-ChildItem -Recurse -Path $IISLogdir -Filter "*.log" | Select-String -Pattern 'powershell.*autodiscover\.json.*\@.*200'
if ($IOCs) {
	write-host "IOC powershell.*autodiscover\.json.*\@.*200 found in IIS Logs" -foregroundcolor red
}
else {
	write-host "IOC powershell.*autodiscover\.json.*\@.*200 not found in IIS Logs" -foregroundcolor green
}
write-host "

########################
 Checking for WebShells
########################
"
$Webshell1 = [PSCustomObject]@{
	ID = 1
    Name = "FrontEnd\HttpProxy\owa\auth\pxh4HG1v.ashx"
    Hash = "c838e77afe750d713e67ffeb4ec1b82ee9066cbe21f11181fd34429f70831ec1"
}
$Webshell2 = [PSCustomObject]@{
	ID = 2
    Name = "FrontEnd\HttpProxy\owa\auth\RedirSuiteServiceProxy.aspx"
    Hash = "65a002fe655dc1751add167cf00adf284c080ab2e97cd386881518d3a31d27f5"
}
$Webshell3 = [PSCustomObject]@{
	ID = 3
    Name = "FrontEnd\HttpProxy\owa\auth\RedirSuiteServiceProxy.aspx"
    Hash = "b5038f1912e7253c7747d2f0fa5310ee8319288f818392298fd92009926268ca"
}
$Webshell4 = [PSCustomObject]@{
	ID = 4
    Name = "FrontEnd\HttpProxy\owa\auth\errorEE.aspx"
    Hash = "be07bd9310d7a487ca2f49bcdaafb9513c0c8f99921fdf79a05eaba25b52d257"
}
$Webshell5 = [PSCustomObject]@{
	ID = 5
    Name = "C:\Program Files\Microsoft\Exchange Server\V15\FrontEnd\HttpProxy\owa\auth\pxh4HG1v.ashx"
    Hash = "c838e77afe750d713e67ffeb4ec1b82ee9066cbe21f11181fd34429f70831ec1"
}

[System.Collections.ArrayList]$WebShellArray = @()
$WebShellArray.Add($Webshell1) | out-null
$WebShellArray.Add($Webshell2) | out-null
$WebShellArray.Add($Webshell3) | out-null
$WebShellArray.Add($Webshell4) | out-null

foreach ($WebShell in $WebShellArray) {
	$WebshellPath = "$exinstall" + $WebShell.Name
	if (test-path $WebshellPath) {
		$FileHash = (Get-FileHash $WebshellPath).Hash.ToLower()
		if ($Webshell.Hash -eq $FileHash) {
			write-host "WebShell File $WebshellPath found!" -foregroundcolor red
		}
		else {
			write-host "WebShell File $WebshellPath not found!" -foregroundcolor green
		}
	}
	else {
		write-host "WebShell File $WebshellPath not found!" -foregroundcolor green
	}
}
