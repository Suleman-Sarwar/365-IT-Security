### Enable and configure Azure JIT for VMs
$JitPolicy = (@{ id="/subscriptions/SUBSCRIPTIONID/resourceGroups/RESOURCEGROUP/providers/Microsoft.Compute/virtualMachines/VMNAME"
ports=(@{
     number=22; ## SSH
     protocol="*"; ## All Protocols
     allowedSourceAddressPrefix=@("*"); ## Source IP
     maxRequestAccessDuration="PT3H"}, ## Three hours mode
     @{
     number=3389;
     protocol="*";
     allowedSourceAddressPrefix=@("*");
     maxRequestAccessDuration="PT3H"})})
$JitPolicyArr=@($JitPolicy)

## Send the policy to Azure and commit it to the VM
# Option 1
Set-AzJitNetworkAccessPolicy -Kind "Basic" -Location "LOCATION" -Name VMNAME -ResourceGroupName "RESOURCEGROUP" -VirtualMachine $JitPolicyArr

# Option 2
# Set-AzJitNetworkAccessPolicy -Kind "Basic" -Location "LOCATION" -Name "$vms" -ResourceGroupName "RESOURCEGROUP" -VirtualMachine $JitPolicyArr

# Option 3
# $vms=Get-AzureRmVM -ResourceGroupName "ResourceGroup" # Choose the RG VMs
# Set-AzJitNetworkAccessPolicy -Kind "Basic" -Location "LOCATION" -Name "$vms" -ResourceGroupName "RESOURCEGROUP" -VirtualMachine $JitPolicyArr
