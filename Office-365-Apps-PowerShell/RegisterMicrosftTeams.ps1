# IMProvider Registry Path
$IMProviderPath = "HKCU:\Software\IM Providers"

# Retrieve Current IMProvider Information
$imProvider = Get-ItemProperty -Path $IMProviderPath

# Check if user UnRegister Microsoft Teams Chat Office
if ($imProvider.DefaultIMApp) {
 
    # Build Path and Values for Microsoft Teams
    $TeamsPath = Join-Path -Path $IMProviderPath -ChildPath "Teams"

    # Check existing Microsoft Teams IMProvider path and values
    if (Test-Path $TeamsPath) {
        Write-Host "$TeamsPath already exists, no action needed..."
    }
    else {
        Write-Warning "$TeamsPath does not exist, creating..."
        New-Item -Path $IMProviderPath -Name "Teams"
    }

    # Microsoft Teams Path and Values Created
    if (Test-Path $TeamsPath) {
        Set-ItemProperty -Path $TeamsPath PreviousDefaultIMApp -Value $imProvider.DefaultIMApp -Type String
    }
    else {
        Write-Warning "Unable to create value for $TeamsPath"
    }
}
# Set Microsoft Teams as Register Teams as the chat app for Office 
Set-ItemProperty -Path $imProviderPath -Name "DefaultIMApp" -Value "Teams"
