# Check if Software is installed already in registry.
$CheckADCReg = Get-ItemProperty HKLM:\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall\* | where {$_.DisplayName -like "Adobe Acrobat Reader DC*"}
# If Adobe Reader is not installed continue with script. If it's istalled already script will exit.
If ($CheckADCReg -eq $null) {

# Path for the temporary downloadfolder. Script will run as system so no issues here
$Installdir = "C:\Intune\install_adobe"
New-Item -Path $Installdir  -ItemType directory

# Download the installer from the Adobe website. Always check for new versions!!
$source = "ftp://ftp.adobe.com/pub/adobe/reader/win/AcrobatDC/1800920044/AcroRdrDC1800920044_es_ES.exe"
$destination = "$Installdir\AcroRdrDC1800920044_es_ES.exe"
Invoke-WebRequest $source -OutFile $destination

# Start the installation when download is finished
Start-Process -FilePath "$Installdir\AcroRdrDC1800920044_en_US.exe" -ArgumentList "/sAll /rs /rps /msi /norestart /quiet EULA_ACCEPT=YES"

# Wait for the installation to finish. Test the installation and time it yourself. I've set it to 240 seconds.
Start-Sleep -s 240

# Finish by cleaning up the download. I choose to leave C:\Intune\ for future installations.
rm -Force $Installdir\AcroRdrDC*
}
#--------------------------------------------------------------------------------------------------------------------------------