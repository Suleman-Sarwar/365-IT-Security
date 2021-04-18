#Import and Install Module
Import-Module SkypeOnlineConnector
Install-Module MicrosoftTeams 
Import-Module MicrosoftTeams

#Connect Teams and Skype for Business
$creds=Get-Credential

$session=New-CsOnlineSession -Credential $creds -OverrideAdminDomain elishlomo365.onmicrosoft.com
Import-PSSession $session -AllowClobber
Connect-MicrosoftTeams -Credential $creds

#Create Online PSTN Gateway
New-CsOnlinePSTNGateway -Fqdn sbc.elishlomo.com -SipSignallingPort 5061 -MaxConcurrentSessions 10 -ForwardCallHistory $true -Enabled $true

#Create an empty PSTN Usage
Set-CsOnlinePstnUsage -Identity Global -Usage @{Add="ILPSTNGateway"}

#Create Voice Routes and Associate with PSTN Usage
New-CsOnlineVoiceRoute -Identity "ILVoiceRoute" -NumberPattern "^+972$" -OnlinePstnGatewayList sbc.elishlomo365.com -Priority 1 -OnlinePstnUsages "ILPSTNGateway"

#Create Voice Routing Policy
New-CsOnlineVoiceRoutingPolicy "ILVoiceRoutingPolicy" -OnlinePstnUsages "ILPSTNGateway"

#Check User
Get-CsOnlineUser -Identity "tteams" | fl RegistrarPool

#Enable Telephony Features and Configure Phone Number
Set-CsUser -Identity TeamsUpgradePolicy -EnterpriseVoiceEnabled $true -HostedVoiceMail $true -OnPremLineURI tel:+391234123

#Configure Voice Routing
Grant-CsOnlineVoiceRoutingPolicy -Identity "eli@elishlomo365.com" -PolicyName ILVoiceRoutingPolicy

#Check User Settings
Get-CsOnlineUser -Identity "eli@elishlomo365.com" | fl -Property FirstName, LastName, EnterpriseVoiceEnabled, HostedVoiceMail, LineURI, UsageLocation, UserPrincipalName, WindowsEmailAddress, SipAddress, OnPremLineURI, OnlineVoiceRoutingPolicy, TeamsCallingPolicy, RegistrarPool, TeamsInteropPolicy, TeamsUpgradePolicy

#Set Teams as preferred calling client
Grant-CsTeamsInteropPolicy -PolicyName Tag:DisallowOverrideCallingDefaultChatDefault -Identity eli@elishlomo365.com

#Set TeamsUpgradePolicy
Grant-CsTeamsUpgradePolicy -PolicyName Islands -Identity eli@elishlomo365.com

#Set TeamsCallingPolicy

Grant-CsTeamsCallingPolicy -PolicyName Tag:AllowCalling -Identity eli@elishlomo365.com

#-------------------------------------------------------------------------------------------------------------------------------------------------

#Check Settings

Get-CsOnlinePSTNGateway
Get-CsOnlinePstnUsage
Get-CsOnlineVoiceRoutingPolicy
Get-CsTenantDialPlan
Get-CsOnlineVoiceRoute
Get-CsTeamsCallingPolicy
Get-CsTeamsInteropPolicy 
