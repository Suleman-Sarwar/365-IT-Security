# --------------------------------------------------
# Purpose: Account connection strings and Regenerate a key
# --------------------------------------------------


# --------------------------------------------------
# Purpose: Login to Azure
# --------------------------------------------------
# $User = "admin@domain.onmicrosoft.com"
# $PWord = ConvertTo-SecureString -String "<Password>" -AsPlainText -Force
# $tenant = "tenant id"
# $subscription = "subscription id"
# $Credential = New-Object -TypeName "System.Management.Automation.PSCredential" -ArgumentList $User,$PWord
# Connect-AzAccount -Credential $Credential -Tenant $tenant -Subscription $subscription
# --------------------------------------------------

# --------------------------------------------------
# Reference: Az.CosmosDB | https://docs.microsoft.com/powershell/module/az.cosmosdb
# --------------------------------------------------
Install-Module Az.CosmosDB -AllowClobber -Confirm:$False -Force  

Connect-AzAccount # Optional and not required if Login to Azure is configured

# --------------------------------------------------
# Purpose Connect to Azure Cosmos DB
# --------------------------------------------------
$resourceGroupName = "M5" # Resource Group must already exist
$accountName = "acdb-1" # Must be all lower case
$keyKind = "primary" # Other key kinds: secondary, primaryReadOnly, secondaryReadOnly

# --------------------------------------------------
# Reset Azure Cosmos DB Keys - Reset All Keys!!!
# --------------------------------------------------
Write-Host "List connection strings"
Get-AzCosmosDBAccountKey -ResourceGroupName $resourceGroupName `
    -Name $accountName -Type "ConnectionStrings"
Write-Host "List keys"
Get-AzCosmosDBAccountKey -ResourceGroupName $resourceGroupName `
    -Name $accountName -Type "Keys"
Write-Host "Reset key"
New-AzCosmosDBAccountKey  -ResourceGroupName $resourceGroupName `
    -Name $accountName -KeyKind $keyKind
