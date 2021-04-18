#Reviewing OAuth Permissions in Azure AD
Get-AzureADServicePrincipal -Filter "serviceprincipaltype eq 'Application'" -All $true -PipelineVariable sp | Get-AzureADServicePrincipalOAuth2PermissionGrant -top 1 | select @{N = "SPDisplayname"; E = { $sp.displayname } }, @{N = "SPObjectid"; E = { $sp.objectid } }, consenttype, scope
