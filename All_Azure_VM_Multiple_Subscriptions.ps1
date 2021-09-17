# Report for all VM status along with OS Type, OS Version, VM Name, RG Name
# Define Variables($Subscription) to collect subscription details and $
--------------------------------------------------------------------------------------------------------
$Subscriptions = Get-AzureRmSubscription | Where-Object { $_.Name -in ("SUB1", "SUB2") }
$Report = ForEach ($Subscription in $Subscriptions) {
     $SubscriptionName = $Subscription.Name
     Set-AzureRmContext -SubscriptionName "$SubscriptionName" | Out-Null
     $RGs = Get-AzureRMResourceGroup
     foreach ($RG in $RGs) {
         $VMs = Get-AzureRmVM -ResourceGroupName $RG.ResourceGroupName
         foreach ($VM in $VMs) {
             # VM Status (running/deallocated/stopped)
             $VMDetail = Get-AzureRmVM -ResourceGroupName $RG.ResourceGroupName -Name $VM.Name -Status
             $VMStatusDetail = $VMDetail.Statuses.DisplayStatus -match "^VM .*$"
             New-Object psobject -Property @{
                 "SubscriptionName" = $SubscriptionName
                 "VMName"           = $VM.Name
                 "VMStatus"         = "$VMStatusDetail"
                 "OSType"           = $VM.StorageProfile.OSDisk.OSType
                 "OSVersion"        = $Vm.StorageProfile.ImageReference.Sku
                 "ResourceGroup"    = $RG.ResourceGroupName                 
               }
          }
     }
 }
## End Subscription
## Pull the $Report variable to get all details and save in csv format.
$Report | Export-Csv "c:\temp\Azure_VMs_Status.csv" -Force -NoTypeInformation
