# Install Microsoft Teams Client
.\Install-MicrosoftTeams.ps1 -source '\\storage\Microsoft\Teams'

# Install Microsoft Teams Client 32bit
.\Install-MicrosoftTeams.ps1 -source '\\storage\Microsoft\Teams' -Version 'x86'

# Uninstall Microsoft Teams Client
.\Install-MicrosoftTeams.ps1 -uninstall $true
