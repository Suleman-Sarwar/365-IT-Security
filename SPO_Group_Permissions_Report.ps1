# Connect to SharePoint Online
## Make sure to install SPO Shell https://download.microsoft.com/download/0/2/E/02E7E5BA-2190-44A8-B407-BC73CA0D6B87/SharePointOnlineManagementShell_20518-12000_x64_en-us.msi

$SPOURL = "https://XXXXXX-admin.sharepoint.com/"
Connect-SPOService -url $SPOURL -Credential (Get-Credential)

# General Parameters 
## The report location is based on CSVPath
$CSVPath = "C:\Temp\SPO_Groups_Permissions_Report.csv"
$GroupsData = @()
 
# Get all Site collections
Get-SPOSite -Limit ALL | ForEach-Object {
    Write-Host -f Yellow "Processing Site Collection:"$_.URL
  
    # Get SharePoint Online Groups Powershell
    $SiteGroups = Get-SPOSiteGroup -Site $_.URL
 
    Write-host "Total Number of Groups:"$SiteGroups.Count
 
    ForEach ($Group in $SiteGroups) {
        $GroupsData += New-Object PSObject -Property @{
            'Site URL'    = $_.URL
            'Group Name'  = $Group.Title
            'Permissions' = $Group.Roles -join ","
            'Users'       = $Group.Users -join ","
        }
    }
}
#Export data to CSV
$GroupsData | Export-Csv $CSVPath -NoTypeInformation
Write-host -f Green "Report Generated Successfully"
