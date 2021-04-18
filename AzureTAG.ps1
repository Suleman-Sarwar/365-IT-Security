# Configure Azure TAG for specific Resources with Azure PowerShell (Az module cmdlets)

## Login to Azure and Subscription Selection  
Login-AzAccount
Get-AzSubscription 
Select-AzSubscription -Subscription "62670aff-1ba3-4ffd-98d6-807c6049c506"

Get-AzResourceGroup

## Check existing Azure TAG 
Get-AzTag
(Get-AzResource -ResourceGroupName "LAB").Tags

## Set Azure TAG to a Resource Groups

$resourceGroupName = "LAB"
$azureRGInfo = Get-AzResourceGroup -Name $resourceGroupName
Set-AzResourceGroup -Id $azureRGInfo.ResourceId -Tag @{ENV = "LAB"; Owner = "Elli Shlomo"; BusinessProcess = "CloudOPS_LAB" } 

## Set Tags to All a Resources within a Resource Group (RG Inherited)
$resourceGroupName = "LAB"
$azureRGInfo = Get-AzResourceGroup -Name $resourceGroupName
foreach ($item in $azureRGInfo) {
    Get-AzResource  -ResourceGroupName $item.ResourceGroupName | ForEach-Object { Set-AzResource  -ResourceId $PSItem.ResourceId -Tag $item.Tags -Force } 
}

## Remove Azure TAG from Azure resource
Set-AzResourceGroup -Name LAB `
                    -Tag @{}
               -Force

