Import-Module ActiveDirectory
$username = Read-Host "Enter username (SAM Account Name)"
$user = Get-ADUser $username
$sourceAnchor = [System.Convert]::ToBase64String((new-Object system.Guid($user.objectguid.guid)).ToByteArray())
$events = Get-EventLog -LogName Application -Source "Directory Synchronization" -InstanceId 657
$results = @()

foreach ($event in $events){
	$found = $false
	if ($event.message.contains($sourceAnchor)){
		$found = $true
		Write-Host "Found an event on date" $event.TimeGenerated "with index" $event.Index
		$Messages = $event.message -split "`n" | % { $_.trim() }
		foreach ($Message in $Messages){
			if ($Message.contains($sourceAnchor)){
				$resultIndex = $Message.IndexOf('Result :') + 9
				$result = $Message.Substring($resultIndex,$Message.Length - ($resultIndex + 1))
				$entry = New-Object PSObject
				$entry | Add-Member -MemberType NoteProperty -Name "Date" -Value $event.TimeGenerated
				$entry | Add-Member -MemberType NoteProperty -Name "UserPrincipalName" -Value $user.UserPrincipalName
				$entry | Add-Member -MemberType NoteProperty -Name "Result" -Value $result
				$results += $entry
				
				break
			}
		}
		
	}
	
}

if (!$found){
	Write-Host
	Write-Host "AD Connect didn't sync this user's password for a while" -fore Yellow
	Write-Host "If the user had changed his password recently, this could be an issue..." -fore Yellow
}
else {
	$results
}
#-----------------------------------------------------------------------------------------------------------------------------------